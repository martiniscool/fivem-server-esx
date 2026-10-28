(() => {
 const screens=["create","driver","main","game"]; let profile=null,activePage="main",lastGameData={},profileRequestPending=false;
 const $=id=>document.getElementById(id);
 function show(id){screens.forEach(s=>$(s).classList.toggle("hidden",s!==id));const n=$("notice");if(n&&id!=="create")n.classList.add("hidden");}
 function emit(name,...args){if(window.mta&&typeof window.mta.triggerEvent==="function")window.mta.triggerEvent(name,...args);else console.log("MTA bridge missing",name,args);}
 function esc(s){return String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));}
 function card(title,tag,desc,button,action,value){return '<article class="choice-card"><span class="tag">'+esc(tag)+'</span><b>'+esc(title)+'</b><small>'+esc(desc||"")+'</small><button data-action="'+esc(action)+'" data-value="'+esc(value||"")+'">'+esc(button)+'</button></article>';}
 function setGame(title,lead,tag,html){activePage=tag;$("gameTitle").textContent=title;$("gameLead").textContent=lead;$("gameTag").textContent=tag.toUpperCase();$("gameContent").innerHTML=html;$("leaveLobbyButton").classList.toggle("hidden",tag!=="multiplayer");show("game");}
 function vehicles(data,action){return (data.vehicles||[]).map(v=>card(v.label,v.class+" · "+v.drive,v.power+" PS","VYBRAT AUTO",action,v.id)).join("");}
 function stages(data,action){return (data.stages||[]).map(s=>card(s.name,s.difficulty+" · "+s.location,s.description,action==="solo"?"VYBRAT ETAPU":"VYBRAT ETAPU",action,s.id)).join("");}
 window.MocazRallyUI={
  setVersion(v){$("version").textContent="BUILD "+v;},
  showCreateProfile(){profileRequestPending=false;show("create");const n=$("nickname");if(n&&n.value)n.focus();},
  showDriverSelection(data){profileRequestPending=false;if(data&&data.nickname)profile=Object.assign(profile||{},data);if(!profile||!profile.nickname){show("create");this.showNotice("Profil se nevrátil ze serveru. Vyplň registraci znovu; serverová konzole vypíše důvod.");return;}show("driver");},
  showMain(data){document.body.classList.remove("racing");if(data&&data.nickname)profile=Object.assign(profile||{},data);if(!profile||!profile.nickname){if(!profileRequestPending){profileRequestPending=true;emit("mocazRally:uiRequestProfile");}show("main");$("welcomeName").textContent="načítám profil…";$("profileName").textContent="Načítám…";$("profileMeta").textContent="SPOJENÍ SE SERVEREM";this.showNotice("Obnovuji závodní profil ze serveru…");return;}profileRequestPending=false;$("welcomeName").textContent=profile.nickname+"."; $("profileName").textContent=profile.nickname;$("profileMeta").textContent="ROK "+(profile.birthYear||"—")+" · "+String(profile.driverStyle||"rookie").toUpperCase();show("main");$("raceOverlay").classList.add("hidden");},
  showNotice(message){const n=$("notice");n.textContent=String(message||"Něco se nepovedlo.");n.classList.remove("hidden");clearTimeout(window.noticeTimer);window.noticeTimer=setTimeout(()=>n.classList.add("hidden"),5000);},
  showSection(action){emit("mocazRally:uiMenuAction",action);},
  showGameData(page,data){lastGameData=data||{};if(page==="solo"){setGame("Vyber si etapu.","Zvol trasu a auto pro časovku.","solo",stages(data,"solo")+'<div class="lobby-box"><label for="soloVehicle">ZÁVODNÍ AUTO</label><select id="soloVehicle">'+(data.vehicles||[]).map(v=>'<option value="'+esc(v.id)+'">'+esc(v.label+' · '+v.drive+' · '+v.power+' PS')+'</option>').join("")+'</select></div>');}
   else if(page==="garage"){const tuneHtml=(data.tuning||[]).map(t=>card(t.label,(data.currentTune===t.id?"AKTIVNÍ SETUP":"TUNING"),t.description+" Odemčeno v testovací verzi.","POUŽÍT SETUP","tune",t.id)).join("");setGame("Tvoje garáž.","Vyber auto a nastav jeho jízdní charakteristiku. Aktuální modely jsou základní GTA:SA; vlastní auta se přidávají jako samostatný modpack.","garage",vehicles(data,"vehicle")+(tuneHtml?'<div class="lobby-box"><h3>NASTAVENÍ VOZU</h3>'+tuneHtml+'</div>':""));}
   else if(page==="school"){setGame("Rally škola.","Vyber lekci a přečti si úkol, než vyjedeš.","school",card("Brzdění","LEKCE 01","Zpomal před zatáčkou a plynule přenes váhu.","ZAHÁJIT LEKCI","lesson","braking")+card("Ideální stopa","LEKCE 02","Najížděj zvenku, tref vrchol a nech auto vyjet.","ZAHÁJIT LEKCI","lesson","line")+card("Ruční brzda","LEKCE 03","Krátké použití pomůže natočit auto do ostré zatáčky.","ZAHÁJIT LEKCI","lesson","handbrake"));}
   else if(page==="profile"){const rows=(data.results||[]).map(r=>'<div class="member">'+esc(r.stage_id)+' · '+(Number(r.time_ms)/1000).toFixed(2)+' s · '+esc(r.mode)+'</div>').join("");setGame("Závodní profil.","Tvoje uložené výsledky z tohoto serveru.","profile",'<div class="lobby-box"><h3>POSLEDNÍ VÝSLEDKY</h3>'+(rows||'<div class="member">Zatím žádné dokončené závody.</div>')+'</div>');}
  },
  showLobby(data){lastGameData=data||{};const stagesHtml=stages(data,"lobby");const carsHtml='<div class="lobby-box"><label for="lobbyVehicle">MOJE AUTO</label><select id="lobbyVehicle">'+(data.vehicles||[]).map(v=>'<option value="'+esc(v.id)+'">'+esc(v.label+' · '+v.drive)+'</option>').join("")+'</select></div>';let body="";
   if(data.exists && data.isMember){body='<div class="lobby-box"><h3>'+esc(data.stageName||"Rally lobby")+'</h3><div class="member">Zakladatel: '+esc(data.host||"—")+'</div><div class="member">Závodníci: '+esc(data.count||0)+' / '+esc(data.maxPlayers||8)+'</div>'+((data.members||[]).map(m=>'<div class="member">'+esc(m.nickname)+(m.host?' · HOST':'')+'</div>').join(""))+'<div class="inline-controls">'+(data.isHost?'<button class="primary-small" data-action="startLobby">SPOLEČNĚ ODSTARTOVAT</button>':'<button data-action="leaveLobby">OPUSTIT LOBBY</button>')+'</div></div>'+carsHtml;
   }else if(data.exists){body='<div class="lobby-box"><h3>OTEVŘENÁ LOBBY</h3><div class="member">Etapa: '+esc(data.stageName||"—")+'</div><div class="member">Zakladatel: '+esc(data.host||"—")+'</div><div class="member">Závodníci: '+esc(data.count||0)+' / '+esc(data.maxPlayers||8)+'</div><div class="inline-controls"><button class="primary-small" data-action="joinLobby">PŘIPOJIT SE</button></div></div>'+carsHtml;}else{body='<div class="lobby-box"><h3>ŽÁDNÁ OTEVŘENÁ LOBBY</h3><p class="lead">Můžeš vytvořit novou místnost, nebo se vrátit později.</p><div class="inline-controls"><button data-action="joinLobby">PŘIPOJIT SE K DOSTUPNÉ LOBBY</button></div></div>'+stagesHtml+carsHtml;}
   setGame("Multiplayer","Vytvoř lobby nebo se připoj k otevřenému závodu.","multiplayer",body);
  },
  showRaceMode(){document.body.classList.add("racing");screens.forEach(s=>$(s).classList.add("hidden"));$("raceOverlay").classList.remove("hidden");},
  showRaceHUD(message){document.body.classList.add("racing");$("raceOverlay").classList.remove("hidden");$("raceMessage").textContent=String(message||"");const done=String(message||"").startsWith("CÍL!");if(done)screens.forEach(s=>$(s).classList.add("hidden"));$("raceOverlay").style.pointerEvents=done?"auto":"none";$("raceOverlay").querySelector("small").textContent=done?"KLIKNI PRO NÁVRAT DO MENU":"BACKSPACE · UKONČIT JÍZDU";},
  hideRaceHUD(){ document.body.classList.remove("racing");$("raceOverlay").style.pointerEvents="none";$("raceOverlay").classList.add("hidden");show("main");}
 };
 $("profileForm").addEventListener("submit",e=>{e.preventDefault();emit("mocazRally:uiCreateProfile",$("nickname").value.trim(),Number($("birthYear").value));});
 document.querySelectorAll("[data-driver]").forEach(b=>b.addEventListener("click",()=>{b.disabled=true;b.classList.add("selected");emit("mocazRally:uiChooseDriver",b.dataset.driver);setTimeout(()=>{if(document.getElementById("driver")&&!document.getElementById("driver").classList.contains("hidden")){b.disabled=false;b.classList.remove("selected");window.MocazRallyUI.showNotice("Server neodpověděl na výběr stylu. Zkontroluj, zda se aktualizoval server/main.lua.");}},5000);}));
 document.querySelectorAll("[data-action]").forEach(b=>b.addEventListener("click",()=>emit("mocazRally:uiMenuAction",b.dataset.action)));
 $("gameContent").addEventListener("click",e=>{const b=e.target.closest("button[data-action]");if(!b)return;const action=b.dataset.action,val=b.dataset.value;
  if(action==="solo"){const select=$("soloVehicle");emit("mocazRally:uiStartSolo",val,select?select.value:"sultan");}
  else if(action==="vehicle")emit("mocazRally:uiSelectVehicle",val);
  else if(action==="tune")emit("mocazRally:uiBuyTune",val);
  else if(action==="lesson")emit("mocazRally:uiSchoolLesson",val);
  else if(action==="lobby"){const select=$("lobbyVehicle");emit("mocazRally:uiCreateLobby",val,select?select.value:"sultan");}
  else if(action==="joinLobby"){const select=$("lobbyVehicle");emit("mocazRally:uiJoinLobby",select?select.value:"sultan");}
  else if(action==="startLobby")emit("mocazRally:uiStartLobby");
  else if(action==="leaveLobby")emit("mocazRally:uiLeaveLobby");
 });
 $("gameContent").addEventListener("change",e=>{if(e.target.id==="lobbyVehicle")emit("mocazRally:uiSetPreferredVehicle",e.target.value);});
 $("raceOverlay").addEventListener("click",()=>{if($("raceOverlay").style.pointerEvents==="auto")window.MocazRallyUI.hideRaceHUD();});
 $("backButton").addEventListener("click",()=>show("main"));
 $("leaveLobbyButton").addEventListener("click",()=>emit("mocazRally:uiLeaveLobby"));
 document.addEventListener("keydown",e=>{if(e.key==="Escape"&&!$("raceOverlay").classList.contains("hidden"))return;if(e.key==="Escape")show("main");});
})();