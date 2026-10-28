local ESX = exports['es_extended']:getSharedObject()
ESX.RegisterServerCallback('mocaz_rally:getMenuData', function(_, cb)
 local stages={}
 for id,stage in pairs(Config.Stages) do if stage.enabled then stages[#stages+1]={id=id,label=stage.label,description=stage.description or ''} end end
 cb({stages=stages})
end)
RegisterNetEvent('mocaz_rally:requestStart', function(stageId)
 local src=source
 if type(stageId)~='string' or #stageId>48 then return end
 local stage=Config.Stages[stageId]
 if not stage or not stage.enabled then TriggerClientEvent('mocaz_rally:notify',src,'Tato etapa není dostupná.'); return end
 TriggerEvent('mocaz_rally:beginRace',src,stageId)
end)
RegisterNetEvent('mocaz_rally:cancel', function() TriggerEvent('mocaz_rally:cancelPlayer',source,'Závod zrušen.') end)
