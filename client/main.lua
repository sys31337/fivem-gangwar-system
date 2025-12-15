-- FiveM Gangwar System - Client Main
-- Config and Locales are loaded via shared_scripts in fxmanifest.lua

local PlayerGang = nil
local InWar = false
local CurrentWar = nil

-- Initialize NUI
SetNuiFocus(false, false)

-- Listen for war started event
AddEventHandler('gangwar:warStarted', function(warId, attacker, defender)
    CurrentWar = {
        id = warId,
        attacker = attacker,
        defender = defender,
    }
    InWar = true
    TriggerEvent('chat:addMessage', {
        args = {'Gangwar', 'War started between ' .. attacker .. ' and ' .. defender},
        color = {255, 0, 0}
    })
end)

-- Listen for war ended event
AddEventHandler('gangwar:warEnded', function(winner)
    InWar = false
    TriggerEvent('chat:addMessage', {
        args = {'Gangwar', winner .. ' won the war!'},
        color = {0, 255, 0}
    })
end)

-- Listen for territory captured event
AddEventHandler('gangwar:territoryCaptured', function(gangId, territoryId)
    TriggerEvent('chat:addMessage', {
        args = {'Territory', 'Territory ' .. territoryId .. ' captured by ' .. gangId},
        color = {255, 255, 0}
    })
end)

-- Update war data from server
AddEventHandler('gangwar:updateWar', function(warData)
    SendNuiMessage(json.encode({
        type = 'warUpdate',
        data = warData,
    }))
end)

-- Update player stats from server
AddEventHandler('gangwar:updateStats', function(stats)
    SendNuiMessage(json.encode({
        type = 'statsUpdate',
        data = stats,
    }))
end)

-- Command to open UI
RegisterCommand('gangwar', function(source, args, rawCommand)
    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({type = 'openUI'}))
end, false)

-- Command to close UI
RegisterCommand('gangwarclose', function(source, args, rawCommand)
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({type = 'closeUI'}))
end, false)

print('^2[Gangwar Client] Started successfully^7')
