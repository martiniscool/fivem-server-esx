local screenW,screenH=guiGetScreenSize()
local race=nil
local marker,blip
local function clearMarkers()
 if isElement(marker) then destroyElement(marker) end
 if isElement(blip) then destroyElement(blip) end
 marker,blip=nil,nil
end
local function setCheckpoint(point,finish)
 clearMarkers(); if not point then return end
 marker=createMarker(point.x,point.y,point.z-1,"checkpoint",5,finish and 255 or 240,finish and 190 or 68,finish and 62 or 62,190)
 blip=createBlip(point.x,point.y,point.z,finish and 53 or 0,2,240,68,62,255)
 setElementDimension(marker,MocazRally.RaceDimension); setElementDimension(blip,MocazRally.RaceDimension)
end
local function ui(fn,value)
 if type(MocazRallyCallUI)=="function" then MocazRallyCallUI(fn,value) end
end
addEvent("mocazRally:racePrepared",true)
addEventHandler("mocazRally:racePrepared",resourceRoot,function(p)
 race={payload=p,next=1,running=false,started=0}
 ui("showRaceHUD","PŘIPRAV SE · "..p.stageName.." · "..p.vehicle)
 setCheckpoint(p.checkpoints[1],false)
end)
addEvent("mocazRally:countdown",true)
addEventHandler("mocazRally:countdown",resourceRoot,function(n) ui("showRaceHUD","START ZA "..n) end)
addEvent("mocazRally:raceGo",true)
addEventHandler("mocazRally:raceGo",resourceRoot,function(start,total)
 if not race then return end
 race.running=true; race.started=getTickCount(); race.total=total
 ui("showRaceHUD","JEĎ! · CHECKPOINT 1/"..total)
end)
addEvent("mocazRally:checkpointAccepted",true)
addEventHandler("mocazRally:checkpointAccepted",resourceRoot,function(index,total)
 if not race then return end
 race.next=index+1
 if race.next<=total then setCheckpoint(race.payload.checkpoints[race.next],false); ui("showRaceHUD","CHECKPOINT "..index.."/"..total)
 else setCheckpoint(race.payload.finish,true); ui("showRaceHUD","DO CÍLE!") end
end)
addEvent("mocazRally:raceResult",true)
addEventHandler("mocazRally:raceResult",resourceRoot,function(result)
 clearMarkers(); race=nil
 local s=(result.timeMs or 0)/1000
 ui("showRaceHUD",string.format("CÍL! ČAS %02d:%05.2f",math.floor(s/60),s%60))
 triggerServerEvent("mocazRally:requestGameData",resourceRoot,"profile")
end)
addEvent("mocazRally:raceFinished",true)
addEventHandler("mocazRally:raceFinished",resourceRoot,function() clearMarkers(); race=nil; ui("hideRaceHUD",nil) end)
addEvent("mocazRally:raceReturn",true)
addEventHandler("mocazRally:raceReturn",resourceRoot,function()
 clearMarkers(); race=nil; ui("hideRaceHUD",nil); setElementAlpha(localPlayer,0); setElementFrozen(localPlayer,true); showCursor(true)
end)
addEventHandler("onClientRender",root,function()
 if not race or not race.running then return end
 local elapsed=(getTickCount()-race.started)/1000
 dxDrawText(string.format("%02d:%05.2f",math.floor(elapsed/60),elapsed%60),0,30,screenW-35,90,tocolor(255,255,255,245),1.3,"bankgothic","right","top",false,false,false,true)
end)
addEventHandler("onClientKey",root,function(key,press)
 if press and race and key=="backspace" then triggerServerEvent("mocazRally:cancelRace",resourceRoot) end
end)
addEventHandler("onClientResourceStop",resourceRoot,clearMarkers)
