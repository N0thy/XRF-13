
// All reagents related to medicine

/datum/reagent/medicine
	name = "Medicine"
	taste_description = "bitterness"
	reagent_state = LIQUID
	taste_description = "bitterness"

/datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = REAGENTS_OVERDOSE*2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL*2
	scannable = TRUE
	trait_flags = TACHYCARDIC

/datum/reagent/medicine/inaprovaline/on_mob_life(mob/living/L, metabolism)
	L.reagent_shock_modifier += PAIN_REDUCTION_LIGHT
	if(metabolism & IS_VOX)
		L.adjustToxLoss(REAGENTS_METABOLISM)
	else if(iscarbon(L))
		var/mob/living/carbon/C = L
		if(C.losebreath > 10)
			C.set_Losebreath(10)
	return ..()

/datum/reagent/medicine/inaprovaline/overdose_process(mob/living/L, metabolism)
	L.jitter(5) //Overdose causes a spasm
	L.Unconscious(40 SECONDS)

/datum/reagent/medicine/inaprovaline/overdose_crit_process(mob/living/L, metabolism)
	L.setDrowsyness(L.drowsyness, 20)
	if(ishuman(L)) //Critical overdose causes total blackout and heart damage. Too much stimulant
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		E.take_damage(0.5*effect_str, TRUE)
	if(prob(10))
		L.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/medicine/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn is a long-duration shield against toxic chemicals."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = TRUE
	custom_metabolism = REAGENTS_METABOLISM * 0.125
	purge_list = list(/datum/reagent/toxin)
	purge_rate = 5
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/medicine/ryetalyn/on_mob_life(mob/living/L, metabolism)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.disabilities = 0
	return ..()

/datum/reagent/medicine/ryetalyn/overdose_process(mob/living/L, metabolism)
	L.Confused(40 SECONDS)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/ryetalyn/overdose_crit_process(mob/living/L, metabolism)
	if(prob(15))
		L.Unconscious(30 SECONDS)
	L.apply_damage(3*effect_str, CLONE)

/datum/reagent/medicine/paracetamol
	name = "Paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller, good for enduring heavy labor."
	color = "#C855DC"
	scannable = TRUE
	custom_metabolism = REAGENTS_METABOLISM * 0.125
	purge_list = list(/datum/reagent/medicine/kelotane, /datum/reagent/medicine/tricordrazine, /datum/reagent/medicine/bicaridine)
	purge_rate = 1
	overdose_threshold = REAGENTS_OVERDOSE*2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL*2

/datum/reagent/medicine/paracetamol/on_mob_life(mob/living/L, metabolism)
	L.reagent_pain_modifier += PAIN_REDUCTION_HEAVY
	L.heal_limb_damage(0.2*effect_str, 0.2*effect_str)
	L.adjustToxLoss(-0.1*effect_str)
	L.adjustStaminaLoss(-effect_str)
	return ..()

/datum/reagent/paracetamol/overdose_process(mob/living/L, metabolism)
	L.hallucination = max(L.hallucination, 2)
	L.reagent_pain_modifier += PAIN_REDUCTION_VERY_LIGHT
	L.apply_damage(0.5*effect_str, TOX)

/datum/reagent/paracetamol/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(3*effect_str, TOX)

/datum/reagent/medicine/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller."
	color = "#C8A5DC"
	scannable = TRUE
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/medicine/tramadol/on_mob_life(mob/living/L)
	L.reagent_pain_modifier += PAIN_REDUCTION_VERY_HEAVY
	if(volume > 20)
		L.reagent_pain_modifier += PAIN_REDUCTION_LIGHT
		L.apply_damage(0.25*effect_str, TOX)
	return ..()

/datum/reagent/medicine/tramadol/overdose_process(mob/living/L, metabolism)
	L.hallucination = max(L.hallucination, 2) //Hallucinations and oxy damage
	L.apply_damage(effect_str, OXY)

/datum/reagent/medicine/tramadol/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(3*effect_str, TOX)

/datum/reagent/medicine/oxycodone
	name = "Oxycodone"
	description = "An effective and very addictive painkiller."
	color = "#C805DC"
	custom_metabolism = REAGENTS_METABOLISM * 1.25
	overdose_threshold = REAGENTS_OVERDOSE * 0.5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL * 0.5
	scannable = TRUE

/datum/reagent/medicine/oxycodone/on_mob_add(mob/living/L, metabolism)
	L.adjustStaminaLoss(-20*effect_str)
	to_chat(L, "<span class='userdanger'>You feel a burst of energy revitalize you all of a sudden! You can do anything!</span>")

/datum/reagent/medicine/oxycodone/on_mob_life(mob/living/L, metabolism)
	L.reagent_pain_modifier += PAIN_REDUCTION_FULL
	L.apply_damage(0.2*effect_str, TOX)
	return ..()

/datum/reagent/medicine/oxycodone/overdose_process(mob/living/L, metabolism)
	L.hallucination = max(L.hallucination, 3)
	L.set_drugginess(10)
	L.jitter(3)

/datum/reagent/medicine/oxycodone/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(3*effect_str, TOX)
	L.reagent_pain_modifier += PAIN_REDUCTION_FULL
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.take_damage(3*effect_str, TRUE)

/datum/reagent/medicine/oxycodone/on_mob_delete(mob/living/L, metabolism)
	to_chat(L, "<span class='userdanger'>The room spins slightly as you start to come down off your painkillers!</span>")
	addtimer(CALLBACK(L, /mob/living.proc/Paralyze, 3), 10 SECONDS)

