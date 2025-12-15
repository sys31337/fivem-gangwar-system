# FiveM Gangwar System - Architecture

## Communication Flow

This document explains how the frontend, client, and server communicate.

### 🏗️ Architecture Overview

```
┌─────────────────────┐
│  React Frontend     │  (Browser / NUI)
│   (web/src/*)       │
└──────────┬──────────┘
           │ RegisterNuiCallback
           │ (Client-side only)
           ↓
┌─────────────────────┐
│  Client Scripts     │  (client/*.lua)
│  - main.lua         │  Handles NUI callbacks
│  - nui.lua          │  Triggers server events
│  - events.lua       │
└──────────┬──────────┘
           │ TriggerServerEvent
           │
           ↓
┌─────────────────────┐
│  Server Scripts     │  (server/*.lua)
│  - main.lua         │  Handles events
│  - functions.lua    │  Game logic
│  - database.lua     │  Database queries
│  - commands.lua     │  Admin commands
└──────────┬──────────┘
           │ TriggerClientEvent / BroadcastWarUpdate
           │
           ↓
┌─────────────────────┐
│  Client Scripts     │  Receives updates
│  (events.lua)       │  from server
└──────────┬──────────┘
           │ SendNuiMessage
           │
           ↓
┌─────────────────────┐
│  React Frontend     │  Updates UI
└─────────────────────┘
```

## Data Flow Examples

### Example 1: Starting a War

**User Action:**
```
1. User clicks "Start War" in React UI
2. React calls: fetchNUI('startWar', { attacker: 'grove', defender: 'ballas' })
```

**Client Script (client/nui.lua):**
```lua
RegisterNuiCallback('startWar', function(data, cb)
    TriggerServerEvent('gangwar:server:startWar', data.attacker, data.defender)
    cb({success = true})
end)
```

**Server Script (server/main.lua):**
```lua
AddEventHandler('gangwar:server:startWar', function(attacker, defender)
    local result = StartWar(attacker, defender)  -- server/functions.lua
    TriggerClientEvent('gangwar:client:warStarted', source, result)
    BroadcastWarUpdate()  -- Send to ALL clients
end)
```

**Back to Client (client/events.lua):**
```lua
AddEventHandler('gangwar:updateWar', function(warData)
    SendNuiMessage(json.encode({
        type = 'warUpdate',
        data = warData,
    }))
end)
```

**React Updates:**
```javascript
const handleMessage = (event: MessageEvent) => {
    const data = event.data
    if (data.type === 'warUpdate') {
        setWarData(data.data.war)  // Update UI
    }
}
```

---

## Critical Rules

### ✅ DO
- Use `RegisterNuiCallback` in **CLIENT scripts ONLY**
- Use `TriggerServerEvent` from client to call server
- Use `TriggerClientEvent` from server to call client
- Use `SendNuiMessage` from client to send data to React
- Export functions from server using `Exports('name', function)`

