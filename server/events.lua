-- Server-side event handlers

-- Handle NUI callback: Start war
AddEventHandler('gangwar:startWar', function(attacker, defender)
    local result = StartWar(attacker, defender)
    if result.success then
        TriggerClientEvent('chat:addMessage', -1, {
            args = {'Gangwar', 'War started!'},
            color = {255, 0, 0}
        })
    end
end)

-- Handle NUI callback: End war
AddEventHandler('gangwar:endWar', function()
    local result = EndWar()
    if result.success then
        TriggerClientEvent('chat:addMessage', -1, {
            args = {'Gangwar', 'War ended!'},
            color = {0, 255, 0}
        })
    end
end)

-- Handle NUI callback: Capture territory
AddEventHandler('gangwar:captureTerritory', function(gangId, territoryId)
    local result = CaptureTerritory(gangId, territoryId)
    if result.success then
        TriggerClientEvent('chat:addMessage', -1, {
            args = {'Territory', gangId .. ' captured territory!'},
            color = {255, 255, 0}
        })
    end
end)

-- Handle NUI callback: Get stats
AddEventHandler('gangwar:getStats', function()
    local stats = GetGangStats('all')
    TriggerClientEvent('gangwar:statsUpdate', source, stats)
end)