/datum/reagent/medicine/hydrocodone
	name = "Hydrocodone"
	description = "An effective but very short lasting painkiller only made by autodocs."
	color = "#C805DC"
	custom_metabolism = REAGENTS_METABOLISM * 2
	overdose_threshold = REAGENTS_OVERDOSE*0.6 //You aren't using this out of combat. And only the B18 makes it.
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL*0.5
	scannable = TRUE

/datum/reagent/medicine/hydrocodone/on_mob_life(mob/living/L, metabolism)
	L.reagent_pain_modifier += PAIN_REDUCTION_FULL
	return ..()

/datum/reagent/medicine/hydrocodone/overdose_process(mob/living/L, metabolism)
	L.adjustToxLoss(2.5*effect_str, TRUE)

/datum/reagent/medicine/hydrocodone/overdose_crit_process(mob/living/L, metabolism)
	L.adjustBrainLoss(1.5*effect_str, TRUE)

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = TRUE
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/medicine/leporazine/on_mob_life(mob/living/L, metabolism)
	var/target_temp = L.get_standard_bodytemperature()
	if(L.bodytemperature > target_temp)
		L.adjust_bodytemperature(-40*TEMPERATURE_DAMAGE_COEFFICIENT*effect_str, target_temp)
	else if(L.bodytemperature < target_temp + 1)
		L.adjust_bodytemperature(40*TEMPERATURE_DAMAGE_COEFFICIENT*effect_str, 0, target_temp)
	return ..()

/datum/reagent/medicine/leporazine/overdose_process(mob/living/L, metabolism)
	if(prob(10))
		L.Unconscious(5 SECONDS)

/datum/reagent/medicine/leporazine/overdose_crit_process(mob/living/L, metabolism)
	L.drowsyness  = max(L.drowsyness, 30)

/datum/reagent/medicine/kelotane
	name = "Kelotane"
	description = "Kelotane is a drug used to treat burns."
	color = "#D8C58C"
	scannable = TRUE
	purge_list = list(/datum/reagent/medicine/ryetalyn)
	purge_rate = 1
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/medicine/kelotane/on_mob_life(mob/living/L, metabolism)
	var/target_temp = L.get_standard_bodytemperature()
	L.heal_limb_damage(0, effect_str)
	if(L.bodytemperature > target_temp)
		L.adjust_bodytemperature(-2.5*TEMPERATURE_DAMAGE_COEFFICIENT*effect_str, target_temp)
	if(volume > 10)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	if(volume > 20)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
		L.heal_limb_damage(0, 0.5*effect_str)
	return ..()

/datum/reagent/medicine/kelotane/overdose_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 0, effect_str)

/datum/reagent/medicine/kelotane/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 0, 2*effect_str)

/datum/reagent/medicine/dermaline
	name = "Dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	color = "#F8C57C"
	overdose_threshold = REAGENTS_OVERDOSE*0.5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL*0.5
	scannable = TRUE
	purge_list = list(/datum/reagent/medicine/oxycodone)
	purge_rate = 0.2

/datum/reagent/medicine/dermaline/on_mob_life(mob/living/L, metabolism)
	var/target_temp = L.get_standard_bodytemperature()
	L.heal_limb_damage(0, 2*effect_str)
	if(L.bodytemperature > target_temp)
		L.adjust_bodytemperature(-5*TEMPERATURE_DAMAGE_COEFFICIENT*effect_str, target_temp)
	if(volume > 5)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	if(volume > 10)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
		L.heal_limb_damage(0, 1.5*effect_str)
	return ..()

/datum/reagent/medicine/dermaline/overdose_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 0, effect_str)

/datum/reagent/medicine/dermaline/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(3*effect_str, 0, 3*effect_str)

/datum/reagent/medicine/dexalin
	name = "Dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	color = "#C865FC"
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/dexalin/on_mob_life(mob/living/L,metabolism)
	if(metabolism & IS_VOX)
		L.adjustToxLoss(3*effect_str)
	else
		L.adjustOxyLoss(-3*effect_str)
	holder.remove_reagent("lexorin", effect_str)
	return ..()

/datum/reagent/medicine/dexalin/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/dexalin/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 0, 2*effect_str)

/datum/reagent/medicine/dexalinplus
	name = "Dexalin Plus"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	color = "#C8A5FC"
	overdose_threshold = REAGENTS_OVERDOSE/2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = TRUE

/datum/reagent/medicine/dexalinplus/on_mob_life(mob/living/L,metabolism)
	if(metabolism & IS_VOX)
		L.adjustToxLoss(1.5*effect_str)
	else
		L.adjustOxyLoss(-L.getOxyLoss())
	holder.remove_reagent("lexorin", effect_str)
	return ..()

/datum/reagent/medicine/dexalinplus/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/dexalinplus/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 0, 3*effect_str)

/datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	color = "#B865CC"
	scannable = TRUE
	purge_list = list(/datum/reagent/medicine/ryetalyn)
	purge_rate = 1
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	taste_description = "grossness"

/datum/reagent/medicine/tricordrazine/on_mob_life(mob/living/L, metabolism)

	L.adjustOxyLoss(-0.5*effect_str)
	L.adjustToxLoss(-0.4*effect_str)
	L.heal_limb_damage(0.8*effect_str, 0.8*effect_str)
	if(volume > 10)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	if(volume > 20)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	return ..()

/datum/reagent/medicine/tricordrazine/overdose_process(mob/living/L, metabolism)
	L.jitter(5)
	L.adjustBrainLoss(effect_str, TRUE)

/datum/reagent/medicine/tricordrazine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(3*effect_str, 3*effect_str, 3*effect_str)

/datum/reagent/medicine/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum antitoxin."
	color = "#A8F59C"
	scannable = TRUE
	purge_list = list(/datum/reagent/toxin, /datum/reagent/toxin/xeno_neurotoxin, /datum/reagent/consumable/drink/atomiccoffee, /datum/reagent/medicine/paracetamol, /datum/reagent/medicine/larvaway)
	purge_rate = 1
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	taste_description = "a roll of gauze"

