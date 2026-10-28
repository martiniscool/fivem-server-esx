MocazRally = MocazRally or {}
MocazRally.Version = "0.5.0"
MocazRally.Brand = "MOCAZ RALLY"
MocazRally.MenuCamera = { x = 1959.55, y = -1714.46, z = 24.0, lx = 1959.55, ly = -1714.46, lz = 18.0 }
MocazRally.MinBirthYear, MocazRally.MaxBirthYear, MocazRally.MaxNicknameLength = 1900, 2027, 24
MocazRally.RaceDimension, MocazRally.LobbyMaxPlayers, MocazRally.CheckpointRadius, MocazRally.StartCountdown = 40, 8, 18, 5
MocazRally.Theme = { primary = "#e53935", background = "#101114", surface = "#1a1c21", accent = "#f4f4f5" }
MocazRally.DriverStyles = {
 {id="rookie",label="ROOKIE",description="Začínám od nuly."},
 {id="technician",label="TECHNIK",description="Přesnost a nastavení."},
 {id="showman",label="SHOWMAN",description="Odvážný styl."}
}

-- Modely jsou nyní dostupné modely GTA: San Andreas. Pro skutečné značky je nutné
-- dodat a legálně distribuovat odpovídající DFF/TXD modely jako samostatný modpack.
MocazRally.Vehicles = {
 {id="sultan",label="Sultan",model=560,drive="AWD",class="RALLY",power=255,price=0},
 {id="elegy",label="Elegy",model=562,drive="RWD",class="RALLY",power=280,price=18000},
 {id="flash",label="Flash",model=565,drive="FWD",class="RALLY",power=190,price=9000},
 {id="jester",label="Jester",model=559,drive="RWD",class="SPORT",power=300,price=26000},
 {id="uranus",label="Uranus",model=558,drive="RWD",class="SPORT",power=220,price=12000},
 {id="bullet",label="Bullet",model=541,drive="RWD",class="SUPER",power=330,price=50000},
 {id="stratum",label="Stratum",model=561,drive="FWD",class="RALLY",power=210,price=11000},
 {id="euros",label="Euros",model=587,drive="RWD",class="SPORT",power=245,price=16000},
 {id="comet",label="Comet",model=480,drive="RWD",class="SPORT",power=265,price=22000},
 {id="flash_gt",label="Flash GT",model=402,drive="RWD",class="STREET",power=235,price=14000},
 {id="zr350",label="ZR-350",model=477,drive="RWD",class="SPORT",power=290,price=24000},
 {id="sabre",label="Sabre",model=475,drive="RWD",class="CLASSIC",power=215,price=10000},
 {id="buffalo",label="Buffalo",model=402,drive="RWD",class="STREET",power=250,price=17000},
 {id="landstalker",label="Landstalker Rally",model=400,drive="AWD",class="RALLY SUV",power=220,price=15000},
 {id="mesa",label="Mesa Rally Raid",model=500,drive="AWD",class="RALLY RAID",power=205,price=13000},
 {id="banshee",label="Banshee",model=429,drive="RWD",class="SPORT",power=310,price=32000},
 {id="phoenix",label="Phoenix",model=603,drive="RWD",class="STREET",power=270,price=21000},
 {id="hotknife",label="Hotknife",model=434,drive="RWD",class="CLASSIC",power=230,price=18000}
}

MocazRally.Tuning = {
 {id="stage1",label="STAGE 1",description="Lehký upgrade výkonu a odezvy.",price=5000,power=1.08,maxVelocity=1.05,acceleration=1.08},
 {id="stage2",label="STAGE 2",description="Výraznější motor a akcelerace.",price=12000,power=1.16,maxVelocity=1.10,acceleration=1.15},
 {id="rally",label="RALLY SETUP",description="Vyvážené nastavení pro šotolinu a zatáčky.",price=9000,power=1.05,maxVelocity=1.02,acceleration=1.07}
}

