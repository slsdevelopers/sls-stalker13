/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = list()
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	var/ignore_flags = 0

/obj/item/weapon/reagent_containers/hypospray/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty!</span>"
		return
	if(!iscarbon(M))
		return

	if(reagents.total_volume && (ignore_flags || M.can_inject(user, 1))) // Ignore flag should be checked first or there will be an error message.
		M << "<span class='warning'>You feel a tiny prick!</span>"
		user << "<span class='notice'>You inject [M] with [src].</span>"

		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(M, INJECT, fraction)
		if(M.reagents)
			var/list/injected = list()
			for(var/datum/reagent/R in reagents.reagent_list)
				injected += R.name

			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			user << "<span class='notice'>[trans] unit\s injected.  [reagents.total_volume] unit\s remaining in [src].</span>"

			var/contained = english_list(injected)

			add_logs(user, M, "injected", src, "([contained])")

/obj/item/weapon/reagent_containers/hypospray/CMO
	list_reagents = list("omnizine" = 30)

/obj/item/weapon/reagent_containers/hypospray/combat
	name = "combat stimulant injector"
	desc = "A modified air-needle autoinjector, used by support operatives to quickly heal injuries in combat."
	amount_per_transfer_from_this = 10
	icon_state = "combat_hypo"
	volume = 90
	ignore_flags = 1 // So they can heal their comrades.
	list_reagents = list("epinephrine" = 30, "omnizine" = 30, "leporazine" = 15, "atropine" = 15)

/obj/item/weapon/reagent_containers/hypospray/combat/nanites
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with expensive medical nanites for rapid healing."
	volume = 100
	list_reagents = list("nanites" = 80, "synaptizine" = 20)

//MediPens

