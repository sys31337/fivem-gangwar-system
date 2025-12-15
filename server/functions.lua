local Config = require('shared.config')
local Locales = require('shared.locales')

-- Start a war between two gangs
function StartWar(attackerGang, defenderGang)
    if not attackerGang or not defenderGang then
        return {success = false, message = 'Invalid gang IDs'}
    end
    
    if CurrentWar then
        return {success = false, message = Locales['en'].already_in_war}
    end
    
    -- Check minimum players
    local playerCount = GetNumPlayerIndices()
    if playerCount < Config.War.minPlayersRequired then
        return {success = false, message = 'Not enough players'}
    end
    
    CurrentWar = {
        id = GenerateWarId(),
        attacker = attackerGang,
        defender = defenderGang,
        startTime = os.time(),
        endTime = nil,
        status = 'active',
        kills = {
            [attackerGang] = 0,
            [defenderGang] = 0,
        },
        territories = {
            [attackerGang] = 0,
            [defenderGang] = 0,
        },
    }
    
    TriggerEvent('gangwar:warStarted', CurrentWar.id, attackerGang, defenderGang)
    TriggerClientEvent('gangwar:warStarted', -1, CurrentWar)
    
    print(string.format(Locales['en'].war_started, attackerGang, defenderGang))
    
    return {success = true, war = CurrentWar}
end

-- End current war
function EndWar()
    if not CurrentWar then
        return {success = false, message = 'No war in progress'}
    end
    
    CurrentWar.status = 'ended'
    CurrentWar.endTime = os.time()
    
    -- Determine winner
    local winner = CurrentWar.kills[CurrentWar.attacker] > CurrentWar.kills[CurrentWar.defender]
        and CurrentWar.attacker or CurrentWar.defender
    
    TriggerEvent('gangwar:warEnded', CurrentWar.id, winner)
    TriggerClientEvent('gangwar:warEnded', -1, winner)
    
    print(string.format(Locales['en'].war_ended, winner))
    
    local warData = CurrentWar
    CurrentWar = nil
    
    return {success = true, war = warData}
end

-- Add kill to player stats
function AddKill(playerId, killerId)
    if PlayerStats[playerId] and PlayerStats[killerId] then
        PlayerStats[playerId].deaths = PlayerStats[playerId].deaths + 1
        PlayerStats[killerId].kills = PlayerStats[killerId].kills + 1
        
        if CurrentWar then
            CurrentWar.kills[PlayerStats[killerId].gang] = (CurrentWar.kills[PlayerStats[killerId].gang] or 0) + 1
        end
        
        BroadcastPlayerStats()
        return {success = true}
    end
    return {success = false, message = 'Player not found'}
end

-- Capture territory
function CaptureTerritory(gangId, territoryId)
    local territory = TerritoryControl[territoryId]
    if not territory then
        return {success = false, message = 'Territory not found'}
    end
    
    territory.owner = gangId
    territory.lastUpdate = GetGameTimer()
    
    if CurrentWar then
        CurrentWar.territories[gangId] = (CurrentWar.territories[gangId] or 0) + 1
    end
    
    TriggerEvent('gangwar:territoryCaptured', gangId, territoryId)
    TriggerClientEvent('gangwar:territoryCaptured', -1, gangId, territoryId)
    BroadcastWarUpdate()
    
    return {success = true, territory = territory}
end

-- Update player statistics
function UpdatePlayerStats(playerId, kills, deaths)
    if PlayerStats[playerId] then
        PlayerStats[playerId].kills = kills
        PlayerStats[playerId].deaths = deaths
        BroadcastPlayerStats()
        return true
    end
    return false
end

-- Get gang statistics
function GetGangStats(gangId)
    local stats = {
        kills = 0,
        deaths = 0,
        territories = 0,
        players = 0,
    }
    
    for playerId, playerStats in pairs(PlayerStats) do
        if playerStats.gang == gangId then
            stats.kills = stats.kills + playerStats.kills
            stats.deaths = stats.deaths + playerStats.deaths
            stats.players = stats.players + 1
        end
    end
    
    for territoryId, territory in pairs(TerritoryControl) do
        if territory.owner == gangId then
            stats.territories = stats.territories + 1
        end
    end
    
    return stats
end

-- Get war status
function GetWarStatus()
    return CurrentWar or {status = 'idle'}
end

-- Generate unique war ID
function GenerateWarId()
    return 'war_' .. os.time() .. '_' .. math.random(1000, 9999)
end
