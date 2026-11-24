#!/usr/bin/env python3
"""Collects one player's classical games from Lichess broadcasts into a PGN
for tool/games/build.dart (players/<Name>.pgn), for players PGN Mentor does
not have yet. Broadcast PGN headers are unreliable, so each game gets the
date of its round and tie-break rounds (rapid, blitz, armageddon) are skipped.

    python3 -I tool/games/lichess_player.py Sindarov <src>/players/Sindarov.pgn

The tours are listed in data/games/sources.yaml (challenge.lichess).
"""
import datetime
import json
import re
import sys
import time
import urllib.error
import urllib.request

FAST = re.compile(r'tie-?break|rapid|blitz|armageddon|playoff', re.I)


def get(url: str) -> str:
    req = urllib.request.Request(url, headers={'User-Agent': 'games-library-builder'})
    for attempt in range(6):
        try:
            with urllib.request.urlopen(req) as r:
                return r.read().decode('utf-8')
        except urllib.error.HTTPError as e:
            # Lichess asks for a full minute's pause after a 429.
            if e.code != 429 or attempt == 5:
                raise
            time.sleep(61)
    raise AssertionError('unreachable')


def tours_from_sources(player: str) -> list[str]:
    # Tiny reader for `lichess: {<Name>: [id, id, …]}` in sources.yaml (no PyYAML needed).
    text = open('data/games/sources.yaml', encoding='utf-8').read()
    m = re.search(rf'^\s+{re.escape(player)}:\s*\[([^\]]*)\]', text, re.M)
    if not m:
        sys.exit(f'no lichess tours for {player} in data/games/sources.yaml')
    return [t.strip() for t in m.group(1).split(',') if t.strip()]


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    player, out = sys.argv[1], sys.argv[2]
    games = []
    for tour in tours_from_sources(player):
        info = json.loads(get(f'https://lichess.org/api/broadcast/{tour}'))
        for rnd in info['rounds']:
            if FAST.search(rnd['name']) or not rnd.get('startsAt'):
                continue
            day = datetime.datetime.fromtimestamp(rnd['startsAt'] / 1000, datetime.UTC).strftime('%Y.%m.%d')
            pgn = get(f"https://lichess.org/api/broadcast/round/{rnd['id']}.pgn").replace('\r', '')
            for g in re.split(r'\n\n(?=\[Event )', pgn.strip()):
                h = dict(re.findall(r'^\[(\w+) "(.*)"\]$', g, re.M))
                if player.lower() not in (h.get('White', '') + h.get('Black', '')).lower():
                    continue
                games.append(re.sub(r'^\[Date "[^"]*"\]$', f'[Date "{day}"]', g, flags=re.M))
            time.sleep(1)  # be gentle with the API
        print(f"{info['tour']['name']}: {len(games)} games so far", file=sys.stderr)
    with open(out, 'w', encoding='utf-8') as f:
        f.write('\n\n'.join(games) + '\n')
    print(f'{len(games)} games → {out}', file=sys.stderr)


if __name__ == '__main__':
    main()
