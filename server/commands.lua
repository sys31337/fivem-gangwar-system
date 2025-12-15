-- Admin command: Start war
RegisterCommand('startwar', function(source, args, rawCommand)
    local attacker = args[1]
    local defender = args[2]
    
    if not attacker or not defender then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Usage', '/startwar <attacker_gang> <defender_gang>'},
            color = {255, 0, 0}
        })
        return
    end
    
    local result = StartWar(attacker, defender)
    if result.success then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'War System', 'War started!'},
            color = {0, 255, 0}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {'War System', result.message},
            color = {255, 0, 0}
        })
    end
end, false)

-- Admin command: End war
RegisterCommand('endwar', function(source, args, rawCommand)
    local result = EndWar()
    if result.success then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'War System', 'War ended!'},
            color = {0, 255, 0}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {'War System', result.message},
            color = {255, 0, 0}
        })
    end
end, false)

-- Command: View gang stats
RegisterCommand('gangstats', function(source, args, rawCommand)
    local gangId = args[1]
    if not gangId then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Usage', '/gangstats <gang_id>'},
            color = {255, 0, 0}
        })
        return
    end
    
    local stats = GetGangStats(gangId)
    TriggerClientEvent('chat:addMessage', source, {
        args = {'Gang Stats', json.encode(stats)},
        color = {0, 255, 0}
    })
end, false)

-- Command: View war status
RegisterCommand('warstatus', function(source, args, rawCommand)
    local war = GetWarStatus()
    TriggerClientEvent('chat:addMessage', source, {
        args = {'War Status', json.encode(war)},
        color = {0, 255, 0}
    })
end, false)

-- Command: Open gangwar UI
RegisterCommand('gangwar', function(source, args, rawCommand)
    TriggerClientEvent('gangwar:openUI', source)
end, false)
