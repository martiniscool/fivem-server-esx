(() => {
  const screens = ["create", "main", "section"];
  let profile = null;
  const sectionInfo = {
    solo: ["01 / SOLO RALLY", "Časovky začínají.", "Sólo režim bude obsahovat etapy, checkpointy, měření času, osobní rekordy a opakování jízd."],
    multiplayer: ["02 / MULTIPLAYER", "Sejdeme se na startu.", "Připravujeme lobby, výběr etapy, synchronizovaný odpočet, výsledky a žebříčky."],
    school: ["03 / RALLY ŠKOLA", "Nauč se číst trať.", "Výuka brzdění, ideální stopy, ruční brzdy a pokynů spolujezdce bude rozdělena do lekcí."],
    garage: ["04 / GARÁŽ", "Tvoje auto. Tvoje nastavení.", "Garáž bude mít výběr vozidel, parametry, odemykání a tuning. Modely přidáme až po ověření licence."],
    profile: ["DRIVER PROFILE", "Tvoje kariéra.", "Profil a vybraný styl se ukládají. Statistiky a závodní historie přibudou s herními režimy."]
  };
  function show(id) { screens.forEach(s => document.getElementById(s).classList.toggle("hidden", s !== id)); }
  function emit(name, ...args) {
    if (window.mta && typeof window.mta.triggerEvent === "function") window.mta.triggerEvent(name, ...args);
    else console.log("MTA bridge unavailable", name, args);
  }
  window.MocazRallyUI = {
    setVersion(v) { document.getElementById("version").textContent = "BUILD " + v; },
    showCreateProfile() { show("create"); },
    showMain(data) {
      if (data) profile = Object.assign(profile || {}, data);
      if (profile && profile.nickname) {
        document.getElementById("welcomeName").textContent = profile.nickname + ".";
        document.getElementById("profileName").textContent = profile.nickname;
        document.getElementById("profileMeta").textContent = "NAROZEN " + (profile.birthYear || "—") + " · " + String(profile.driverStyle || "rookie").toUpperCase();
        show("main");
      } else {
        show("create");
      }
    },
    showNotice(message) {
      const el = document.getElementById("notice");
      el.textContent = String(message || "Něco se nepovedlo.");
      el.classList.remove("hidden");
      clearTimeout(window.noticeTimer);
      window.noticeTimer = setTimeout(() => el.classList.add("hidden"), 5000);
    },
    showSection(action) {
      const info = sectionInfo[action];
      if (!info) return;
      document.getElementById("sectionTag").textContent = info[0];
      document.getElementById("sectionTitle").textContent = info[1];
      document.getElementById("sectionText").textContent = info[2];
      show("section");
    }
  };
  document.getElementById("profileForm").addEventListener("submit", e => {
    e.preventDefault();
    emit("mocazRally:uiCreateProfile", document.getElementById("nickname").value.trim(), Number(document.getElementById("birthYear").value));
  });
  document.querySelectorAll("[data-action]").forEach(button => button.addEventListener("click", () => emit("mocazRally:uiMenuAction", button.dataset.action)));
  document.getElementById("backButton").addEventListener("click", () => show("main"));
  document.addEventListener("keydown", e => { if (e.key === "Escape") emit("mocazRally:uiClose"); });
})();