-- Export functions for external resources

-- Get all territories owned by a gang
local function getTerritoriesByGang(gangId)
    local territories = {}
    for territoryId, territory in pairs(TerritoryControl) do
        if territory.owner == gangId then
            table.insert(territories, {
                id = territoryId,
                owner = gangId,
                lastUpdate = territory.lastUpdate,
            })
        end
    end
    return territories
end

-- Start a war
local function startWar(attackerGang, defenderGang)
    return StartWar(attackerGang, defenderGang)
end

-- End current war
local function endWar()
    return EndWar()
end

-- Add kill to stats
local function addKill(playerId, killerId)
    return AddKill(playerId, killerId)
end

-- Capture territory
local function captureTerritory(gangId, territoryId)
    return CaptureTerritory(gangId, territoryId)
end

-- Get gang statistics
local function getGangStats(gangId)
    return GetGangStats(gangId)
end

-- Get current war status
local function getWarStatus()
    return GetWarStatus()
end

-- Get all player stats
local function getPlayerStats(playerId)
    return PlayerStats[playerId] or {}
end

-- Get all territories
local function getAllTerritories()
    return TerritoryControl
end

-- Register exports
Exports('getTerritoriesByGang', getTerritoriesByGang)
Exports('startWar', startWar)
Exports('endWar', endWar)
Exports('addKill', addKill)
Exports('captureTerritory', captureTerritory)
Exports('getGangStats', getGangStats)
Exports('getWarStatus', getWarStatus)
Exports('getPlayerStats', getPlayerStats)
Exports('getAllTerritories', getAllTerritories)
