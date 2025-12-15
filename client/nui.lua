-- NUI Callbacks - CLIENT SIDE ONLY
-- RegisterNuiCallback is for client scripts receiving messages from React frontend

-- NUI Callback: NUI is ready
RegisterNuiCallback('nuiReady', function(data, cb)
    print('^2[Gangwar NUI] Frontend ready^7')
    cb({success = true})
end)

-- NUI Callback: Close UI
RegisterNuiCallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb({success = true})
end)

-- NUI Callback: Start war (from React frontend)
RegisterNuiCallback('startWar', function(data, cb)
    print('[Gangwar] Starting war: ' .. data.attacker .. ' vs ' .. data.defender)
    TriggerServerEvent('gangwar:server:startWar', data.attacker, data.defender)
    cb({success = true})
end)

-- NUI Callback: End war (from React frontend)
RegisterNuiCallback('endWar', function(data, cb)
    print('[Gangwar] Ending war')
    TriggerServerEvent('gangwar:server:endWar')
    cb({success = true})
end)

-- NUI Callback: Capture territory (from React frontend)
RegisterNuiCallback('captureTerritory', function(data, cb)
    print('[Gangwar] Capturing territory ' .. data.territoryId .. ' for gang ' .. data.gangId)
    TriggerServerEvent('gangwar:server:captureTerritory', data.gangId, data.territoryId)
    cb({success = true})
end)

-- NUI Callback: Get stats (from React frontend)
RegisterNuiCallback('getStats', function(data, cb)
    print('[Gangwar] Getting stats')
    TriggerServerEvent('gangwar:server:getStats')
    cb({success = true})
end)

-- Send data to NUI
function SendToNUI(type, data)
    SendNuiMessage(json.encode({
        type = type,
        data = data,
    }))
end

print('^2[Gangwar NUI] Callbacks registered successfully^7')
