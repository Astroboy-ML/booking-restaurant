import { getApiUrlOrThrow } from "../config";

type Reservation = {
  id: number;
  name: string;
  date_time: string;
  party_size: number;
  status: "active" | "cancelled";
};

type NewReservation = {
  name: string;
  date_time: string;
  party_size: number;
};

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const baseUrl = getApiUrlOrThrow();

  const response = await fetch(`${baseUrl}${path}`, {
    headers: { "Content-Type": "application/json", ...(init?.headers ?? {}) },
    ...init
  });

  if (!response.ok) {
    let details = "";
    try {
      const body = await response.json();
      details = typeof body?.detail === "string" ? body.detail : JSON.stringify(body);
    } catch {
      // ignore JSON parse errors
    }
    const message = details
      ? `${response.status} ${response.statusText} - ${details}`
      : `${response.status} ${response.statusText}`;
    throw new Error(message);
  }

  if (response.status === 204) {
    return undefined as T;
  }

  return (await response.json()) as T;
}

async function getReservations(): Promise<Reservation[]> {
  const reservations = await request<Reservation[]>("/reservations");
  return reservations;
}

async function createReservation(input: NewReservation): Promise<Reservation> {
  const reservation = await request<Reservation>("/reservations", {
    method: "POST",
    body: JSON.stringify(input)
  });
  return reservation;
}

async function deleteReservation(id: number): Promise<void> {
  await request<void>(`/reservations/${id}`, {
    method: "DELETE"
  });
}

export type { Reservation, NewReservation };
export { getReservations, createReservation, deleteReservation };
