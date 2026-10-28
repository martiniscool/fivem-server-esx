local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('mocaz_rally:getMenuData', function(_, cb)
    local stages = {}
    for id, stage in pairs(Config.Stages) do
        if stage.enabled then
            stages[#stages + 1] = { id=id, label=stage.label, description=stage.description or '' }
        end
    end
    table.sort(stages, function(a, b) return a.label < b.label end)

    local leaderboard = {}
    if Config.SavePersonalBest then
        local ok, rows = pcall(function()
            return MySQL.query.await([[
                SELECT stage_id, MIN(best_time_ms) AS best_time_ms
                FROM mocaz_rally_personal_bests
                GROUP BY stage_id
                ORDER BY best_time_ms ASC
                LIMIT 5
            ]])
        end)
        if ok and rows then
            for _, row in ipairs(rows) do
                local stage = Config.Stages[row.stage_id]
                if stage then
                    leaderboard[#leaderboard + 1] = {
                        stageLabel=stage.label,
                        timeMs=tonumber(row.best_time_ms) or 0
                    }
                end
            end
        end
    end
    cb({ stages=stages, leaderboard=leaderboard })
end)

RegisterNetEvent('mocaz_rally:requestStart', function(stageId)
    local src = source
    if type(stageId) ~= 'string' or #stageId > 48 then return end
    local stage = Config.Stages[stageId]
    if not stage or not stage.enabled then
        TriggerClientEvent('mocaz_rally:notify', src, 'Tato etapa není dostupná.')
        return
    end
    TriggerEvent('mocaz_rally:beginRace', src, stageId)
end)

RegisterNetEvent('mocaz_rally:cancel', function()
    TriggerEvent('mocaz_rally:cancelPlayer', source, 'Závod zrušen.')
end)
