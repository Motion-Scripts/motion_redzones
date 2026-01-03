function ensurePlayerExists(discordId)
    MySQL.rawExecute.await([[
        INSERT INTO redzone_stats (discord, kills, deaths)
        VALUES (?, 0, 0)
        ON DUPLICATE KEY UPDATE discord = discord;
    ]], { discordId })
end

function addKill(id)
    local discordId = GetPlayerIdentifierByType(id, 'discord')
    print(discordId)
    ensurePlayerExists(discordId)

    MySQL.rawExecute.await('UPDATE redzone_stats SET kills = kills + 1 WHERE discord = ?', {
        discordId
    })

    if Config.kdUIEnabled then TriggerClientEvent("jmhr-redzones:UpdateUI", id, getPlayerStats(id)) end
end

function addDeath(id)
    local discordId = GetPlayerIdentifierByType(id, 'discord')
    ensurePlayerExists(discordId)

    MySQL.rawExecute.await('UPDATE redzone_stats SET deaths = deaths + 1 WHERE discord = ?', {
        discordId
    })

    if Config.kdUIEnabled then TriggerClientEvent("jmhr-redzones:UpdateUI", id, getPlayerStats(id)) end
end

function getPlayerStats(id)
    local discordId = GetPlayerIdentifierByType(id, 'discord')
    ensurePlayerExists(discordId)

    return MySQL.single.await('SELECT * FROM redzone_stats WHERE discord = ?', {
        discordId
    })
end

function getLeaderboard()
    local topKills = MySQL.query.await(string.format([[
        SELECT discord, kills, deaths, (kills / NULLIF(deaths, 0)) AS kd
        FROM redzone_stats
        ORDER BY kills DESC
        LIMIT %d
    ]], server_config.leaderboardLength))

    local topKD = MySQL.query.await(string.format([[
        SELECT *
        FROM (
            SELECT discord, kills, deaths, (kills / NULLIF(deaths, 0)) AS kd
            FROM redzone_stats
        ) AS t
        ORDER BY kd DESC
        LIMIT %d
    ]], server_config.leaderboardLength))

    return topKills, topKD
end

function sendLeaderboard()
    print("[JMHR-Redzones] Sending Leaderboard")
    local topKills, topKD = getLeaderboard()

    local killsText = ""
    for i, row in ipairs(topKills) do
        local discord = row.discord:gsub("discord:", "")

        killsText = killsText ..
            string.format("**%d. <@%s>** — %d kills, %d deaths (KD: %.2f)\n",
                i, discord, row.kills, row.deaths, row.kd or 0)
    end

    local kdText = ""
    for i, row in ipairs(topKD) do
        local discord = row.discord:gsub("discord:", "")

        kdText = kdText ..
            string.format("**%d. <@%s>** — KD: %.2f (%d kills, %d deaths)\n",
                i, discord, row.kd or 0, row.kills, row.deaths)
    end

    local embed = {
        username = "Redzone Leaderboard",
        embeds = {{
            title = "🔥 Redzone Leaderboard (Top " .. server_config.leaderboardLength .. ")",
            color = 15158332,
            fields = {
                {
                    name = "🏆 Top Kills",
                    value = killsText ~= "" and killsText or "No data.",
                    inline = false
                },
                {
                    name = "🎯 Top KD",
                    value = kdText ~= "" and kdText or "No data.",
                    inline = false
                }
            },
            footer = {
                text = "Leaderboard Auto-Update | jmhr.uk | "
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    PerformHttpRequest(server_config.leaderboardWebhook, function() end, "POST", json.encode(embed), {
        ["Content-Type"] = "application/json"
    })
end

if not server_config.trackKills then
    return
else
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `redzone_stats` (
            `discord` VARCHAR(50) NOT NULL,
            `kills` INT NOT NULL DEFAULT 0,
            `deaths` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`discord`)
        );
    ]])

    RegisterNetEvent("jmhr-redzones:RequestStats", function()
        TriggerClientEvent("jmhr-redzones:UpdateUI", source, getPlayerStats(source))
    end)

    RegisterCommand("resetredzonestats", function(source)
        if source ~= 0 then return end

        MySQL.rawExecute.await([[
            TRUNCATE TABLE `redzone_stats`;
        ]])
    
        print("Redzone stats have been reset.")
    end)

    if server_config.sendLeaderboard then
        CreateThread(function()
            while true do
                Wait((server_config.leaderboardTimer or 30) * 60000)
                sendLeaderboard()
            end
        end)
    end
end
