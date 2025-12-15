import { useState, useEffect } from 'react'
import { useNUI } from './hooks/useNUI'
import WarStatus from './components/WarStatus'
import TeamStats from './components/TeamStats'
import TerritoryMap from './components/TerritoryMap'
import AdminPanel from './components/AdminPanel'
import './styles/app.css'

type TabType = 'war' | 'stats' | 'territories' | 'admin'

function App() {
  const [activeTab, setActiveTab] = useState<TabType>('war')
  const { warData, playerStats, isAdmin } = useNUI()

  return (
    <div className="app-container">
      <div className="header">
        <h1>🎮 Gangwar System</h1>
        <button className="close-btn" onClick={() => (window as any).invokeNative('closeUI', {})}>
          ✕
        </button>
      </div>

      <div className="tabs">
        <button
          className={`tab ${activeTab === 'war' ? 'active' : ''}`}
          onClick={() => setActiveTab('war')}
        >
          War Status
        </button>
        <button
          className={`tab ${activeTab === 'stats' ? 'active' : ''}`}
          onClick={() => setActiveTab('stats')}
        >
          Statistics
        </button>
        <button
          className={`tab ${activeTab === 'territories' ? 'active' : ''}`}
          onClick={() => setActiveTab('territories')}
        >
          Territories
        </button>
        {isAdmin && (
          <button
            className={`tab ${activeTab === 'admin' ? 'active' : ''}`}
            onClick={() => setActiveTab('admin')}
          >
            Admin
          </button>
        )}
      </div>

      <div className="content">
        {activeTab === 'war' && <WarStatus war={warData} />}
        {activeTab === 'stats' && <TeamStats stats={playerStats} />}
        {activeTab === 'territories' && <TerritoryMap territories={warData?.territories} />}
        {activeTab === 'admin' && isAdmin && <AdminPanel />}
      </div>
    </div>
  )
}

export default App
