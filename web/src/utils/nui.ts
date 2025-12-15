export async function fetchNUI(eventName: string, data: any = {}): Promise<any> {
  try {
    const resourceName = 'fivem-gangwar-system'
    const response = await fetch(`https://${resourceName}/${eventName}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    })
    
    if (!response.ok) {
      throw new Error(`NUI call failed: ${response.statusText}`)
    }
    
    const result = await response.json()
    return result
  } catch (error) {
    console.error(`Error calling NUI event ${eventName}:`, error)
    return { success: false, error: error instanceof Error ? error.message : 'Unknown error' }
  }
}

export function useNUIListener(eventName: string, callback: (data: any) => void) {
  const handleMessage = (event: MessageEvent) => {
    const data = event.data
    if (data.type === eventName) {
      callback(data.data)
    }
  }

  window.addEventListener('message', handleMessage)

  return () => {
    window.removeEventListener('message', handleMessage)
  }
}
