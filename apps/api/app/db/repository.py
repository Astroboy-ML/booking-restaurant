import os
from pathlib import Path
from typing import Protocol

import psycopg
from psycopg.rows import dict_row

SCHEMA_PATH = Path(__file__).with_name("schema.sql")


class DatabaseUnavailable(Exception):
    """Raised when the database connection cannot be established."""


class ReservationCreateDTO(Protocol):
    name: str
    date_time: object
    party_size: int


class ReservationRepository(Protocol):
    def create(self, data: ReservationCreateDTO) -> dict:
        ...

    def list(self) -> list[dict]:
        ...


def get_database_url() -> str:
    return os.getenv("DATABASE_URL", "postgresql://booking:booking@localhost:5432/booking")


def initialize_schema() -> None:
    """Ensure the reservations table exists (idempotent)."""
    try:
        with psycopg.connect(get_database_url(), autocommit=True) as conn:
            with conn.cursor() as cur:
                cur.execute(SCHEMA_PATH.read_text())
    except Exception as exc:
        raise DatabaseUnavailable("Could not initialize database schema") from exc


class PostgresReservationRepository:
    """Simple repository using psycopg and raw SQL."""

    def __init__(self, dsn: str | None = None) -> None:
        self.dsn = dsn or get_database_url()

    def create(self, data: ReservationCreateDTO) -> dict:
        with psycopg.connect(self.dsn, autocommit=True, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO reservations (name, date_time, party_size)
                    VALUES (%s, %s, %s)
                    RETURNING id, name, date_time, party_size, created_at
                    """,
                    (data.name, data.date_time, data.party_size),
                )
                return cur.fetchone()

    def list(self) -> list[dict]:
        with psycopg.connect(self.dsn, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    SELECT id, name, date_time, party_size
                    FROM reservations
                    ORDER BY id ASC
                    """
                )
                return cur.fetchall()


def get_repository() -> ReservationRepository:
    return PostgresReservationRepository()
