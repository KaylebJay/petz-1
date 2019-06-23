local modpath, S = ...

minetest.register_globalstep(function(dtime)

	local abr = minetest.get_mapgen_setting('active_block_range')
	local radius =  abr * 16 --recommemded		
	interval = petz.settings.spawn_interval	
	
	local spawn_pos = mobkit.get_spawn_pos_abr(dtime, interval, radius, 0.3, 0.2)
	
	if spawn_pos then
		local random_mob = petz.mobs_list[math.random(1, #petz.mobs_list)] --Get a random mob from the list of petz mobs
		local spawn_chance = petz.settings[random_mob.."_spawn_chance"]
		if spawn_chance < 0 then
			spawn_chance = 0
		elseif spawn_chance > 1 then
			spawn_chance = 1
		end
		spawn_chance = 1 / spawn_chance
		--minetest.chat_send_player("singleplayer", tostring(spawn_chance))
		local random_chance = math.random(1, spawn_chance)
		--minetest.chat_send_player("singleplayer", tostring(random_chance))
		if random_chance == 1 then
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
			--minetest.chat_send_player("singleplayer", tostring(mob_count))	
			if mob_count < petz.settings.max_mobs then
				local do_spawn = false
				local pos_below = {
					x = spawn_pos.x,
					y = spawn_pos.y - 1.0,
					z = spawn_pos.z,
				}
				local node = minetest.get_node(pos_below)		
				--minetest.chat_send_player("singleplayer", random_mob)				
				local spawn_nodes_list = petz.settings[random_mob.."_spawn_nodes"]
				if spawn_nodes_list then
					spawn_nodes = spawn_nodes_list:split(", ")
					for i = 1, #spawn_nodes do --loop  thru all spawn nodes
						--minetest.chat_send_player("singleplayer", "spawn node="..spawn_nodes[i])	
						--minetest.chat_send_player("singleplayer", "node name="..node.name)	
						if spawn_nodes[i] == node.name then
							do_spawn = true
							break
						end
					end
					if do_spawn == true then
						--check for bigger mobs:
						pos_below = {
							x = spawn_pos.x,
							y = spawn_pos.y - 0.5,
							z = spawn_pos.z,
						}		
						if minetest.get_node(pos_below).name ~= "air" then
						spawn_pos = {
							x = spawn_pos.x,
							y = spawn_pos.y + 1.0,
							z = spawn_pos.z,
						}	
						end
						minetest.add_entity(spawn_pos, "petz:"..random_mob)	
						--minetest.chat_send_player("singleplayer", "spawned!!!")	
					end
				end
			end
		end
	end
end)
