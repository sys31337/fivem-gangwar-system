-- Client-side event handlers

-- Listen for server war update
AddEventHandler('gangwar:warUpdate', function(data)
    SendNuiMessage(json.encode({
        type = 'warUpdate',
        data = data,
    }))
end)

-- Listen for server stats update
AddEventHandler('gangwar:statsUpdate', function(data)
    SendNuiMessage(json.encode({
        type = 'statsUpdate',
        data = data,
    }))
end)

-- Listen for war started
AddEventHandler('gangwar:warStarted', function(warData)
    SendNuiMessage(json.encode({
        type = 'warStarted',
        data = warData,
    }))
end)

-- Listen for war ended
AddEventHandler('gangwar:warEnded', function(winner)
    SendNuiMessage(json.encode({
        type = 'warEnded',
        data = { winner = winner },
    }))
end)

-- Listen for territory captured
AddEventHandler('gangwar:territoryCaptured', function(gangId, territoryId)
    SendNuiMessage(json.encode({
        type = 'territoryCaptured',
        data = { gangId = gangId, territoryId = territoryId },
    }))
end)
