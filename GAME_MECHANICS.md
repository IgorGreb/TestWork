# Game Mechanics

## Overview
- Chick Game is a portrait-only match-3 puzzle built with Flutter and Riverpod.
- Each mission is a self-contained level with a target score and flavor text (see `lib/features/levels/level_missions.dart`).
- The player manipulates a 7x7 grid of egg tiles (`lib/features/game/egg_assets.dart`) trying to meet the mission score before running out of moves.

## Board Initialization
- `GameController` (`lib/features/game/game_controller.dart`) generates the starting board by filling every cell with a random egg type while rejecting any placement that would immediately create a match of три або квадрат 2×2, потім повторює спробу, доки не зʼявиться хоча б один валідний своп.  
  Уся ця робота виконується в окремому ізоляті, тому запуск рівня й перегенерація дошки не блокують головний потік.
- Tiles are represented by integer indices pointing at textures in `eggAssetPaths`.

## Turn Flow
1. Player taps any cell to select it (stored as `selectedRow/selectedCol` in `GameState`).
2. Tapping an adjacent cell attempts a swap. Taps on non-adjacent cells simply move the selection.
3. The swap is simulated on a cloned board; only swaps that create at least one horizontal/vertical group of ≥3 identical tiles **або** квадрат 2х2 одного типу яйця є валідними. Failed swaps just clear the selection and do not consume a move.
4. Successful swaps decrement `movesLeft` by one and trigger `_resolveBoard`.

## Match Detection & Resolution
- `_detectMatchGroups` scans rows and columns separately so “T” and “+” shapes are treated as multiple groups sharing tiles, and додатково перевіряє кожен 2х2 блок, щоб врахувати квадратні збіги.
- `_resolveBoard` loops while matches exist:
  - Adds all matched positions to a removal set.
  - Increments `score` by `group.length * 10`.
  - Awards one coin for every group larger than three and fires haptic feedback.
  - Removes matched tiles by writing `-1`, collapses columns downward, spawns random eggs at the top, and rescans to allow cascading combos.
- Після завершення каскаду, якщо на дошці не залишилося жодного можливого ходу, контролер автоматично перегенерує поле (без втрати рахунку чи ходів), щоб гравець не застряг.
- Win condition: `score >= targetScore`.
- Loss condition: `movesLeft == 0` while the target score is not met.

## Moves, Status, and Controls
- Fresh games start with 25 moves (`GameState` default) **та обмеженням за часом** — кожна місія з `level_missions.dart` має `timeLimitSeconds`, що запускає зворотний відлік. Таймер зупиняється під час паузи та обнуляється при рестарті.
- Restarting the level regenerates the whole board and resets moves/score/time.
- `GameStatus` drives UI overlays:
  - `playing`: normal interaction.
  - `paused`: shown when the player taps the pause icon; moves/hints freeze.
  - `won` / `lost`: overlay appears з новим повноекранним повідомленням у стилі макета (великі таблички SCORE/BEST, кнопки HOME/RESTART і яскрава кнопка NEXT на перемогу).
- Completing a mission notifies `levelsControllerProvider` so that higher missions can unlock.

## Hints
- `_hintTimer` in `GameScreen` polls every second. If the player has not interacted with the board for five seconds, the controller scans for the first valid swap and stores its coordinates in `hintPositions`.
- `_BoardView` highlights hinted tiles with a yellow border, and the hint clears after the next interaction.

## Coins and Shop Integration
- Coins reflect in `state.coinsEarned` during the level and are synced into the persistent `ShopController` when matches of four or more are resolved.
- The shop (`lib/features/shop/shop_controller.dart`) persists balances and purchases via `SharedPreferences`.
- `finalizeCoins()` now grants a victory bonus once per completed mission: a flat +5 coins plus +2 coins for every unused move, both added to the HUD tally and written to the shop balance.
- Найкращий рахунок кожного рівня зберігається у `GameStatsRepository` (SharedPreferences) і показується на екрані завершення, що мотивує перевершувати попередні результати.

## Mission and Progression Context
- Level data resides in `level_missions.dart` and currently covers nine missions with progressively higher target scores.
- `GameScreen` reads the desired mission index from the navigation arguments (defaulting to level 1) and caches it for the lifetime of the screen.
- When `GameStatus.won` is reached the mission is marked as complete, enabling progression across the larger app (leaderboards, shop, etc.).

## UI Summary
- The `ChickLayout` scaffold renders HUD elements—score, target, moves, coins, mission text, pause/play button—and the board grid.
- Tiles are rendered via `GridView.builder` with `AssetImage` backgrounds, and the selected tile gains a white border for clarity.
- Winning or losing overlays block the board via a centered column to avoid unintended taps while the player decides what to do next.
