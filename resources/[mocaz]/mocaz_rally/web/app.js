const app=document.getElementById('app'),select=document.getElementById('stage'),desc=document.getElementById('description'),toast=document.getElementById('toast');
function nui(name,data={}){return fetch(`https://${GetParentResourceName()}/${name}`,{method:'POST',headers:{'Content-Type':'application/json; charset=UTF-8'},body:JSON.stringify(data)}).then(r=>r.json()).catch(()=>({ok:false}))}
function message(text){toast.textContent=text;toast.classList.remove('hidden');setTimeout(()=>toast.classList.add('hidden'),3500)}
function update(){desc.textContent=select.selectedOptions[0]?.dataset.description||'Vyber dostupnou etapu.'}
select.addEventListener('change',update);
document.getElementById('close').onclick=()=>{app.classList.add('hidden');nui('close')};
document.getElementById('start').onclick=()=>{if(!select.value)return message('Není vybraná etapa.');nui('startRace',{stageId:select.value});app.classList.add('hidden')};
window.addEventListener('message',e=>{const d=e.data||{};if(d.action==='open'){select.innerHTML='';(d.stages||[]).forEach(s=>{const o=document.createElement('option');o.value=s.id;o.textContent=s.label;o.dataset.description=s.description||'';select.appendChild(o)});update();app.classList.remove('hidden')}if(d.action==='countdown')message('Start za '+d.seconds+'…');if(d.action==='raceStarted')message('START: '+(d.stage||'Mocaz Rally'));if(d.action==='raceEnded'){const r=d.result||{};message(r.valid?'CÍL '+(r.time||''):r.reason||'Závod ukončen.')}});
document.addEventListener('keyup',e=>{if(e.key==='Escape'&&!app.classList.contains('hidden')){app.classList.add('hidden');nui('close')}});
