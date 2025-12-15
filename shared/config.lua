Config = {}

-- Gang Configuration
Config.Gangs = {
    ['grove'] = {
        name = 'Grove Street Family',
        color = {r = 0, g = 200, b = 100},
        label = 'GSF',
        headquarters = vector3(0, 0, 0),
    },
    ['families'] = {
        name = 'The Families',
        color = {r = 100, g = 200, b = 0},
        label = 'FAM',
        headquarters = vector3(0, 0, 0),
    },
    ['ballas'] = {
        name = 'Los Santos Vagos',
        color = {r = 200, g = 100, b = 0},
        label = 'VAGOS',
        headquarters = vector3(0, 0, 0),
    },
}

-- Territory Configuration
Config.Territories = {
    {
        id = 1,
        name = 'Mission Row',
        zone = 'MISSION',
        coords = vector3(428.5, -982.6, 29.4),
        radius = 50.0,
        owner = nil,
        captureTime = 300, -- seconds
    },
    {
        id = 2,
        name = 'El Rancho',
        zone = 'ELRANCHO',
        coords = vector3(425.2, -978.3, 29.3),
        radius = 50.0,
        owner = nil,
        captureTime = 300,
    },
    {
        id = 3,
        name = 'Del Perro',
        zone = 'DELPERRO',
        coords = vector3(-1555.2, -438.8, 42.6),
        radius = 50.0,
        owner = nil,
        captureTime = 300,
    },
}

-- War Configuration
Config.War = {
    minPlayersRequired = 2,
    maxDuration = 3600, -- 1 hour in seconds
    rewardMultiplier = 2.0,
    killReward = 500,
    deathPenalty = 100,
    captureReward = 2000,
}

-- Features
Config.Features = {
    enableNUI = true,
    enableDatabase = true,
    enableBlips = true,
    enableZones = true,
    debugMode = false,
}

return Config
