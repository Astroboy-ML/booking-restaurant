import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../config", () => ({
  API_URL: "http://localhost",
  getApiUrlOrThrow: () => "http://localhost",
  getApiUrlDisplay: () => "http://localhost"
}));

import ClientPage from "./ClientPage";

function jsonResponse(body: unknown, init?: ResponseInit) {
  return Promise.resolve(
    new Response(JSON.stringify(body), {
      status: 200,
      headers: { "Content-Type": "application/json" },
      ...init
    })
  );
}

describe("ClientPage", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("charge la liste au montage", async () => {
    const fetchMock = vi.fn().mockResolvedValueOnce(
      await jsonResponse([
        { id: 1, name: "Alice", date_time: "2025-01-01T19:00", party_size: 2, status: "active" }
      ])
    );
    vi.stubGlobal("fetch", fetchMock);

    render(<ClientPage />);

    expect(await screen.findByText(/alice/i)).toBeVisible();
    expect(fetchMock).toHaveBeenCalledWith(expect.stringContaining("/reservations"), expect.anything());
  });

  it("submit OK -> POST puis recharge la liste", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(await jsonResponse([])) // initial GET
      .mockResolvedValueOnce(
        await jsonResponse(
          { id: 1, name: "Bob", date_time: "2025-02-02T20:30", party_size: 4, status: "active" },
          { status: 201 }
        )
      ) // POST
      .mockResolvedValueOnce(
        await jsonResponse([
          { id: 1, name: "Bob", date_time: "2025-02-02T20:30", party_size: 4, status: "active" }
        ])
      ); // refreshed GET
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<ClientPage />);

    await screen.findByRole("heading", { name: /reservations/i });

    await user.type(screen.getByLabelText(/^nom$/i), "Bob");
    await user.type(screen.getByLabelText(/date et heure/i), "2025-02-02T20:30");
    await user.type(screen.getByLabelText(/nombre de convives/i), "4");
    await user.click(screen.getByRole("button", { name: /creer la reservation/i }));

    expect(fetchMock).toHaveBeenCalledWith(
      expect.stringContaining("/reservations"),
      expect.objectContaining({ method: "POST" })
    );
    expect(await screen.findByText(/convives : 4/i)).toBeVisible();
  });

  it("affiche une erreur si le POST echoue", async () => {
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(await jsonResponse([])) // initial GET
      .mockResolvedValueOnce(
        await jsonResponse({ detail: "Oups" }, { status: 500, statusText: "Server Error" })
      ); // POST error
    vi.stubGlobal("fetch", fetchMock);

    const user = userEvent.setup();
    render(<ClientPage />);

    await screen.findByRole("heading", { name: /reservations/i });

    await user.type(screen.getByLabelText(/^nom$/i), "Eve");
    await user.type(screen.getByLabelText(/date et heure/i), "2025-03-03T19:00");
    await user.type(screen.getByLabelText(/nombre de convives/i), "2");
    await user.click(screen.getByRole("button", { name: /creer la reservation/i }));

    await waitFor(() => {
      expect(screen.getByRole("alert")).toBeVisible();
      expect(screen.getByText(/500/i)).toBeVisible();
    });
  });
});
