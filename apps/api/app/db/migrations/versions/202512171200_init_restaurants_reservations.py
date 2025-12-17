"""Initial migration for restaurants and reservations."""

import sqlalchemy as sa
from alembic import op

revision = "202512171200"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "restaurants",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column("name", sa.Text(), nullable=False),
        sa.Column("contact_email", sa.Text(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
    )

    op.execute(
        sa.text(
            "INSERT INTO restaurants (id, name) VALUES (1, 'Default Restaurant') "
            "ON CONFLICT DO NOTHING"
        )
    )

    op.create_table(
        "reservations",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column(
            "restaurant_id",
            sa.Integer(),
            sa.ForeignKey("restaurants.id"),
            nullable=False,
            server_default=sa.text("1"),
        ),
        sa.Column("name", sa.Text(), nullable=False),
        sa.Column("date_time", sa.DateTime(timezone=True), nullable=False),
        sa.Column("party_size", sa.Integer(), nullable=False),
        sa.Column(
            "status", sa.String(length=20), nullable=False, server_default=sa.text("'active'")
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.CheckConstraint(
            "party_size > 0",
            name="ck_reservations_party_size_positive",
        ),
        sa.CheckConstraint(
            "status in ('active','cancelled')",
            name="ck_reservations_status_valid",
        ),
    )

    op.create_index("ix_reservations_restaurant_id", "reservations", ["restaurant_id"])
    op.create_index("ix_reservations_date_time", "reservations", ["date_time"])


def downgrade() -> None:
    op.drop_index("ix_reservations_date_time", table_name="reservations")
    op.drop_index("ix_reservations_restaurant_id", table_name="reservations")
    op.drop_table("reservations")
    op.drop_table("restaurants")
