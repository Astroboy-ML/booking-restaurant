import { useEffect, useMemo, useState } from "react";
import { deleteReservation, getReservations, type Reservation } from "../api/reservations";

function RestaurateurPage() {
  const [reservations, setReservations] = useState<Reservation[]>([]);
  const [loading, setLoading] = useState(false);
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  const sortedReservations = useMemo(() => {
    return [...reservations].sort((a, b) => {
      const byDate = a.date_time.localeCompare(b.date_time);
      if (byDate !== 0) return byDate;
      return a.id - b.id;
    });
  }, [reservations]);

  useEffect(() => {
    void loadReservations();
  }, []);

  async function loadReservations() {
    setLoading(true);
    setError(null);
    try {
      const data = await getReservations();
      setReservations(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Impossible de charger les reservations");
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id: number) {
    setDeletingId(id);
    setError(null);
    try {
      await deleteReservation(id);
      await loadReservations();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Impossible d'annuler la reservation");
    } finally {
      setDeletingId(null);
    }
  }

  return (
    <section className="card">
      <h1>Espace restaurateur</h1>
      <p>Consultez et annulez les reservations.</p>

      {error && (
        <div role="alert" className="alert">
          {error}
        </div>
      )}

      <div className="list">
        <div className="list__header">
          <h2>Reservations</h2>
          {loading && <span>Chargement...</span>}
        </div>

        {sortedReservations.length === 0 && !loading ? (
          <p>Aucune reservation a afficher.</p>
        ) : (
          <ul>
            {sortedReservations.map((reservation) => (
              <li key={reservation.id} className="list__item">
                <p>
                  <strong>{reservation.name}</strong>
                </p>
                <p>Date/heure : {reservation.date_time}</p>
                <p>Convives : {reservation.party_size}</p>
                <p>Statut : {reservation.status}</p>
                <button
                  type="button"
                  onClick={() => void handleDelete(reservation.id)}
                  disabled={deletingId === reservation.id}
                >
                  {deletingId === reservation.id ? "Annulation..." : "Annuler"}
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </section>
  );
}

export default RestaurateurPage;
