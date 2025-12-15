# FiveM Gangwar System - Setup Guide

## ⚙️ Requirements

### Must Have:
- **FiveM Server** (Latest version)
- **Node.js 16+** (For building the React frontend)
- **One of the following database resources:**
  - `oxmysql` (Recommended - Modern)
  - `mysql-async` (Legacy)
  - `qb-core` (QBCore framework)

### Optional:
- Git (For cloning the repository)
- VSCode (For editing)

## 🚀 Installation Steps

### Step 1: Clone or Download

```bash
# Using Git
git clone https://github.com/sys31337/fivem-gangwar-system.git

# OR manually download and extract to your resources folder
```

Place the folder in: `your-server/resources/fivem-gangwar-system/`

### Step 2: Install Dependencies

```bash
cd fivem-gangwar-system/web
npm install
```

### Step 3: Build the React Frontend

```bash
# One-time build for production
npm run build

# OR for development with hot-reload
npm run dev
```

### Step 4: Add to server.cfg

Add this line to your `server.cfg`:

```
ensure fivem-gangwar-system
```

### Step 5: Configure Your Framework

The system auto-detects your database:

**If using oxmysql:**
```cfg
ensure oxmysql
ensure fivem-gangwar-system
```

**If using mysql-async:**
```cfg
ensure mysql-async
ensure fivem-gangwar-system
```

**If using QBCore:**
```cfg
ensure qb-core
ensure fivem-gangwar-system
```

### Step 6: Start Your Server

```
fx_setIterationMode always -- optional, for performance
start fivem-gangwar-system
```

## ✅ Verification

Check your server console for:

```
[Gangwar System] Server started successfully
[Gangwar] Using oxmysql (or your database)
[Gangwar] Database tables initialized
```

## 🎮 Testing

1. **Connect to your server**
2. **Open the UI:**
   ```
   /gangwar
   ```
3. **Start a war (admin only):**
   ```
   /startwar grove ballas
   ```
4. **Check status:**
   ```
   /warstatus
   ```

## 🛠️ Common Issues & Fixes

### Issue 1: "No such export execute in resource mysql-async"

**Cause:** You're using `mysql-async` but the resource isn't started.

**Solution:**
```cfg
# Add to server.cfg BEFORE gangwar-system
ensure mysql-async
ensure fivem-gangwar-system
```

### Issue 2: "Module 'shared.config' not found"

**Cause:** The fxmanifest.lua isn't loading shared scripts correctly.

**Solution:**
- ✅ Already fixed! Re-download the latest version from GitHub
- Make sure `shared/config.lua` exists in your resource folder
- Check that `fxmanifest.lua` includes `shared_scripts`

### Issue 3: "NUI is not showing"

**Cause:** React frontend not built or UI page not set.

**Solution:**
```bash
# Rebuild the frontend
cd web
npm run build
```

Then restart your server:
```
restart fivem-gangwar-system
```

### Issue 4: "Web files are 404"

**Cause:** dist folder not created or vite config issue.

**Solution:**
```bash
cd web
rm -rf dist node_modules  # Delete old files
npm install               # Fresh install
npm run build             # Rebuild
```

### Issue 5: Database errors in console

**Cause:** Database resource not started or incorrect SQL syntax.

**Solution:**
1. Make sure oxmysql or mysql-async is running
2. Check your `my.cnf` or hosting database settings
3. The system will warn you if no database is available and run in standalone mode

## 📋 Configuration

### Customize Gangs

Edit `shared/config.lua`:

```lua
Config.Gangs = {
    ['grove'] = {
        name = 'Grove Street Family',
        color = {r = 0, g = 200, b = 100},
        label = 'GSF',
        headquarters = vector3(100, 200, 30),
    },
    ['mygang'] = {
        name = 'My New Gang',
        color = {r = 255, g = 0, b = 0},
        label = 'MG',
        headquarters = vector3(500, 500, 30),
    },
}
```

### Add Territories

```lua
Config.Territories = {
    {
        id = 1,
        name = 'Downtown',
        zone = 'DOWNTOWN',
        coords = vector3(200, 200, 30),
        radius = 50.0,
        owner = nil,
        captureTime = 300,  -- 5 minutes
    },
}
```

### Adjust War Settings

```lua
Config.War = {
    minPlayersRequired = 2,
    maxDuration = 3600,      -- 1 hour
    rewardMultiplier = 2.0,
    killReward = 500,
    deathPenalty = 100,
    captureReward = 2000,
}
```

## 🔧 Development Mode

For development with hot-reload:

```bash
cd web
npm run dev
```

This starts a Vite dev server with hot-reload. The NUI will update automatically when you edit files.

**Note:** Make sure your FiveM server is running locally for NUI to connect.

## 🏗️ Building for Production

```bash
cd web
npm run build
```

This creates optimized files in the `dist` folder.

## 📦 File Structure

```
fivem-gangwar-system/
├── server/
│   ├── main.lua          # Server entry point
│   ├── functions.lua     # Core war logic
│   ├── database.lua      # Database layer
│   ├── commands.lua      # Admin commands
│   ├── exports.lua       # Export functions
│   └── events.lua        # Event handlers
├── client/
│   ├── main.lua          # Client entry point
│   ├── functions.lua     # Helper functions
│   ├── nui.lua           # NUI callbacks
│   └── events.lua        # Event listeners
├── shared/
│   ├── config.lua        # Configuration
│   └── locales.lua       # Translations
├── web/
│   ├── src/
│   │   ├── components/   # React components
│   │   ├── hooks/        # Custom hooks
│   │   ├── types/        # TypeScript types
│   │   ├── utils/        # Utilities
│   │   ├── styles/       # CSS
│   │   ├── App.tsx       # Main component
│   │   └── main.tsx      # Entry point
│   ├── dist/             # Built files (production)
│   ├── index.html        # HTML template
│   ├── vite.config.ts    # Vite config
│   ├── tsconfig.json     # TypeScript config
│   └── package.json      # Dependencies
├── fxmanifest.lua        # FiveM manifest
├── README.md             # Documentation
├── SETUP.md              # This file
└── .gitignore            # Git ignore
```

## 🚨 Troubleshooting Checklist

- [ ] Node.js 16+ installed (`node --version`)
- [ ] Dependencies installed (`npm install`)
- [ ] Frontend built (`npm run build`)
- [ ] Database resource running (oxmysql/mysql-async/qb-core)
- [ ] Resource in server.cfg
- [ ] Server config points to correct paths
- [ ] `shared/config.lua` exists
- [ ] `web/dist/` folder exists and has files
- [ ] Console shows no red errors
- [ ] `/gangwar` command works

## 📞 Support

If you're still having issues:

1. Check the console for **red errors** (not yellow warnings)
2. Make sure your **database resource is running**
3. Try **restarting the resource**: `restart fivem-gangwar-system`
4. Check that **all files are in the correct folders**
5. Open an **issue on GitHub** with your error messages

## 🎓 Next Steps

1. ✅ Install the system (you are here)
2. ✅ Configure gangs and territories (`shared/config.lua`)
3. ✅ Customize UI colors (`web/src/styles/app.css`)
4. ✅ Add custom logic (`server/functions.lua`)
5. ✅ Deploy to production

## 📚 Additional Resources

- [FiveM Documentation](https://docs.fivem.net/)
- [React Documentation](https://react.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Vite Documentation](https://vitejs.dev/)

---

**Happy coding! 🚀**