/datum/reagent/medicine/dylovene/on_mob_life(mob/living/L,metabolism)
	L.hallucination = max(0, L.hallucination -  2.5*effect_str)
	L.adjustToxLoss(-effect_str)
	if(volume > 10)
		L.adjustStaminaLoss(0.5*effect_str)
	return ..()

/datum/reagent/medicine/dylovene/overdose_process(mob/living/L, metabolism)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
	if(E)
		E.take_damage(0.5*effect_str, TRUE)

/datum/reagent/medicine/dylovene/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 2*effect_str)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.take_damage(1.5*effect_str, TRUE)

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#C8A5DC" // rgb: 200, 165, 220
	taste_description = "badmins"

/datum/reagent/medicine/adminordrazine/on_mob_life(mob/living/L, metabolism)
	L.reagents.remove_all_type(/datum/reagent/toxin, 2.5*effect_str, 0, 1)
	L.setCloneLoss(0)
	L.setOxyLoss(0)
	L.heal_limb_damage(5, 5)
	L.adjustToxLoss(-5)
	L.hallucination = 0
	L.setBrainLoss(0)
	L.set_blurriness(0, TRUE)
	L.set_blindness(0, TRUE)
	L.SetStun(0, FALSE)
	L.SetUnconscious(0)
	L.SetParalyzed(0)
	L.dizziness = 0
	L.setDrowsyness(0)
	L.stuttering = 0
	L.SetConfused(0)
	L.SetSleeping(0)
	L.jitteriness = 0
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.drunkenness = 0
		C.disabilities = 0
	return ..()

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is a commonly used performance-enhancing drug with minimal side effects."
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = REAGENTS_OVERDOSE/5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/5
	scannable = TRUE
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	purge_list = list(/datum/reagent/toxin/mindbreaker)
	purge_rate = 5

/datum/reagent/medicine/synaptizine/on_mob_add(mob/living/L, metabolism)
	L.adjustStaminaLoss(-30*effect_str)
	to_chat(L, "<span class='userdanger'>You feel a burst of energy as the stimulants course through you! Time to go!</span>")

/datum/reagent/medicine/synaptizine/on_mob_life(mob/living/L, metabolism)
	L.reagent_shock_modifier += PAIN_REDUCTION_MEDIUM
	L.adjustDrowsyness(-5)
	L.AdjustUnconscious(-20)
	L.AdjustStun(-20)
	L.AdjustParalyzed(-20)
	L.adjustToxLoss(effect_str)
	L.hallucination = max(0, L.hallucination - 10)
	switch(current_cycle)
		if(1 to 10)
			L.adjustStaminaLoss(-7.5*effect_str)
		if(11 to 40)
			L.adjustStaminaLoss((current_cycle*0.75 - 14)*effect_str)
		if(41 to INFINITY)
			L.adjustStaminaLoss(15*effect_str)
	return ..()

/datum/reagent/medicine/synaptizine/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/synaptizine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, effect_str, effect_str)

/datum/reagent/medicine/synaptizine/on_mob_delete(mob/living/L, metabolism)
	to_chat(L, "<span class='userdanger'>The room spins as you start to come down off your stimulants!</span>")
	addtimer(CALLBACK(L, /mob/living.proc/Paralyze, 15), 10 SECONDS)

/datum/reagent/medicine/neuraline //injected by neurostimulator implant and medic-only injector
	name = "Neuraline"
	description = "A chemical cocktail tailored to enhance or dampen specific neural processes."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 2
	overdose_threshold = 5
	overdose_crit_threshold = 6
	scannable = FALSE

/datum/reagent/medicine/neuraline/on_mob_life(mob/living/L)
	L.reagent_shock_modifier += PAIN_REDUCTION_FULL
	L.adjustDrowsyness(-5)
	L.dizzy(-5)
	L.stuttering = max(L.stuttering-5, 0)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.drunkenness = max(C.drunkenness-5, 0)
	L.AdjustConfused(-10 SECONDS)
	L.adjust_blurriness(-5)
	L.AdjustUnconscious(-40)
	L.AdjustStun(-40)
	L.AdjustParalyzed(-20)
	L.AdjustSleeping(-40)
	L.adjustStaminaLoss(-30*effect_str)
	L.heal_limb_damage(7.5*effect_str, 7.5*effect_str)
	L.adjustToxLoss(3.75*effect_str)
	return ..()

/datum/reagent/medicine/neuraline/overdose_process(mob/living/L, metabolism)
	L.adjustToxLoss(2.5*effect_str, TRUE)

/datum/reagent/medicine/neuraline/overdose_crit_process(mob/living/L, metabolism)
	L.adjustBrainLoss(10*effect_str, TRUE) //if you double inject, you're fucked till surgery. This is the downside of a very strong chem.

/datum/reagent/medicine/hyronalin
	name = "Hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of toxin poisoning."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/hyronalin/on_mob_life(mob/living/L)
	L.adjustToxLoss(-effect_str)
	return ..()

/datum/reagent/medicine/hyronalin/overdose_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/medicine/hyronalin/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(0, effect_str, effect_str)

/datum/reagent/medicine/arithrazine
	name = "Arithrazine"
	description = "Arithrazine is an unstable medication used for minor cases of toxin poisoning."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM
	overdose_threshold = REAGENTS_OVERDOSE/2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = TRUE

/datum/reagent/medicine/arithrazine/on_mob_life(mob/living/L)
	L.adjustToxLoss(-0.5*effect_str)
	if(prob(15))
		L.take_limb_damage(effect_str, 0)
	return ..()

/datum/reagent/medicine/arithrazine/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/arithrazine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, effect_str, 2*effect_str)

