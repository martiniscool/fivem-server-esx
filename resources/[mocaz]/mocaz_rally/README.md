# Mocaz Rally — FiveM ESX prototype v0.1.0

Samostatný vývojový resource pro rally časovky v GTA V. Do stávajícího serveru se přidá až po vlastním testu.

## Požadavky
- ESX Legacy s exports['es_extended']:getSharedObject()
- oxmysql
- FXServer a MySQL/MariaDB

## Instalace
1. Nahraj složku resources/[mocaz]/mocaz_rally na server.
2. Importuj sql/install.sql do databáze.
3. V server.cfg zajisti pořadí: ensure oxmysql, ensure es_extended, ensure mocaz_rally.
4. Restartuj resource a ve hře spusť /rally.

## Omezení prototypu
- Souřadnice Sandy Shores jsou orientační a musí se ověřit ve hře.
- Multiplayer lobby a synchronizovaný společný start nejsou hotové; první verze je základ pro sólo časovku.
- Server ověřuje pořadí checkpointů, ale zatím neověřuje serverově vzdálenost hráče od checkpointu. Není to anti-cheat ani soutěžní produkční řešení.
- Čas se ukládá v sekundové přesnosti.
- Žádné externí modely aut nejsou přiloženy. Sultan je pouze vanilla GTA V testovací vůz, nikoli skutečné rally auto.
- Před přidáním reálných aut ověř licenci autora, FiveM kompatibilitu a práva pro použití/redistribuci. Nepoužívej modely z RBR nebo jiných her bez výslovného povolení.
- Resource nebyl automaticky otestován na Hythostu.

Další fáze: serverové ověřování polohy, skutečná multiplayer lobby, leaderboard UI, servisní zóna a licencované vozy.
