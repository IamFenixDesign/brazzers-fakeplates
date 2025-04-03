fx_version 'cerulean'
game 'gta5'

name "Brazzers Fake Plates"
author "Brazzers Development | MannyOnBrazzers#6826 ft FenixDesign (add ox target and multiple tweaks)"
version "1.1"

lua54 'yes'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
	'@qb-core/shared/locale.lua',
	'shared/*.lua',
    '@ox_lib/init.lua',
}

lua54 'yes'