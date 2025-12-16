from fastapi.testclient import TestClient

from main import app


client = TestClient(app)


def test_health_returns_ok_status():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_metrics_endpoint_returns_prometheus_text():
    response = client.get("/metrics")
    assert response.status_code == 200
    # Basic check that an HTTP metrics line is present
    assert "http_request_duration_seconds" in response.text or "http_requests_total" in response.text
