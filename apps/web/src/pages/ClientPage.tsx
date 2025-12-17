import { FormEvent, useEffect, useMemo, useState } from "react";
import { createReservation, getReservations, type Reservation } from "../api/reservations";

type FormState = {
  name: string;
  dateTime: string;
  partySize: string;
};

function ClientPage() {
  const [form, setForm] = useState<FormState>({ name: "", dateTime: "", partySize: "" });
  const [reservations, setReservations] = useState<Reservation[]>([]);
  const [loadingList, setLoadingList] = useState(false);
  const [submitting, setSubmitting] = useState(false);
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
    setLoadingList(true);
    setError(null);
    try {
      const data = await getReservations();
      setReservations(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Impossible de charger les reservations");
    } finally {
      setLoadingList(false);
    }
  }

  function validateForm(): string | null {
    if (!form.name.trim()) return "Le nom est requis.";
    if (!form.dateTime) return "La date/heure est requise.";
    const size = Number(form.partySize);
    if (!Number.isFinite(size) || size <= 0) return "Le nombre de convives doit etre superieur a 0.";
    return null;
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const validationError = validateForm();
    if (validationError) {
      setError(validationError);
      return;
    }

    setSubmitting(true);
    setError(null);
    try {
      await createReservation({
        name: form.name.trim(),
        date_time: form.dateTime,
        party_size: Number(form.partySize)
      });
      setForm({ name: "", dateTime: "", partySize: "" });
      await loadReservations();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Impossible de creer la reservation");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <section className="card">
      <h1>Espace client</h1>
      <p>Creer et consulter vos reservations.</p>

      <form className="form" onSubmit={handleSubmit}>
        <div className="form__group">
          <label htmlFor="name">Nom</label>
          <input
            id="name"
            name="name"
            type="text"
            value={form.name}
            onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))}
            required
          />
        </div>

        <div className="form__group">
          <label htmlFor="dateTime">Date et heure</label>
          <input
            id="dateTime"
            name="dateTime"
            type="datetime-local"
            value={form.dateTime}
            onChange={(e) => setForm((prev) => ({ ...prev, dateTime: e.target.value }))}
            required
          />
        </div>

        <div className="form__group">
          <label htmlFor="partySize">Nombre de convives</label>
          <input
            id="partySize"
            name="partySize"
            type="number"
            min="1"
            value={form.partySize}
            onChange={(e) => setForm((prev) => ({ ...prev, partySize: e.target.value }))}
            required
          />
        </div>

        <button type="submit" disabled={submitting}>
          {submitting ? "Envoi..." : "Creer la reservation"}
        </button>
      </form>

      {error && (
        <div role="alert" className="alert">
          {error}
        </div>
      )}

      <div className="list">
        <div className="list__header">
          <h2>Reservations</h2>
          {loadingList && <span>Chargement...</span>}
        </div>

        {sortedReservations.length === 0 && !loadingList ? (
          <p>Aucune reservation pour le moment.</p>
        ) : (
          <ul>
            {sortedReservations.map((reservation) => (
              <li key={reservation.id} className="list__item">
                <p>
                  <strong>{reservation.name}</strong>
                </p>
                <p>Date/heure : {reservation.date_time}</p>
                <p>Convives : {reservation.party_size}</p>
              </li>
            ))}
          </ul>
        )}
      </div>
    </section>
  );
}

export default ClientPage;
