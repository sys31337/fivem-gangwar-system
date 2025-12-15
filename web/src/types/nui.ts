export interface NUIMessage {
  type: string
  data?: any
}

export interface NUICallback {
  success: boolean
  message?: string
  data?: any
}

export interface WarData {
  id: string
  attacker: string
  defender: string
  status: 'idle' | 'active' | 'ended'
  startTime: number
  kills: Record<string, number>
  territories: Record<string, number>
}

export interface PlayerStats {
  [key: string]: {
    kills: number
    deaths: number
    territories: number
  }
}

export interface Territory {
  id: number
  name: string
  zone: string
  coords: {
    x: number
    y: number
    z: number
  }
  radius: number
  owner: string | null
  captureTime: number
}
