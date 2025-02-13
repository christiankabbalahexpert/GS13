/datum/round_event_control/heart_attack
	name = "Random Heart Attack"
	typepath = /datum/round_event/heart_attack
	weight = 20
	max_occurrences = 0
	min_players = 400 // To avoid shafting lowpop

	// Made the event impossible to come across to bolster server's RP quality a bit - GLDW

/datum/round_event/heart_attack/start()
	var/list/heart_attack_contestants = list()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.player_list))
		if(!H.client || H.z != SSmapping.station_start || H.stat == DEAD || H.InCritical() || !H.can_heartattack() || H.has_status_effect(STATUS_EFFECT_EXERCISED) || (/datum/disease/heart_failure in H.diseases) || H.undergoing_cardiac_arrest() || HAS_TRAIT(H,TRAIT_EXEMPT_HEALTH_EVENTS))
			continue
		if(H.satiety <= -60) //Multiple junk food items recently
			heart_attack_contestants[H] = 3
		else
			heart_attack_contestants[H] = 1

	if(LAZYLEN(heart_attack_contestants))
		var/mob/living/carbon/human/winner = pickweight(heart_attack_contestants)
		var/datum/disease/D = new /datum/disease/heart_failure()
		winner.ForceContractDisease(D, FALSE, TRUE)
		notify_ghosts("[winner] is beginning to have a heart attack!", enter_link="<a href=?src=[REF(src)];orbit=1>(Click to orbit)</a>", source=winner, action=NOTIFY_ORBIT)
