import { WarData } from '../types'

interface Props {
  war: WarData | null
}

export default function WarStatus({ war }: Props) {
  if (!war || war.status === 'idle') {
    return (
      <div className="war-status idle">
        <h2>No War in Progress</h2>
        <p>Waiting for a war to start...</p>
      </div>
    )
  }

  return (
    <div className="war-status active">
      <div className="war-header">
        <h2>Active War</h2>
        <span className="status-badge">Active</span>
      </div>

      <div className="gangs-container">
        <div className="gang attacker">
          <h3>{war.attacker}</h3>
          <p className="kills">Kills: {war.kills[war.attacker] || 0}</p>
        </div>

        <div className="vs">VS</div>

        <div className="gang defender">
          <h3>{war.defender}</h3>
          <p className="kills">Kills: {war.kills[war.defender] || 0}</p>
        </div>
      </div>

      <div className="war-info">
        <div className="info-item">
          <label>Duration:</label>
          <span>{Math.floor((Date.now() - war.startTime * 1000) / 1000)} seconds</span>
        </div>
        <div className="info-item">
          <label>Territories:</label>
          <span>
            {war.territories[war.attacker] || 0} vs {war.territories[war.defender] || 0}
          </span>
        </div>
      </div>
    </div>
  )
}
