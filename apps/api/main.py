from datetime import datetime
from typing import List

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="Booking Restaurant API")


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


class InMemoryReservationStore:
    """Dedicated in-memory store to allow later replacement by a real DB."""

    def __init__(self) -> None:
        self._reservations: List[Reservation] = []
        self._next_id: int = 1

    def create(self, data: ReservationCreate) -> Reservation:
        reservation = Reservation(id=self._next_id, **data.model_dump())
        self._next_id += 1
        self._reservations.append(reservation)
        return reservation


store = InMemoryReservationStore()


@app.post("/reservations", response_model=Reservation, status_code=201, tags=["reservations"])
async def create_reservation(payload: ReservationCreate) -> Reservation:
    """Create a reservation; uses in-memory store so it is independent of the DB."""
    return store.create(payload)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
