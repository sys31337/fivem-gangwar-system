fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Complete FiveM Gangwar System with React.js UI'
version '1.0.0'
url 'https://github.com/yourusername/fivem-gangwar-system'

lua54 'yes'

shared_scripts {
    'shared/config.lua',
    'shared/locales.lua',
}

server_scripts {
    'server/main.lua',
    'server/functions.lua',
    'server/database.lua',
    'server/commands.lua',
    'server/exports.lua',
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/nui.lua',
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/**/*',
}

dependencies {
    '/server:4960',
    '/onesync',
}

exports {
    'getTerritoriesByGang',
    'startWar',
    'endWar',
    'addKill',
    'captureTerritory',
    'getGangStats',
    'getWarStatus',
}
