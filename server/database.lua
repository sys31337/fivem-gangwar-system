-- Database initialization and helpers
-- Supports: oxmysql, mysql-async, QBCore

local MySQL = nil
local DBType = 'oxmysql' -- Default

-- Detect which database library is available
local function InitDatabase()
    if GetResourceState('oxmysql') == 'started' then
        MySQL = exports.oxmysql
        DBType = 'oxmysql'
        print('^2[Gangwar] Using oxmysql^7')
    elseif GetResourceState('mysql-async') == 'started' then
        MySQL = exports['mysql-async']
        DBType = 'mysql-async'
        print('^2[Gangwar] Using mysql-async^7')
    elseif GetResourceState('qb-core') == 'started' then
        print('^2[Gangwar] Using QBCore MySQL^7')
        DBType = 'qbcore'
    else
        print('^3[Gangwar] No database resource detected, running in standalone mode^7')
        return false
    end
    return true
end

-- Execute query based on database type
local function ExecuteQuery(query, params, callback)
    if not MySQL and DBType ~= 'qbcore' then
        if callback then callback({}) end
        return
    end

    if DBType == 'oxmysql' then
        MySQL.execute(query, params, function(result)
            if callback then callback(result) end
        end)
    elseif DBType == 'mysql-async' then
        MySQL.execute(query, params, function(result)
            if callback then callback(result) end
        end)
    elseif DBType == 'qbcore' then
        local QBCore = exports['qb-core']:GetObject()
        QBCore.Functions.ExecuteSql(false, query, params, function(result)
            if callback then callback(result) end
        end)
    end
end

-- Create tables if they don't exist
local function CreateTables()
    local statements = {
        [[CREATE TABLE IF NOT EXISTS gangwar_wars (
            id INT PRIMARY KEY AUTO_INCREMENT,
            attacker_gang VARCHAR(50) NOT NULL,
            defender_gang VARCHAR(50) NOT NULL,
            start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            end_time TIMESTAMP NULL,
            winner VARCHAR(50),
            status VARCHAR(20) DEFAULT 'active',
            INDEX idx_status (status)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
        [[CREATE TABLE IF NOT EXISTS gangwar_territories (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL,
            zone VARCHAR(50),
            owner VARCHAR(50),
            captured_at TIMESTAMP,
            INDEX idx_owner (owner)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
        [[CREATE TABLE IF NOT EXISTS gangwar_stats (
            id INT PRIMARY KEY AUTO_INCREMENT,
            player_id INT NOT NULL,
            gang_id VARCHAR(50),
            kills INT DEFAULT 0,
            deaths INT DEFAULT 0,
            territories_captured INT DEFAULT 0,
            money_earned BIGINT DEFAULT 0,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY player_gang (player_id, gang_id),
            INDEX idx_player_id (player_id),
            INDEX idx_gang_id (gang_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
        [[CREATE TABLE IF NOT EXISTS gangwar_gangs (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL UNIQUE,
            label VARCHAR(20),
            color VARCHAR(7),
            balance BIGINT DEFAULT 0,
            headquarters JSON,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_name (name)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]]
    }

    for _, statement in ipairs(statements) do
        ExecuteQuery(statement, {}, function(result)
            -- Tables created or already exist
        end)
    end
    print('^2[Gangwar] Database tables initialized^7')
end

-- Save war to database
local function SaveWarToDatabase(war)
    local query = 'INSERT INTO gangwar_wars (attacker_gang, defender_gang, winner, status, end_time) VALUES (?, ?, ?, ?, ?)'
    local endTime = os.date('%Y-%m-%d %H:%M:%S', war.endTime or os.time())

    ExecuteQuery(query, {
        war.attacker,
        war.defender,
        war.winner or 'draw',
        war.status,
        endTime
    }, function(result)
        if result then
            print('^2[Gangwar] War saved to database^7')
        end
    end)
end

-- Save player stats to database
local function SavePlayerStatsToDatabase(playerId, stats)
    local query = 'INSERT INTO gangwar_stats (player_id, gang_id, kills, deaths, territories_captured) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE kills = VALUES(kills), deaths = VALUES(deaths), territories_captured = VALUES(territories_captured)'

    ExecuteQuery(query, {
        playerId,
        stats.gang,
        stats.kills,
        stats.deaths,
        stats.territories,
    }, function(result)
        if result then
            print('^2[Gangwar] Player stats saved^7')
        end
    end)
end

-- Initialize database on script start
local dbInitialized = InitDatabase()
if dbInitialized then
    CreateTables()
else
    print('^3[Gangwar] Running without database functionality^3')
end

-- Exports
return {
    execute = ExecuteQuery,
    saveWar = SaveWarToDatabase,
    savePlayerStats = SavePlayerStatsToDatabase,
    isInitialized = function() return dbInitialized end,
}
