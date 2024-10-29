fx_version 'cerulean'
games { 'gta5' }

author 'HoboDevCo#3011'
description 'SDC | World Interaction Script'
version '1.0.2'

shared_script {
    '@ox_lib/init.lua',
    "config/config.lua",
    "config/lang.lua"
}

client_scripts {
    "src/client/client_customize_me.lua",
    "src/client/main.lua",
    "src/client/cl_portapotty.lua",
    "src/client/cl_dumpsters.lua",
    "src/client/cl_parkingmeters.lua",
    "src/client/cl_vending.lua",
    "src/client/cl_toilets.lua",
    "src/client/cl_chairs.lua",
}

server_scripts {
    "src/server/server_customize_me.lua",
    "src/server/main.lua",
    "src/server/sv_portapotty.lua",
    "src/server/sv_dumpsters.lua",
    "src/server/sv_parkingmeters.lua",
    "src/server/sv_vending.lua",
    "src/server/sv_toilets.lua",
    "src/server/sv_chairs.lua",
}

escrow_ignore {
    "config/config.lua",
    "config/lang.lua",
    
    "src/client/client_customize_me.lua",
    "src/client/main.lua",
    "src/client/cl_portapotty.lua",
    "src/client/cl_dumpsters.lua",
    "src/client/cl_parkingmeters.lua",
    "src/client/cl_vending.lua",
    "src/client/cl_toilets.lua",
    "src/client/cl_chairs.lua",

    "src/server/server_customize_me.lua",
    "src/server/main.lua",
    "src/server/sv_portapotty.lua",
    "src/server/sv_dumpsters.lua",
    "src/server/sv_parkingmeters.lua",
    "src/server/sv_vending.lua",
    "src/server/sv_toilets.lua",
    "src/server/sv_chairs.lua",
}
lua54 'yes'