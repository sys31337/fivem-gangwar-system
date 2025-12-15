import { useState } from 'react'
import { useNUI } from '../hooks/useNUI'

export default function AdminPanel() {
  const { callNUI } = useNUI()
  const [attacker, setAttacker] = useState('')
  const [defender, setDefender] = useState('')
  const [loading, setLoading] = useState(false)

  const handleStartWar = async () => {
    if (!attacker || !defender) {
      alert('Please select both gangs')
      return
    }

    setLoading(true)
    const result = await callNUI('startWar', { attacker, defender })
    if (result?.success) {
      alert('War started!')
      setAttacker('')
      setDefender('')
    } else {
      alert(`Error: ${result?.message || 'Unknown error'}`)
    }
    setLoading(false)
  }

  const handleEndWar = async () => {
    setLoading(true)
    const result = await callNUI('endWar', {})
    if (result?.success) {
      alert('War ended!')
    } else {
      alert(`Error: ${result?.message || 'Unknown error'}`)
    }
    setLoading(false)
  }

  return (
    <div className="admin-panel">
      <h2>Admin Controls</h2>

      <div className="admin-section">
        <h3>Start War</h3>
        <div className="form-group">
          <label>Attacker Gang</label>
          <input
            type="text"
            value={attacker}
            onChange={(e) => setAttacker(e.target.value)}
            placeholder="e.g., grove"
          />
        </div>
        <div className="form-group">
          <label>Defender Gang</label>
          <input
            type="text"
            value={defender}
            onChange={(e) => setDefender(e.target.value)}
            placeholder="e.g., ballas"
          />
        </div>
        <button onClick={handleStartWar} disabled={loading} className="btn-primary">
          {loading ? 'Starting...' : 'Start War'}
        </button>
      </div>

      <div className="admin-section">
        <h3>End War</h3>
        <button onClick={handleEndWar} disabled={loading} className="btn-danger">
          {loading ? 'Ending...' : 'End War'}
        </button>
      </div>
    </div>
  )
}
