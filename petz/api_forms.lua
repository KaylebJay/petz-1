local modpath, S = ...

petz.create_form = function(player_name)
    local pet = petz.pet[player_name]
    local form_size = {w = 4, h = 3}
    local hungrystuff_pos = {x= 0, y = 0}
    local buttonexit_pos = {x = 1, y = 6}
    local form_title = ""
    local tamagochi_form_stuff = ''
    local affinity_stuff = ''
    local form_orders = ''
    local more_form_orders = ''
    local final_form = ''	
    local pet_icon = "image[0,0;1,1;petz_spawnegg_"..pet.type..".png]"
    if pet.affinity == nil then
       pet.affinity = 0
    end
    if petz.settings.tamagochi_mode == true then     
    	form_size.w= form_size.w + 1
		if pet.has_affinity == true then
			form_title = S("Orders")
			hungrystuff_pos = {x= 3, y = 2}
			affinity_stuff =
				"image[3,3;1,1;petz_affinity_heart.png]"..
				"label[4,3;".. tostring(pet.affinity).."%]"
		else
			form_size.w= form_size.w
			form_size.h= form_size.h + 1
			form_title = S("Status")
			hungrystuff_pos = {x= 1, y = 3}
		end
		tamagochi_form_stuff = 
            pet_icon ..
            "label[1,2;".. form_title .."]"..
            "image[".. hungrystuff_pos.x ..",".. hungrystuff_pos.y ..";1,1;petz_pet_bowl_inv.png]"..
            affinity_stuff            
        local hungry_label = ""
        if pet.fed == false then
            hungry_label = "Hungry"
        else
            hungry_label = "Satiated"
        end
        tamagochi_form_stuff = tamagochi_form_stuff .. "label[".. hungrystuff_pos.x +1 ..",".. hungrystuff_pos.y ..";"..S(hungry_label).."]"
    else
        tamagochi_form_stuff = pet_icon 
        if pet.has_affinity == true then
			tamagochi_form_stuff = tamagochi_form_stuff .. "label[1,2;".. S("Orders") .."]"	
		end
    end
    if pet.is_pet == true and pet.tamed == true then
		if not(pet.tag) then
			pet.tag = ""
		end
		local selected
		if pet.show_tag == true then
			selected = "true"
		else
			selected = "false"
		end
		if pet.dreamcatcher == true then
			tamagochi_form_stuff = tamagochi_form_stuff..
			"image_button_exit[4,0;1,1;petz_dreamcatcher.png;btn_dreamcatcher;]"
		end
		tamagochi_form_stuff = tamagochi_form_stuff..
		"field[1,1;2,1;ipt_name;"..S("Name")..":"..";"..pet.tag.."]"..		
		"checkbox[3,1;btn_show_tag;"..S("Show tag")..";"..selected.."]"
	end
	if pet.breed == true then --Show the Gender
		local gender = ''
		if pet.is_male == true then
			gender = S("Male")
		else
			gender = S("Female")
		end				
		tamagochi_form_stuff = tamagochi_form_stuff..
			"label[3,0;"..gender.."]"
		local pregnant_icon_x
		local pregnant_icon_y 
		local pregnant_text_x
		local pregnant_text_y
		local infertile_text_x
		local infertile_text_y
		if pet.is_mountable == true or pet.give_orders == true then
			pregnant_icon_x = 3
			pregnant_icon_y = 5
			pregnant_text_x = 4
			pregnant_text_y = 5
			infertile_text_x = 3 
			infertile_text_y = 5
		else			
			pregnant_icon_x = 3
			pregnant_icon_y = 2
			pregnant_text_x = 4
			pregnant_text_y = 2
			infertile_text_x = 3 
			infertile_text_y = 3
		end			
		if pet.is_male == false and pet.is_pregnant == true then
			tamagochi_form_stuff = tamagochi_form_stuff..
				"image["..pregnant_icon_x..","..pregnant_icon_y..";1,1;petz_"..pet.type.."_pregnant_icon.png]"..
				"label["..pregnant_text_x..","..pregnant_text_y..";"..S("Pregnant").."]"
		elseif pet.is_male == false and pet.pregnant_count <= 0 then
			tamagochi_form_stuff = tamagochi_form_stuff..				
				"label["..infertile_text_x..","..infertile_text_y..";"..S("Infertile").."]"
		end
	end
    if pet.type == "parrot" then
		form_size.h = form_size.h + 1
		buttonexit_pos.y = buttonexit_pos.y + 1
		more_form_orders = more_form_orders..
		"button_exit[0,6;1,1;btn_alight;"..S("Alight").."]"	..
		"button_exit[1,6;1,1;btn_fly;"..S("Fly").."]"..
		"button_exit[2,6;2,1;btn_perch_shoulder;"..S("Perch on shoulder").."]"
	elseif pet.is_mountable == true then		
		more_form_orders = more_form_orders..			
			"image[3,4;1,1;petz_"..pet.type.."_velocity_icon.png]"..
			"label[4,4;".. tostring(pet.max_speed_forward).."/"..tostring(pet.max_speed_reverse)..'/'..tostring(pet.accel).."]"
		if pet.has_saddlebag == true and pet.saddlebag == true then
			more_form_orders = more_form_orders..	
				"image_button[5,0;1,1;petz_saddlebag.png;btn_saddlebag;]"
		end
    end
    if pet.give_orders == true then
		form_size.h= form_size.h + 4
		form_size.w= form_size.w + 1
		form_orders =
			"button_exit[0,3;3,1;btn_followme;"..S("Follow me").."]"..
			"button_exit[0,4;3,1;btn_standhere;"..S("Stand here").."]"..
			"button_exit[0,5;3,1;btn_ownthing;"..S("Do your own thing").."]"..	
			more_form_orders
	else
		if petz.settings.tamagochi_mode == true then
			buttonexit_pos.y = buttonexit_pos.y - 2
			form_size.h= form_size.h + 1
		else
			buttonexit_pos.y = buttonexit_pos.y - 4
			form_size.w= form_size.w + 1
		end
    end
    if pet.is_wild == true then
		form_orders =	form_orders .. "button_exit[3,5;2,1;btn_guard;"..S("Guard").."]"
    end
    final_form =
		"size["..form_size.w..","..form_size.h..";]"..
		tamagochi_form_stuff..        
		form_orders..
		"button_exit["..buttonexit_pos.x..","..buttonexit_pos.y..";1,1;btn_close;"..S("Close").."]"
	return final_form
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if (formname ~= "petz:form_orders") then
		return false
	end
	local player_name = player:get_player_name()
    local pet = petz.pet[player_name] 
	if pet and pet.object then	
		if fields.btn_followme then
			if not(pet.can_fly) then
				mobkit.clear_queue_low(pet)
				mobkit.hq_follow(pet, 15, player)
				pet.status = mobkit.remember(pet, "status", "follow")
			end			
		elseif fields.btn_standhere then
			petz.standhere(pet)
		elseif fields.btn_guard then
			petz.guard(pet)
		elseif fields.btn_ownthing then
			mobkit.clear_queue_low(pet)			
			petz.ownthing(pet)
		elseif fields.btn_alight then
			petz.alight(pet)
		elseif fields.btn_fly then	
			mobkit.clear_queue_low(pet)		
			mobkit.clear_queue_high(pet)	
			pet.status = ""
			mobkit.hq_fly(pet, 0)		
			minetest.after(2.5, function(pet) 
				mobkit.clear_queue_low(pet)
				pet.object:set_acceleration({ x = 0, y = 0, z = 0 })    
				pet.object:set_velocity({ x = 0, y = 0, z = 0 })    
			end, pet)			
		elseif fields.btn_perch_shoulder then
			pet.object:set_attach(player, "Arm_Left", {x=0.5,y=-6.25,z=0}, {x=0,y=0,z=180}) 
			mobkit.animate(pet, "stand")	
			minetest.after(120.0, function(pet) 
				pet.object:set_detach()
			end, pet)
		elseif fields.btn_show_tag then			
			pet.show_tag = mobkit.remember(pet, "show_tag", petz.to_boolean(fields.btn_show_tag))
		elseif fields.btn_dreamcatcher then		
			petz.drop_dreamcatcher(pet)
		elseif fields.btn_saddlebag then	
			--Load the inventory from the petz			
			local inv = minetest.get_inventory({ type="detached", name="saddlebag_inventory" })
			inv:set_list("saddlebag", {})
			if pet.saddlebag_inventory then
				for key, value in pairs(pet.saddlebag_inventory) do
					inv:set_stack("saddlebag", key, value)
				end						
			end
			--Show the inventory:	
			local formspec = "size[8,8;]"..
							"image[3,0;1,1;petz_saddle.png]"..
							"label[4,0;"..S("Saddlebag").."]"..
							"list[detached:saddlebag_inventory;saddlebag;0,1;8,2;]"..
							"list[current_player;main;0,4;8,4;]"		
			minetest.show_formspec(player_name, "petz:saddlebag_inventory", formspec)		
		end
		if fields.ipt_name then
			pet.tag = minetest.formspec_escape(string.sub(fields.ipt_name, 1 , 12))
			mobkit.remember(pet, "tag", pet.tag)
			petz.insert_petz_list_by_owner(pet)
		end
		petz.update_nametag(pet)
		return true
	else
		return false
	end
