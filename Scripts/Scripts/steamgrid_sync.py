#!/usr/bin/env python3

import os
import requests
import vdf
from pathlib import Path

API_KEY = "c740e6a720de0991ce43d97e0482c745

STEAM_USERDATA = Path.home() / ".local/share/Steam/userdata"
HEADERS = {"Authorization": f"Bearer {API_KEY}"}


# ---------- STEAM DETECTION ----------

def get_user_folder():
    users = [p for p in STEAM_USERDATA.iterdir() if p.is_dir() and p.name.isdigit()]
    if not users:
        raise RuntimeError("No Steam userdata found")
    return users[0]


def load_shortcuts():
    user = get_user_folder()
    file = user / "config/shortcuts.vdf"

    if not file.exists():
        raise RuntimeError("shortcuts.vdf not found")

    with open(file, "rb") as f:
        data = vdf.binary_load(f)

    return data.get("shortcuts", {}), user


# ---------- STEAMGRIDDB ----------

def search_game(name):
    url = f"https://www.steamgriddb.com/api/v2/search/autocomplete/{name}"
    r = requests.get(url, headers=HEADERS, timeout=20)
    r.raise_for_status()
    return r.json().get("data", [])


def get_art(game_id, art_type):
    url = f"https://www.steamgriddb.com/api/v2/{art_type}/game/{game_id}"
    r = requests.get(url, headers=HEADERS, timeout=20)
    r.raise_for_status()
    data = r.json().get("data", [])
    return data[0]["url"] if data else None


def download(url, path):
    r = requests.get(url, timeout=60)
    r.raise_for_status()
    with open(path, "wb") as f:
        f.write(r.content)


# ---------- UI ----------

def choose(results):
    if not results:
        return None

    for i, r in enumerate(results, 1):
        print(f"{i}) {r['name']}")

    print("0) skip")

    while True:
        try:
            c = int(input("> "))
            if c == 0:
                return None
            return results[c - 1]
        except:
            pass


# ---------- MAIN ----------

def main():
    shortcuts, user = load_shortcuts()

    grid_dir = user / "config/grid"
    grid_dir.mkdir(parents=True, exist_ok=True)

    for _, sc in shortcuts.items():

        if not isinstance(sc, dict):
            continue

        name = sc.get("AppName", "").strip()
        if not name:
            continue

        print(f"\n🎮 {name}")

        try:
            results = search_game(name)
            choice = choose(results)

            if not choice:
                continue

            game_id = choice["id"]

            grid = get_art(game_id, "grids")
            hero = get_art(game_id, "heroes")
            logo = get_art(game_id, "logos")
            icon = get_art(game_id, "icons")

            safe = "".join(c for c in name if c.isalnum() or c in " _-").strip()

            if grid:
                download(grid, grid_dir / f"{safe}.png")
            if hero:
                download(hero, grid_dir / f"{safe}_hero.png")
            if logo:
                download(logo, grid_dir / f"{safe}_logo.png")
            if icon:
                download(icon, grid_dir / f"{safe}_icon.png")

            print("✔ done")

        except Exception as e:
            print("error:", e)


if __name__ == "__main__":
    main()
