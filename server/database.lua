-- Database initialization and helpers
-- Note: This is a template. Adapt to your database system (MySQL, MongoDB, etc.)

local MySQL = exports['mysql-async'] -- Adjust based on your DB resource

-- Create tables if they don't exist
function InitializeDatabase()
    local createTablesQuery = [[
        CREATE TABLE IF NOT EXISTS gangwar_wars (
            id INT PRIMARY KEY AUTO_INCREMENT,
            attacker_gang VARCHAR(50) NOT NULL,
            defender_gang VARCHAR(50) NOT NULL,
            start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            end_time TIMESTAMP,
            winner VARCHAR(50),
            status VARCHAR(20) DEFAULT 'active'
        );

        CREATE TABLE IF NOT EXISTS gangwar_territories (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL,
            zone VARCHAR(50),
            owner VARCHAR(50),
            captured_at TIMESTAMP,
            INDEX idx_owner (owner)
        );

        CREATE TABLE IF NOT EXISTS gangwar_stats (
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
        );

        CREATE TABLE IF NOT EXISTS gangwar_gangs (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL UNIQUE,
            label VARCHAR(20),
            color VARCHAR(7),
            balance BIGINT DEFAULT 0,
            headquarters JSON,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_name (name)
        );
    ]]
    
    MySQL.execute(createTablesQuery, {}, function(result)
        print('^2[Gangwar] Database tables initialized^7')
    end)
end

-- Save war to database
function SaveWarToDatabase(war)
    local query = [[
        INSERT INTO gangwar_wars (attacker_gang, defender_gang, winner, status, end_time)
        VALUES (?, ?, ?, ?, ?)
    ]]
    
    MySQL.execute(query, {
        war.attacker,
        war.defender,
        war.winner or 'draw',
        war.status,
        os.date('%Y-%m-%d %H:%M:%S', war.endTime)
    })
end

-- Save player stats to database
function SavePlayerStatsToDatabase(playerId, stats)
    local query = [[
        INSERT INTO gangwar_stats (player_id, gang_id, kills, deaths, territories_captured)
        VALUES (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
        kills = VALUES(kills),
        deaths = VALUES(deaths),
        territories_captured = VALUES(territories_captured)
    ]]
    
    MySQL.execute(query, {
        playerId,
        stats.gang,
        stats.kills,
        stats.deaths,
        stats.territories,
    })
end

-- Load player stats from database
function LoadPlayerStatsFromDatabase(playerId)
    local query = 'SELECT * FROM gangwar_stats WHERE player_id = ?'
    
    MySQL.query.await(query, {playerId}, function(results)
        return results and results[1] or nil
    end)
end

-- Initialize database on script start
if Config.Features.enableDatabase then
    InitializeDatabase()
end
