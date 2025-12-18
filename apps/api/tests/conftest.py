import os
import sys
from pathlib import Path

import pytest

# Ensure project and API module are importable when running pytest from repo root
THIS_DIR = Path(__file__).resolve().parent
API_ROOT = THIS_DIR.parent
PROJECT_ROOT = API_ROOT.parent.parent

for path in (str(API_ROOT), str(PROJECT_ROOT)):
    if path not in sys.path:
        sys.path.insert(0, path)


@pytest.fixture(autouse=True)
def set_api_key_env(monkeypatch: pytest.MonkeyPatch):
    monkeypatch.setenv("API_KEY", "test-api-key")
    monkeypatch.setenv("API_KEY_HEADER", "X-API-Key")
    monkeypatch.setenv("API_KEY_QUERY", "api_key")
