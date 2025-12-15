# FiveM Gangwar System

A complete, production-ready gangwar system for FiveM with React.js frontend, TypeScript, and full Lua server integration.

## Features

- 🎮 **Real-time War System** - Start and manage gang wars with live updates
- 📊 **Statistics Dashboard** - Track player kills, deaths, and territory captures
- 🗺️ **Territory Control** - Dynamic territory system with capture mechanics
- 👥 **Multi-Gang Support** - Full support for multiple gangs (QBCore, ESX, Standalone)
- 🎨 **Modern React UI** - Beautiful, responsive interface built with React 18+
- 📱 **Responsive Design** - Works on all screen sizes
- ⚡ **Performance Optimized** - Vite bundler for fast development and builds
- 🔒 **Type Safe** - Full TypeScript support for both frontend and backend
- 📡 **NUI IPC Communication** - Secure client-server communication
- 🗄️ **Database Ready** - SQL templates included for persistent data

## Requirements

- FiveM Server
- Node.js 16+ (for development)
- MySQL (optional, for persistent storage)

## Installation

1. Clone or download this resource
2. Place it in your FiveM `resources` folder
3. Install dependencies:
   ```bash
   cd web
   npm install
   ```

4. Build the React frontend:
   ```bash
   npm run build
   ```

5. Add to your `server.cfg`:
   ```
   ensure gangwar-system
   ```

## Development

For development with hot-reload:

```bash
cd web
npm run dev
```

The NUI will reload automatically when you make changes.

## Configuration

Edit `shared/config.lua` to customize:

- Gang names and colors
- Territory locations and capture times
- War settings (min players, duration, rewards)
- Feature flags

### Example:

```lua
Config.Gangs = {
    ['grove'] = {
        name = 'Grove Street Family',
        color = {r = 0, g = 200, b = 100},
        label = 'GSF',
        headquarters = vector3(0, 0, 0),
    },
    -- Add more gangs...
}
```

## Commands

### Admin Commands

- `/startwar <attacker_gang> <defender_gang>` - Start a war between two gangs
- `/endwar` - End the current war
- `/gangstats <gang_id>` - View gang statistics
- `/warstatus` - View current war status

### Player Commands

- `/gangwar` - Open the gangwar UI
- `/gangwarclose` - Close the UI

## API/Exports

Use these exports from other resources:

```lua
-- Start a war
exports.gangwar:startWar('grove', 'ballas')

-- End current war
exports.gangwar:endWar()

-- Add kill to player stats
exports.gangwar:addKill(victimId, killerId)

-- Capture territory
exports.gangwar:captureTerritory('grove', 1)

-- Get gang stats
local stats = exports.gangwar:getGangStats('grove')

-- Get war status
local war = exports.gangwar:getWarStatus()

-- Get player stats
local playerStats = exports.gangwar:getPlayerStats(playerId)

-- Get all territories
local territories = exports.gangwar:getAllTerritories()
```

## Events

Listen for these events:

```lua
-- War started
AddEventHandler('gangwar:warStarted', function(warId, attacker, defender)
    print(attacker .. ' started war with ' .. defender)
end)

-- War ended
AddEventHandler('gangwar:warEnded', function(winner)
    print(winner .. ' won the war!')
end)

-- Territory captured
AddEventHandler('gangwar:territoryCaptured', function(gangId, territoryId)
    print(gangId .. ' captured territory ' .. territoryId)
end)

-- Player killed
AddEventHandler('gangwar:playerKilled', function(victimId, killerId)
    print('Player ' .. victimId .. ' killed by ' .. killerId)
end)
```

## Database Schema

Optional SQL schema for persistent storage:

```sql
CREATE TABLE gangwar_wars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    attacker_gang VARCHAR(50) NOT NULL,
    defender_gang VARCHAR(50) NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    winner VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE gangwar_territories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    zone VARCHAR(50),
    owner VARCHAR(50),
    captured_at TIMESTAMP,
    INDEX idx_owner (owner)
);

CREATE TABLE gangwar_stats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    gang_id VARCHAR(50),
    kills INT DEFAULT 0,
    deaths INT DEFAULT 0,
    territories_captured INT DEFAULT 0,
    UNIQUE KEY player_gang (player_id, gang_id)
);
```

## Project Structure

```
gangwar-system/
├── web/                          # React frontend
│   ├── src/
│   │   ├── components/          # React components
│   │   ├── hooks/               # Custom hooks (useNUI, etc)
│   │   ├── types/               # TypeScript types
│   │   ├── styles/              # CSS styles
│   │   ├── App.tsx              # Main app component
│   │   └── main.tsx             # Entry point
│   ├── index.html               # HTML template
│   ├── vite.config.ts           # Vite config
│   ├── tsconfig.json            # TypeScript config
│   └── package.json             # Dependencies
├── server/                       # Server-side Lua
│   ├── main.lua                 # Main server file
│   ├── functions.lua            # War logic functions
│   ├── database.lua             # Database helpers
│   ├── commands.lua             # Admin commands
│   └── exports.lua              # Exports for other resources
├── client/                       # Client-side Lua
│   ├── main.lua                 # Main client file
│   ├── functions.lua            # Client functions
│   └── nui.lua                  # NUI callbacks
├── shared/                       # Shared files
│   ├── config.lua               # Configuration
│   └── locales.lua              # Translations
├── fxmanifest.lua               # FiveM manifest
├── README.md                     # This file
└── .gitignore                    # Git ignore rules
```

## Customization

### Adding Gangs

Edit `shared/config.lua`:

```lua
Config.Gangs = {
    ['mygang'] = {
        name = 'My Gang',
        color = {r = 255, g = 0, b = 0},
        label = 'MG',
        headquarters = vector3(100, 100, 100),
    },
}
```

### Adding Territories

```lua
Config.Territories = {
    {
        id = 4,
        name = 'New Territory',
        zone = 'ZONE',
        coords = vector3(100, 100, 100),
        radius = 50.0,
        owner = nil,
        captureTime = 300,
    },
}
```

### Changing UI Colors

Edit `web/src/styles/app.css` and update the gradient colors:

```css
background: linear-gradient(45deg, #00d4ff, #7b2ff7);
```

## Troubleshooting

### NUI not showing
- Ensure `ui_page` is set correctly in `fxmanifest.lua`
- Check that web files are built: `npm run build`
- Verify resource is started: `start gangwar-system`

### Commands not working
- Ensure you have admin rights
- Check server console for errors
- Verify resource is running

### Database errors
- Check MySQL connection
- Ensure tables are created
- Verify SQL syntax for your database system

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## License

MIT License - Feel free to use and modify as needed.

## Credits

Built with:
- React 18+
- TypeScript
- Vite
- FiveM
- Lua

---

**Made with ❤️ for the FiveM community**
