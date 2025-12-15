-- Client-side functions for gangwar system

-- Get player gang
function GetPlayerGang()
    return PlayerGang
end

-- Set player gang
function SetPlayerGang(gang)
    PlayerGang = gang
end

-- Check if player is in war
function IsPlayerInWar()
    return InWar
end

-- Draw text on screen
function DrawText3D(x, y, z, text)
    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        EndTextCommandDisplayText(screenX, screenY)
    end
end

-- Create blip for territory
function CreateTerritoryBlip(territory)
    local blip = AddBlipForCoord(territory.coords.x, territory.coords.y, territory.coords.z)
    SetBlipAsNoLongerNeeded(blip)
    SetBlipRoute(blip, false)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, false)
    AddTextComponentString(territory.name)
    return blip
end

-- Create zone for territory
function CreateTerritoryZone(territory, callback)
    local coords = territory.coords
    local entering = false
    
    while true do
        Wait(100)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - coords)
        
        if distance < territory.radius then
            if not entering then
                entering = true
                callback(true, territory)
            end
        else
            if entering then
                entering = false
                callback(false, territory)
            end
        end
    end
end

-- Notify player
function Notify(title, message, type)
    TriggerEvent('chat:addMessage', {
        args = {title, message},
        color = type == 'success' and {0, 255, 0} or {255, 0, 0}
    })
end
