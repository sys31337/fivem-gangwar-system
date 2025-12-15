-- NUI callbacks and communication

-- NUI to Lua communication
RegisterNuiCallback('nuiReady', function(data, cb)
    print('^2[NUI] Frontend ready^7')
    cb({success = true})
end)

RegisterNuiCallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb({success = true})
end)

RegisterNuiCallback('startWar', function(data, cb)
    TriggerServerEvent('gangwar:startWar', data.attacker, data.defender)
    cb({success = true})
end)

RegisterNuiCallback('endWar', function(data, cb)
    TriggerServerEvent('gangwar:endWar')
    cb({success = true})
end)

RegisterNuiCallback('captureTerritory', function(data, cb)
    TriggerServerEvent('gangwar:captureTerritory', data.gangId, data.territoryId)
    cb({success = true})
end)

RegisterNuiCallback('getStats', function(data, cb)
    TriggerServerEvent('gangwar:getStats')
    cb({success = true})
end)

-- Lua to NUI communication
function SendToNUI(type, data)
    SendNuiMessage(json.encode({
        type = type,
        data = data,
    }))
end
