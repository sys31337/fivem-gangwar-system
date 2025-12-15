local Config = require('shared.config')
local Locales = require('shared.locales')
local CurrentWar = nil
local PlayerStats = {}
local TerritoryControl = {}

-- Initialize territories
for _, territory in ipairs(Config.Territories) do
    TerritoryControl[territory.id] = {
        owner = territory.owner,
        capturing = false,
        capturingGang = nil,
        captureProgress = 0,
        lastUpdate = GetGameTimer(),
    }
end

-- NUI Callback: Get war status
RegisterNuiCallback('getWarStatus', function(data, cb)
    cb({
        war = CurrentWar,
        territories = TerritoryControl,
        playerStats = PlayerStats,
    })
end)

-- NUI Callback: Start war
RegisterNuiCallback('startWar', function(data, cb)
    local result = StartWar(data.attackerGang, data.defenderGang)
    cb(result)
end)

-- NUI Callback: End war
RegisterNuiCallback('endWar', function(data, cb)
    local result = EndWar()
    cb(result)
end)

-- NUI Callback: Update player stats
RegisterNuiCallback('updatePlayerStats', function(data, cb)
    UpdatePlayerStats(data.playerId, data.kills, data.deaths)
    cb({success = true})
end)

-- NUI Callback: Capture territory
RegisterNuiCallback('captureTerritory', function(data, cb)
    local result = CaptureTerritory(data.gangId, data.territoryId)
    cb(result)
end)

-- Server event: Player joined
AddEventHandler('playerJoined', function()
    local playerId = source
    PlayerStats[playerId] = {
        playerId = playerId,
        kills = 0,
        deaths = 0,
        territories = 0,
    }
end)

-- Server event: Player left
AddEventHandler('playerDropped', function()
    local playerId = source
    PlayerStats[playerId] = nil
end)

-- Broadcast war updates
function BroadcastWarUpdate()
    TriggerClientEvent('gangwar:updateWar', -1, {
        war = CurrentWar,
        territories = TerritoryControl,
    })
end

-- Broadcast player stats
function BroadcastPlayerStats()
    TriggerClientEvent('gangwar:updateStats', -1, PlayerStats)
end

-- Update NUI with latest data
function UpdateNUI(data)
    SendNuiMessage(json.encode({
        type = 'updateWarData',
        data = data,
    }))
end

print('^2[Gangwar System] Server started successfully^7')
