import { useState, useEffect } from 'react'

interface WarData {
  id: string
  attacker: string
  defender: string
  status: string
  startTime: number
  kills: Record<string, number>
  territories: Record<string, number>
}

interface PlayerStats {
  [key: string]: {
    kills: number
    deaths: number
    territories: number
  }
}

export function useNUI() {
  const [warData, setWarData] = useState<WarData | null>(null)
  const [playerStats, setPlayerStats] = useState<PlayerStats>({})
  const [isAdmin, setIsAdmin] = useState(false)

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data

      if (data.type === 'warUpdate') {
        setWarData(data.data.war)
      } else if (data.type === 'statsUpdate') {
        setPlayerStats(data.data)
      } else if (data.type === 'adminStatus') {
        setIsAdmin(data.data.isAdmin)
      }
    }

    window.addEventListener('message', handleMessage)

    return () => {
      window.removeEventListener('message', handleMessage)
    }
  }, [])

  const callNUI = async (action: string, data: any) => {
    try {
      const response = await fetch(`https://fivem-gangwar/${action}`, {
        method: 'POST',
        body: JSON.stringify(data),
      })
      return await response.json()
    } catch (error) {
      console.error(`Error calling NUI action ${action}:`, error)
      return null
    }
  }

  return {
    warData,
    playerStats,
    isAdmin,
    callNUI,
  }
}