/obj/item/weapon/reagent_containers/hypospray/medipen
	name = "epinephrine medipen"
	desc = "A rapid and safe way to stabilize patients in critical condition for personnel without advanced medical knowledge."
	icon_state = "medipen"
	item_state = "medipen"
	amount_per_transfer_from_this = 10
	volume = 10
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("epinephrine" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/attack(mob/M, mob/user)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty!</span>"
		return
	..()
	update_icon()
	spawn(80)
		if(isrobot(user) && !reagents.total_volume)
			var/mob/living/silicon/robot/R = user
			if(R.cell.use(100))
				reagents.add_reagent_list(list_reagents)
				update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/medipen/update_icon()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/medipen/examine()
	..()
	if(reagents && reagents.reagent_list.len)
		usr << "<span class='notice'>It is currently loaded.</span>"
	else
		usr << "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack //goliath kiting
	name = "stimpack medipen"
	desc = "A rapid way to stimulate your body's adrenaline, allowing for freer movement in restrictive armor."
	icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list("ephedrine" = 10, "coffee" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor
	desc = "A modified stimulants autoinjector for use in combat situations. Has a mild healing effect."
	list_reagents = list("stimulants" = 10, "omnizine" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/morphine
	name = "morphine medipen"
	desc = "A rapid way to get you out of a tight situation and fast! You'll feel rather drowsy, though."
	list_reagents = list("morphine" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/tuberculosiscure
	name = "BVAK autoinjector"
	desc = "Bio Virus Antidote Kit autoinjector. Has a two use system for yourself, and someone else. Inject when infected."
	icon_state = "stimpen"
	volume = 60
	amount_per_transfer_from_this = 30
	list_reagents = list("atropine" = 10, "epinephrine" = 10, "salbutamol" = 20, "spaceacillin" = 20)

/obj/item/reagent_containers/hypospray/medipen/antiburn
	name = "Anti-burn solution"
	desc = "Р”Р°РЅРЅС‹Р№ РґРІСѓС…СЂР°Р·РѕРІС‹Р№ РёРЅР¶РµРєС‚РѕСЂ СЃРѕРґРµСЂР¶РёС‚ РІРµС‰РµСЃС‚РІРѕ, РїСЂРё РІРІРµРґРµРЅРёРё СѓСЃРєРѕСЂСЏСЋС‰РµРµ СЂРµРіРµРЅРµСЂР°С†РёСЋ РѕР±РіРѕСЂРµРІС€РёС… С‚РєР°РЅРµР№ С‡РµР»РѕРІРµС‡РµСЃРєРѕРіРѕ С‚РµР»Р°. РќРµ РґРµР»Р°С‚СЊ Р±РѕР»РµРµ РѕРґРЅРѕР№ РёРЅСЉРµРєС†РёРё Р·Р° РєРѕСЂРѕС‚РєРёР№ РїСЂРѕРјРµР¶СѓС‚РѕРє РІСЂРµРјРµРЅРё."
	eng_desc = "This injector contains a solution that boosts up your burned tissues regeneration. Two-time use, so don't dispose of it after first use. Do not make more than one injection in quick succesion."
	icon_state = "medipen"
	volume = 50
	amount_per_transfer_from_this = 25
	list_reagents = list("kelotane" = 50)

/obj/item/reagent_containers/hypospray/medipen/antiburn/mil
	name = "expanded Anti-burn solution"
	eng_desc = "This expanded injector contains a solution that boosts up your burned tissues regeneration. Three-time use, so don't dispose of it after first use. Do not make more than one injection in quick succesion."
	volume = 75
	amount_per_transfer_from_this = 25
	list_reagents = list("kelotane" = 75)

/obj/item/reagent_containers/hypospray/medipen/antibrute
	name = "Anti-brute solution"
	desc = "Р”Р°РЅРЅС‹Р№ РґРІСѓС…СЂР°Р·РѕРІС‹Р№ РёРЅР¶РµРєС‚РѕСЂ СЃРѕРґРµСЂР¶РёС‚ РІРµС‰РµСЃС‚РІРѕ, РїСЂРё РІРІРµРґРµРЅРёРё СѓСЃРєРѕСЂСЏСЋС‰РµРµ Р»РµС‡РµРЅРёРµ СЃСЃР°РґРёРЅ, СЃРёРЅСЏРєРѕРІ, РїРѕСЂРµР·РѕРІ, РїСѓР»РµРІС‹С… СЂР°РЅРµРЅРёР№ Рё РїСЂРѕС‡РёС… СЃС…РѕР¶РёС… СЂР°РЅ. РќРµ РґРµР»Р°С‚СЊ Р±РѕР»РµРµ РѕРґРЅРѕР№ РёРЅСЉРµРєС†РёРё Р·Р° РєРѕСЂРѕС‚РєРёР№ РїСЂРѕРјРµР¶СѓС‚РѕРє РІСЂРµРјРµРЅРё."
	eng_desc = "This injector contains a solution that boosts up your brute trauma regeneration. Two-time use, so don't dispose of it after first use. Do not make more than one injection in quick succesion."
	icon_state = "medipen"
	volume = 50
	amount_per_transfer_from_this = 25
	list_reagents = list("bicaridine" = 50)

/obj/item/reagent_containers/hypospray/medipen/antibrute/mil
	name = "expanded Anti-brute solution"
	eng_desc = "This expanded injector contains a solution that boosts up your brute trauma regeneration. Three-time use, so don't dispose of it after first use. Do not make more than one injection in quick succesion."
	icon_state = "medipen"
	volume = 75
	amount_per_transfer_from_this = 25
	list_reagents = list("bicaridine" = 75)

/obj/item/reagent_containers/hypospray/medipen/antitoxin
	name = "Antitoxin"
	desc = "Р”Р°РЅРЅС‹Р№ РґРІСѓС…СЂР°Р·РѕРІС‹Р№ РёРЅР¶РµРєС‚РѕСЂ СЃРѕРґРµСЂР¶РёС‚ РІРµС‰РµСЃС‚РІРѕ, РЅРµР№С‚СЂР°Р»РёР·СѓСЋС‰РµРµ Рё РІС‹РІРѕРґСЏС‰РµРµ Р±РѕР»СЊС€РёРЅСЃС‚РІРѕ РёР·РІРµСЃС‚РЅС‹С… СЏРґРѕРІ Рё СЃР»РµРіРєР° РїРѕРґР°РІР»СЏСЋС‰РµРµ СЂР°РґРёР°С†РёСЋ."
	eng_desc = "This injector contains a solution that neutralises most of the known poisons and toxins. Two-time use, so don't dispose of it after first use."
	icon_state = "medipen"
	volume = 50
	amount_per_transfer_from_this = 25
	list_reagents = list("antitoxin" = 50)

/obj/item/reagent_containers/hypospray/medipen/bloodrefill
	name = "Blood-forming stimulants"
	desc = "Р”Р°РЅРЅС‹Р№ РґРІСѓС…СЂР°Р·РѕРІС‹Р№ РёРЅР¶РµРєС‚РѕСЂ СЃРѕРґРµСЂР¶РёС‚ РІРµС‰РµСЃС‚РІРѕ, СѓСЃРєРѕСЂСЏСЋС‰РµРµ РїСЂРѕРёР·РІРѕРґСЃС‚РІРѕ РєСЂР°СЃРЅС‹С… РєСЂРѕРІСЏРЅС‹С… С‚РµР»РµС† Рё РјРµРґР»РµРЅРЅРѕ РІРѕСЃСЃС‚Р°РЅР°РІР»РёРІР°СЋС‰РµРµ СѓС‚СЂР°С‡РµРЅРЅСѓСЋ РєСЂРѕРІСЊ."
	eng_desc = "This injector contains a solution that boosts up your blood regeneration processes in your body and clots existing bleedings. Four-time use, so don't dispose of it after first use."
	icon_state = "medipen"
	volume = 100
	amount_per_transfer_from_this = 25
	list_reagents = list("iron" = 50, "eets" = 50)

/obj/item/reagent_containers/hypospray/medipen/antirad
	name = "Scientific antirad"
	desc = "Данный инжектор содержит небольшую дозу вещества, подавляющего эффекты радиоактивного облучения и помогающего справиться с ним."
	eng_desc = "This injector contains small dosage of an antiradiation substance that suppresses the effects of radiation exposure and helps to cope with it."
	icon_state = "medipen"
	volume = 18
	amount_per_transfer_from_this = 9
	list_reagents = list("pen_acid" = 18)
