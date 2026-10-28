AddEventHandler('mocaz_rally:saveResult',function(src,stageId,timeMs)
 if not Config.SavePersonalBest then return end
 local ESX=exports['es_extended']:getSharedObject(); local player=ESX.GetPlayerFromId(src)
 if not player or not player.identifier then return end
 MySQL.insert('INSERT INTO mocaz_rally_results (identifier, stage_id, time_ms) VALUES (?, ?, ?)',{player.identifier,stageId,math.floor(timeMs)})
 MySQL.update('INSERT INTO mocaz_rally_personal_bests (identifier, stage_id, best_time_ms) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE best_time_ms = LEAST(best_time_ms, VALUES(best_time_ms))',{player.identifier,stageId,math.floor(timeMs)})
end)
