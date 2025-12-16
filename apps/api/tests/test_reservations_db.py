import psycopg
import pytest
from fastapi.testclient import TestClient

from apps.api.app.db.repository import (
    DatabaseUnavailable,
    get_database_url,
    initialize_schema,
)
from apps.api.main import app


def ensure_db_or_skip() -> None:
    try:
        initialize_schema()
    except DatabaseUnavailable:
        pytest.skip("Database unavailable for integration test")


@pytest.fixture()
def client() -> TestClient:
    ensure_db_or_skip()
    return TestClient(app)


def fetch_reservations_count() -> int:
    with psycopg.connect(get_database_url()) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM reservations")
            return cur.fetchone()[0]


@pytest.mark.integration
def test_create_reservation_persists_in_db(client: TestClient):
    before = fetch_reservations_count()

    payload = {
        "name": "Integration Test",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 3,
    }

    response = client.post("/reservations", json=payload)
    after = fetch_reservations_count()

    assert response.status_code == 201
    assert "id" in response.json()
    assert after == before + 1
