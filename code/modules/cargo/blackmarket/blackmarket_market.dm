/datum/blackmarket_market
	/// Name for the market.
	var/name = "huh?"

	/// Available shipping methods and prices, just leave the shipping method out that you don't want to have.
	var/list/shipping


	// Automatic vars, do not touch these.
	/// Items available from this market, populated by SSblackmarket on initialization.
	var/list/available_items = list()
	/// Item categories available from this market, only items which are in these categories can be gotten from this market.
	var/list/categories	= list()

/datum/blackmarket_market/New()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(cycle_stock)), 60 MINUTES, TIMER_STOPPABLE|TIMER_LOOP|TIMER_DELETE_ME)

/datum/blackmarket_market/proc/cycle_stock()
	var/list/pair_items_to_handle = list()

	for(var/category in available_items)
		for(var/item in available_items[category])
			if(istype(item, /datum/blackmarket_item))
				var/datum/blackmarket_item/b_item = item
				b_item.cycle()
				if(b_item.available == TRUE)
					for(var/paired_item in b_item.pair_item)
						var/datum/blackmarket_item/item_to_set = get_item_in_market(paired_item)
						if(!(item_to_set in pair_items_to_handle) && !isnull(item_to_set))
							pair_items_to_handle += item_to_set

	for(var/item in pair_items_to_handle)
		var/datum/blackmarket_item/b_item = item
		b_item.cycle(TRUE,FALSE,FALSE,TRUE)

// returns the blackmarket_item datum currently in the availible items list. Null if not in the list
/datum/blackmarket_market/proc/get_item_in_market(datum/blackmarket_item/item)
	for(var/item_to_find in available_items[item.category])
		if(istype(item_to_find,item))
			return item_to_find
	return null

/// Adds item to the available items and add it's category if it is not in categories yet.
/datum/blackmarket_market/proc/add_item(datum/blackmarket_item/item, paired)
	if(ispath(item))
		item = new item()

	if(!(item.category in categories))
		categories += item.category
		available_items[item.category] = list()

	available_items[item.category] += item

	if(prob(initial(item.availability_prob)) || paired)
		item.available = TRUE
	else
		item.available = FALSE

	return TRUE

/// Handles buying the item, this is mainly for future use and moving the code away from the uplink.
/datum/blackmarket_market/proc/purchase(item, category, method, obj/item/blackmarket_uplink/uplink, user)
	if(!istype(uplink) || !(method in shipping))
		return FALSE

	for(var/datum/blackmarket_item/I in available_items[category])
		if(I.type != item)
			continue
		var/price = I.price + shipping[method]
		// I can't get the price of the item and shipping in a clean way to the UI, so I have to do this.
		if(uplink.money < price)
			to_chat(user, span_warning("You don't have enough credits in [uplink] for [I] with [method] shipping."))
			return FALSE

		if(I.buy(uplink, user, method))
			uplink.money -= price
			return TRUE
		return FALSE

/datum/blackmarket_market/blackmarket
	name = "Black Market"
	shipping = list(SHIPPING_METHOD_LTSRBT	=100,
					SHIPPING_METHOD_LAUNCH	=10,
					SHIPPING_METHOD_DEAD_DROP = 20)
