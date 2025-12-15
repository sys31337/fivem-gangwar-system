Locales = {}

Locales['en'] = {
    -- War Messages
    war_started = 'War started between %s and %s!',
    war_ended = 'War ended! %s won the battle.',
    war_cancelled = 'War cancelled due to insufficient players.',
    
    -- Territory Messages
    territory_captured = '%s captured %s territory!',
    territory_lost = '%s lost %s territory!',
    territory_capturing = 'Capturing territory...',
    
    -- Kill Messages
    player_killed = '%s was killed by %s',
    kill_reward = '+$%s for kill',
    death_penalty = '-$%s for death',
    
    -- Notifications
    joined_war = 'You joined the war!',
    left_war = 'You left the war!',
    not_in_gang = 'You must be in a gang to participate.',
    already_in_war = 'War already in progress.',
    
    -- Commands
    cmd_start_war = 'Start a war between two gangs',
    cmd_end_war = 'End current war',
    cmd_add_kill = 'Add a kill to player stats',
    cmd_gang_stats = 'View gang statistics',
}

Locales['es'] = {
    war_started = '¡Guerra iniciada entre %s y %s!',
    war_ended = '¡Guerra terminada! %s ganó la batalla.',
    territory_captured = '%s capturó el territorio de %s!',
    player_killed = '%s fue asesinado por %s',
}

Locales['fr'] = {
    war_started = 'Guerre démarrée entre %s et %s!',
    war_ended = 'Guerre terminée! %s a remporté la bataille.',
    territory_captured = '%s a capturé le territoire de %s!',
}

return Locales
