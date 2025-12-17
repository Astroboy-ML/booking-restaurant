param(
  [string] = "8000",
  [string] = "5173"
)

Continue = "Stop"
C:\Users\marti\booking-restaurant = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

function Ensure-PythonDeps {
  try {
    @'
import importlib
import sys
missing = []
for mod in ("psycopg", "alembic"):
    try:
        importlib.import_module(mod)
    except ImportError:
        missing.append(mod)
if missing:
    sys.exit(f"missing:{','.join(missing)}")
print("ok")
'@ | python - | Out-Null
  } catch {
    Write-Host "[dev] Installation des deps API (psycopg, alembic)..." -ForegroundColor Yellow
    python -m pip install -r (Join-Path C:\Users\marti\booking-restaurant "apps/api/requirements.txt") | Out-Null
  }
}

Write-Host "[dev] Démarrage de l'environnement..." -ForegroundColor Cyan

# 1) Démarrer Postgres via docker compose
Push-Location C:\Users\marti\booking-restaurant
Write-Host "[dev] Démarrage de la base (docker compose up -d db)..."
docker compose up -d db

# 2) Préparer la variable DATABASE_URL si absente
if (-not ) {
   = "postgresql+psycopg://booking:booking@localhost:5432/booking"
  Write-Host "[dev] DATABASE_URL non défini, utilisation de "
}

# 3) Appliquer les migrations
Write-Host "[dev] Application des migrations Alembic..."
Ensure-PythonDeps
Push-Location (Join-Path C:\Users\marti\booking-restaurant "apps/api")
try {
  alembic -c alembic.ini upgrade head
} catch {
  Pop-Location
  Write-Error "[dev] Échec des migrations Alembic. Arrêt."
  exit 1
}
Pop-Location

# 4) Lancer l'API en mode reload (python -m uvicorn pour fiabiliser le PATH)
Write-Host "[dev] Lancement de l'API (uvicorn --reload sur port )..."
 = Start-Job -ScriptBlock {
  param(, , )
  Continue = "Stop"
   = 
  Set-Location (Join-Path  "apps/api")
  python -m uvicorn main:app --host 0.0.0.0 --port  --reload
} -ArgumentList , , C:\Users\marti\booking-restaurant

# 5) Lancer le front Vite en mode dev
Write-Host "[dev] Lancement du front (npm run dev -- --host --port )..."
 = Start-Job -ScriptBlock {
  param(, )
  Continue = "Stop"
  Set-Location (Join-Path  "apps/web")
  npm run dev -- --host --port 
} -ArgumentList , C:\Users\marti\booking-restaurant

Write-Host "[dev] URLs :" -ForegroundColor Green
Write-Host "  API : http://localhost:" -ForegroundColor Green
Write-Host "  Web : http://localhost:" -ForegroundColor Green
Write-Host "  DB  : localhost:5432 (user=booking password=booking db=booking)" -ForegroundColor Green
Write-Host "[dev] Arrêt : Ctrl+C puis nettoyer les jobs PowerShell si nécessaire (Get-Job | Remove-Job)." -ForegroundColor Green

# Garder la session ouverte tant que les jobs tournent et afficher leurs logs si l'un termine
Wait-Job , 
Write-Host "[dev] Un des jobs s'est terminé, affichage des logs :" -ForegroundColor Yellow
Receive-Job  -Keep
Receive-Job  -Keep
