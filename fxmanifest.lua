lua54 "yes"

fx_version 'cerulean'
game 'gta5'

author 'Motion Scripts'
description 'Made by Motion Scripts (Original By @jmhruk)'
version '1.0.2'

depedency 'motion_bridge'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/server_config.lua',
    '_versioncheck.lua',
    'server/*.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
}






