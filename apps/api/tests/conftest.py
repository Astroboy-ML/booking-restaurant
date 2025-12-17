import sys
from pathlib import Path

# Ensure project and API module are importable when running pytest from repo root
THIS_DIR = Path(__file__).resolve().parent
API_ROOT = THIS_DIR.parent
PROJECT_ROOT = API_ROOT.parent.parent

for path in (str(API_ROOT), str(PROJECT_ROOT)):
    if path not in sys.path:
        sys.path.insert(0, path)
