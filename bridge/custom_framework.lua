-- This is used if server_config.customInvetory or server_config.customAmbulance is set to true
-- If this isn't used the script autodetects any of the supported ambulance jobs.

custom = {}

function custom.revive(id) -- ID is the server id of the player to be revived.
    -- add logic here
end

function custom.addItem(id, item, amount) -- ID is the server id of the player to be revived.
    -- add logic here
end 

function custom.removeItem(id, item, amount) -- ID is the server id of the player to be revived.
    -- add logic here
end

function custom.getItemCount(id, item) -- ID is the server id of the player to be revived.
    local amount = nil -- placeholder
    -- add logic here
    return amount
end
