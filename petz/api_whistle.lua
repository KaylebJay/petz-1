local modpath, S = ...

-- Whistle Item

minetest.register_craftitem("petz:whistle", {
	description = S("Pet Whistle"),
	inventory_image = "petz_whistle.png",
	groups = {},
	on_use = function (itemstack, user, pointed_thing)
		local user_name = user:get_player_name()
		local user_pos = user:get_pos()
        minetest.show_formspec(user_name, "petz:form_whistle", petz.create_form_list_by_owner(user_name, user_pos))
    end,	
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:whistle',
    recipe = {        
        {'', '', ''},
        {'', 'petz:ducky_feather', ''},
        {'', 'default:steel_ingot', ''},
    }
})

petz.create_form_list_by_owner = function(user_name, user_pos)
	--Get the values of the list
	local item_list_table = petz.petz_list_by_owner[user_name]	
	if item_list_table then
		if #item_list_table <= 0 then
			minetest.chat_send_player(user_name, "You have no pets with a name to call.")	
			return ''
		end
		local item_list = ""
		for key, pet in ipairs(item_list_table) do
			if mobkit.is_alive(pet) then -- check if alive
				local pet_type =  pet.type:gsub("^%l", string.upper) 
				local pet_pos =  pet.object:get_pos() 
				local pet_pos_x, pet_pos_y, pet_pos_z
				if pet_pos then
					distance = tostring(petz.round(vector.distance(user_pos, pet_pos) , 1))
					pet_pos_x = tostring(math.floor(pet_pos.x+0.5))
					pet_pos_y = tostring(math.floor(pet_pos.y+0.5))
					pet_pos_z = tostring(math.floor(pet_pos.z+0.5))
				else
					pet_pos_x = "X"
					pet_pos_y = "Y"
					pet_pos_z = "Z"
					distance = "too far away"
				end
				item_list = item_list .. minetest.colorize("#EE0", pet.tag).." | " .. S(pet_type) .. " | ".. "Pos = (".. pet_pos_x .. "/"
					.. pet_pos_y .. "/".. pet_pos_z ..") | Dist= "..distance..","
			end
		end
		local form_list_by_owner =
			"size[6,8;]"..
			"image[2,0;1,1;petz_whistle.png]"..
			"textlist[0,1;5,6;petz_list;"..item_list..";selected idx]"..
			"button_exit[2,7;1,1;btn_exit;"..S("Close").."]"
		return form_list_by_owner
	else
		return ''
	end
end

--On receive fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "petz:form_whistle" then
		return false
	end
	if fields.petz_list then
		local player_name = player:get_player_name()
		local event = minetest.explode_textlist_event(fields.petz_list)		
		local pet_index = event.index	
		local pet = petz.petz_list_by_owner[player_name][pet_index]
		if pet then
			local pos_front_player = petz.pos_front_player(player)
			local pet_pos = {
				x = pos_front_player.x,
				y = pos_front_player.y + 1,
				z =pos_front_player.z,
			}
			pet.object:set_pos(pet_pos)
			minetest.close_formspec(player_name, "petz:form_whistle")
			petz.do_sound_effect("player", player, "petz_whistle")
		end
	end
	return true
end)
