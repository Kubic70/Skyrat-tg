/obj/item/clothing/gloves/ball_mittens
	name = "Ball mittens"
	desc = "Nice and comfortable pair of inflatable ball gloves"
	icon_state = "ballmittens"
	inhand_icon_state = "ballmittens"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_gloves.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	clothing_flags = DANGEROUS_OBJECT
	equip_delay_other = 60
	equip_delay_self = 60
	strip_delay = 60
	breakouttime = 10

/obj/item/clothing/gloves/ball_mittens/attackby(obj/item/I, mob/user, params) //That part allows reinforcing this item with handcuffs
    if(istype(I, /obj/item/restraints/handcuffs))
        var/obj/item/clothing/gloves/ball_mittens_reinforced/W = new /obj/item/clothing/gloves/ball_mittens_reinforced
        remove_item_from_storage(user)
        user.put_in_hands(W)
        to_chat(user, "<span class='notice'>You reinforce belts with using [src] on [I].</span>")
        qdel(I)
        qdel(src)
        return
    . = ..()

/obj/item/clothing/gloves/ball_mittens_reinforced //We getting this item by using handcuffs on normal ball mittens
	name = "reinforced ball mittens"
	desc = "Do not put these on. Its REALLY hard to put them off... But they looks so comfortable"
	icon_state = "ballmittens"
	inhand_icon_state = "ballmittens"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_gloves.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	clothing_flags = DANGEROUS_OBJECT
	equip_delay_other = 80
	equip_delay_self = 80
	strip_delay = 80
	breakouttime = 1100 //do not touch this, i beg you.
