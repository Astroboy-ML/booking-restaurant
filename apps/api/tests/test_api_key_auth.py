import pytest
from fastapi.testclient import TestClient

from app.db.repository import get_repository
from main import app


class StubReservationRepository:
    def create(self, data):
        return {"id": 1, "name": data.name, "date_time": data.date_time, "party_size": data.party_size}

    def list(self) -> list[dict]:
        return []

    def delete(self, reservation_id: int) -> bool:
        return True


@pytest.fixture()
def client_with_stub_repo():
    app.dependency_overrides[get_repository] = lambda: StubReservationRepository()
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


def test_protected_route_without_api_key_returns_401():
    client = TestClient(app)

    response = client.get("/reservations")

    assert response.status_code == 401
    assert response.json() == {"detail": "Missing API key"}


def test_protected_route_with_invalid_api_key_returns_403():
    client = TestClient(app)

    response = client.get("/reservations", headers={"X-API-Key": "invalid"})

    assert response.status_code == 403
    assert response.json() == {"detail": "Invalid API key"}


def test_protected_route_accepts_valid_header(client_with_stub_repo: TestClient):
    response = client_with_stub_repo.get("/reservations", headers={"X-API-Key": "test-api-key"})

    assert response.status_code == 200
    assert response.json() == []


def test_protected_route_accepts_valid_query_param(client_with_stub_repo: TestClient):
    response = client_with_stub_repo.get("/reservations?api_key=test-api-key")

    assert response.status_code == 200
    assert response.json() == []
