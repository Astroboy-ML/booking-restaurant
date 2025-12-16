from fastapi.testclient import TestClient
import pytest

from app.db.repository import DatabaseUnavailable, initialize_schema
from main import app


def ensure_db_or_skip() -> None:
    try:
        initialize_schema()
    except DatabaseUnavailable:
        pytest.skip("Database unavailable for reservation tests")


@pytest.fixture()
def client() -> TestClient:
    ensure_db_or_skip()
    return TestClient(app)


def test_create_reservation_returns_201_with_id(client: TestClient):
    payload = {
        "name": "Alice",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 2,
    }
    response = client.post("/reservations", json=payload)
    body = response.json()

    assert response.status_code == 201
    assert "id" in body
    assert body["name"] == payload["name"]
    assert body["party_size"] == payload["party_size"]


def test_create_reservation_invalid_party_size_returns_422(client: TestClient):
    payload = {
        "name": "Bob",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 0,
    }
    response = client.post("/reservations", json=payload)
    assert response.status_code == 422
