# Mocaz Rally — MTA:SA prototype 0.1.0

Standalone rally-game resource for Multi Theft Auto: San Andreas. This is a fresh MTA implementation, separate from the earlier FiveM prototype.

## Current foundation
- Full-screen CEF interface with a dark red/black motorsport theme.
- First-join profile form (nickname and birth year).
- Persistent profile storage in SQLite, keyed by MTA player serial.
- Driver identity selection: Rookie, Technik, Showman.
- Main menu entries for Solo, Multiplayer, Rally School, Garage and Profile.
- Hides regular player HUD/chat and freezes/hides the player while the menu is open.
- Menu destinations are currently UI placeholders; playable rally stages, vehicle assets, tuning, multiplayer lobby and school lessons are not implemented yet.

## Install
1. Copy the folder named mocaz_rally into the MTA server's resources folder.
2. In the MTA server console run refresh then start mocaz_rally, or add start mocaz_rally to mtaserver.conf.
3. Join the server. The resource creates mocaz_rally.db automatically.

## Notes
- The profile currently uses the player's MTA serial as its persistent key. This is a prototype identity system, not a secure account/password system.
- Birth year is a profile field only; it is not age verification.
- Menu camera coordinates and the first screen are prototype values and need in-game testing.
- The UI imports Google Fonts when internet access is available; local fallback fonts are included.
- No third-party vehicle models or maps are bundled. Only add assets with verified permissions/licences.
- Not yet tested on a live MTA server.
