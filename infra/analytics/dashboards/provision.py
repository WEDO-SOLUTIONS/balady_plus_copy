#!/usr/bin/env python3
"""Provision Balady+ dashboards into a PostHog instance from the *.json files
next to this script. Idempotent: a dashboard whose exact name already exists
is skipped (use --force to delete and recreate it).

Usage:
    POSTHOG_HOST=https://153.80.192.8.sslip.io \
    POSTHOG_PROJECT_ID=1 \
    POSTHOG_API_KEY=phx_...  # personal API key, scopes: dashboard:write, insight:write, dashboard:read
    python3 provision.py [--force] [file.json ...]

Only python3 stdlib is used on purpose — no toolchain to install.
Compatible with python3.9+ (macOS system python).
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import urllib.parse
from pathlib import Path

HOST = os.environ.get("POSTHOG_HOST", "https://153.80.192.8.sslip.io").rstrip("/")
PROJECT_ID = os.environ.get("POSTHOG_PROJECT_ID", "")
API_KEY = os.environ.get("POSTHOG_API_KEY", "")

# HTTP goes through the curl binary rather than urllib: macOS system python
# links LibreSSL 2.8.3, which cannot complete the TLS handshake with the
# Caddy/LetsEncrypt setup on the analytics host. POSTHOG_INSECURE=1 skips cert
# verification for a fresh instance whose cert is not issued yet.
CURL_INSECURE = ["-k"] if os.environ.get("POSTHOG_INSECURE") == "1" else []


def api(method: str, path: str, body: dict | None = None) -> dict:
    cmd = [
        "curl", "-sS", "--max-time", "60",
        "-X", method,
        "-H", f"Authorization: Bearer {API_KEY}",
        "-H", "Content-Type: application/json",
        "-w", "\n%{http_code}",
        *CURL_INSECURE,
        f"{HOST}{path}",
    ]
    if body is not None:
        cmd += ["-d", json.dumps(body)]
    out = subprocess.run(cmd, capture_output=True, text=True)
    if out.returncode != 0:
        raise SystemExit(f"{method} {path} -> curl failed: {out.stderr.strip()}")
    payload, _, status = out.stdout.rpartition("\n")
    if not status.startswith("2"):
        raise SystemExit(f"{method} {path} -> HTTP {status}\n{payload}")
    return json.loads(payload or "{}")


def find_dashboard(name: str) -> dict | None:
    q = urllib.parse.quote(name)
    found = api("GET", f"/api/projects/{PROJECT_ID}/dashboards/?search={q}&limit=100")
    for d in found.get("results", []):
        if d.get("name") == name and not d.get("deleted"):
            return d
    return None


def provision_file(path: Path, force: bool) -> None:
    spec = json.loads(path.read_text())
    name = spec["dashboard"]["name"]

    existing = find_dashboard(name)
    if existing and not force:
        print(f"= {name}: already exists (id {existing['id']}), skipping — use --force to recreate")
        return
    if existing and force:
        api("PATCH", f"/api/projects/{PROJECT_ID}/dashboards/{existing['id']}/", {"deleted": True})
        print(f"- {name}: deleted old dashboard id {existing['id']}")

    dashboard = api(
        "POST",
        f"/api/projects/{PROJECT_ID}/dashboards/",
        {"name": name, "description": spec["dashboard"].get("description", "")},
    )
    print(f"+ {name}: created dashboard id {dashboard['id']}")

    for insight in spec["insights"]:
        created = api(
            "POST",
            f"/api/projects/{PROJECT_ID}/insights/",
            {
                "name": insight["name"],
                "query": insight["query"],
                "dashboards": [dashboard["id"]],
                "saved": True,
            },
        )
        print(f"  + insight '{insight['name']}' (id {created['id']})")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="delete and recreate existing dashboards")
    parser.add_argument("files", nargs="*", help="specific dashboard json files (default: all next to this script)")
    args = parser.parse_args()

    if not PROJECT_ID or not API_KEY:
        sys.exit("Set POSTHOG_PROJECT_ID and POSTHOG_API_KEY (personal key, phx_...). See README.md.")

    here = Path(__file__).parent
    files = [Path(f) for f in args.files] or sorted(here.glob("*.json"))
    if not files:
        sys.exit("No dashboard json files found.")

    print(f"Provisioning {len(files)} dashboard(s) into {HOST}, project {PROJECT_ID}")
    for f in files:
        provision_file(f, args.force)
    print("Done.")


if __name__ == "__main__":
    main()
