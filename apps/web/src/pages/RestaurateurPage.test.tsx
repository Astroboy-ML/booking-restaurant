import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../config", () => ({
  API_URL: "http://localhost",
  getApiUrlOrThrow: () => "http://localhost",
  getApiUrlDisplay: () => "http://localhost"
}));

import RestaurateurPage from "./RestaurateurPage";

function jsonResponse(body: unknown, init?: ResponseInit) {
  const status = init?.status ?? 200;
  // For 204, Response must not have a body.
  const payload = status === 204 ? null : JSON.stringify(body);
  const headers = status === 204 ? undefined : { "Content-Type": "application/json" };
  return Promise.resolve(
    new Response(payload, {
      status,
      headers,
      ...init
    })
  );
}

describe("RestaurateurPage", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("charge la liste et affiche les reservations", async () => {
    const fetchMock = vi.fn().mockResolvedValueOnce(
      await jsonResponse([
        { id: 1, name: "Alice", date_time: "2025-01-01T19:00", party_size: 2 },
        { id: 2, name: "Bob", date_time: "2025-01-02T20:00", party_size: 4 }
      ])
    );
    vi.stubGlobal("fetch", fetchMock);

    render(<RestaurateurPage />);

    expect(await screen.findByText(/alice/i)).toBeVisible();
    expect(await screen.findByText(/bob/i)).toBeVisible();
    expect(fetchMock).toHaveBeenCalledWith(expect.stringContaining("/reservations"), expect.anything());
  });

  it("annule une reservation et recharge la liste", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(
        await jsonResponse([{ id: 1, name: "Alice", date_time: "2025-01-01T19:00", party_size: 2 }])
      ) // initial GET
      .mockResolvedValueOnce(await jsonResponse({}, { status: 204 })) // DELETE
      .mockResolvedValueOnce(await jsonResponse([])); // refreshed GET
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<RestaurateurPage />);

    await screen.findByText(/alice/i);

    await user.click(screen.getByRole("button", { name: /annuler/i }));

    await waitFor(() => {
      expect(fetchMock).toHaveBeenCalledWith(
        expect.stringContaining("/reservations/1"),
        expect.objectContaining({ method: "DELETE" })
      );
    });

    await waitFor(() => {
      expect(screen.queryByText(/alice/i)).not.toBeInTheDocument();
    });
  });

  it("affiche une erreur si l'annulation echoue", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(
        await jsonResponse([{ id: 1, name: "Alice", date_time: "2025-01-01T19:00", party_size: 2 }])
      ) // initial GET
      .mockResolvedValueOnce(await jsonResponse({ detail: "Oups" }, { status: 500, statusText: "Server Error" })); // DELETE error
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<RestaurateurPage />);

    await screen.findByText(/alice/i);

    await user.click(screen.getByRole("button", { name: /annuler/i }));

    await waitFor(() => {
      expect(screen.getByRole("alert")).toBeVisible();
      expect(screen.getByText(/500/i)).toBeVisible();
    });
  });
});
