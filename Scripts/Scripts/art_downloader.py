#!/usr/bin/env python3

import requests
import time
from pathlib import Path

API_KEY = "c740e6a720de0991ce43d97e0482c745"

HEADERS = {
    "Authorization": f"Bearer {API_KEY}"
}

# ---------------- SETTINGS ----------------

GAMES = [
    "Megabonk",
    "Guacamelee",
    "Sifu",
    "Hades",
    "Celeste"
]
  
OUTPUT_DIR = Path.home() / Games/Art


# ---------------- STEAMGRIDDB ----------------

def search_game(name):
    url = f"https://www.steamgriddb.com/api/v2/search/autocomplete/{name}"
    r = requests.get(url, headers=HEADERS, timeout=20)
    return r.json().get("data", [])


def get_art(game_id, art_type):
    url = f"https://www.steamgriddb.com/api/v2/{art_type}/game/{game_id}"
    r = requests.get(url, headers=HEADERS, timeout=20)
    data = r.json().get("data", [])
    return data[0]["url"] if data else None


def download(url, path):
    r = requests.get(url, timeout=60)
    path.write_bytes(r.content)


def pick(results):
    return results[0] if results else None


# ---------------- MAIN ----------------

def main():
    OUTPUT_DIR.mkdir(exist_ok=True)

    for name in GAMES:
        print(f"\n🎮 {name}")

        try:
            results = search_game(name)
            game = pick(results)

            if not game:
                print("no match")
                continue

            game_id = game["id"]

            folder = OUTPUT_DIR / name
            folder.mkdir(exist_ok=True)

            grid = get_art(game_id, "grids")
            hero = get_art(game_id, "heroes")
            logo = get_art(game_id, "logos")
            icon = get_art(game_id, "icons")

            if grid:
                download(grid, folder / "grid.png")

            if hero:
                download(hero, folder / "hero.jpg")

            if logo:
                download(logo, folder / "logo.png")

            if icon:
                download(icon, folder / "icon.png")

            print("✔ done")

            time.sleep(0.3)

        except Exception as e:
            print("error:", e)


if __name__ == "__main__":
    main()
