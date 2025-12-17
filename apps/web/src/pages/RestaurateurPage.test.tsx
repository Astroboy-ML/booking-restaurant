import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../config", () => ({
  API_URL: "http://localhost",
  getApiUrlOrThrow: () => "http://localhost",
  getApiUrlDisplay: () => "http://localhost"
}));

import RestaurateurPage from "./RestaurateurPage";

function jsonResponse(body: unknown, init?: ResponseInit) {
  return Promise.resolve(
    new Response(JSON.stringify(body), {
      status: 200,
      headers: { "Content-Type": "application/json" },
      ...init
    })
  );
}

describe("RestaurateurPage", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("affiche la liste et permet d'annuler une reservation", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(
        await jsonResponse([
          {
            id: 1,
            name: "Alice",
            date_time: "2025-01-01T19:00",
            party_size: 2,
            status: "active"
          }
        ])
      )
      .mockResolvedValueOnce(new Response(null, { status: 204 }))
      .mockResolvedValueOnce(await jsonResponse([]));
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<RestaurateurPage />);

    expect(await screen.findByText(/alice/i)).toBeVisible();
    expect(screen.getByText(/statut : active/i)).toBeVisible();

    await user.click(screen.getByRole("button", { name: /annuler/i }));

    await waitFor(() => {
      expect(fetchMock).toHaveBeenCalledWith(
        expect.stringContaining("/reservations/1"),
        expect.objectContaining({ method: "DELETE" })
      );
      expect(screen.getByText(/aucune reservation/i)).toBeVisible();
    });
  });

  it("affiche une erreur si l'annulation echoue", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(
        await jsonResponse([
          {
            id: 2,
            name: "Bob",
            date_time: "2025-02-02T20:00",
            party_size: 4,
            status: "active"
          }
        ])
      )
      .mockResolvedValueOnce(
        await jsonResponse({ detail: "Database unavailable" }, { status: 503, statusText: "Service Unavailable" })
      );
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<RestaurateurPage />);

    expect(await screen.findByText(/bob/i)).toBeVisible();
    await user.click(screen.getByRole("button", { name: /annuler/i }));

    await waitFor(() => {
      expect(screen.getByRole("alert")).toHaveTextContent(/database unavailable/i);
    });
  });
});
