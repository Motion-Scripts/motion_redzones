local resourceName = GetCurrentResourceName()
if resourceName ~= "motion_redzones" then
    print("^1[ERROR]^7 Resource must be named 'motion_redzones' ")
    print("^1[ERROR]^7 Current name: '" .. resourceName .. "'")
    print("^1[ERROR]^7 Resource will now stop")
    return
end

local inZone = {}

function sendToDiscord(webhook, title, message)
    if not server_config.discordLogs then return end
    local embed = {
        {
            ["color"] = 16753920,
            ["title"] = "**" .. title .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Made by motion.uk",
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("motion-redzones:UpdateStatus", function(playerId, netId)
    inZone[source] = true
    
    if Config.deleteVehicles == true then
        if netId ~= 0 then
            DeleteEntity(NetworkGetEntityFromNetworkId(netId))
        end
    end
end)

RegisterNetEvent("motion-redzones:RewardPlayer", function(attackerSource, zoneKey)
    local src = source

    if server_config.trackKills then
        addKill(attackerSource)
        addDeath(src)
    end

    zone = Config.Zones[zoneKey]

    if inZone[src] and inZone[attackerSource] then
        exports["motion_bridge"]:AddItem(attackerSource, zone.cashItem, zone.cashAmount)
        exports["motion_bridge"]:AddItem(attackerSource, zone.rewardItems[math.random(1, #zone.rewardItems)], math.random(zone.rewardQuantity[1], zone.rewardQuantity[2]))
        
        sendToDiscord(server_config.reviveWebhook, "Redzone Player Rewarded:", "**Player Being Rewarded:** ID" .. attackerSource .. " (" .. GetPlayerName(attackerSource) .. ")" .. "\n **Victim Player:** ID" .. src .. " (" .. GetPlayerName(src) .. ")")
    end
end)

RegisterNetEvent("motion-redzones:HelpPlayer", function(zoneKey)
    local src = source 

    zone = Config.Zones[zoneKey]

    local itemCount = exports["motion_bridge"]:ItemCount(src, zone.cashItem)
    if itemCount < zone.revivePrice then
        return
    end
    
    exports["motion_bridge"]:RemoveItem(src, zone.cashItem, zone.revivePrice)
    
    TriggerClientEvent("motion-redzones:TeleportOut", src)
    
    SetTimeout(zone.reviveTime, function()
        exports["motion_bridge"]:Revive(src)
    end)

    sendToDiscord(server_config.reviveWebhook, "Redzone Player Revived:", "**Player Being Revived:** ID" .. src .. " (" .. GetPlayerName(src) .. ")")

end) 
