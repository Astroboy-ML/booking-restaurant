CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    date_time TIMESTAMPTZ NOT NULL,
    party_size INTEGER NOT NULL CHECK (party_size > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
