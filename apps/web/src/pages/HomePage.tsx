function HomePage() {
  return (
    <section className="card hero">
      <h1>Bienvenue</h1>
      <p>
        Cette interface sépare l&apos;espace client (réservations) et l&apos;espace restaurateur
        (gestion). La navigation ci-dessus permet de passer d&apos;un espace à l&apos;autre.
      </p>
      <ul className="section-list">
        <li>Espace client : créer et suivre les réservations.</li>
        <li>Espace restaurateur : gérer les réservations et l&apos;accueil.</li>
        <li>Base technique : React + Vite + TypeScript + React Router + Vitest/RTL + ESLint.</li>
      </ul>
    </section>
  );
}

export default HomePage;
