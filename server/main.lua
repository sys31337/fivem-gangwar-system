-- FiveM Gangwar System - Server Main
-- Config and Locales are loaded via shared_scripts in fxmanifest.lua

local CurrentWar = nil
local PlayerStats = {}
local TerritoryControl = {}

-- Initialize territories from config
if Config and Config.Territories then
    for _, territory in ipairs(Config.Territories) do
        TerritoryControl[territory.id] = {
            owner = territory.owner,
            capturing = false,
            capturingGang = nil,
            captureProgress = 0,
            lastUpdate = GetGameTimer(),
        }
    end
end

-- Server event: Start war from client
AddEventHandler('gangwar:server:startWar', function(attackerGang, defenderGang)
    local result = StartWar(attackerGang, defenderGang)
    TriggerClientEvent('gangwar:client:warStarted', source, result)
    BroadcastWarUpdate()
end)

-- Server event: End war from client
AddEventHandler('gangwar:server:endWar', function()
    local result = EndWar()
    TriggerClientEvent('gangwar:client:warEnded', source, result)
    BroadcastWarUpdate()
end)

-- Server event: Update player stats
AddEventHandler('gangwar:server:updatePlayerStats', function(playerId, kills, deaths)
    UpdatePlayerStats(playerId, kills, deaths)
    BroadcastPlayerStats()
end)

-- Server event: Capture territory
AddEventHandler('gangwar:server:captureTerritory', function(gangId, territoryId)
    local result = CaptureTerritory(gangId, territoryId)
    TriggerClientEvent('gangwar:client:territoryCaptured', source, result)
    BroadcastWarUpdate()
end)

-- Server event: Player joined
AddEventHandler('playerJoining', function()
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

-- Broadcast war updates to all clients
function BroadcastWarUpdate()
    TriggerClientEvent('gangwar:updateWar', -1, {
        war = CurrentWar,
        territories = TerritoryControl,
    })
end

-- Broadcast player stats to all clients
function BroadcastPlayerStats()
    TriggerClientEvent('gangwar:updateStats', -1, PlayerStats)
end

-- Global variables for command access
_G.CurrentWar = CurrentWar
_G.PlayerStats = PlayerStats
_G.TerritoryControl = TerritoryControl

print('^2[Gangwar System] Server started successfully^7')
