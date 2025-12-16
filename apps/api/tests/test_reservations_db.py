import psycopg
import pytest
from fastapi.testclient import TestClient

from app.db.repository import DatabaseUnavailable, get_database_url, initialize_schema
from main import app


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


@pytest.mark.integration
def test_list_reservations_returns_created_items(client: TestClient):
    payload1 = {
        "name": "List Test 1",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 2,
    }
    payload2 = {
        "name": "List Test 2",
        "date_time": "2025-01-02T20:00:00Z",
        "party_size": 4,
    }

    r1 = client.post("/reservations", json=payload1)
    r2 = client.post("/reservations", json=payload2)

    assert r1.status_code == 201
    assert r2.status_code == 201

    list_response = client.get("/reservations")
    assert list_response.status_code == 200

    ids = [item["id"] for item in list_response.json()]
    assert r1.json()["id"] in ids
    assert r2.json()["id"] in ids


@pytest.mark.integration
def test_delete_reservation_then_absent_in_get(client: TestClient):
    create_response = client.post(
        "/reservations",
        json={
            "name": "To Delete",
            "date_time": "2025-01-03T18:00:00Z",
            "party_size": 2,
        },
    )
    assert create_response.status_code == 201
    created_id = create_response.json()["id"]

    delete_response = client.delete(f"/reservations/{created_id}")
    assert delete_response.status_code == 204
    assert delete_response.text == ""

    list_response = client.get("/reservations")
    assert list_response.status_code == 200
    ids = [item["id"] for item in list_response.json()]
    assert created_id not in ids


@pytest.mark.integration
def test_delete_nonexistent_returns_404(client: TestClient):
    response = client.delete("/reservations/999999")
    assert response.status_code == 404
    assert response.json()["detail"] == "Reservation not found"