/datum/reagent/medicine/russian_red
	name = "Russian Red"
	description = "An emergency generic treatment with extreme side effects."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 5
	overdose_threshold = REAGENTS_OVERDOSE/2   //so it makes the OD threshold effectively 15 so two pills  is too much but one is fine
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/2.5 //and this makes the Critical OD 20
	scannable = TRUE

/datum/reagent/medicine/russian_red/on_mob_life(mob/living/L, metabolism)
	L.heal_limb_damage(10*effect_str, 10*effect_str)
	L.adjustToxLoss(-2.5*effect_str)
	L.adjustCloneLoss(effect_str)
	return ..()

/datum/reagent/medicine/russian_red/overdose_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 0, 0)

/datum/reagent/medicine/russian_red/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 2*effect_str, effect_str)
	L.adjustBrainLoss(2*effect_str, TRUE)

/datum/reagent/medicine/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	color = "#E89599"
	custom_metabolism = REAGENTS_METABOLISM * 0.25
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/alkysine/on_mob_life(mob/living/L, metabolism)
	L.reagent_shock_modifier += PAIN_REDUCTION_VERY_LIGHT
	L.adjustBrainLoss(-1.5*effect_str)
	return ..()

/datum/reagent/medicine/alkysine/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/alkysine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(0, effect_str, effect_str)

/datum/reagent/medicine/imidazoline
	name = "Imidazoline"
	description = "Heals eye damage"
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE
	taste_description = "dull toxin"

/datum/reagent/medicine/imidazoline/on_mob_life(mob/living/L, metabolism)
	L.adjust_blurriness(-5)
	L.adjust_blindness(-5)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.heal_organ_damage(effect_str)
	return ..()

/datum/reagent/medicine/imidazoline/overdose_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/medicine/imidazoline/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(0, effect_str, 2*effect_str)

/datum/reagent/medicine/peridaxon
	name = "Peridaxon"
	description = "Used to stabilize internal organs while waiting for surgery, and fixes organ damage at cryogenic temperatures. Medicate cautiously."
	color = "#C845DC"
	overdose_threshold = REAGENTS_OVERDOSE/2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/2
	custom_metabolism = REAGENTS_METABOLISM * 0.25
	scannable = TRUE

/datum/reagent/medicine/peridaxon/on_mob_life(mob/living/L, metabolism)
	if(!ishuman(L))
		return ..()
	var/mob/living/carbon/human/H = L
	for(var/datum/internal_organ/I in H.internal_organs)
		if(I.damage)
			if(L.bodytemperature > 169 && I.damage > 5)
				continue
			I.heal_organ_damage(effect_str)
	return ..()

/datum/reagent/medicine/peridaxon/overdose_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, BRUTE)

/datum/reagent/peridaxon/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 3*effect_str, 3*effect_str)

/datum/reagent/medicine/peridaxon_plus
	name = "Peridaxon Plus"
	description = "Used to heal severely damaged internal organs in the field. Moderately toxic. Do not self-administer."
	color = "#C845DC"
	overdose_threshold = REAGENTS_OVERDOSE/30
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/25
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	scannable = TRUE

/datum/reagent/medicine/peridaxon_plus/on_mob_life(mob/living/L, metabolism)
	L.reagents.add_reagent(/datum/reagent/toxin,5)
	L.adjustStaminaLoss(10*effect_str)
	if(!ishuman(L))
		return ..()
	var/mob/living/carbon/human/H = L
	for(var/datum/internal_organ/I in H.internal_organs)
		if(I.damage)
			I.heal_organ_damage(2*effect_str)
	return ..()

/datum/reagent/medicine/peridaxon_plus/overdose_process(mob/living/L, metabolism)
	L.apply_damage(15*effect_str, TOX)

/datum/reagent/peridaxon_plus/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(15*effect_str, TOX) //Ya triple-clicked. Ya shouldn'ta did that.

/datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	color = "#E8756C"
	purge_list = list(/datum/reagent/medicine/ryetalyn)
	purge_rate = 1
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/bicaridine/on_mob_life(mob/living/L, metabolism)
	L.heal_limb_damage(effect_str, 0)
	if(volume > 10)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	if(volume > 20)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
		L.heal_limb_damage(0.5*effect_str, 0)
	return ..()


/datum/reagent/medicine/bicaridine/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, BURN)

/datum/reagent/medicine/bicaridine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, 3*effect_str, 2*effect_str)

/datum/reagent/medicine/meralyne
	name = "Meralyne"
	description = "Meralyne is a concentrated form of bicardine and can be used to treat extensive blunt trauma."
	color = "#E6666C"
	overdose_threshold = REAGENTS_OVERDOSE*0.5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL*0.5
	scannable = TRUE
	purge_list = list(/datum/reagent/medicine/oxycodone)
	purge_rate = 0.2

/datum/reagent/medicine/meralyne/on_mob_life(mob/living/L, metabolism)
	L.heal_limb_damage(2*effect_str, 0)
	if(volume > 5)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
	if(volume > 10)
		L.reagent_pain_modifier -= PAIN_REDUCTION_LIGHT
		L.heal_limb_damage(1.5*effect_str, 0)
	return ..()


/datum/reagent/medicine/meralyne/overdose_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, BURN)

/datum/reagent/medicine/meralyne/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 6*effect_str, 4*effect_str)

/datum/reagent/medicine/quickclot
	name = "Quick Clot"
	description = "A chemical designed to quickly arrest all sorts of bleeding by encouraging coagulation. Can rectify internal bleeding at cryogenic temperatures."
	color = "#CC00FF"
	overdose_threshold = REAGENTS_OVERDOSE/2 //Was 4, now 6 //Now 15
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = TRUE //scannable now.  HUZZAH.
	custom_metabolism = REAGENTS_METABOLISM * 0.25

