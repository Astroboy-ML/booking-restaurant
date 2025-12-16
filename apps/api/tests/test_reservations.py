from fastapi.testclient import TestClient

from apps.api.main import app


client = TestClient(app)


def test_create_reservation_returns_201_with_id():
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


def test_create_reservation_invalid_party_size_returns_422():
    payload = {
        "name": "Bob",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 0,
    }
    response = client.post("/reservations", json=payload)
    assert response.status_code == 422
