fx_version 'cerulean'
game 'gta5'

lua54 'yes'
shared_script '@ox_lib/init.lua'

client_scripts {
    'klijent/*.lua',
    'podesavanje.lua',
    'termalna/heli_client.lua'
}

server_scripts {
    'server/*.lua',
    'podesavanje.lua',
    'termalna/heli_server.lua'
}