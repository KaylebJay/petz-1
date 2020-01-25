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
	if ((self.is_pet == true) and (self.owner == player_name) and (self.can_be_brushed == true))-- If brushing or spread beaver oil
			and ((wielded_item_name == "petz:hairbrush") or (wielded_item_name == "petz:beaver_oil")) then                       
		if petz.settings.tamagochi_mode == true then
			if wielded_item_name == "petz:hairbrush" then
				if self.brushed == false then
					petz.set_affinity(self, true, 5)
                    self.brushed = true
                    mobkit.remember(self, "brushed", self.brushed) 
                 else
					minetest.chat_send_player(self.owner, S("Your").." "..S(pet_name).." "..S("had already been brushed."))
                 end                
			else --it's beaver_oil						
				if self.beaver_oil_applied == false then
					petz.set_affinity(self, true, 20)
                    self.beaver_oil_applied = true
                    mobkit.remember(self, "beaver_oil_applied", self.beaver_oil_applied)
				else 
					minetest.chat_send_player(self.owner, S("Your").." "..S(pet_name).." "..S("had already been spreaded with beaver oil."))
				end     
			end
		end
		petz.do_sound_effect("object", self.object, "petz_brushing")
		petz.do_particles_effect(self.object, self.object:get_pos(), "star")
	--If feeded
	elseif petz.feed_tame(self, clicker, wielded_item, wielded_item_name, 5, true) then
		if petz.settings.tamagochi_mode == true and self.fed == false then
			petz.do_feed(self)       
		end
		petz.refill(self) --Refill wool, milk or nothing			
	--convert to
	elseif not(petz.str_is_empty(petz.settings[self.type.."_convert"])) and not(petz.str_is_empty(petz.settings[self.type.."_convert_to"]))
		and petz.item_in_itemlist(wielded_item_name, petz.settings[self.type.."_convert"]) then
			petz.convert(self, player_name)	
	elseif petz.check_capture_items(self, wielded_item_name, clicker, true) == true then          	
		local player_name = clicker:get_player_name()
		if (self.is_pet == true and self.owner and self.owner ~= player_name and petz.settings.rob_mobs == false) then
			minetest.chat_send_player(player_name, S("You are not the owner of the").." "..S(pet_name)..".")	
			return
		end
		if self.owner== nil or self.owner== "" or (self.owner ~= player_name and petz.settings.rob_mobs == true) then
			petz.set_owner(self, 	player_name, false)
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
	elseif self.type == "moth" and (wielded_item_name == "vessels:glass_bottle") then
		--capture the moth in the bottle			
		local new_stack = ItemStack("petz:bottle_moth") 	-- add special mob egg with all mob information
		local stack_meta = new_stack:get_meta()	
		stack_meta = petz.capture(self, clicker, false)
		local inv = clicker:get_inventory()	
		if inv:room_for_item("main", new_stack) then
			inv:add_item("main", new_stack)
		else
			minetest.add_item(clicker:get_pos(), new_stack)
		end
	elseif self.type == "pony" and (wielded_item_name == "petz:horseshoe") then
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
