local modpath, S = ...

--
-- Register Egg
--

function petz:register_egg(pet_name, desc, inv_img, no_creative)
	local grp = {spawn_egg = 1}
	minetest.register_craftitem(pet_name .. "_set", { -- register new spawn egg containing mob information
		description = S("@1 (", desc)..S("Tamed")..")",
		inventory_image = inv_img,
		groups = {spawn_egg = 2},
		stack_max = 1,
		on_place = function(itemstack, placer, pointed_thing)
			local spawn_pos = pointed_thing.above
			-- am I clicking on something with existing on_rightclick function?
			local under = minetest.get_node(pointed_thing.under)
			local def = minetest.registered_nodes[under.name]
			if def and def.on_rightclick then
				return def.on_rightclick(pointed_thing.under, under, placer, itemstack)
			end
			if spawn_pos and not minetest.is_protected(spawn_pos, placer:get_player_name()) then
				if not minetest.registered_entities[pet_name] then
					return
				end
				spawn_pos = petz.pos_to_spawn(pet_name, spawn_pos)
				local meta = itemstack:get_meta()				
				local meta_table = meta:to_table()
				local sdata = minetest.serialize(meta_table)
				local mob = minetest.add_entity(spawn_pos, pet_name, sdata)
				local ent = mob:get_luaentity()
				petz.set_owner(ent, placer:get_player_name()) --set owner
				itemstack:take_item() -- since mob is unique we remove egg once spawned
			end
			return itemstack
		end,
	})
end

petz.check_capture_items = function(self, wielded_item_name, clicker, check_inv_room)	
	local capture_item_type
	if wielded_item_name == "mobs:lasso" or wielded_item_name == "petz:lasso" then
		capture_item_type = "lasso"
	elseif (wielded_item_name == "mobs:net") or (wielded_item_name == "fireflies:bug_net") then
		capture_item_type = "net"
	else		
		return false
	end
	if capture_item_type == self.capture_item then
		if check_inv_room == true then
			--check for room in inventory
			local inv = clicker:get_inventory()
			if inv:room_for_item("main", ItemStack("air")) then
				return true
			else
				minetest.chat_send_player(clicker:get_player_name(), S("No room in your inventory to capture it."))
				return false				
			end
		else
			return true
		end
	else
		return false
	end
end

petz.capture = function(self, clicker, put_in_inventory)
	local new_stack = ItemStack(self.name .. "_set") 	-- add special mob egg with all mob information
	local stack_meta = new_stack:get_meta()	
	--local sett ="---TABLE---: "
	for key, value in pairs(self) do
		local t = type(value)
		if  t ~= "function" and t ~= "nil" and t ~= "userdata" then
			stack_meta:set_string(key, self[key])	
			--sett= sett .. ", ".. tostring(key).." : ".. tostring(self[key])
			--minetest.chat_send_player("singleplayer", sett)				
		end
	end	
	--Save some extra values-->
	stack_meta:set_string("captured", "true") --mark as captured
	stack_meta:set_string("texture_no", tostring(self.texture_no)) --Save the current texture_no
	stack_meta:set_string("tamed", tostring(self.tamed))	 --Save if tamed	
	stack_meta:set_string("tag", self.tag) --Save the current tag
	stack_meta:set_string("show_tag", tostring(self.show_tag))
	stack_meta:set_string("dreamcatcher", tostring(self.dreamcatcher))
	if self.type == 'lamb' then
		stack_meta:set_string("shaved", tostring(self.shaved))	 --Save if shaved
	elseif self.is_mountable == true then
		stack_meta:set_string("saddle", tostring(self.saddle))
		stack_meta:set_string("saddlebag", tostring(self.saddlebag))
		stack_meta:set_string("saddlebag_inventory", minetest.serialize(self.saddlebag_inventory))
		stack_meta:set_string("max_speed_forward", tostring(self.max_speed_forward))
		stack_meta:set_string("max_speed_reverse", tostring(self.max_speed_reverse))
		stack_meta:set_string("accel", tostring(self.accel))
	end
	if self.breed == true then
		stack_meta:set_string("is_male", tostring(self.is_male))
		stack_meta:set_string("is_rut", tostring(self.is_rut))
		stack_meta:set_string("is_baby", tostring(self.is_baby))
		stack_meta:set_string("is_pregnant", tostring(self.is_pregnant))
		stack_meta:set_string("pregnant_count", tostring(self.pregnant_count))
		stack_meta:set_string("genes", minetest.serialize(self.genes))
	end
	if put_in_inventory == true then
		local inv = clicker:get_inventory()	
		if inv:room_for_item("main", new_stack) then
			inv:add_item("main", new_stack)
		else
			minetest.add_item(clicker:get_pos(), new_stack)
		end
	end
	self.object:remove()
	petz.remove_petz_list_by_owner(self)
	return stack_meta
end
