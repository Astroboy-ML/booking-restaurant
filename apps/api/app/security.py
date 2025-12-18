"""API key authentication helpers for the FastAPI application."""

from dataclasses import dataclass
import os

from fastapi import HTTPException, Request, status


@dataclass
class ApiKeyConfig:
    """Configuration for API key validation sourced from environment variables."""

    key: str | None
    header_name: str
    query_name: str

    @classmethod
    def from_env(cls) -> "ApiKeyConfig":
        return cls(
            key=os.getenv("API_KEY"),
            header_name=os.getenv("API_KEY_HEADER", "X-API-Key"),
            query_name=os.getenv("API_KEY_QUERY", "api_key"),
        )


async def require_api_key(request: Request) -> None:
    """Validate presence and correctness of the API key on protected routes.

    The key must match the value provided via the ``API_KEY`` environment variable.
    Clients can send the key either using the configured header name or the
    configured query parameter.
    """

    config = ApiKeyConfig.from_env()

    if not config.key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="API key not configured",
        )

    provided_key = request.headers.get(config.header_name) or request.query_params.get(
        config.query_name
    )

    if not provided_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing API key",
        )

    if provided_key != config.key:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid API key",
        )