/datum/reagent/medicine/quickclot/on_mob_life(mob/living/L, metabolism)
	L.blood_volume += 0.2
	if(!ishuman(L) || L.bodytemperature > 169) //only heals IB at cryogenic temperatures.
		return ..()
	var/mob/living/carbon/human/H = L
	for(var/datum/limb/X in H.limbs)
		for(var/datum/wound/W in X.wounds)
			if(W.internal)
				W.damage = max(0, W.damage - (effect_str))
				X.update_damages()
				if (X.update_icon())
					X.owner.UpdateDamageIcon(1)
	return ..()


/datum/reagent/medicine/quickclot/overdose_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, BRUTE)

/datum/reagent/medicine/quickclot/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(0, 2*effect_str, 2*effect_str)


/datum/reagent/medicine/quickclotplus
	name = "Quick Clot Plus"
	description = "A chemical designed to quickly and painfully remove internal bleeding by encouraging coagulation. Should not be self-administered."
	color = "#CC00FF"
	overdose_threshold = REAGENTS_OVERDOSE/5 //Was 4, now 6 //Now 15 //Now 6 again, yay oldQC
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/5 //10u
	scannable = TRUE
	custom_metabolism = REAGENTS_METABOLISM * 2.5

/datum/reagent/medicine/quickclotplus/on_mob_life(mob/living/L, metabolism)
	var/mob/living/carbon/human/H = L
	for(var/datum/limb/X in H.limbs)
		for(var/datum/wound/W in X.wounds)
			if(W.internal)
				W.damage = max(0, W.damage - (2.5*effect_str))
				X.update_damages()
				if (X.update_icon())
					X.owner.UpdateDamageIcon(1)
	L.reagents.add_reagent(/datum/reagent/toxin,5)
	L.reagent_shock_modifier -= PAIN_REDUCTION_FULL
	L.adjustStaminaLoss(15*effect_str)
	return ..()


/datum/reagent/medicine/quickclotplus/overdose_process(mob/living/L, metabolism)
	L.apply_damage(1.5*effect_str, TOX)
	L.blood_volume -= 4

/datum/reagent/medicine/quickclotplus/overdose_crit_process(mob/living/L, metabolism)
	L.blood_volume -= 20

/datum/reagent/medicine/nanoblood
	name = "Nanoblood"
	description = "A chemical designed to massively boost the body's natural blood restoration rate. Causes fatigue and minor toxic effects."
	color = "#CC00FF"
	overdose_threshold = REAGENTS_OVERDOSE/5 //6u
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/5 //10u
	scannable = TRUE

/datum/reagent/medicine/nanoblood/on_mob_life(mob/living/L, metabolism)
	L.blood_volume += 2.4
	L.adjustToxLoss(effect_str)
	L.adjustStaminaLoss(6*effect_str)
	if(L.blood_volume < BLOOD_VOLUME_OKAY)
		L.blood_volume += 2.4
	if(L.blood_volume < BLOOD_VOLUME_BAD)
		L.blood_volume = (BLOOD_VOLUME_BAD+1)
		L.reagents.add_reagent(/datum/reagent/toxin,25)
		L.AdjustSleeping(100)
	return ..()

/datum/reagent/medicine/nanoblood/overdose_process(mob/living/L, metabolism)
	L.apply_damage(1.5*effect_str, TOX)

/datum/reagent/medicine/nanoblood/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(3*effect_str, TOX)

/datum/reagent/medicine/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a highly effective, muscle and adrenal stimulant that massively accelerates metabolism.  May cause heart damage"
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = REAGENTS_OVERDOSE/5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL/5
	scannable = TRUE
	purge_list = list(/datum/reagent/medicine/dexalinplus) //Does this purge any specific chems?
	purge_rate = 15 //rate at which it purges specific chems
	trait_flags = TACHYCARDIC

/datum/reagent/medicine/hyperzine/on_mob_add(mob/living/L, metabolism)
	. = ..()
	L.add_movespeed_modifier(type, TRUE, 0, NONE, TRUE, -1)

/datum/reagent/medicine/hyperzine/on_mob_delete(mob/living/L, metabolism)
	L.remove_movespeed_modifier(type)
	var/amount = current_cycle * 2
	L.adjustOxyLoss(amount)
	L.adjustStaminaLoss(amount * 1.5)
	if(L.stat == DEAD)
		var/death_message = "<span class='danger'>Your body is unable to bear the strain. The last thing you feel, aside from crippling exhaustion, is an explosive pain in your chest as you drop dead. It's a sad thing your adventures have ended here!</span>"
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.species.species_flags & NO_PAIN)
				death_message = "<span class='danger'>Your body is unable to bear the strain. The last thing you feel as you drop dead is utterly crippling exhaustion. It's a sad thing your adventures have ended here!</span>"

		to_chat(L, "[death_message]")
	else
		switch(amount)
			if(4 to 20)
				to_chat(L, "<span class='warning'>You feel a bit tired.</span>")
			if(21 to 50)
				L.Paralyze(amount * 2)
				to_chat(L, "<span class='danger'>You collapse as a sudden wave of fatigue washes over you.</span>")
			if(50 to INFINITY)
				L.Unconscious(amount * 2)
				to_chat(L, "<span class='danger'>Your world convulses as a wave of extreme fatigue washes over you!</span>") //when hyperzine is removed from the body, there's a backlash as it struggles to transition and operate without the drug

	return ..()

/datum/reagent/medicine/hyperzine/on_mob_life(mob/living/L, metabolism)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.adjust_nutrition(-volume * 1.5*effect_str)
	if(prob(1))
		L.emote(pick("twitch","blink_r","shiver"))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/datum/internal_organ/heart/F = H.internal_organs_by_name["heart"]
			F.take_damage(effect_str, TRUE)
	return ..()

