inventory = {}

local function detectFramework()
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox'
    elseif GetResourceState('qb-inventory') == 'started' then
        return 'qb'
    elseif GetResourceState('codem-inventory') == 'started' then
        return 'codem'
    elseif server_config.customInventory then
        return 'custom'
    end
    return nil
end

local script = detectFramework()
if not script then
    print("[JMHR-Redzones] Please install a supported inventory script. If you're confused, check the readme :)")
else
    print("[JMHR-Redzones] Inventory Script Detected: " .. script)
end

function inventory.addItem(id, item, amount)
    if script == 'custom' then
        custom.addItem(id, item, amount)
    elseif script == 'ox' then
        exports.ox_inventory:AddItem(id, item, amount)
    elseif script == 'qb' then
        exports['qb-inventory']:AddItem(id, item, amount)        
    elseif script == 'codem' then
        exports['codem-inventory']:AddItem(id, item, amount)
    else
        print("[JMHR-Redzones] Unknown or unsupported inventory script. This action has failed.")
    end
end

function inventory.removeItem(id, item, amount)
    if script == 'custom' then
        custom.removeItem(id, item, amount)
    elseif script == 'ox' then
        exports.ox_inventory:RemoveItem(id, item, amount)
    elseif script == 'qb' then
        exports['qb-inventory']:RemoveItem(id, item, amount)        
    elseif script == 'codem' then
        exports['codem-inventory']:RemoveItem(id, item, amount)
    else
        print("[JMHR-Redzones] Unknown or unsupported inventory script. This action has failed.")
    end
end

function inventory.itemCount(id, item)
    if script == 'custom' then
        return custom.getItemCount(id, item)
    elseif script == 'ox' then
        return exports.ox_inventory:GetItemCount(id, item)
    elseif script == 'qb' then
        return exports['qb-inventory']:GetItemCount(id, item)
    elseif script == 'codem' then
       return exports['codem-inventory']:GetItemsTotalAmount(id, item)
    else
        print("[JMHR-Redzones] Unknown or unsupported inventory script. This action has failed.")
    end
end