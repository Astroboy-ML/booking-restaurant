import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { BrowserRouter } from "react-router-dom";
import App from "./App";

describe("App navigation", () => {
  it("affiche la navigation et permet de naviguer vers les espaces", async () => {
    const user = userEvent.setup();
    render(
      <BrowserRouter>
        <App />
      </BrowserRouter>
    );

    const homeLink = screen.getByRole("link", { name: /accueil/i });
    const clientLink = screen.getByRole("link", { name: /client/i });
    const restaurateurLink = screen.getByRole("link", { name: /restaurateur/i });

    expect(homeLink).toBeVisible();
    expect(clientLink).toBeVisible();
    expect(restaurateurLink).toBeVisible();

    await user.click(clientLink);
    expect(screen.getByRole("heading", { name: /espace client/i })).toBeVisible();

    await user.click(restaurateurLink);
    expect(screen.getByRole("heading", { name: /espace restaurateur/i })).toBeVisible();
  });
});
