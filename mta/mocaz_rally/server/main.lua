local db = dbConnect("sqlite", "mocaz_rally.db")
local profiles = {}

if not db then
    outputDebugString("[Mocaz Rally] Nepodařilo se otevřít SQLite databázi.", 1)
else
    dbExec(db, [[CREATE TABLE IF NOT EXISTS profiles (
        serial TEXT PRIMARY KEY,
        nickname TEXT NOT NULL,
        birth_year INTEGER NOT NULL,
        driver_style TEXT NOT NULL DEFAULT 'rookie',
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    )]])
end

local function cleanNickname(value)
    if type(value) ~= "string" then return nil end
    value = value:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[<>]", "")
    if #value < 3 or #value > MocazRally.MaxNicknameLength then return nil end
    if not value:match("^[%w _%-]+$") then return nil end
    return value
end

local function sendProfile(player, profile)
    profiles[player] = profile
    setElementData(player, "mocazRally:nickname", profile.nickname, false)
    setElementData(player, "mocazRally:birthYear", profile.birthYear, false)
    setElementData(player, "mocazRally:driverStyle", profile.driverStyle or "rookie", false)
    triggerClientEvent(player, "mocazRally:profileLoaded", resourceRoot, profile)
end

addEvent("mocazRally:requestProfile", true)
addEventHandler("mocazRally:requestProfile", resourceRoot, function()
    local player = client
    if not isElement(player) or not db then return end
    local qh = dbQuery(db, "SELECT nickname, birth_year, driver_style FROM profiles WHERE serial = ?", getPlayerSerial(player))
    local result = dbPoll(qh, -1)
    if result and result[1] then
        sendProfile(player, { nickname = result[1].nickname, birthYear = tonumber(result[1].birth_year), driverStyle = result[1].driver_style or "rookie", isNew = false })
    else
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
    dbExec(db, "INSERT OR REPLACE INTO profiles (serial, nickname, birth_year, driver_style) VALUES (?, ?, ?, COALESCE((SELECT driver_style FROM profiles WHERE serial = ?), 'rookie'))", serial, nickname, birthYear, serial)
    sendProfile(player, { nickname = nickname, birthYear = birthYear, driverStyle = "rookie", isNew = true })
end)

addEvent("mocazRally:chooseDriver", true)
addEventHandler("mocazRally:chooseDriver", resourceRoot, function(style)
    local player = client
    if not isElement(player) or not db or not profiles[player] then return end
    local valid = false
    for _, item in ipairs(MocazRally.DriverStyles) do if item.id == style then valid = true break end end
    if not valid then return end
    dbExec(db, "UPDATE profiles SET driver_style = ? WHERE serial = ?", style, getPlayerSerial(player))
    profiles[player].driverStyle = style
    triggerClientEvent(player, "mocazRally:driverChosen", resourceRoot, { nickname = profiles[player].nickname, birthYear = profiles[player].birthYear, driverStyle = style, isNew = false })
end)

addEvent("mocazRally:menuAction", true)
addEventHandler("mocazRally:menuAction", resourceRoot, function(action)
    local player = client
    if not isElement(player) or not profiles[player] then return end
    local allowed = { solo = true, multiplayer = true, school = true, garage = true, profile = true }
    if not allowed[action] then return end
    triggerClientEvent(player, "mocazRally:menuOpened", resourceRoot, action)
end)

addEventHandler("onPlayerQuit", root, function() profiles[source] = nil end)
addEventHandler("onResourceStart", resourceRoot, function()
    outputDebugString("[Mocaz Rally] Resource spuštěn. Verze " .. MocazRally.Version)
end)
