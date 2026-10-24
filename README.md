# Move Damage Info

A [Gen1Recomp](https://gen1recomp.com) mod: while you pick a move in battle, the
TYPE/PP box shows the damage that move would deal **right now**, with two more
pages for its numbers and a plain-language description of what it does.

Written against the Gen1Recomp 0.3.x source (mod API 2, Gen 1 only).

## What it does

The box the cart already draws at the top-left of the move list gets three
pages. Left/Right switches between them, and the choice resets every time you
open the move list.

| Page | Shows |
| --- | --- |
| 1 (default) | `DMG 12-14` against the foe in front of you, the move's type, PP |
| 2 | `PWR 95`, `ACC 100`, the type multiplier (`X1/4` … `X4`) |
| 3 | a short description: `LOWERS / ATTACK`, `MAY / BURN`, `HITS / 2-5 TIMES` |

**SELECT** opens a text box with the same information spelled out: the effect
in words, power, accuracy, the damage range, how much of the foe's HP that is,
the matchup, and the PP.

A disabled move keeps the cart's own `disabled!` message: the mod draws nothing
for it.

## The damage is the real one

The number is not an estimate. The mod calls the cart's own calculator
(`src.battle.Damage.compute`) twice — once with the lowest random roll and once
with the highest, no critical hit — so the range already accounts for:

- the attacker's stats, stat stages, badge boosts and burn;
- the defender's stats, stages, Reflect and Light Screen;
- STAB, the type chart (including immunities), and the 217–255 random factor;
- the Gen 1 floor order, which is why the two ends of the range are computed
  rather than scaled.

Multi-hit moves report the damage **per hit**, and the description page says so.

## Languages

The mod's own text exists in English (default), Italian, Spanish and Portuguese:

- `MODS → Move Damage Info → LANGUAGE`, or the `MOVE INFO LANG` row in the
  in-game `OPTION` menu.

Move and type names are the cart's, so they follow the game — and any
translation mod you have installed.

## Install

1. Download the newest ZIP from
   [Releases](https://github.com/cchrkk/gen1recomp-move-damage-info/releases).
2. `MODS → Import mod .zip`.
3. Enable it if it is not already on.

Manual install: extract the ZIP into
`<save dir>/mods/move_damage_info/`, where the save dir is

- Windows: `%APPDATA%\pokemon-love2d\`
- macOS: `~/Library/Application Support/pokemon-love2d/`
- Linux: `~/.local/share/pokemon-love2d/`

or the game folder's `mods/` in portable mode.

The mod is on by default. Turn it off in `MODS → Move Damage Info`, in the
`OPTION` menu, or per-save.

## Building the ZIP

The manifest sits at the archive root, so a plain zip of this folder minus
`.git` is the release asset:

```sh
zip -r move_damage_info-1.2.0.zip main.lua manifest.json README.md CHANGELOG.md LICENSE
```

## Tests

The drawing and the damage range are tested headless (stub `love`, stub engine
modules), including all four languages:

```sh
luajit tests/move_damage_info_test.lua
```

## Licence

MIT — see [LICENSE](LICENSE).
