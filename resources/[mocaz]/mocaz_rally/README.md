# Mocaz Rally — FiveM ESX prototype v0.1.1

Samostatný vývojový resource pro rally časovky v GTA V. Do stávajícího serveru se přidává samostatně.

## Požadavky
- ESX Legacy s exports['es_extended']:getSharedObject()
- oxmysql
- FXServer a MySQL/MariaDB

## Instalace
1. Nahraj složku `resources/[mocaz]/mocaz_rally` na server.
2. Importuj `sql/install.sql` do databáze.
3. V `server.cfg` zajisti pořadí: `ensure oxmysql`, `ensure es_extended`, `ensure mocaz_rally`.
4. Ve hře se přesuň ke startovní zóně etapy a spusť `/rally`.

## Nové ve v0.1.1
- Server kontroluje, zda je hráč v blízkosti startu, checkpointu a cíle.
- Čas se měří na serveru v milisekundách, klientská hodnota se nepoužívá.
- Menu zobrazuje stručný přehled nejlepších osobních rekordů podle tratě.

## Omezení prototypu
- Souřadnice Sandy Shores jsou orientační a musí se ověřit ve hře.
- Multiplayer lobby a synchronizovaný společný start nejsou hotové; jde stále o sólo časovku.
- Serverové ověřování polohy zvyšuje odolnost, ale není plnohodnotný anti-cheat. Dále je nutné testovat zneužití eventů a rychlosti pohybu.
- Časy zobrazené v přehledu jsou zkrácené na sekundy.
- Žádné externí modely aut nejsou přiloženy. Sultan je pouze vanilla GTA V testovací vůz, nikoli skutečné rally auto.
- Před přidáním reálných aut ověř licenci autora, FiveM kompatibilitu a práva pro použití/redistribuci. Nepoužívej modely z RBR nebo jiných her bez výslovného povolení.
- Resource nebyl automaticky otestován na Hythostu.

Další fáze: multiplayer lobby, leaderboard s přezdívkami a přesnými časy, servisní zóna a licencované vozy.
