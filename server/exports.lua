-- Export functions for external resources

-- Get all territories owned by a gang
function exports.getTerritoriesByGang(gangId)
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
function exports.startWar(attackerGang, defenderGang)
    return StartWar(attackerGang, defenderGang)
end

-- End current war
function exports.endWar()
    return EndWar()
end

-- Add kill to stats
function exports.addKill(playerId, killerId)
    return AddKill(playerId, killerId)
end

-- Capture territory
function exports.captureTerritory(gangId, territoryId)
    return CaptureTerritory(gangId, territoryId)
end

-- Get gang statistics
function exports.getGangStats(gangId)
    return GetGangStats(gangId)
end

-- Get current war status
function exports.getWarStatus()
    return GetWarStatus()
end

-- Get all player stats
function exports.getPlayerStats(playerId)
    return PlayerStats[playerId] or {}
end

-- Get all territories
function exports.getAllTerritories()
    return TerritoryControl
end
