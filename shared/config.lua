--[[
       _ __  __ _    _ _____        _    _ _  __
      | |  \/  | |  | |  __ \      | |  | | |/ /
      | | \  / | |__| | |__) |     | |  | | ' / 
  _   | | |\/| |  __  |  _  /      | |  | |  <  
 | |__| | |  | | |  | | | \ \   _  | |__| | . \ 
  \____/|_|  |_|_|  |_|_|  \_\ (_)  \____/|_|\_\
                                                
]]

Config = {}

Config.RenderDistance = 200

Config.Zones = {
    example = {
        center = vector3(451.619, -1520.727, 29.219), -- Center of the redzone
        radius = 50.0, -- Radius of the redzone in meters
        exitPoints = { -- Locations to be teleported to on death inside a zone.
            vector3(420.72, -1455.758, 29.36),
            vector3(366.105, -1522.646, 29.278),
            vector3(412.429, -1591.965, 29.494),
            vector3(475.256, -1573.347, 29.121),
            vector3(516.968, -1506.737, 29.209),
            vector3(490.414, -1457.813, 29.183),
        },
        zoneColor = {255,0,0},

        doReward = true, -- If the killer should be rewarded for the kill
        cashItem = "cash", -- The item that is given as cash
        cashAmount = 7500, -- Amount killer gets given, to disable set to 0
        rewardItems = {"metalscrap", "jungle_pooch"}, -- Table of items, one will be chosen randomly, to disable remove items from list.
        rewardQuantity = {1,2}, -- Min/Max amount of items that can be given
        
        doRevive = true, -- If the player killed should get revived
        revivePrice = 7500, -- How much it costs for the player to get revived
        reviveTime = 2500, -- How long to wait until player gets revived and teleported


        blip = { -- Blip that is displayed on map for the zone
            zoneEnabled = true,
            zoneColor = 1,
            spriteEnabled = true,
            sprite = 310,
            spriteColor = 1,
            spriteScale = 0.9,
        },
    },
}

Config.kdUIEnabled = true -- if the UI in bottom right should be displayed, server_config.trackKills must also be enabled
Config.deleteVehicles = false -- should vehicles be deleted if they drive into the zone