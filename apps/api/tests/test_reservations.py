import pytest
from fastapi.testclient import TestClient

from app.db.repository import DatabaseUnavailable, get_repository, initialize_schema
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
    assert body["status"] == "active"


def test_create_reservation_invalid_party_size_returns_422(client: TestClient):
    payload = {
        "name": "Bob",
        "date_time": "2025-01-01T19:00:00Z",
        "party_size": 0,
    }
    response = client.post("/reservations", json=payload)
    assert response.status_code == 422


def test_list_reservations_returns_503_when_repo_unavailable():
    class FailingRepo:
        def create(self, data):
            raise DatabaseUnavailable("db down")

        def list(self):
            raise DatabaseUnavailable("db down")

        def delete(self, reservation_id: int):
            raise DatabaseUnavailable("db down")

    app.dependency_overrides[get_repository] = lambda: FailingRepo()
    try:
        client = TestClient(app)

        response = client.get("/reservations")

        assert response.status_code == 503
        assert response.json()["detail"] == "Database unavailable"
    finally:
        app.dependency_overrides.clear()


def test_list_reservations_returns_500_on_unexpected_error():
    class ExplodingRepo:
        def create(self, data):  # pragma: no cover - unused
            raise ValueError("boom")

        def list(self):
            raise ValueError("boom")

        def delete(self, reservation_id: int):  # pragma: no cover - unused
            raise ValueError("boom")

    app.dependency_overrides[get_repository] = lambda: ExplodingRepo()
    try:
        client = TestClient(app)

        response = client.get("/reservations")

        assert response.status_code == 500
        assert response.json()["detail"] == "Internal server error"
    finally:
        app.dependency_overrides.clear()
