local screenW, screenH = guiGetScreenSize()
local browserGUI, browser
local profileReady = false

local function hideWorld()
    fadeCamera(true, 0.5)
    setElementFrozen(localPlayer, true)
    setElementAlpha(localPlayer, 0)
    setCameraMatrix(MocazRally.MenuCamera.x, MocazRally.MenuCamera.y, MocazRally.MenuCamera.z, MocazRally.MenuCamera.lx, MocazRally.MenuCamera.ly, MocazRally.MenuCamera.lz)
    showChat(false)
    showPlayerHudComponent("all", false)
end

local function showWorld()
    setElementAlpha(localPlayer, 255)
    setElementFrozen(localPlayer, false)
    setCameraTarget(localPlayer)
    showChat(true)
    showPlayerHudComponent("all", true)
end

local function callUI(functionName, ...)
    if not isElement(browser) then return end
    local encoded = {}
    for i, value in ipairs({...}) do encoded[i] = toJSON(value, true) end
    executeBrowserJavascript(browser, "window.MocazRallyUI && window.MocazRallyUI." .. functionName .. "(" .. table.concat(encoded, ",") .. ");")
end
MocazRallyCallUI = callUI

addEvent("mocazRally:uiCreateProfile", true)
addEventHandler("mocazRally:uiCreateProfile", root, function(nickname, birthYear)
    triggerServerEvent("mocazRally:createProfile", resourceRoot, nickname, tonumber(birthYear))
end)
addEvent("mocazRally:uiChooseDriver", true)
addEventHandler("mocazRally:uiChooseDriver", root, function(style)
    triggerServerEvent("mocazRally:chooseDriver", resourceRoot, style)
end)
addEvent("mocazRally:uiMenuAction", true)
addEventHandler("mocazRally:uiMenuAction", root, function(action)
    triggerServerEvent("mocazRally:requestGameData", resourceRoot, action)
end)
addEvent("mocazRally:uiStartSolo", true)
addEventHandler("mocazRally:uiStartSolo", root, function(stageId, vehicleId)
    triggerServerEvent("mocazRally:startSolo", resourceRoot, stageId, vehicleId)
end)
addEvent("mocazRally:uiCreateLobby", true)
addEventHandler("mocazRally:uiCreateLobby", root, function(stageId, vehicleId)
    triggerServerEvent("mocazRally:createLobby", resourceRoot, stageId, vehicleId)
end)
addEvent("mocazRally:uiJoinLobby", true)
addEventHandler("mocazRally:uiJoinLobby", root, function(vehicleId)
    triggerServerEvent("mocazRally:joinLobby", resourceRoot, vehicleId)
end)
addEvent("mocazRally:uiStartLobby", true)
addEventHandler("mocazRally:uiStartLobby", root, function() triggerServerEvent("mocazRally:startLobby", resourceRoot) end)
addEvent("mocazRally:uiLeaveLobby", true)
addEventHandler("mocazRally:uiLeaveLobby", root, function() triggerServerEvent("mocazRally:leaveLobby", resourceRoot) end)
addEvent("mocazRally:uiSelectVehicle", true)
addEventHandler("mocazRally:uiSelectVehicle", root, function(id) triggerServerEvent("mocazRally:selectVehicle", resourceRoot, id) end)
addEvent("mocazRally:uiSetPreferredVehicle", true)
addEventHandler("mocazRally:uiSetPreferredVehicle", root, function(id) triggerServerEvent("mocazRally:setPreferredVehicle", resourceRoot, id) end)
addEvent("mocazRally:uiSchoolLesson", true)
addEventHandler("mocazRally:uiSchoolLesson", root, function(id) triggerServerEvent("mocazRally:schoolLesson", resourceRoot, id) end)

addEvent("mocazRally:profileLoaded", true)
addEventHandler("mocazRally:profileLoaded", resourceRoot, function(profile)
    profileReady = true
    if profile and profile.isNew then callUI("showDriverSelection", profile) else callUI("showMain", profile) end
end)
addEvent("mocazRally:profileMissing", true)
addEventHandler("mocazRally:profileMissing", resourceRoot, function() callUI("showCreateProfile") end)
addEvent("mocazRally:notice", true)
addEventHandler("mocazRally:notice", resourceRoot, function(message) callUI("showNotice", message) end)
addEvent("mocazRally:driverChosen", true)
addEventHandler("mocazRally:driverChosen", resourceRoot, function(profile)
    profileReady = true
    callUI("showMain", profile)
end)
addEvent("mocazRally:menuOpened", true)
addEventHandler("mocazRally:menuOpened", resourceRoot, function(action) callUI("showSection", action) end)
addEvent("mocazRally:gameData", true)
addEventHandler("mocazRally:gameData", resourceRoot, function(page, data) callUI("showGameData", page, data) end)
addEvent("mocazRally:lobbyUpdate", true)
addEventHandler("mocazRally:lobbyUpdate", resourceRoot, function(data) callUI("showLobby", data) end)
addEvent("mocazRally:racePrepared", true)
addEventHandler("mocazRally:racePrepared", resourceRoot, function() setCameraTarget(localPlayer); showCursor(false); showChat(true); showPlayerHudComponent("all", true); callUI("showRaceMode") end)
addEvent("mocazRally:raceReturn", true)
addEventHandler("mocazRally:raceReturn", resourceRoot, function() setCameraMatrix(MocazRally.MenuCamera.x, MocazRally.MenuCamera.y, MocazRally.MenuCamera.z, MocazRally.MenuCamera.lx, MocazRally.MenuCamera.ly, MocazRally.MenuCamera.lz); showCursor(true); callUI("showMain") end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    hideWorld()
    browserGUI = guiCreateBrowser(0, 0, screenW, screenH, true, true, false)
    browser = guiGetBrowser(browserGUI)
    addEventHandler("onClientBrowserCreated", browser, function()
        loadBrowserURL(source, "http://mta/local/ui/index.html")
    end)
    showCursor(true)
end)

addEventHandler("onClientBrowserDocumentReady", root, function()
    if source ~= browser then return end
    callUI("setVersion", MocazRally.Version)
    triggerServerEvent("mocazRally:requestProfile", resourceRoot)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setElementAlpha(localPlayer, 255)
    setElementFrozen(localPlayer, false)
    setCameraTarget(localPlayer)
    showChat(true)
    showPlayerHudComponent("all", true)
    showCursor(false)
end)

addEvent("mocazRally:uiClose", true)
addEventHandler("mocazRally:uiClose", root, function()
    if profileReady then showCursor(false) end
end)
