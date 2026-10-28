# Mocaz Rally — MTA:SA resource 0.5.0

Samostatný závodní režim pro Multi Theft Auto: San Andreas. Nejde o FiveM resource.

## Co je v této verzi

- CEF úvodní obrazovka, registrace závodnického profilu a volba stylu.
- SQLite profily ukládané podle MTA serialu.
- Opravený tok výběru závodnického stylu: server při volbě znovu ověří profil v databázi, takže není závislý jen na dočasné cache v paměti.
- Diagnostické hlášky profilu na klientu i serveru, aby šlo zjistit, proč se menu případně vrací.
- Hlavní menu, sólová časovka, základní lobby, garáž, rally škola a historie výsledků.
- Jedna prototypová etapa, checkpointy, odpočet, cílový čas a oddělená dimenze závodu.

## Instalace / aktualizace

1. Zastav resource příkazem `stop mocaz_rally`.
2. Udělej zálohu aktuální složky `resources/mocaz_rally`.
3. Stáhni ZIP repozitáře a nahraj složku `mta/mocaz_rally` do `resources` tak, aby výsledná cesta byla `resources/mocaz_rally/meta.xml`.
4. Přepiš soubory resource novými soubory. Neponechávej staré `server/main.lua`, `client/main.lua` ani `ui/app.js`.
5. V konzoli spusť `refresh` a `start mocaz_rally`.
6. Odpoj se a znovu připoj. Zkontroluj serverovou konzoli a klientskou debug konzoli F8.

Databáze `mocaz_rally.db` se nemaže; existující profily mají zůstat zachovány.

## Když se profil stále vrací na registraci

Nová verze vypisuje hlášky s prefixem `[Mocaz Rally]`. Po kliknutí na styl se má objevit `Styl ... uložen` v serverové konzoli a `driverChosen` v klientské konzoli. Pokud se neobjeví, pravděpodobně hosting stále spouští starý soubor, resource nebyl skutečně restartován nebo se událost z UI nedostává do Lua.

## Co ještě není produkční hotové

- Nebyl proveden test na živém hostingu MTA; tuto verzi je nutné ověřit na konkrétním hostingu.
- Je jen jedna prototypová etapa LS Airport Sprint; její souřadnice a checkpointy je potřeba ověřit ve hře.
- Auta jsou zatím vestavěné modely GTA:SA. Externí reálné modely aut, skutečný tuning, vlastní rally mapy a jejich assety nejsou přibalené.
- Multiplayer je základní lobby, ne robustní matchmaking.
- Škola obsahuje úvodní lekce; nejsou to zatím propracované výukové mise.
- Výkony uvedené u aut jsou informativní a zatím nemění fyziku.
- Profil není chráněný účtem a heslem; identita je navázaná na MTA serial.
- Anti-cheat, administrace, zálohování databáze a produkční ochrana proti cheatům zatím nejsou implementované.


## Build 0.4.0 — rozšířený závodní základ

Tato verze přidává:
- pět konfigurovaných etap: LS Airport Sprint, Airport Grand Loop, Red County Run, Flint Hills Gravel a Bone County Desert;
- rozšířený výběr 12 vozidel založených na dostupných modelech GTA: San Andreas;
- persistentní rally setupy Stage 1, Stage 2 a Rally Setup, ukládané do SQLite a aplikované při vytvoření závodního auta;
- žebříček nejlepších uložených časů podle etap;
- aktualizované menu a verzi resource 0.4.0.

### Instalace aktualizace
Nahraď celý adresář `mocaz_rally` verzí z repozitáře a potom v konzoli MTA spusť:
```
refresh
restart mocaz_rally
```
Neodstraňuj soubor `mocaz_rally.db`, obsahuje profily a výsledky.

### Důležitá omezení
Etapy používají konfigurované souřadnice a je nutné je fyzicky projet a ověřit na konkrétní mapě MTA:SA. Vozidla jsou aktuálně modely GTA:SA s herními názvy; skutečné značky, nové karoserie, interiéry, zvuky a kvalitní modpack vyžadují samostatné kompatibilní DFF/TXD/handling soubory a testování. Rally setupy v tomto prototypu nemají napojenou ekonomiku a jsou odemčené pro testování. Tato verze nebyla na tvém hostingu spuštěna ani otestována.


## Build 0.5.0 — rozšíření rally nabídky

- Přidáno šest dalších výběrů vozidel využívajících vestavěné modely GTA:SA (Buffalo, Landstalker Rally, Mesa Rally Raid, Banshee, Phoenix a Hotknife).
- Přidány dvě konfigurované etapy: Mount Chiliad Technical a Las Venturas Night Sprint.
- Přidána centrální paleta pro červeno-černý závodní vzhled UI.

**Pozor:** jde o rozšíření konfiguračního základu, nikoli o hotový externí modpack. Vozidla stále používají původní modely GTA:SA a nové etapy mají neověřené souřadnice. Před veřejným spuštěním je nutné tratě projet ve hře a dodat samostatné legálně použitelné modely aut/mapové assety. Na FakaHedě tato verze zatím není nasazena ani otestována.