end)

--On receive fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "petz:saddlebag_inventory" then
		return false
	end	
	--Save the saddlebag content
	local player_name = player:get_player_name()
	local ent = petz.pet[player_name] 
	if ent and ent.object then			
		local inv = minetest.get_inventory({ type="detached", name="saddlebag_inventory" })
		local itemstacks_table = {}			
		local inv_size = inv:get_size("saddlebag") 
		if inv_size > 0 then
			for i = 1, inv_size do
				itemstacks_table[i] = inv:get_stack("saddlebag", i):to_table()
			end		
			ent.saddlebag_inventory = itemstacks_table 		
			mobkit.remember(ent, "saddlebag_inventory", itemstacks_table)
		end
	end
	return true
end)

--Saddlebag detached inventory

local function allow_put(pos, listname, index, stack, player)	
	return stack:get_count()
end

petz.create_detached_saddlebag_inventory = function(name)
	local saddlebag_inventory = minetest.create_detached_inventory(name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local stack = inv:get_stack(from_list, from_index)
			return allow_put(pos, to_list, to_index, stack, player)
			end,
		allow_put = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
	})
	-- Size and width of saddlebag inventory
	saddlebag_inventory:set_size("saddlebag", 16)
	saddlebag_inventory:set_width("saddlebag", 8)
end

petz.create_detached_saddlebag_inventory("saddlebag_inventory")
