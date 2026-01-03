RegisterNetEvent("jmhr-redzones:showUI", function()
    SendNUIMessage({type = 'showUI'})
end)

RegisterNetEvent("jmhr-redzones:hideUI", function()
    SendNUIMessage({type = 'hideUI'})
end)

RegisterNetEvent("jmhr-redzones:UpdateUI", function(stats)
    SendNUIMessage({
        type = 'update',
        values = {kills = stats.kills, deaths = stats.deaths}
    })
end)

