import { PlayerStats } from '../types'

interface Props {
  stats: PlayerStats
}

export default function TeamStats({ stats }: Props) {
  const sortedStats = Object.entries(stats)
    .sort(([, a], [, b]) => b.kills - a.kills)
    .slice(0, 10)

  return (
    <div className="team-stats">
      <h2>Player Statistics</h2>
      <table>
        <thead>
          <tr>
            <th>Rank</th>
            <th>Player</th>
            <th>Kills</th>
            <th>Deaths</th>
            <th>K/D Ratio</th>
            <th>Territories</th>
          </tr>
        </thead>
        <tbody>
          {sortedStats.map(([playerId, stat], index) => (
            <tr key={playerId}>
              <td className="rank">#{index + 1}</td>
              <td>{playerId}</td>
              <td className="kills">{stat.kills}</td>
              <td className="deaths">{stat.deaths}</td>
              <td className="kd-ratio">
                {(stat.kills / Math.max(stat.deaths, 1)).toFixed(2)}
              </td>
              <td>{stat.territories}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
