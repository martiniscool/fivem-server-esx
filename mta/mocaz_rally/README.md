# Mocaz Rally — MTA:SA prototype 0.2.0

Samostatný závodní resource pro Multi Theft Auto: San Andreas. Je oddělený od původního FiveM prototypu.

## Co aktuálně obsahuje
- Úvodní CEF rozhraní s vytvořením profilu, přezdívkou a rokem narození.
- Ukládání profilu do SQLite podle MTA serialu.
- Výběr závodnické identity: Rookie, Technik a Showman.
- První sólo časovku: spawn auta, odpočet, checkpointy, kontrolu pořadí, cílový čas a uložení výsledku.
- Základní multiplayer lobby: vytvoření, připojení, host start a společný odpočet.
- Garáž se šesti vestavěnými modely GTA:SA.
- Rally školu s úvodními lekcemi brzdění, ideální stopy a ruční brzdy.
- Historii výsledků v profilu.
- Oddělenou dimenzi pro závodění, aby závody neprobíhaly v běžném open worldu.

## Instalace na čistý MTA server
1. Stáhni složku `mta/mocaz_rally` z repozitáře.
2. Nahraj samotnou složku `mocaz_rally` do složky `resources` svého MTA serveru.
3. V serverové konzoli spusť `refresh` a potom `start mocaz_rally`.
4. Alternativně přidej `start mocaz_rally` do `mtaserver.conf`.
5. Připoj se do hry. Resource si automaticky vytvoří databázi `mocaz_rally.db`.

## Důležité limity první verze
- Resource zatím nebyl otestován na živém MTA serveru. Nejdřív jej spusť na testovacím serveru a zkontroluj serverovou i klientskou debug konzoli.
- Je nakonfigurovaná jedna prototypová etapa LS Airport Sprint. Souřadnice, výška checkpointů a průjezdnost trasy se musí ověřit ve hře a případně upravit.
- Vozidla jsou zatím pouze vestavěné modely GTA:SA; žádné externí modely ani mapy nejsou přibalené.
- Multiplayer má jednu otevřenou lobby a je to základní implementace, nikoli produkční matchmaking.
- Rally škola zatím poskytuje instrukce, ne plnohodnotné praktické zkoušky.
- Hodnoty výkonu aut jsou zatím informativní a nemění fyziku vozidel.
- Profil je navázaný na MTA serial, nejde o účet chráněný heslem. Rok narození není ověřením věku.
- Anti-cheat, administrace, moderace a produkční zálohování databáze nejsou součástí prototypu.
