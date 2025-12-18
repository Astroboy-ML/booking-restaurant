# Booking Restaurant API

## API key authentication

Protected routes (reservation CRUD) require an API key. Configure the key and parameter names via environment variables:

- `API_KEY` (required): expected secret value.
- `API_KEY_HEADER` (optional, default: `X-API-Key`): header name clients can use.
- `API_KEY_QUERY` (optional, default: `api_key`): query parameter clients can use.

If `API_KEY` is missing, protected endpoints return a 500 error to signal missing configuration. Requests without a key return 401; requests with an invalid key return 403.

Example usage:

```bash
export API_KEY="your-generated-key"
export API_KEY_HEADER="X-API-Key"

# Header
curl -H "X-API-Key: $API_KEY" http://localhost:8000/reservations

# Query parameter
curl "http://localhost:8000/reservations?api_key=$API_KEY"
```

Public endpoints (`/health`, `/metrics`) stay accessible without authentication.
