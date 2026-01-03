--[[
       _ __  __ _    _ _____        _    _ _  __
      | |  \/  | |  | |  __ \      | |  | | |/ /
      | | \  / | |__| | |__) |     | |  | | ' / 
  _   | | |\/| |  __  |  _  /      | |  | |  <  
 | |__| | |  | | |  | | | \ \   _  | |__| | . \ 
  \____/|_|  |_|_|  |_|_|  \_\ (_)  \____/|_|\_\
                                                
]]

server_config = {}

server_config.discordLogs = true -- if you're going to complain discord logs are trash just add your own logging service
server_config.rewardWebhook = ""
server_config.reviveWebhook = ""

-- Stat Tracking
server_config.trackKills = true
server_config.sendLeaderboard = true -- change webhook in shared/server_config.lua
server_config.leaderboardTimer = 30 -- Time in minutes between leaderboard updates
server_config.leaderboardLength = 5 -- how many players to display on the leaderboard
server_config.leaderboardWebhook = ""

-- I highly recommend using one of the supported resources unless you know what you're doing
-- Edit these functions in bridge/custom_framework.lua
server_config.customInventory = false 
server_config.customAmbulance = false