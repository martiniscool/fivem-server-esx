local activeRaces, playerRace, cooldowns = {}, {}, {}
local function notify(src,msg) TriggerClientEvent('mocaz_rally:notify',src,msg) end
AddEventHandler('mocaz_rally:beginRace', function(src,stageId)
 if playerRace[src] then notify(src,'Už jsi v závodě.'); return end
 local now=os.time()
 if cooldowns[src] and now-cooldowns[src]<Config.RaceCooldownSeconds then notify(src,'Počkej chvíli před dalším závodem.'); return end
 local stage=Config.Stages[stageId]; local id=('%s-%s-%s'):format(src,now,math.random(1000,9999)); local cps={}
 for i,p in ipairs(stage.checkpoints) do cps[i]={x=p.x,y=p.y,z=p.z} end
 activeRaces[id]={owner=src,stageId=stageId,startedAt=0,lastCheckpoint=0}; playerRace[src]=id; cooldowns[src]=now
 TriggerClientEvent('mocaz_rally:countdown',src,5)
 SetTimeout(5000,function()
  if not GetPlayerName(src) or playerRace[src]~=id then return end
  local r=activeRaces[id]; if not r then return end; r.startedAt=os.time()
  TriggerClientEvent('mocaz_rally:raceStarted',src,{raceId=id,stageId=stageId,stageLabel=stage.label,checkpoints=cps,finish={x=stage.finish.x,y=stage.finish.y,z=stage.finish.z}})
 end)
end)
RegisterNetEvent('mocaz_rally:checkpoint',function(id,idx)
 local src=source; if playerRace[src]~=id then return end
 local r=activeRaces[id]; if not r or type(idx)~='number' then return end
 local stage=Config.Stages[r.stageId]
 if idx~=r.lastCheckpoint+1 or idx>#stage.checkpoints then return end
 r.lastCheckpoint=idx
end)
RegisterNetEvent('mocaz_rally:finish',function(id,_clientElapsed)
 local src=source; if playerRace[src]~=id then return end
 local r=activeRaces[id]; if not r then return end; local stage=Config.Stages[r.stageId]
 if not stage or r.lastCheckpoint~=#stage.checkpoints then notify(src,'Etapa není dokončena: chybí checkpointy.'); return end
 local seconds=os.time()-r.startedAt
 if seconds<Config.MinimumRaceSeconds then notify(src,'Čas závodu nebyl platný.'); return end
 playerRace[src]=nil; activeRaces[id]=nil
 TriggerClientEvent('mocaz_rally:raceEnded',src,{valid=true,stageLabel=stage.label,timeMs=seconds*1000,time=('%02d:%02d'):format(math.floor(seconds/60),seconds%60)})
 TriggerEvent('mocaz_rally:saveResult',src,r.stageId,seconds*1000)
end)
AddEventHandler('mocaz_rally:cancelPlayer',function(src,reason)
 local id=playerRace[src]; if id then playerRace[src]=nil; activeRaces[id]=nil; TriggerClientEvent('mocaz_rally:raceEnded',src,{valid=false,reason=reason}) end
end)
AddEventHandler('playerDropped',function() local src=source; TriggerEvent('mocaz_rally:cancelPlayer',src,'Odpojení ze serveru.'); cooldowns[src]=nil end)
