local race, checkpointIndex, startedAt, finished = nil, 1, 0, false
RegisterNetEvent('mocaz_rally:raceStarted', function(payload) race=payload; checkpointIndex=1; startedAt=GetGameTimer(); finished=false end)
RegisterNetEvent('mocaz_rally:raceEnded', function() race=nil; finished=true end)
CreateThread(function()
 while true do
  if not race or finished then Wait(500) else
   Wait(0)
   local pos=GetEntityCoords(PlayerPedId())
   local point=race.checkpoints[checkpointIndex]
   if point then
    local target=vector3(point.x,point.y,point.z)
    DrawMarker(1,target.x,target.y,target.z-1.0,0.0,0.0,0.0,0.0,0.0,0.0,3.0,3.0,1.0,220,35,55,160,false,true,2,false,nil,nil,false)
    if #(pos-target)<=Config.CheckpointRadius then TriggerServerEvent('mocaz_rally:checkpoint',race.raceId,checkpointIndex); checkpointIndex=checkpointIndex+1 end
   else
    local f=race.finish; local target=vector3(f.x,f.y,f.z)
    DrawMarker(4,target.x,target.y,target.z,0.0,0.0,0.0,0.0,0.0,0.0,5.0,5.0,2.0,220,35,55,180,false,true,2,false,nil,nil,false)
    if #(pos-target)<=Config.FinishRadius then finished=true; TriggerServerEvent('mocaz_rally:finish',race.raceId,GetGameTimer()-startedAt) end
   end
   if IsControlJustReleased(0,177) then TriggerServerEvent('mocaz_rally:cancel') end
  end
 end
end)
