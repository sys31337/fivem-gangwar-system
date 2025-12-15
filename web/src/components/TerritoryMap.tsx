import { Territory } from '../types'

interface Props {
  territories: Territory[] | undefined
}

export default function TerritoryMap({ territories }: Props) {
  return (
    <div className="territory-map">
      <h2>Territory Control</h2>
      {territories && territories.length > 0 ? (
        <div className="territories-grid">
          {territories.map((territory) => (
            <div key={territory.id} className="territory-card">
              <h3>{territory.name}</h3>
              <p className="zone">Zone: {territory.zone}</p>
              <p className="owner">Owner: {territory.owner || 'Unclaimed'}</p>
              <div className="territory-stats">
                <span className="capture-time">Capture Time: {territory.captureTime}s</span>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p>No territories available</p>
      )}
    </div>
  )
}
