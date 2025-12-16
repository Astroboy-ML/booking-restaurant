from contextlib import asynccontextmanager
from datetime import datetime
from typing import List

from fastapi import Depends, FastAPI
from pydantic import BaseModel, Field

from apps.api.app.db.repository import (
    DatabaseUnavailable,
    ReservationRepository,
    get_repository,
    initialize_schema,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        initialize_schema()
    except DatabaseUnavailable as exc:
        # In dev, we prefer surfacing the init error clearly.
        raise RuntimeError("Database initialization failed") from exc
    yield


app = FastAPI(title="Booking Restaurant API", lifespan=lifespan)


@app.get("/health", tags=["health"])
async def health() -> dict:
    """Simple health endpoint that does not depend on external services."""
    return {"status": "ok"}


class ReservationCreate(BaseModel):
    name: str = Field(min_length=1)
    date_time: datetime
    party_size: int = Field(gt=0)


class Reservation(ReservationCreate):
    id: int


@app.post("/reservations", response_model=Reservation, status_code=201, tags=["reservations"])
async def create_reservation(
    payload: ReservationCreate, repo: ReservationRepository = Depends(get_repository)
) -> Reservation:
    """Create a reservation using the database-backed repository."""
    created = repo.create(payload)
    # psycopg returns datetime objects; pydantic model will handle them on response.
    return Reservation(**created)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
