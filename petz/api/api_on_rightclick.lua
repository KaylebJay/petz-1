local modpath, S = ...

--Context
--In this temporary table is saved the reference to an entity by its owner
--to show the when on_rightclick form is shown
petz.pet = {} -- A table of pet["owner_name"]= entity_ref

minetest.register_on_leaveplayer(function(player)
    petz.pet[player:get_player_name()] = nil
end)

--
--on_rightclick event for all the Mobs
--

petz.on_rightclick = function(self, clicker)
	if not(clicker:is_player()) then
		return false
	end
	local pet_name = petz.first_to_upper(self.type)
	local player_name = clicker:get_player_name()
	local wielded_item = clicker:get_wielded_item()
	local wielded_item_name = wielded_item:get_name()
	local show_form = false
	if ((self.is_pet == true) and (self.owner == player_name) and (self.can_be_brushed == true)) -- If brushing or spread beaver oil
		and ((wielded_item_name == "petz:hairbrush") or (wielded_item_name == "petz:beaver_oil")) then
			petz.brush(self, wielded_item_name, pet_name)
	--If feeded
	elseif mokapi.feed(self, clicker, petz.settings.tamagochi_feed_hunger_rate, S("@1 at full health (@2)", S(petz.first_to_upper(self.type)), tostring(self.hp)), "moaning") then
		if mokapi.tame(self, 5, player_name, S("@1 has been tamed!", S(petz.first_to_upper(self.type))), {max = petz.settings.max_tamed_by_owner, count= petz.count_tamed_by_owner(player_name), msg = S("You cannot tame more petz! (@1 max.)", tostring(petz.settings.max_tamed_by_owner))}) then
			petz.do_tame(self)
		end
		if self.tamed== true then
			petz.update_nametag(self)
		end
		if petz.settings.tamagochi_mode == true and self.fed == false then
			petz.do_feed(self)
		end
		petz.refill(self) --Refill wool, milk or nothing
	--convert to
	elseif not(petz.str_is_empty(petz.settings[self.type.."_convert"])) and not(petz.str_is_empty(petz.settings[self.type.."_convert_to"]))
		and mokapi.item_in_itemlist(wielded_item_name, petz.settings[self.type.."_convert"]) then
			petz.convert(self, player_name)
	elseif petz.check_capture_items(self, wielded_item_name, clicker, true) == true then
		local player_name = clicker:get_player_name()
		if (self.is_pet == true and (not(self.tamed) or (self.owner and self.owner ~= player_name)) and not(petz.settings.rob_mobs)) then
			minetest.chat_send_player(player_name, S("You are not the owner of the").." "..S(pet_name)..".")
			return
		end
		if self.owner== nil or self.owner== "" or (self.owner ~= player_name and petz.settings.rob_mobs == true) then
			mokapi.set_owner(self, player_name)
			petz.do_tame(self)
		end
		petz.capture(self, clicker, true)
		minetest.chat_send_player("singleplayer", S("Your").." "..S(pet_name).." "..S("has been captured")..".")
	elseif self.breed and wielded_item_name == petz.settings[self.type.."_breed"] and not(self.is_baby) then
		petz.breed(self, clicker, wielded_item, wielded_item_name)
	elseif (wielded_item_name == "petz:dreamcatcher") and (self.tamed == true) and (self.is_pet == true) and (self.owner == player_name) then
		petz.put_dreamcatcher(self, clicker, wielded_item, wielded_item_name)
	elseif petz.settings[self.type.."_colorized"] == true and minetest.get_item_group(wielded_item_name, "dye") > 0  then --Colorize textures
		local color_group = petz.get_color_group(wielded_item_name)
		if color_group and not(self.shaved) then
			petz.colorize(self, color_group)
		end
	--
	--Pet Specifics
	--below here
	elseif self.type == "lamb" then
		if (wielded_item_name == "mobs:shears" or wielded_item_name == "petz:shears") and clicker:get_inventory() and not self.shaved then
			petz.lamb_wool_shave(self, clicker) --shear it!
		else
			show_form = true
		end
	elseif self.milkable == true and wielded_item_name == "bucket:bucket_empty" and clicker:get_inventory() then
		if not(self.milked) then
			petz.milk_milk(self, clicker)
		else
			minetest.chat_send_player(clicker:get_player_name(), S("This animal has already been milked."))
		end
	elseif (self.is_mountable == true) and (wielded_item_name == "petz:glass_syringe" or wielded_item_name == "petz:glass_syringe_sperm") then
		if not(self.is_baby) then
			petz.pony_breed(self, clicker, wielded_item, wielded_item_name)
		end
	elseif self.bottled and (wielded_item_name == "vessels:glass_bottle") then
		petz.bottled(self, clicker)
	elseif (self.type == "pony") and (wielded_item_name == "petz:horseshoe") and (self.owner == player_name) then
		petz.put_horseshoe(self, clicker)
	elseif self.is_mountable == true then
		show_form = petz.mount(self, clicker, wielded_item, wielded_item_name)
	elseif self.feathered then
		if (wielded_item_name == "mobs:shears" or wielded_item_name == "petz:shears") and clicker:get_inventory() then
			petz.cut_feather(self, clicker) --cut a feather
		else
			show_form = true
		end
	else --Else open the Form
		show_form = true
	end
	if show_form == true then
		if (self.tamed == true) and (self.is_pet == true) and (self.owner == player_name) then
			petz.pet[player_name]= self
			minetest.show_formspec(player_name, "petz:form_orders", petz.create_form(player_name))
		end
	end
end
