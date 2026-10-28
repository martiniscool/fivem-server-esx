local db = dbConnect("sqlite", "mocaz_rally.db")
local active, schoolProgress = {}, {}
local lobby, nextLobbyId = nil, 1
if db then dbExec(db, [[CREATE TABLE IF NOT EXISTS race_results (id INTEGER PRIMARY KEY AUTOINCREMENT, serial TEXT NOT NULL, nickname TEXT NOT NULL, stage_id TEXT NOT NULL, time_ms INTEGER NOT NULL, mode TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)]]) end

local function stageById(id) for _,v in ipairs(MocazRally.Stages) do if v.id==id then return v end end end
local function vehicleById(id) for _,v in ipairs(MocazRally.Vehicles) do if v.id==id then return v end end end
local function notice(p,msg) if isElement(p) then triggerClientEvent(p,"mocazRally:notice",resourceRoot,msg) end end
local function menu(p,page,data) triggerClientEvent(p,"mocazRally:gameData",resourceRoot,page,data or {}) end
local function clearRace(p, returnMenu)
 local r=active[p]
 if r and isElement(r.vehicle) then destroyElement(r.vehicle) end
 active[p]=nil
 if isElement(p) then
  setElementDimension(p,0); setElementInterior(p,0); setElementFrozen(p,false); setElementAlpha(p, returnMenu and 0 or 255)
  if returnMenu then setElementFrozen(p,true); triggerClientEvent(p,"mocazRally:raceReturn",resourceRoot) else triggerClientEvent(p,"mocazRally:raceFinished",resourceRoot) end
 end
end
local function spawnRace(p,stage,vehicleId,mode,lobbyId)
 local v=vehicleById(vehicleId) or MocazRally.Vehicles[1]
 local car=createVehicle(v.model,stage.start.x,stage.start.y,stage.start.z,0,0,stage.start.rot or 0)
 if not car then notice(p,"Nepodařilo se vytvořit auto."); return false end
 setElementDimension(p,MocazRally.RaceDimension); setElementDimension(car,MocazRally.RaceDimension)
 setElementInterior(p,0); setElementInterior(car,0); setVehicleColor(car,240,68,62,25,25,28)
 warpPedIntoVehicle(p,car); setElementFrozen(car,true); setElementFrozen(p,true); setElementAlpha(p,255)
 active[p]={stage=stage,vehicle=car,vehicleId=v.id,mode=mode,lobbyId=lobbyId,checkpoint=1,countdown=true}
 triggerClientEvent(p,"mocazRally:racePrepared",resourceRoot,{stageId=stage.id,stageName=stage.name,checkpoints=stage.checkpoints,finish=stage.finish,vehicle=v.label,mode=mode})
 return true
