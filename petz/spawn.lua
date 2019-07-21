local modpath, S = ...

minetest.register_globalstep(function(dtime)

	local abr = minetest.get_mapgen_setting('active_block_range')
	local radius =  abr * 16 --recommended		
	local interval = petz.settings.spawn_interval	
	
	local spawn_pos = mobkit.get_spawn_pos_abr(dtime, interval, radius, 0.3, 0.2)	
	
	if spawn_pos then
		local pos_below = {
			x = spawn_pos.x,
			y = spawn_pos.y - 1.0,
			z = spawn_pos.z,
		}
		local node = minetest.get_node(pos_below) --the node below the spawn pos
		local candidates_list = {} --Create a sublist of the petz with the same node to spawn		
		for i = 1, #petz.petz_list do		
			local spawn_nodes_list = petz.settings[petz.petz_list[i].."_spawn_nodes"]
			if spawn_nodes_list then
				local spawn_nodes = spawn_nodes_list:split(", ")
				for j = 1, #spawn_nodes do --loop  thru all spawn nodes
					--minetest.chat_send_player("singleplayer", "spawn node="..spawn_nodes[j])	
					--minetest.chat_send_player("singleplayer", "node name="..node.name)	
					if spawn_nodes[j] == node.name then
						table.insert(candidates_list, petz.petz_list[i])
						break
					end
				end						
			end
		end --end for
		
		--minetest.chat_send_player("singleplayer", minetest.serialize(candidates_list))
		
		if #candidates_list < 1 then --if no candidates, then return
			return
		end
			
		local random_mob = candidates_list[math.random(1, #candidates_list)] --Get a random mob from the list of candidates
		local spawn_chance = petz.settings[random_mob.."_spawn_chance"]
		--minetest.chat_send_player("singleplayer", random_mob)
		if spawn_chance < 0 then
			spawn_chance = 0
		elseif spawn_chance > 1 then
			spawn_chance = 1
		end
		spawn_chance = math.floor((1 / spawn_chance)+0.5)
		--minetest.chat_send_player("singleplayer", tostring(spawn_chance))
		local random_chance = math.random(1, spawn_chance)
		--minetest.chat_send_player("singleplayer", tostring(random_chance))		
		if random_chance == 1 then			
			local random_mob_biome = petz.settings[random_mob.."_spawn_biome"]
			--minetest.chat_send_player("singleplayer", "biome="..random_mob_biome)		
			if random_mob_biome ~= "default" then --specific biome to spawn for this mob
				local biome_name = minetest.get_biome_name(minetest.get_biome_data(spawn_pos).biome) --biome of the spawn pos
				if biome_name ~= random_mob_biome then
					return
				end
			end	
			local objs = minetest.get_objects_inside_radius(spawn_pos, abr*16 + 5)		
			local mob_count = 0	
			for _, obj in ipairs(objs) do		-- count mobs in abrange
				if not obj:is_player() then
					local luaent = obj:get_luaentity()
					if luaent then
						mob_count = mob_count + 1
					end
				end
			end
			local pet_name = "petz:"..random_mob
			if mob_count < petz.settings.max_mobs then --check for bigger mobs:
				spawn_pos = petz.pos_to_spawn(pet_name, spawn_pos) --recalculate pos.y for bigger mobs
				minetest.add_entity(spawn_pos, pet_name)	
				--minetest.chat_send_player("singleplayer", "spawned!!!")					
			end
		end
	end
end)

petz.pos_to_spawn = function(pet_name, pos)	
	local x = pos.x
	local y = pos.y
	local z = pos.z
	if minetest.registered_entities[pet_name] and minetest.registered_entities[pet_name].visual_size.x then
		if minetest.registered_entities[pet_name].visual_size.x >= 32 and
			minetest.registered_entities[pet_name].visual_size.x <= 48 then
				y = y + 2
		elseif minetest.registered_entities[pet_name].visual_size.x > 48 then
			y = y + 5
		else
			y = y + 1
		end
	end
	spawn_pos = { x = x, y = y, z = z}
	return spawn_pos
end
