import json
import logging
import os
import time
from contextlib import asynccontextmanager
from datetime import datetime
from enum import Enum
from uuid import uuid4

import psycopg
from fastapi import Depends, FastAPI, HTTPException, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
from pydantic import BaseModel, Field

from app.db.repository import (
    DatabaseUnavailable,
    ReservationRepository,
    get_repository,
    run_migrations,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        run_migrations()
    except DatabaseUnavailable as exc:
        # In dev, we prefer surfacing the init error clearly.
        raise RuntimeError("Database initialization failed") from exc
    yield


app = FastAPI(title="Booking Restaurant API", lifespan=lifespan)
instrumentator = Instrumentator().instrument(app).expose(app, include_in_schema=False)

# Allow frontend dev server (localhost:5173) to call the API in dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

logger = logging.getLogger("booking_api")
logger.setLevel(logging.INFO)
if not logger.handlers:
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)
    logger.addHandler(handler)
logger.propagate = False


@app.middleware("http")
async def add_request_id_and_log(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID", str(uuid4()))
    start_time = time.perf_counter()
    try:
        response: Response = await call_next(request)
    except Exception:
        duration_ms = (time.perf_counter() - start_time) * 1000
        logger.exception(
            json.dumps(
                {
                    "timestamp": datetime.utcnow().isoformat() + "Z",
                    "level": "ERROR",
                    "path": request.url.path,
                    "method": request.method,
                    "status_code": 500,
                    "duration_ms": round(duration_ms, 2),
                    "request_id": request_id,
                }
            )
        )
        raise

    duration_ms = (time.perf_counter() - start_time) * 1000
    log_payload = {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "level": "INFO",
        "path": request.url.path,
        "method": request.method,
        "status_code": response.status_code,
        "duration_ms": round(duration_ms, 2),
        "request_id": request_id,
    }
    logger.info(json.dumps(log_payload))
    response.headers["X-Request-ID"] = request_id
    request.state.request_id = request_id
    return response


@app.get("/health", tags=["health"])
async def health() -> dict:
    """Simple health endpoint that does not depend on external services."""
    return {"status": "ok"}


class ReservationStatus(str, Enum):
    ACTIVE = "active"
    CANCELLED = "cancelled"


class ReservationCreate(BaseModel):
    name: str = Field(min_length=1)
    date_time: datetime
    party_size: int = Field(gt=0)


class Reservation(ReservationCreate):
    id: int
    status: ReservationStatus


def map_repository_error(exc: Exception, context: str) -> HTTPException:
    logger.exception("Repository error during %s", context, exc_info=exc)
    if isinstance(exc, (DatabaseUnavailable, psycopg.OperationalError)):
        return HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        )
    return HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail="Internal server error",
    )


@app.post(
    "/reservations",
    response_model=Reservation,
    status_code=201,
    tags=["reservations"],
)
async def create_reservation(
    payload: ReservationCreate, repo: ReservationRepository = Depends(get_repository)
) -> Reservation:
    """Create a reservation using the database-backed repository."""
    try:
        created = repo.create(payload)
    except Exception as exc:  # pragma: no cover - mapped via map_repository_error
        raise map_repository_error(exc, "create_reservation")
    # psycopg returns datetime objects; pydantic model will handle them on response.
    return Reservation(**created)


@app.get("/reservations", response_model=list[Reservation], tags=["reservations"])
async def list_reservations(
    repo: ReservationRepository = Depends(get_repository),
) -> list[Reservation]:
    """List reservations from the database, ordered by id ASC."""
    try:
        rows = repo.list()
    except Exception as exc:  # pragma: no cover - mapped via map_repository_error
        raise map_repository_error(exc, "list_reservations")
    return [Reservation(**row) for row in rows]


@app.delete(
    "/reservations/{reservation_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    tags=["reservations"],
)
async def delete_reservation(
    reservation_id: int, repo: ReservationRepository = Depends(get_repository)
) -> None:
    """Delete a reservation; returns 204 on success, 404 if not found."""
    try:
        deleted = repo.delete(reservation_id)
    except Exception as exc:  # pragma: no cover - mapped via map_repository_error
        raise map_repository_error(exc, "delete_reservation")
    if not deleted:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reservation not found")


if __name__ == "__main__":
    import uvicorn

    host = os.getenv("UVICORN_HOST", "127.0.0.1")
    uvicorn.run("main:app", host=host, port=8000, reload=True)