/datum/reagent/medicine/hyperzine/overdose_process(mob/living/L, metabolism)
	if(ishuman(L))
		L.jitter(5)
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.take_damage(0.5*effect_str, TRUE)
	if(prob(10))
		L.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/medicine/hyperzine/overdose_crit_process(mob/living/L, metabolism)
	if(ishuman(L))
		L.jitter(10)
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.take_damage(2*effect_str, TRUE)
	if(prob(25))
		L.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/medicine/ultrazine
	name = "Ultrazine"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 0.0835
	overdose_threshold = 10
	overdose_crit_threshold = 20
	addiction_threshold = 0.4 // Adios Addiction Virus
	taste_multi = 2

/datum/reagent/medicine/ultrazine/on_mob_add(mob/living/L, metabolism)
	. = ..()
	L.add_movespeed_modifier(type, TRUE, 0, NONE, TRUE, -1)

/datum/reagent/medicine/ultrazine/on_mob_delete(mob/living/L, metabolism)
	L.remove_movespeed_modifier(type)

/datum/reagent/medicine/ultrazine/on_mob_life(mob/living/L, metabolism)
	if(prob(50))
		L.AdjustParalyzed(-20)
		L.AdjustStun(-20)
		L.AdjustUnconscious(-20)
	L.adjustStaminaLoss(-2*effect_str)
	if(prob(2))
		L.emote(pick("twitch","blink_r","shiver"))
	return ..()