end
local function startRace(players,stage,mode,lobbyId,vehicles)
 local ready={}
 for _,p in ipairs(players) do
  if isElement(p) and not active[p] then
   local v=(vehicles and vehicles[p]) or getElementData(p,"mocazRally:vehicle") or "sultan"
   if spawnRace(p,stage,v,mode,lobbyId) then ready[#ready+1]=p end
  end
 end
 if #ready==0 then return end
 for n=MocazRally.StartCountdown,1,-1 do
  setTimer(function(second) for _,p in ipairs(ready) do if isElement(p) and active[p] then triggerClientEvent(p,"mocazRally:countdown",resourceRoot,second) end end end,(MocazRally.StartCountdown-n)*1000,1,n)
 end
 setTimer(function()
  local startTick=getTickCount()
  for _,p in ipairs(ready) do local r=active[p]; if isElement(p) and r then r.startedAt=startTick; r.countdown=false; setElementFrozen(p,false); if isElement(r.vehicle) then setElementFrozen(r.vehicle,false) end; triggerClientEvent(p,"mocazRally:raceGo",resourceRoot,startTick,#r.stage.checkpoints) end end
 end,MocazRally.StartCountdown*1000,1)
end

addEvent("mocazRally:startSolo",true)
addEventHandler("mocazRally:startSolo",resourceRoot,function(stageId,vehicleId)
 local p=client; if not isElement(p) or active[p] then return end
 local stage=stageById(stageId); if not stage then notice(p,"Neplatná etapa."); return end
 local v=vehicleById(vehicleId); if not v then v=MocazRally.Vehicles[1] end
 setElementData(p,"mocazRally:vehicle",v.id,false); startRace({p},stage,"solo",nil)
end)

local function lobbyData()
 if not lobby then return {exists=false} end
 local members={}
 for p in pairs(lobby.members) do if isElement(p) then members[#members+1]={nickname=getElementData(p,"mocazRally:nickname") or getPlayerName(p),host=p==lobby.host} end end
 return {exists=true,id=lobby.id,stageId=lobby.stage.id,stageName=lobby.stage.name,host=isElement(lobby.host) and (getElementData(lobby.host,"mocazRally:nickname") or getPlayerName(lobby.host)) or "—",count=#members,maxPlayers=MocazRally.LobbyMaxPlayers,members=members}
end
local function broadcastLobby()
 if not lobby then return end
 for p in pairs(lobby.members) do if isElement(p) then local d=lobbyData(); d.isHost=p==lobby.host; d.isMember=true; d.vehicles=MocazRally.Vehicles; d.stages=MocazRally.Stages; triggerClientEvent(p,"mocazRally:lobbyUpdate",resourceRoot,d) end end
end
addEvent("mocazRally:createLobby",true)
addEventHandler("mocazRally:createLobby",resourceRoot,function(stageId,vehicleId)
 local p=client; if not isElement(p) or active[p] then return end
 if lobby then notice(p,"Lobby už existuje. Připoj se k ní."); return end
 local stage=stageById(stageId); if not stage then notice(p,"Vyber platnou etapu."); return end
 local v=vehicleById(vehicleId) or MocazRally.Vehicles[1]
 lobby={id=nextLobbyId,host=p,stage=stage,members={[p]=true},vehicles={[p]=v.id}}; nextLobbyId=nextLobbyId+1
 setElementData(p,"mocazRally:vehicle",v.id,false); broadcastLobby()
end)
addEvent("mocazRally:joinLobby",true)
addEventHandler("mocazRally:joinLobby",resourceRoot,function(vehicleId)
 local p=client; if not isElement(p) or active[p] then return end
 if not lobby then notice(p,"Žádná otevřená lobby není k dispozici."); return end
 local n=0; for member in pairs(lobby.members) do if isElement(member) then n=n+1 end end
 if n>=MocazRally.LobbyMaxPlayers then notice(p,"Lobby je plná."); return end
 local v=vehicleById(vehicleId) or MocazRally.Vehicles[1]
 lobby.members[p]=true; lobby.vehicles[p]=v.id; setElementData(p,"mocazRally:vehicle",v.id,false); broadcastLobby()
end)
addEvent("mocazRally:startLobby",true)
addEventHandler("mocazRally:startLobby",resourceRoot,function()
 local p=client; if not lobby or lobby.host~=p then notice(p,"Start může spustit pouze zakladatel lobby."); return end
 local players,vehicles={},{}
 for member in pairs(lobby.members) do if isElement(member) then players[#players+1]=member; vehicles[member]=lobby.vehicles[member] end end
 local stage,id=lobby.stage,lobby.id; lobby=nil
 startRace(players,stage,"multiplayer",id,vehicles)
end)
addEvent("mocazRally:leaveLobby",true)
addEventHandler("mocazRally:leaveLobby",resourceRoot,function()
 local p=client; if not lobby or not lobby.members[p] then return end
 lobby.members[p]=nil; lobby.vehicles[p]=nil
 if lobby.host==p then lobby.host=nil; for member in pairs(lobby.members) do if isElement(member) then lobby.host=member; break end end end
 if not lobby.host then lobby=nil else broadcastLobby() end
end)

addEvent("mocazRally:checkpoint",true)
addEventHandler("mocazRally:checkpoint",resourceRoot,function(index)
 local p=client; local r=active[p]
 if not r or r.countdown or type(index)~="number" or index~=r.checkpoint then return end
 local pt=r.stage.checkpoints[index]
 if not pt or not isElement(r.vehicle) or getPedOccupiedVehicle(p)~=r.vehicle then return end
 local x,y,z=getElementPosition(p)
 if getDistanceBetweenPoints3D(x,y,z,pt.x,pt.y,pt.z)>MocazRally.CheckpointRadius then return end
 r.checkpoint=r.checkpoint+1; triggerClientEvent(p,"mocazRally:checkpointAccepted",resourceRoot,index,#r.stage.checkpoints)
end)
addEvent("mocazRally:finish",true)
addEventHandler("mocazRally:finish",resourceRoot,function()
 local p=client; local r=active[p]
 if not r or r.countdown or r.checkpoint<=#r.stage.checkpoints or not isElement(r.vehicle) or getPedOccupiedVehicle(p)~=r.vehicle then return end
 local pt=r.stage.finish; local x,y,z=getElementPosition(p)
 if getDistanceBetweenPoints3D(x,y,z,pt.x,pt.y,pt.z)>MocazRally.CheckpointRadius then return end
 local elapsed=getTickCount()-(r.startedAt or getTickCount())
 if elapsed<10000 then notice(p,"Čas jízdy nebyl platný."); clearRace(p,true); return end
 if db then dbExec(db,"INSERT INTO race_results (serial,nickname,stage_id,time_ms,mode) VALUES (?,?,?,?,?)",getPlayerSerial(p),getElementData(p,"mocazRally:nickname") or getPlayerName(p),r.stage.id,elapsed,r.mode) end
 clearRace(p,true)
 triggerClientEvent(p,"mocazRally:raceResult",resourceRoot,{stageName=r.stage.name,timeMs=elapsed,mode=r.mode})
end)
addEvent("mocazRally:cancelRace",true)
addEventHandler("mocazRally:cancelRace",resourceRoot,function() if active[client] then clearRace(client,true) end end)

addEvent("mocazRally:requestGameData",true)
addEventHandler("mocazRally:requestGameData",resourceRoot,function(page)
 local p=client; if not isElement(p) then return end
 if page=="solo" or page=="school" then menu(p,page,{stages=MocazRally.Stages,vehicles=MocazRally.Vehicles})
 elseif page=="garage" then menu(p,page,{vehicles=MocazRally.Vehicles,selected=getElementData(p,"mocazRally:vehicle") or "sultan"})
 elseif page=="multiplayer" then local d=lobbyData(); d.vehicles=MocazRally.Vehicles; d.stages=MocazRally.Stages; d.isHost=lobby and lobby.host==p or false; d.isMember=lobby and lobby.members[p] or false; triggerClientEvent(p,"mocazRally:lobbyUpdate",resourceRoot,d)
 elseif page=="profile" then
  local results={}
  if db then local q=dbQuery(db,"SELECT stage_id,time_ms,mode,created_at FROM race_results WHERE serial=? ORDER BY time_ms ASC LIMIT 10",getPlayerSerial(p)); results=dbPoll(q,-1) or {} end
  menu(p,"profile",{results=results})
 end
end)
addEvent("mocazRally:setPreferredVehicle",true)
addEventHandler("mocazRally:setPreferredVehicle",resourceRoot,function(id)
 local p=client; local v=vehicleById(id); if not isElement(p) or not v then return end
 setElementData(p,"mocazRally:vehicle",id,false)
 if lobby and lobby.members[p] then lobby.vehicles[p]=id; broadcastLobby() end
end)
addEvent("mocazRally:selectVehicle",true)
addEventHandler("mocazRally:selectVehicle",resourceRoot,function(id)
 local p=client; local v=vehicleById(id); if not isElement(p) or not v then return end
 setElementData(p,"mocazRally:vehicle",id,false); if lobby and lobby.members[p] then lobby.vehicles[p]=id; broadcastLobby(); notice(p,"Auto v lobby: "..v.label) else notice(p,"Vybrané auto: "..v.label); menu(p,"garage",{vehicles=MocazRally.Vehicles,selected=id}) end
end)
addEvent("mocazRally:schoolLesson",true)
addEventHandler("mocazRally:schoolLesson",resourceRoot,function(lesson)
 local p=client; if not isElement(p) then return end
 local texts={braking="LEKCE 1: Brzdi před zatáčkou a plynule přenes váhu auta.",line="LEKCE 2: Najížděj zvenku, tref vrchol zatáčky a nech auto vyjet.",handbrake="LEKCE 3: Ruční brzdu použij krátce k natočení auta; dlouhé držení ztrácí rychlost."}
 if texts[lesson] then notice(p,texts[lesson]); schoolProgress[p]=schoolProgress[p] or {}; schoolProgress[p][lesson]=true; triggerClientEvent(p,"mocazRally:schoolProgress",resourceRoot,schoolProgress[p]) end
end)
addEventHandler("onPlayerQuit",root,function()
 if active[source] then clearRace(source,false) end; schoolProgress[source]=nil
 if lobby and lobby.members[source] then lobby.members[source]=nil; lobby.vehicles[source]=nil
  if lobby.host==source then lobby.host=nil; for p in pairs(lobby.members) do if isElement(p) then lobby.host=p; break end end end
  if not lobby.host then lobby=nil else broadcastLobby() end
 end
end)
addEventHandler("onResourceStop",resourceRoot,function() for p in pairs(active) do if isElement(p) then clearRace(p,false) end end end)
