local inZone, currentZone = false, nil
local zones = {}
AddEventHandler("gameEventTriggered", function (event, args)
    if not inZone then return end

    if event == "CEventNetworkEntityDamage" and args[6] == 1 then
        if not IsEntityAPed(args[1]) or not IsPedAPlayer(args[1]) then return end

        local victimPed = args[1]
        local attackerPed = args[2]

        local localPed = PlayerPedId()
        if victimPed ~= localPed then return end

        local attackerPlayerIndex = NetworkGetPlayerIndexFromPed(attackerPed)
        if attackerPlayerIndex == -1 then return end -- invalid attacker

        local attackerServerId = GetPlayerServerId(attackerPlayerIndex)
        if attackerServerId == 0 then return end -- invalid server ID

        if currentZone and currentZone.exitPoints then
            if currentZone.doReward then
                TriggerServerEvent("jmhr-redzones:RewardPlayer", attackerServerId, currentZone.key)
            end
            if currentZone.doRevive then
                Wait(2000)
                TriggerServerEvent("jmhr-redzones:HelpPlayer", currentZone.key)
            end
        end
    end
end)

RegisterNetEvent("jmhr-redzones:TeleportOut", function()
    local exitPoint = currentZone.exitPoints[math.random(1, #currentZone.exitPoints)]

    if exitPoint and type(exitPoint.x) == "number" and type(exitPoint.y) == "number" and type(exitPoint.z) == "number" then
        local ped = PlayerPedId()
        SetEntityCoords(ped, exitPoint.x, exitPoint.y, exitPoint.z)
    end
end)


for zoneKey, zoneData in pairs(Config.Zones) do
    local zone = CircleZone:Create(zoneData.center, zoneData.radius, { name = zoneData.name, debugPoly = true, debugColor = zoneData.zoneColor or {255,0,0}})
    zone:onPlayerInOut(function(isInside)
        inZone = isInside
        if isInside then
            currentZone = zoneData
            currentZone.key = zoneKey

            if Config.kdUIEnabled then
                TriggerEvent("jmhr-redzones:showUI", PlayerId())
            end
        else
            currentZone = nil 

            if Config.kdUIEnabled then
                TriggerEvent("jmhr-redzones:hideUI", PlayerId())
            end
        end

        local netId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false))
        
        TriggerServerEvent("jmhr-redzones:UpdateStatus", PlayerId(), netId)
    end)

    table.insert(zones, zone)
end

for x, v  in pairs(Config.Zones) do
    if v.blip.zoneEnabled then
        local blip = AddBlipForRadius(v.center.x, v.center.y, v.center.z, v.radius)
        SetBlipColour(blip, v.blip.zoneColor)
        SetBlipAlpha(blip, 100)
    end
    if v.blip.spriteEnabled then
        local blip2 = AddBlipForCoord(v.center.x, v.center.y, v.center.z)
        SetBlipSprite(blip2, v.blip.sprite)
        SetBlipColour(blip2, v.blip.spriteColor)
        SetBlipScale(blip2, v.blip.spriteScale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip2)
    end
end

TriggerServerEvent("jmhr-redzones:RequestStats")

while true do
    Wait(2000)
    for key, zone in pairs(zones) do
        local position = zone.center
        if #(position - GetEntityCoords(PlayerPedId())) < Config.RenderDistance then
            if zone.debugPoly == false then
                zone.debugPoly = true
            end
        else
            if zone.debugPoly == true then
                zone.debugPoly = false
            end
        end
    end
end