/datum/reagent/medicine/ultrazine/addiction_act_stage1(mob/living/L, metabolism)
	if(prob(10))
		to_chat(L, "<span class='notice'>[pick("You could use another hit.", "More of that would be nice.", "Another dose would help.", "One more dose wouldn't hurt", "Why not take one more?")]</span>")
	if(prob(5))
		L.emote(pick("twitch","blink_r","shiver"))
		L.adjustStaminaLoss(20)
	if(prob(20))
		L.hallucination += 10

/datum/reagent/medicine/ultrazine/addiction_act_stage2(mob/living/L, metabolism)
	if(prob(10))
		to_chat(L, "<span class='warning'>[pick("It's just not the same without it.", "You could use another hit.", "You should take another.", "Just one more.", "Looks like you need another one.")]</span>")
	if(prob(5))
		L.emote("me", EMOTE_VISIBLE, pick("winces slightly.", "grimaces."))
		L.adjustStaminaLoss(35)
		L.Stun(20)
	if(prob(20))
		L.hallucination += 15
		L.AdjustConfused(60)


/datum/reagent/medicine/ultrazine/addiction_act_stage3(mob/living/L, metabolism)
	if(prob(10))
		to_chat(L, "<span class='warning'>[pick("You need more.", "It's hard to go on like this.", "You want more. You need more.", "Just take another hit. Now.", "One more.")]</span>")
	if(prob(5))
		L.emote("me", EMOTE_VISIBLE, pick("winces.", "grimaces.", "groans!"))
		L.Stun(30)
	if(prob(20))
		L.hallucination += 20
		L.AdjustConfused(10 SECONDS)
		L.dizzy(60)
	L.adjustToxLoss(0.1*effect_str)
	L.adjustBrainLoss(0.1*effect_str, TRUE)

/datum/reagent/medicine/ultrazine/addiction_act_stage4(mob/living/L, metabolism)
	if(prob(10))
		to_chat(L, "<span class='danger'>[pick("You need another dose, now. NOW.", "You can't stand it. You have to go back. You have to go back.", "You need more. YOU NEED MORE.", "MORE", "TAKE MORE.")]</span>")
	if(prob(5))
		L.emote("me", EMOTE_VISIBLE, pick("groans painfully!", "contorts with pain!"))
		L.Stun(80)
		L.do_jitter_animation(200)
	if(prob(20))
		L.hallucination += 30
		L.AdjustConfused(14 SECONDS)
		L.dizzy(80)
	L.adjustToxLoss(0.3*effect_str)
	L.adjustBrainLoss(0.1*effect_str, TRUE)
	if(prob(15) && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/affected_organ = pick("heart","lungs","liver","kidneys")
		var/datum/internal_organ/I =  H.internal_organs_by_name[affected_organ]
		I.take_damage(5.5*effect_str)



/datum/reagent/medicine/ultrazine/overdose_process(mob/living/L, metabolism)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.take_damage(0.5*effect_str, TRUE)
	else
		L.adjustToxLoss(0.5*effect_str)
	if(prob(10))
		L.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/medicine/ultrazine/overdose_crit_process(mob/living/L, metabolism)
	if(!ishuman(L))
		L.adjustToxLoss(1.5*effect_str)
	else
		var/mob/living/carbon/human/H = L
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.take_damage(1.5*effect_str, TRUE)

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = TRUE
	taste_description = "sludge"
	trait_flags = BRADYCARDICS

/datum/reagent/medicine/cryoxadone/on_mob_life(mob/living/L, metabolism)
	if(L.bodytemperature < 170)
		L.adjustCloneLoss(-effect_str)
		L.adjustOxyLoss(-effect_str)
		L.heal_limb_damage(effect_str,effect_str)
		L.adjustToxLoss(-effect_str)
	return ..()

/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = TRUE
	taste_description = "muscle"
	trait_flags = BRADYCARDICS

/datum/reagent/medicine/clonexadone/on_mob_life(mob/living/L, metabolism)
	if(L.bodytemperature < 170)
		L.adjustCloneLoss(-3*effect_str)
		L.adjustOxyLoss(-3*effect_str)
		L.heal_limb_damage(3*effect_str,3*effect_str)
		L.adjustToxLoss(-3*effect_str)

	return ..()

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE
	taste_description = "fish"

/datum/reagent/medicine/rezadone/on_mob_life(mob/living/L, metabolism)
	switch(current_cycle)
		if(1 to 15)
			L.adjustCloneLoss(-effect_str)
			L.heal_limb_damage(effect_str,effect_str)
		if(16 to 35)
			L.adjustCloneLoss(-2*effect_str)
			L.heal_limb_damage(2*effect_str,effect_str)

			L.status_flags &= ~DISFIGURED
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.name = H.get_visible_name()
		if(35 to INFINITY)
			L.adjustToxLoss(effect_str)
			L.dizzy(5)
			L.jitter(5)
	return ..()

/datum/reagent/medicine/rezadone/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/rezadone/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	description = "An all-purpose antiviral agent."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 0.05
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/spaceacillin/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/spaceacillin/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/medicine/polyhexanide
	name = "Polyhexanide"
	description = "A sterilizing agent designed for internal use. Powerful, but dangerous."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 2
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL
	scannable = TRUE

/datum/reagent/medicine/polyhexanide/on_mob_life(mob/living/L, metabolism)
	switch(current_cycle)
		if(1 to 9)
			L.adjustToxLoss(effect_str)
			L.adjustDrowsyness(5)
		if(10 to 50)
			L.adjustToxLoss(1.25*effect_str)
			L.Sleeping(10 SECONDS)
		if(51 to INFINITY)
			L.adjustToxLoss((current_cycle/10-4.6)*effect_str) //why yes, the sleeping stops after it stops working. Yay screaming patients running off!
	return ..()

/datum/reagent/medicine/polyhexanide/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/medicine/larvaway
	name = "Larvaway"
	description = "A proprietary blend of antibiotics and antifungal agents designed to inhibit the growth of xenomorph embryos. Builds up toxicity over time."
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	overdose_threshold = REAGENTS_OVERDOSE * 0.5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL * 0.5
	scannable = TRUE

/datum/reagent/medicine/larvaway/on_mob_life(mob/living/L, metabolism)
	switch(current_cycle)
		if(1 to 100)
			L.adjustToxLoss(0.5*effect_str)
			if(prob(25))
				L.adjustStaminaLoss(0.5*effect_str)
		if(101 to 200)
			L.adjustToxLoss(effect_str)
			if(prob(25))
				L.adjustStaminaLoss(20*effect_str)
		if(201 to INFINITY)
			L.adjustToxLoss(3*effect_str)
	return ..()

/datum/reagent/medicine/larvaway/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/larvaway/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)


/datum/reagent/medicine/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose_threshold = REAGENTS_OVERDOSE
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/medicine/ethylredoxrazine/on_mob_life(mob/living/L, metabolism)
	L.dizzy(-1)
	L.adjustDrowsyness(-1)
	L.stuttering = max(L.stuttering-1, 0)
	L.AdjustConfused(-20)
	var/mob/living/carbon/C = L
	C.drunkenness = max(C.drunkenness-4, 0)
	L.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 0.5*effect_str, 0, 1)
	return ..()

/datum/reagent/medicine/ethylredoxrazine/overdose_process(mob/living/L, metabolism)
	L.apply_damage(effect_str, TOX)

/datum/reagent/medicine/ethylredoxrazine/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damage(2*effect_str, TOX)

/datum/reagent/hypervene // this isn't under /medicine so things that purge /datum/reagent/medicine like neuro/larval don't purge it
	name = "Hypervene"
	description = "Quickly purges the body of toxin damage, radiation and all other chemicals. Causes significant pain."
	color = "#19C832"
	overdose_threshold = REAGENTS_OVERDOSE * 0.5
	overdose_crit_threshold = REAGENTS_OVERDOSE_CRITICAL * 0.5
	custom_metabolism = REAGENTS_METABOLISM * 5
	purge_list = list(/datum/reagent/medicine, /datum/reagent/toxin)
	purge_rate = 5
	scannable = TRUE
	taste_description = "punishment"
	taste_multi = 8

/datum/reagent/hypervene/on_mob_life(mob/living/L, metabolism)
	L.reagent_shock_modifier -= PAIN_REDUCTION_HEAVY //Significant pain while metabolized.
	if(prob(5)) //causes vomiting
		L.vomit()
	return ..()

/datum/reagent/hypervene/overdose_process(mob/living/L, metabolism)
	L.apply_damages(effect_str, effect_str)
	if(prob(10)) //heavy vomiting
		L.vomit()
	L.reagent_shock_modifier -= PAIN_REDUCTION_VERY_HEAVY * 1.25//Massive pain.

/datum/reagent/hypervene/overdose_crit_process(mob/living/L, metabolism)
	L.apply_damages(2*effect_str, 2*effect_str)
	if(prob(50)) //violent vomiting
		L.vomit()
	L.reagent_shock_modifier -= PAIN_REDUCTION_FULL //Unlimited agony.


/datum/reagent/medicine/roulettium
	name = "Roulettium"
	description = "The concentrated essence of unga. Unsafe to ingest in any quantity"
	color = "#19C832"
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	taste_description = "Poor life choices"

/datum/reagent/medicine/roulettium/on_mob_life(mob/living/L, metabolism)
	L.reagent_shock_modifier += PAIN_REDUCTION_FULL
	L.adjustToxLoss(-30*effect_str)
	L.heal_limb_damage(30*effect_str, 30*effect_str)
	L.adjustStaminaLoss(-30*effect_str)
	L.AdjustStun(-100)
	if(prob(5))
		L.adjustBruteLoss(1200*effect_str) //the big oof. No, it's not kill or gib, I want them to nugget.

/datum/reagent/medicine/lemoline
	name = "Lemoline"
	description = "A concentrated set of powders used to enhance other medicine in chemical recipes. Has no use on its own."
	reagent_state = LIQUID
	color = "#66801e"
	taste_description = "piss"

//aphrodisiac & anaphrodisiac

/datum/reagent/drug/aphrodisiac
	name = "Crocin"
	description = "Naturally found in the crocus and gardenia flowers, this drug acts as a natural and safe aphrodisiac."
	taste_description = "strawberries"
	color = "#FFADFF"//PINK, rgb(255, 173, 255)
	can_synth = FALSE
/*HORNYCODE
Pope_Wreckoning:
*/
/datum/reagent/drug/aphrodisiac/on_mob_life(mob/living/L, metabolize)
	if(L/*&& M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO)*/) //Pope_Wreckonging(June/3/2021)"No prefs for clients yet"
		if((prob(min(current_cycle/2,5))))
			L.emote(pick("moan","blush"))
		if(prob(min(current_cycle/4,10)))
			var/aroused_message = pick("You feel frisky.", "You're having trouble suppressing your urges.", "You feel in the mood.")
			to_chat(L, "<span class='userlove'>[aroused_message]</span>")
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/genits = H.adjust_arousal(current_cycle, aphro = TRUE)
			for(var/g in genits)
				var/datum/internal_organ/genital/G = g
				to_chat(L, "<span class='userlove'>[G.arousal_verb]!</span>")
	..()

/datum/reagent/drug/aphrodisiacplus
	name = "Hexacrocin"
	description = "Chemically condensed form of basic crocin. This aphrodisiac is extremely powerful and addictive in most animals.\
					Addiction withdrawals can cause brain damage and shortness of breath. Overdosage can lead to brain damage and a \
					permanent increase in libido (commonly referred to as 'bimbofication')."
	taste_description = "liquid desire"
	color = "#FF2BFF"//dark pink
	addiction_threshold = 15
	overdose_threshold = 20
	can_synth = FALSE

/datum/reagent/drug/aphrodisiacplus/on_mob_life(mob/living/L, metabolism)
	if(L /*&& M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO)*/)
		if(prob(5))
			if(prob(current_cycle))
				L.say(pick("Hnnnnngghh...", "Ohh...", "Mmnnn..."))
			else
				L.emote(pick("moan","blush"))
		if(prob(5))
			var/aroused_message //Pope_Wreckoning(June/03/2021): Okay how this shit work and the G.arousal_verb aint
			if(current_cycle>25)
				aroused_message = pick("You need to fuck someone!", "You're bursting with sexual tension!", "You can't get sex off your mind!")
			else
				aroused_message = pick("You feel a bit hot.", "You feel strong sexual urges.", "You feel in the mood.", "You're ready to go down on someone.")
			to_chat(L, "<span class='userlove'>[aroused_message]</span>")
			REMOVE_TRAIT(L,TRAIT_NEVERBONER,APHRO_TRAIT)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/genits = H.adjust_arousal(100, aphro = TRUE) // redundant but should still be here
			for(var/g in genits)
				var/datum/internal_organ/genital/G = g
				to_chat(L, "<span class='userlove'>[G.arousal_verb]!</span>")
	..()

/datum/reagent/drug/aphrodisiacplus/overdose_process(mob/living/L, metabolism)
	if(L /*&& M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO) && prob(33)*/)
		if(prob(5) && ishuman(L) /*&& M.has_dna() && (M.client?.prefs.cit_toggles & BIMBOFICATION)*/)
			if(!HAS_TRAIT(L,TRAIT_PERMABONER))
				to_chat(L, "<span class='userlove'>Your libido is going haywire!</span>")
				ADD_TRAIT(L,TRAIT_PERMABONER,APHRO_TRAIT)
	..()

/datum/reagent/drug/anaphrodisiac
	name = "Camphor"
	description = "Naturally found in some species of evergreen trees, camphor is a waxy substance. When injested by most animals, it acts as an anaphrodisiac\
					, reducing libido and calming them. Non-habit forming and not addictive."
	taste_description = "dull bitterness"
	taste_multi = 2
	color = "#D9D9D9"//rgb(217, 217, 217)
	reagent_state = SOLID
	can_synth = FALSE

/datum/reagent/drug/anaphrodisiac/on_mob_life(mob/living/L, metabolism)
	if(L /*&& M.client?.prefs.arousable*/ && prob(16))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/genits = H.adjust_arousal(-100, aphro = TRUE)
			if(genits.len)
				to_chat(L, "<span class='notice'>You no longer feel aroused.")
	..()

/datum/reagent/drug/anaphrodisiacplus
	name = "Hexacamphor"
	description = "Chemically condensed camphor. Causes an extreme reduction in libido and a permanent one if overdosed. Non-addictive."
	taste_description = "tranquil celibacy"
	color = "#D9D9D9"//rgb(217, 217, 217)
	reagent_state = SOLID
	overdose_threshold = 20
	can_synth = FALSE

/datum/reagent/drug/anaphrodisiacplus/on_mob_life(mob/living/L, metabolism)
	if(L /* && M.client?.prefs.arousable*/)
		REMOVE_TRAIT(L,TRAIT_PERMABONER,APHRO_TRAIT)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/genits = H.adjust_arousal(-100, aphro = TRUE)
			if(genits.len)
				to_chat(L, "<span class='notice'>You no longer feel aroused.")

	..()

/datum/reagent/drug/anaphrodisiacplus/overdose_process(mob/living/L, metabolism)
	if(L /* && M.client?.prefs.arousable && prob(5)*/)
		to_chat(L, "<span class='userlove'>You feel like you'll never feel aroused again...</span>")
		ADD_TRAIT(L,TRAIT_NEVERBONER,APHRO_TRAIT)
	..()
