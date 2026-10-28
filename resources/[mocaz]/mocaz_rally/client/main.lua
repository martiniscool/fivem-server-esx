local ESX = exports['es_extended']:getSharedObject()
local uiOpen = false

RegisterNetEvent('mocaz_rally:notify', function(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end)

RegisterCommand(Config.Command, function()
    if uiOpen then return end
    ESX.TriggerServerCallback('mocaz_rally:getMenuData', function(data)
        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action='open', stages=data.stages or {}, leaderboard=data.leaderboard or {} })
    end)
end, false)

RegisterNUICallback('close', function(_, cb)
    uiOpen = false
    SetNuiFocus(false, false)
    cb({ ok=true })
end)

RegisterNUICallback('startRace', function(data, cb)
    TriggerServerEvent('mocaz_rally:requestStart', tostring(data.stageId or ''))
    uiOpen = false
    SetNuiFocus(false, false)
    cb({ ok=true })
end)

RegisterNetEvent('mocaz_rally:countdown', function(seconds)
    SendNUIMessage({ action='countdown', seconds=seconds or 5 })
end)

RegisterNetEvent('mocaz_rally:raceStarted', function(payload)
    SendNUIMessage({ action='raceStarted', stage=payload.stageLabel })
    TriggerEvent('mocaz_rally:notify', ('Mocaz Rally: %s – START!'):format(payload.stageLabel or 'Etapa'))
end)

RegisterNetEvent('mocaz_rally:raceEnded', function(result)
    SendNUIMessage({ action='raceEnded', result=result or {} })
end)


-- Visible start-zone markers make the configured stage start discoverable.
CreateThread(function()
    for id, stage in pairs(Config.Stages) do
        if stage.enabled then
            local blip = AddBlipForCoord(stage.start.x, stage.start.y, stage.start.z)
            SetBlipSprite(blip, 315)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Mocaz Rally: ' .. stage.label)
            EndTextCommandSetBlipName(blip)
        end
    end

    while true do
        local waitMs = 900
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for _, stage in pairs(Config.Stages) do
            if stage.enabled then
                local distance = #(coords - stage.start)
                if distance < 70.0 then
                    waitMs = 0
                    DrawMarker(1, stage.start.x, stage.start.y, stage.start.z - 1.0,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        5.0, 5.0, 1.0, 227, 39, 61, 120,
                        false, true, 2, false, nil, nil, false)
                end
            end
        end
        Wait(waitMs)
    end
end)
