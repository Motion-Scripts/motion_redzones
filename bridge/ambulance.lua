ambulance = {}

local function detectFramework()
    if server_config.customAmbulance then
        return 'custom'
    elseif GetResourceState('qbx_medical') == 'started' then
        return 'qbx'
    elseif GetResourceState('qb-ambulancejob') == 'started' then
        return 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('wasabi_ambulance') == 'started' then
        return 'wasabi'
    elseif GetResourceState('ars_ambulancejob') == 'started' then
        return 'ars'
    elseif GetResourceState('brutal_ambulancejob') == 'started' then
        return 'brutal'
    elseif GetResourceState('p_ambulancejob') == 'started' then
        return 'pScripts'
    end
    return nil
end

local script = detectFramework()
if not script then
    print("[JMHR-Redzones] Please install a supported medical script. If you're confused, read the docs :)")
else
    print("[JMHR-Redzones] Ambulance Script Detected: " .. script)
end

function ambulance.revive(id)
    if script == 'custom' then
        custom.revive(id)
    elseif script == 'qb' then
        TriggerClientEvent('hospital:client:Revive', id)
    elseif script == 'qbx' then
        exports.qbx_medical:Revive(id)
    elseif script == 'esx' then
        TriggerClientEvent('esx_ambulancejob:revive', id)
    elseif script == 'ars' then
        TriggerClientEvent('ars_ambulancejob:healPlayer', id, {revive = true})
    elseif script == 'wasabi' then
        exports.wasabi_ambulance:RevivePlayer(id)
    elseif script == 'brutal' then
        TriggerClientEvent('brutal_ambulancejob:revive', id)
    elseif script == 'pScripts' then
        TriggerClientEvent('p_ambulancejob/client/death/revive', id)
    else
        print("[JMHR-Redzones] Unknown or unsupported medical script.")
    end
end
