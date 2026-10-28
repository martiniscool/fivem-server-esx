fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mocaz'
description 'Mocaz Rally - ESX rally time-trial foundation'
version '0.1.0'

ui_page 'web/index.html'
shared_scripts { 'config.lua', 'data/stages.lua', 'data/vehicles.lua' }
client_scripts { 'client/main.lua', 'client/race.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua', 'server/race.lua', 'server/results.lua' }
files { 'web/index.html', 'web/style.css', 'web/app.js' }
dependencies { 'es_extended', 'oxmysql' }
