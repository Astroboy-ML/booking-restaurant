import { Link, Route, Routes } from "react-router-dom";
import { API_URL } from "./config";
import ClientPage from "./pages/ClientPage";
import HomePage from "./pages/HomePage";
import RestaurateurPage from "./pages/RestaurateurPage";
import "./App.css";

function App() {
  return (
    <div className="app">
      <header className="app__header">
        <div>
          <p className="app__brand">Booking Restaurant</p>
          <p className="app__subtitle">
            API: <span className="app__api-url">{API_URL ?? "non configurée"}</span>
          </p>
        </div>
        <nav className="app__nav">
          <Link to="/">Accueil</Link>
          <Link to="/client">Client</Link>
          <Link to="/restaurateur">Restaurateur</Link>
        </nav>
      </header>

      <main className="app__content">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/client" element={<ClientPage />} />
          <Route path="/restaurateur" element={<RestaurateurPage />} />
        </Routes>
      </main>
    </div>
  );
}

export default App;