### ❌ DON'T
- ❌ Use `RegisterNuiCallback` in server scripts
- ❌ Use `SendNuiMessage` in server scripts
- ❌ Use `TriggerClientEvent` without specifying player ID or -1
- ❌ Call `fetchNUI()` from server (it doesn't exist there)
- ❌ Use `require()` for shared files (use shared_scripts in fxmanifest)

---

## File Responsibilities

### Server Files (server/)

| File | Purpose |
|------|----------|
| `main.lua` | Server initialization, event handlers, broadcasts |
| `functions.lua` | Core game logic (StartWar, EndWar, etc) |
| `database.lua` | Database operations (create tables, save data) |
| `commands.lua` | Admin commands (/startwar, /endwar, etc) |
| `exports.lua` | Exports for other resources |
| `events.lua` | Server event handlers |

### Client Files (client/)

| File | Purpose |
|------|----------|
| `main.lua` | Client initialization, player setup |
| `nui.lua` | **RegisterNuiCallback** - React callbacks |
| `functions.lua` | Helper functions, drawing, zones |
| `events.lua` | Server event listeners, UI updates |

### Shared Files (shared/)

| File | Purpose |
|------|----------|
| `config.lua` | Configuration (gangs, territories, settings) |
| `locales.lua` | Language strings (EN, ES, FR) |

### Frontend Files (web/src/)

| File | Purpose |
|------|----------|
| `main.tsx` | React entry point |
| `App.tsx` | Main component, tabs |
| `hooks/useNUI.ts` | Custom hook for NUI communication |
| `components/*.tsx` | UI components |
| `utils/nui.ts` | NUI fetch helper |

---

## Event Names

### Server Events (Client → Server)
These are triggered FROM the client and listened TO by the server.

```lua
TriggerServerEvent('gangwar:server:startWar', attacker, defender)
TriggerServerEvent('gangwar:server:endWar')
TriggerServerEvent('gangwar:server:captureTerritory', gangId, territoryId)
TriggerServerEvent('gangwar:server:updatePlayerStats', playerId, kills, deaths)
```

### Client Events (Server → Client)
These are triggered FROM the server and listened TO by the client.

```lua
TriggerClientEvent('gangwar:client:warStarted', -1, warData)
TriggerClientEvent('gangwar:client:warEnded', -1, winner)
TriggerClientEvent('gangwar:updateWar', -1, warData)  -- Broadcast
TriggerClientEvent('gangwar:updateStats', -1, playerStats)  -- Broadcast
TriggerClientEvent('gangwar:territoryCaptured', -1, gangId, territoryId)
```

### NUI Callbacks
These are RegisterNuiCallback in CLIENT scripts, called FROM React frontend.

```javascript
fetchNUI('startWar', { attacker, defender })
fetchNUI('endWar', {})
fetchNUI('captureTerritory', { gangId, territoryId })
fetchNUI('getStats', {})
fetchNUI('closeUI', {})
```

---

## Adding New Features

### To add a new action (e.g., "claimTerritory"):

**1. Add NUI Callback in client/nui.lua:**
```lua
RegisterNuiCallback('claimTerritory', function(data, cb)
    TriggerServerEvent('gangwar:server:claimTerritory', data.territoryId)
    cb({success = true})
end)
```

**2. Add Server Event Handler in server/main.lua:**
```lua
AddEventHandler('gangwar:server:claimTerritory', function(territoryId)
    local result = ClaimTerritory(territoryId)
    BroadcastWarUpdate()
end)
```

**3. Add Logic in server/functions.lua:**
```lua
function ClaimTerritory(territoryId)
    -- Your logic here
    return {success = true}
end)
```

**4. Call from React:**
```javascript
const claimTerritory = async (id) => {
    const result = await fetchNUI('claimTerritory', { territoryId: id })
}
```

---

## Debugging

### Server Console Logs
```lua
print('^2[Gangwar] Starting war^7')     -- Green
print('^3[Gangwar] Warning message^3')  -- Yellow
print('^1[Gangwar] Error message^7')    -- Red
```

### Client Console Logs
```lua
print('[Gangwar] Client message')  -- For development
```

### React Console Logs
```javascript
console.log('[Gangwar NUI]', data)  // Browser console
```

### Check Events
```lua
-- In server console
jsontxt AddEventHandler('gangwar:test', function(data)
    print(json.encode(data))
end)
```

---

## Performance Tips

1. **Use BroadcastWarUpdate() sparingly** - Broadcasting to all clients costs performance
2. **Use TriggerClientEvent with specific player ID when possible** instead of -1
3. **Cache data** in Lua variables, don't query database every tick
4. **Use database.lua helpers** for async database queries
5. **Debounce React events** - don't trigger updates too frequently

---

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `RegisterNuiCallback does not exist` | Used in server script | Move to client/nui.lua |
| `Module 'shared.config' not found` | Using require() | Use shared_scripts in fxmanifest |
| `attempt to call nil value` | Function not defined | Check function is in correct file |
| `No such export` | Export name wrong | Check Exports() in server/exports.lua |

---

For more details, see README.md and SETUP.md
