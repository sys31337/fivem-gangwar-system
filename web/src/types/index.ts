export interface WarData {
  id: string
  attacker: string
  defender: string
  status: string
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

export interface Gang {
  name: string
  color: {
    r: number
    g: number
    b: number
  }
  label: string
  headquarters: {
    x: number
    y: number
    z: number
  }
}
