param(
  [string]$ApiPort = "8000",
  [string]$WebPort = "5173"
)

$ErrorActionPreference = "Stop"
# PSScriptRoot pointe sur .../scripts ; on remonte d'un cran pour le repo.
$RepoRoot = Split-Path -Parent $PSScriptRoot

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
    python -m pip install -r (Join-Path $RepoRoot "apps/api/requirements.txt") | Out-Null
  }
}

Write-Host "[dev] Demarrage de l'environnement..." -ForegroundColor Cyan

# 1) Demarrer Postgres via docker compose
Push-Location $RepoRoot
Write-Host "[dev] Demarrage de la base (docker compose up -d db)..."
docker compose up -d db

# 2) Preparer DATABASE_URL si absente
if (-not $env:DATABASE_URL) {
  $env:DATABASE_URL = "postgresql+psycopg://booking:booking@localhost:5432/booking"
  Write-Host "[dev] DATABASE_URL non defini, utilisation de $env:DATABASE_URL"
}

# 3) Appliquer les migrations
Write-Host "[dev] Application des migrations Alembic..."
Ensure-PythonDeps
Push-Location (Join-Path $RepoRoot "apps/api")
try {
  alembic -c alembic.ini upgrade head
} catch {
  Pop-Location
  Write-Error "[dev] Echec des migrations Alembic. Arret."
  exit 1
}
Pop-Location

# 4) Lancer l'API
Write-Host "[dev] Lancement de l'API (uvicorn --reload sur port $ApiPort)..."
$apiJob = Start-Job -ScriptBlock {
  param($port, $dbUrl, $root)
  $ErrorActionPreference = "Stop"
  $env:DATABASE_URL = $dbUrl
  Set-Location (Join-Path $root "apps/api")
  python -m uvicorn main:app --host 0.0.0.0 --port $port --reload
} -ArgumentList $ApiPort, $env:DATABASE_URL, $RepoRoot

# 5) Lancer le front
Write-Host "[dev] Lancement du front (npm run dev -- --host --port $WebPort)..."
$webJob = Start-Job -ScriptBlock {
  param($port, $root)
  $ErrorActionPreference = "Stop"
  Set-Location (Join-Path $root "apps/web")
  npm run dev -- --host --port $port
} -ArgumentList $WebPort, $RepoRoot

Write-Host "[dev] URLs :" -ForegroundColor Green
Write-Host "  API : http://localhost:$ApiPort" -ForegroundColor Green
Write-Host "  Web : http://localhost:$WebPort" -ForegroundColor Green
Write-Host "  DB  : localhost:5432 (user=booking password=booking db=booking)" -ForegroundColor Green
Write-Host "[dev] Arret : Ctrl+C puis nettoyer les jobs PowerShell si necessaire (Get-Job | Remove-Job)." -ForegroundColor Green

# Attendre les jobs et afficher leurs logs si un se termine
Wait-Job $apiJob, $webJob
Write-Host "[dev] Un des jobs s'est termine, logs :" -ForegroundColor Yellow
Receive-Job $apiJob -Keep
Receive-Job $webJob -Keep
