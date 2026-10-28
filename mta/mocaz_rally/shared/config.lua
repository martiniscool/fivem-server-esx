MocazRally = MocazRally or {}
MocazRally.Version = "0.2.0"
MocazRally.Brand = "MOCAZ RALLY"
MocazRally.MenuCamera = { x = 1959.55, y = -1714.46, z = 24.0, lx = 1959.55, ly = -1714.46, lz = 18.0 }
MocazRally.MinBirthYear, MocazRally.MaxBirthYear, MocazRally.MaxNicknameLength = 1900, 2026, 24
MocazRally.RaceDimension, MocazRally.LobbyMaxPlayers, MocazRally.CheckpointRadius, MocazRally.StartCountdown = 40, 8, 18, 5
MocazRally.DriverStyles = {
 {id="rookie",label="ROOKIE",description="Začínám od nuly."},
 {id="technician",label="TECHNIK",description="Přesnost a nastavení."},
 {id="showman",label="SHOWMAN",description="Odvážný styl."}
}
MocazRally.Vehicles = {
 {id="sultan",label="Sultan",model=560,drive="AWD",class="RALLY",power=255},
 {id="elegy",label="Elegy",model=562,drive="RWD",class="RALLY",power=280},
 {id="flash",label="Flash",model=565,drive="FWD",class="RALLY",power=190},
 {id="jester",label="Jester",model=559,drive="RWD",class="SPORT",power=300},
 {id="uranus",label="Uranus",model=558,drive="RWD",class="SPORT",power=220},
 {id="bullet",label="Bullet",model=541,drive="RWD",class="SUPER",power=330}
}
MocazRally.Stages = {{
 id="airport_sprint", name="LS Airport Sprint", location="Los Santos · letiště", difficulty="ROOKIE",
 description="Krátká testovací etapa. Souřadnice jsou prototypové a musí se ověřit ve hře.",
 start={x=1950.0,y=-2200.0,z=13.5,rot=90},
 checkpoints={
  {x=2020.0,y=-2200.0,z=13.5},{x=2100.0,y=-2110.0,z=13.5},
  {x=2115.0,y=-1950.0,z=13.5},{x=2030.0,y=-1810.0,z=13.5},
  {x=1910.0,y=-1780.0,z=13.5}
 },
 finish={x=1815.0,y=-1850.0,z=13.5}
}}
