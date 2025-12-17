const API_URL = import.meta.env.VITE_API_URL;

function getApiUrlOrThrow(): string {
  if (!API_URL) {
    throw new Error(
      "API non configurée. Créez apps/web/.env avec VITE_API_URL=http://localhost:8000 puis redémarrez npm run dev."
    );
  }
  return API_URL;
}

function getApiUrlDisplay(): string {
  return API_URL ?? "Non configurée (créez apps/web/.env avec VITE_API_URL=http://localhost:8000 puis redémarrez)";
}

export { API_URL, getApiUrlDisplay, getApiUrlOrThrow };
