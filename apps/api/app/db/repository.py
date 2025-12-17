import os
from pathlib import Path
from typing import Protocol

import psycopg
from psycopg import errors as psycopg_errors
from alembic import command
from alembic.config import Config
from psycopg.rows import dict_row

ALEMBIC_CONFIG_PATH = Path(__file__).resolve().parents[2] / "alembic.ini"
MIGRATIONS_PATH = Path(__file__).resolve().parent / "migrations"
DEFAULT_URL = "postgresql+psycopg://booking:booking@localhost:5432/booking"


class DatabaseUnavailable(Exception):
    """Raised when the database connection cannot be established."""


class ReservationCreateDTO(Protocol):
    name: str
    date_time: object
    party_size: int


class ReservationRepository(Protocol):
    def create(self, data: ReservationCreateDTO) -> dict: ...

    def list(self) -> list[dict]: ...

    def delete(self, reservation_id: int) -> bool: ...


def get_database_url() -> str:
    """
    Return a psycopg-compatible DSN (no driver suffix).

    - Accepts env var DATABASE_URL.
    - If URL uses the SQLAlchemy-style driver suffix (`postgresql+psycopg://`),
      convert it to `postgresql://` for psycopg.connect.
    """
    url = os.getenv("DATABASE_URL", DEFAULT_URL)
    if url.startswith("postgresql+psycopg://"):
        return url.replace("postgresql+psycopg://", "postgresql://", 1)
    return url


def get_alembic_url() -> str:
    """
    Return an SQLAlchemy-compatible URL for Alembic.

    Ensures the psycopg driver suffix is present for SQLAlchemy if missing.
    """
    url = os.getenv("DATABASE_URL", DEFAULT_URL)
    if url.startswith("postgresql://"):
        return url.replace("postgresql://", "postgresql+psycopg://", 1)
    return url


def run_migrations() -> None:
    """Apply database migrations up to head."""
    try:
        config = Config(str(ALEMBIC_CONFIG_PATH))
        config.set_main_option("sqlalchemy.url", get_alembic_url())
        config.set_main_option("script_location", str(MIGRATIONS_PATH))
        command.upgrade(config, "head")
    except Exception as exc:
        raise DatabaseUnavailable("Could not apply database migrations") from exc


def initialize_schema() -> None:
    """Backward-compatible helper to ensure the schema is present."""
    run_migrations()


class PostgresReservationRepository:
    """Simple repository using psycopg and raw SQL."""

    def __init__(self, dsn: str | None = None) -> None:
        self.dsn = dsn or get_database_url()

    def create(self, data: ReservationCreateDTO) -> dict:
        try:
            with psycopg.connect(self.dsn, autocommit=True, row_factory=dict_row) as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        INSERT INTO reservations (name, date_time, party_size)
                        VALUES (%s, %s, %s)
                        RETURNING id, name, date_time, party_size, status, created_at
                        """,
                        (data.name, data.date_time, data.party_size),
                    )
                    return cur.fetchone()
        except psycopg_errors.OperationalError as exc:
            raise DatabaseUnavailable("Database unavailable") from exc

    def list(self) -> list[dict]:
        try:
            with psycopg.connect(self.dsn, row_factory=dict_row) as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        SELECT id, name, date_time, party_size, status
                        FROM reservations
                        ORDER BY id ASC
                        """
                    )
                    return cur.fetchall()
        except psycopg_errors.OperationalError as exc:
            raise DatabaseUnavailable("Database unavailable") from exc

    def delete(self, reservation_id: int) -> bool:
        try:
            with psycopg.connect(self.dsn, autocommit=True) as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        "DELETE FROM reservations WHERE id = %s",
                        (reservation_id,),
                    )
                    return cur.rowcount > 0
        except psycopg_errors.OperationalError as exc:
            raise DatabaseUnavailable("Database unavailable") from exc


def get_repository() -> ReservationRepository:
    return PostgresReservationRepository()
