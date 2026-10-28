local activeRaces, playerRace, cooldowns = {}, {}, {}

local function notify(src, msg)
    TriggerClientEvent('mocaz_rally:notify', src, msg)
end

local function playerNear(src, point, radius)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    return #(coords - point) <= radius
end

AddEventHandler('mocaz_rally:beginRace', function(src, stageId)
    if playerRace[src] then notify(src, 'Už jsi v závodě.'); return end
    local now = os.time()
    if cooldowns[src] and now - cooldowns[src] < Config.RaceCooldownSeconds then
        notify(src, 'Počkej chvíli před dalším závodem.'); return
    end
    local stage = Config.Stages[stageId]
    if not stage or not stage.enabled then return end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or GetVehiclePedIsIn(ped, false) == 0 then
        notify(src, 'Do časovky musíš nastoupit do auta.')
        return
    end
    if not playerNear(src, stage.start, 35.0) then
        notify(src, 'Pro start závodu musíš být u startovní zóny.')
        return
    end

    local id = ('%s-%s-%s'):format(src, now, math.random(1000, 9999))
    local cps = {}
    for i, p in ipairs(stage.checkpoints) do cps[i] = { x=p.x, y=p.y, z=p.z } end
    activeRaces[id] = { owner=src, stageId=stageId, startedAt=0, lastCheckpoint=0 }
    playerRace[src], cooldowns[src] = id, now
    TriggerClientEvent('mocaz_rally:countdown', src, 5)

    SetTimeout(5000, function()
        if not GetPlayerName(src) or playerRace[src] ~= id then return end
        local r = activeRaces[id]
        if not r then return end
        r.startedAt = GetGameTimer()
        TriggerClientEvent('mocaz_rally:raceStarted', src, {
            raceId=id, stageId=stageId, stageLabel=stage.label,
            checkpoints=cps,
            finish={ x=stage.finish.x, y=stage.finish.y, z=stage.finish.z }
        })
    end)
end)

RegisterNetEvent('mocaz_rally:checkpoint', function(id, idx)
    local src = source
    if playerRace[src] ~= id then return end
    local r = activeRaces[id]
    if not r or type(idx) ~= 'number' or idx % 1 ~= 0 then return end
    local stage = Config.Stages[r.stageId]
    if not stage or idx ~= r.lastCheckpoint + 1 or idx > #stage.checkpoints then return end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or GetVehiclePedIsIn(ped, false) == 0 then
        notify(src, 'Checkpoint se počítá pouze v závodním vozidle.')
        return
    end
    if not playerNear(src, stage.checkpoints[idx], Config.CheckpointRadius + 8.0) then
        notify(src, 'Checkpoint nebyl serverem potvrzen.')
        return
    end
    r.lastCheckpoint = idx
end)

RegisterNetEvent('mocaz_rally:finish', function(id)
    local src = source
    if playerRace[src] ~= id then return end
    local r = activeRaces[id]
    if not r then return end
    local stage = Config.Stages[r.stageId]
    if not stage or r.lastCheckpoint ~= #stage.checkpoints then
        notify(src, 'Etapa není dokončena: chybí checkpointy.')
        return
    end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or GetVehiclePedIsIn(ped, false) == 0 then
        notify(src, 'Cíl lze potvrdit pouze v závodním vozidle.')
        return
    end
    if not playerNear(src, stage.finish, Config.FinishRadius + 8.0) then
        notify(src, 'Cíl nebyl serverem potvrzen.')
        return
    end
    local elapsedMs = GetGameTimer() - r.startedAt
    if elapsedMs < Config.MinimumRaceSeconds * 1000 then
        notify(src, 'Čas závodu nebyl platný.')
        return
    end

    playerRace[src], activeRaces[id] = nil, nil
    local seconds = math.floor(elapsedMs / 1000)
    TriggerClientEvent('mocaz_rally:raceEnded', src, {
        valid=true, stageLabel=stage.label, timeMs=elapsedMs,
        time=('%02d:%02d'):format(math.floor(seconds / 60), seconds % 60)
    })
    TriggerEvent('mocaz_rally:saveResult', src, r.stageId, elapsedMs)
end)

AddEventHandler('mocaz_rally:cancelPlayer', function(src, reason)
    local id = playerRace[src]
    if id then
        playerRace[src], activeRaces[id] = nil, nil
        TriggerClientEvent('mocaz_rally:raceEnded', src, { valid=false, reason=reason })
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    TriggerEvent('mocaz_rally:cancelPlayer', src, 'Odpojení ze serveru.')
    cooldowns[src] = nil
end)