MocazRally.Stages = {
 {
  id="airport_sprint", name="LS Airport Sprint", location="Los Santos · letiště", difficulty="ROOKIE",
  description="Krátká asfaltová časovka kolem letiště. Pro první testy a učení checkpointů.",
  start={x=1950.0,y=-2200.0,z=13.5,rot=90},
  checkpoints={{x=2020.0,y=-2200.0,z=13.5},{x=2100.0,y=-2110.0,z=13.5},{x=2115.0,y=-1950.0,z=13.5},{x=2030.0,y=-1810.0,z=13.5},{x=1910.0,y=-1780.0,z=13.5}},
  finish={x=1815.0,y=-1850.0,z=13.5}
 },
 {
  id="airport_long", name="Airport Grand Loop", location="Los Santos · letiště", difficulty="CLUB",
  description="Delší okruh pro čistou stopu, brzdné body a stabilní tempo.",
  start={x=1670.0,y=-2400.0,z=13.5,rot=0},
  checkpoints={{x=1570.0,y=-2300.0,z=13.5},{x=1430.0,y=-2180.0,z=13.5},{x=1450.0,y=-2020.0,z=13.5},{x=1620.0,y=-1900.0,z=13.5},{x=1830.0,y=-1880.0,z=13.5},{x=1980.0,y=-2020.0,z=13.5},{x=1990.0,y=-2220.0,z=13.5}},
  finish={x=1840.0,y=-2380.0,z=13.5}
 },
 {
  id="red_county_run", name="Red County Run", location="Red County · venkov", difficulty="CLUB",
  description="Venkovská etapa s delšími přesuny a technickými změnami směru.",
  start={x= -80.0,y=-1100.0,z=2.0,rot=90},
  checkpoints={{x=120.0,y=-1050.0,z=3.0},{x=300.0,y=-900.0,z=5.0},{x=470.0,y=-760.0,z=8.0},{x=620.0,y=-560.0,z=15.0},{x=780.0,y=-390.0,z=20.0}},
  finish={x=900.0,y=-210.0,z=25.0}
 },
 {
  id="flint_hills", name="Flint Hills Gravel", location="Flint County · kopce", difficulty="PRO",
  description="Náročnější test kontroly auta v kopcích. Doporučený rally setup.",
  start={x=-650.0,y=-1900.0,z=5.0,rot=0},
  checkpoints={{x=-520.0,y=-1780.0,z=8.0},{x=-390.0,y=-1640.0,z=12.0},{x=-250.0,y=-1510.0,z=18.0},{x=-100.0,y=-1390.0,z=24.0},{x=80.0,y=-1280.0,z=30.0}},
  finish={x=220.0,y=-1150.0,z=35.0}
 },
 {
  id="lv_desert", name="Bone County Desert", location="Bone County · poušť", difficulty="PRO",
  description="Rychlá pouštní etapa. Hlídáš rychlost, brzdnou dráhu a průjezdy checkpointy.",
  start={x=-500.0,y=2200.0,z=42.0,rot=90},
  checkpoints={{x=-300.0,y=2280.0,z=40.0},{x=-80.0,y=2350.0,z=35.0},{x=150.0,y=2420.0,z=30.0},{x=380.0,y=2380.0,z=28.0},{x=600.0,y=2250.0,z=30.0}},
  finish={x=780.0,y=2100.0,z=35.0}
 }
 ,
 {
  id="mountain_technical", name="Mount Chiliad Technical", location="Mount Chiliad · horská etapa", difficulty="PRO",
  description="Technická horská etapa s prudkými změnami směru a úzkými průjezdy.",
  start={x=-2310.0,y=-1650.0,z=483.0,rot=0},
  checkpoints={{x=-2260.0,y=-1580.0,z=470.0},{x=-2200.0,y=-1510.0,z=450.0},{x=-2140.0,y=-1430.0,z=425.0},{x=-2070.0,y=-1350.0,z=400.0},{x=-2010.0,y=-1280.0,z=375.0}},
  finish={x=-1950.0,y=-1210.0,z=350.0}
 },
 {
  id="las_venturas_sprint", name="Las Venturas Night Sprint", location="Las Venturas · město", difficulty="CLUB",
  description="Rychlá městská etapa pro přesné brzdění a stabilní průjezdy zatáček.",
  start={x=1460.0,y=750.0,z=11.0,rot=90},
  checkpoints={{x=1550.0,y=820.0,z=11.0},{x=1660.0,y=920.0,z=11.0},{x=1780.0,y=1050.0,z=11.0},{x=1900.0,y=1150.0,z=11.0},{x=2020.0,y=1250.0,z=11.0}},
  finish={x=2130.0,y=1350.0,z=11.0}
 }
}
