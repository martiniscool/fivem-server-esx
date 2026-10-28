local db = dbConnect("sqlite", "mocaz_rally.db")
local profiles = {}
local lastProfileRequest = {}

local function log(message, level)
    outputDebugString("[Mocaz Rally] " .. tostring(message), level or 3)
end

if not db then
    log("FATAL: SQLite databázi se nepodařilo otevřít.", 1)
else
    local ok = dbExec(db, [[CREATE TABLE IF NOT EXISTS profiles (
        serial TEXT PRIMARY KEY,
        nickname TEXT NOT NULL,
        birth_year INTEGER NOT NULL,
        driver_style TEXT NOT NULL DEFAULT 'rookie',
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    )]])
    log("Databáze inicializována: " .. tostring(ok))
end

local function cleanNickname(value)
    if type(value) ~= "string" then return nil end
    value = value:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[<>]", "")
    if #value < 3 or #value > MocazRally.MaxNicknameLength then return nil end
    if not value:match("^[%w _%-]+$") then return nil end
    return value
end

local function sendProfile(player, profile, isNew)
    if not isElement(player) or type(profile) ~= "table" or not profile.nickname then return false end
    profile.birthYear = tonumber(profile.birthYear)
    profile.driverStyle = profile.driverStyle or "rookie"
    profile.isNew = isNew == true
    profiles[player] = profile
    setElementData(player, "mocazRally:nickname", profile.nickname, false)
    setElementData(player, "mocazRally:birthYear", profile.birthYear, false)
    setElementData(player, "mocazRally:driverStyle", profile.driverStyle, false)
    triggerClientEvent(player, "mocazRally:profileLoaded", resourceRoot, profile)
    log("Profil odeslán hráči " .. getPlayerName(player) .. " (" .. profile.nickname .. "), isNew=" .. tostring(profile.isNew))
    return true
end

local function fetchProfile(player)
    if not db or not isElement(player) then return nil end
    local serial = getPlayerSerial(player)
    if not serial or serial == "" then return nil end
    local rows = dbPoll(dbQuery(db, "SELECT nickname, birth_year, driver_style FROM profiles WHERE serial = ?", serial), -1)
    if rows and rows[1] then
        return { nickname = rows[1].nickname, birthYear = tonumber(rows[1].birth_year), driverStyle = rows[1].driver_style or "rookie" }
    end
    return nil
end

addEvent("mocazRally:requestProfile", true)
addEventHandler("mocazRally:requestProfile", resourceRoot, function()
    local player = client
    if not isElement(player) then return end
    local now = getTickCount()
    if lastProfileRequest[player] and now - lastProfileRequest[player] < 3000 then
        return
    end
    lastProfileRequest[player] = now
    if not db then
        triggerClientEvent(player, "mocazRally:notice", resourceRoot, "Databáze profilu není dostupná. Kontaktuj správce serveru.")
        log("requestProfile: databáze není dostupná.", 1)
        return
    end
    local profile = fetchProfile(player)
    if profile then
        sendProfile(player, profile, false)
    else
        profiles[player] = nil
        log("Profil nenalezen pro serial " .. tostring(getPlayerSerial(player)) .. "; zobrazena registrace.")
        triggerClientEvent(player, "mocazRally:profileMissing", resourceRoot)
    end
end)

addEvent("mocazRally:createProfile", true)
addEventHandler("mocazRally:createProfile", resourceRoot, function(nickname, birthYear)
    local player = client
    if not isElement(player) or not db then return end
    nickname = cleanNickname(nickname)
    birthYear = tonumber(birthYear)
    if not nickname then
        triggerClientEvent(player, "mocazRally:notice", resourceRoot, "Přezdívka musí mít 3–24 znaků a obsahovat jen písmena, čísla, mezery, _ nebo -.")
        return
    end
    if not birthYear or birthYear % 1 ~= 0 or birthYear < MocazRally.MinBirthYear or birthYear > MocazRally.MaxBirthYear then
        triggerClientEvent(player, "mocazRally:notice", resourceRoot, "Zadej platný rok narození.")
        return
    end
    local serial = getPlayerSerial(player)
    local existing = fetchProfile(player)
    local style = existing and existing.driverStyle or "rookie"
    local ok = dbExec(db, "INSERT OR REPLACE INTO profiles (serial, nickname, birth_year, driver_style) VALUES (?, ?, ?, ?)", serial, nickname, birthYear, style)
    if not ok then
        log("Uložení profilu selhalo pro " .. getPlayerName(player), 1)
        triggerClientEvent(player, "mocazRally:notice", resourceRoot, "Profil se nepodařilo uložit. Zkontroluj konzoli serveru.")
        return
    end
    sendProfile(player, { nickname = nickname, birthYear = birthYear, driverStyle = style }, not (existing and existing.driverStyle))
end)

addEvent("mocazRally:chooseDriver", true)
addEventHandler("mocazRally:chooseDriver", resourceRoot, function(style)
    local player = client
    if not isElement(player) or not db then return end
    local valid = false
    for _, item in ipairs(MocazRally.DriverStyles) do
        if item.id == style then valid = true break end
    end
    if not valid then
        log("Neplatný styl řidiče: " .. tostring(style), 2)
        return
    end
    -- Nezávisíme na cache v paměti: načteme profil z DB, pokud server po restartu cache ztratil.
    local profile = profiles[player] or fetchProfile(player)
    if not profile then
        log("chooseDriver: profil chybí, vracím hráče k registraci.", 2)
        triggerClientEvent(player, "mocazRally:profileMissing", resourceRoot)
        return
    end
    local ok = dbExec(db, "UPDATE profiles SET driver_style = ? WHERE serial = ?", style, getPlayerSerial(player))
    if not ok then
        triggerClientEvent(player, "mocazRally:notice", resourceRoot, "Nepodařilo se uložit závodnický styl.")
        return
    end
    profile.driverStyle = style
    profiles[player] = profile
    setElementData(player, "mocazRally:driverStyle", style, false)
    triggerClientEvent(player, "mocazRally:driverChosen", resourceRoot, {
        nickname = profile.nickname, birthYear = profile.birthYear, driverStyle = style, isNew = false
    })
    log("Styl " .. style .. " uložen pro " .. tostring(profile.nickname))
end)

addEvent("mocazRally:menuAction", true)
addEventHandler("mocazRally:menuAction", resourceRoot, function(action)
    local player = client
    if not isElement(player) or not profiles[player] then return end
    local allowed = { solo = true, multiplayer = true, school = true, garage = true, profile = true }
    if not allowed[action] then return end
    triggerClientEvent(player, "mocazRally:menuOpened", resourceRoot, action)
end)

addEventHandler("onPlayerQuit", root, function() profiles[source] = nil; lastProfileRequest[source] = nil end)
addEventHandler("onResourceStart", resourceRoot, function()
    log("Resource spuštěn. Verze " .. MocazRally.Version)
end)
