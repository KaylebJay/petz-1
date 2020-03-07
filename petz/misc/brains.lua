local modpath, S = ...


-- 1. HERBIBORE/FLYING MOBS BRAIN
-- 2. PREDATOR BRAIN
-- 3. BEE BRAIN
-- 4. AQUATIC BRAIN
-- 5. SEMIAQUATIC BRAIN
-- 6. MONSTER BRAIN


--
-- 1. HERBIBORE/FLYING MOBS BRAIN
--

function petz.herbivore_brain(self)

	local pos = self.object:get_pos()

	local die = false

	mobkit.vitals(self)

	if self.hp <= 0 then
		die = true
	elseif not(petz.is_night()) and self.die_at_daylight == true then --it dies when sun rises up
		if pos then
			local node_light = minetest.get_node_light(pos, minetest.get_timeofday())
			if node_light and self.max_daylight_level then
				if node_light >= self.max_daylight_level then
					die = true
				end
			end
		end
	end

	if die == true then
		petz.on_die(self)
		return
	end

	if self.can_fly then
		self.object:set_acceleration({x=0, y=0, z=0})
	end

	mobkit.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		if prty < 25 then
			if self.driver then
				mobkit.hq_mountdriver(self, 25)
				return
			end
		end

		if prty < 20 then
			if self.isinliquid then
				if not self.can_fly then
					mobkit.hq_liquid_recovery(self, 20)
				else
					mobkit.hq_liquid_recovery_flying(self, 20)
				end
				return
			end
		end

		local player = mobkit.get_nearby_player(self)

		--Runaway from predator
		if prty < 18  then
			if petz.bh_runaway_from_predator(self, pos) == true then
				return
			end
		end

		--Follow Behaviour
		if prty < 16 then
			if petz.bh_start_follow(self, pos, player, 16) == true then
				return
			end
		end

		if prty == 16 then
			if petz.bh_stop_follow(self, player) == true then
				return
			end
		end

		--Runaway from Player
		if prty < 14 then
			if not(self.can_fly) and self.tamed == false then --if no tamed
				if player then
					local player_pos = player:get_pos()
					local wielded_item_name = player:get_wielded_item():get_name()
					if self.is_pet == false and self.follow ~= wielded_item_name and vector.distance(pos, player_pos) <= self.view_range then
						mobkit.hq_runfrom(self, 14, player)
						return
					end
				end
			end
		end

		--if prty < 7 and self.type == "moth" and mobkit.is_queue_empty_high(self) then --search for a squareball
			--local pos_torch_near = minetest.find_node_near(pos, self.view_range, "default:torch")
			--if pos_torch_near then
				--mobkit.hq_approach_torch(self, 7, pos_torch_near)
				--return
			--end
		--end

		--Replace nodes by others
		if prty < 7 then
			petz.poop(self, pos)
		end

		--Replace nodes by others
		if prty < 6 then
			petz.bh_replace(self)
		end

		if prty < 5 then
			petz.bh_breed(self, pos)
		end

		--search for a petz:pet_bowl
		if prty < 4 and self.tamed == true then
			local view_range = self.view_range
			local nearby_nodes = minetest.find_nodes_in_area(
				{x = pos.x - view_range, y = pos.y - 1, z = pos.z - view_range},
				{x = pos.x + view_range, y = pos.y + 1, z = pos.z + view_range},
				{"petz:pet_bowl"})
			if #nearby_nodes >= 1 then
				local tpos = 	nearby_nodes[1] --the first match
				local distance = vector.distance(pos, tpos)
				if distance > 2 then
					mobkit.hq_goto(self, 4, tpos)
				elseif distance <=2 then
					if (petz.settings.tamagochi_mode == true) and (self.fed == false) then
						petz.do_feed(self)
					end
				end
			end
		end

		--if prty < 5 and self.type == "puppy" and self.tamed == true and self.square_ball_attached == false then --search for a squareball
			--local object_list = minetest.get_objects_inside_radius(self.object:get_pos(), 10)
			--for i = 1,#object_list do
				--local obj = object_list[i]
				--local ent = obj:get_luaentity()
				--if ent and ent.name == "__builtin:item" then
					--minetest.chat_send_player("singleplayer", ent.itemstring)
					--if ent.itemstring == "petz:square_ball" then
						--local spos = self.object:get_pos()
						--local tpos = obj:get_pos()
						--if vector.distance(spos, tpos) > 2 then
							--if tpos then
								--mobkit.hq_goto(self, 5, tpos)
							--end
						--else
							--local meta = ent:get_meta()
							--local shooter_name = meta:get_string("shooter_name")
							--petz.attach_squareball(ent, self, self.object, nil)
						--end
					--end
				--end
			--end
		--end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		if prty < 3 then
			--if self.is_arboreal == true then
				--if petz.check_if_climb(self) then
					--mobkit.hq_climb(self, 3)
				--end
			--end
		end

		if prty < 2 then	--Sleep Behaviour
			petz.bh_sleep(self, 2)
		end

		--Roam default
		if mobkit.is_queue_empty_high(self) and self.status == "" then
			if not(self.can_fly) then
				mobkit.hq_roam(self, 0)
			else
				mobkit.hq_wanderfly(self, 0)
			end
		end

	end
end

--
-- PREDATOR BRAIN
--

function petz.predator_brain(self)

	local pos = self.object:get_pos()

	mobkit.vitals(self)

	if self.hp <= 0 then -- Die Behaviour
		petz.on_die(self)
		return
	end

	mobkit.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)

		if prty < 40 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 40)
			return
		end

		local pos = self.object:get_pos() --pos of the petz

		local player = mobkit.get_nearby_player(self) --get the player close

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		--Follow Behaviour
		if prty < 16 then
			if petz.bh_start_follow(self, pos, player, 16) == true then
				return
			end
		end

		if prty == 16 then
			if petz.bh_stop_follow(self, player) == true then
				return
			end
		end

		-- hunt a prey
		if prty < 12 then -- if not busy with anything important
			if self.tamed == false then
				local preys_list = petz.settings[self.type.."_preys"]
				if preys_list then
					preys_list = petz.str_remove_spaces(preys_list)
					local preys = string.split(preys_list, ',')
					for i = 1, #preys  do --loop  thru all preys
						--minetest.chat_send_player("singleplayer", "preys list="..preys[i])
						--minetest.chat_send_player("singleplayer", "node name="..node.name)
						local prey = mobkit.get_closest_entity(self, preys[i])	-- look for prey
						if prey then
							--minetest.chat_send_player("singleplayer", "got it")
							mobkit.hq_hunt(self, 12, prey) -- and chase it
							return
						end
					end
				end
			end
		end

		if prty < 10 then
			if player then
				if petz.bh_attack_player(self, pos, 10, player) == true then
					return
				end
			end
		end

		--Replace nodes by others
		if prty < 6 then
			petz.bh_replace(self)
		end

		if prty < 5 then
			petz.bh_breed(self, pos)
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if mobkit.is_queue_empty_high(self) and self.status == "" then
			mobkit.hq_roam(self, 0)
		end

	end
end

--
-- BEE BRAIN
--

function petz.bee_brain(self)

	local pos = self.object:get_pos() --pos of the petz

	mobkit.vitals(self)

	self.object:set_acceleration({x=0, y=0, z=0})

	local behive_exists = petz.behive_exists(self)
	local meta, honey_count, bee_count
	if behive_exists then
		meta, honey_count, bee_count = petz.get_behive_stats(self.behive)
	end

	if (self.hp <= 0) or (not(self.queen) and not(petz.behive_exists(self))) then
		if behive_exists then --decrease the total bee count
			petz.decrease_total_bee_count(self.behive)
			petz.set_infotext_behive(meta, honey_count, bee_count)
		end
		petz.on_die(self) -- Die Behaviour
		return
	elseif (petz.is_night() and not(self.queen)) then --all the bees sleep in their beehive
		if behive_exists then
			bee_count = bee_count + 1
			meta:set_int("bee_count", bee_count)
			if self.pollen == true and (honey_count < petz.settings.max_honey_behive) then
				honey_count = honey_count + 1
				meta:set_int("honey_count", honey_count)
			end
			petz.set_infotext_behive(meta, honey_count, bee_count)
			mokapi.remove_mob(self)
			return
		end
	end

	mobkit.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)

		if prty < 40 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 40)
			return
		end

		local player = mobkit.get_nearby_player(self)

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		--search for flowers
		if prty < 20 and behive_exists then
			if not(self.queen) and not(self.pollen) and (honey_count < petz.settings.max_honey_behive) then
				local view_range = self.view_range
				local nearby_flowers = minetest.find_nodes_in_area(
					{x = pos.x - view_range, y = pos.y - view_range, z = pos.z - view_range},
					{x = pos.x + view_range, y = pos.y + view_range, z = pos.z + view_range},
					{"group:flower"})
				if #nearby_flowers >= 1 then
					local tpos = 	nearby_flowers[1] --the first match
					mobkit.hq_gotopollen(self, 20, tpos)
					return
				end
			end
		end

		--search for the bee behive when pollen
		if prty < 18 and behive_exists then
			if not(self.queen) and self.pollen == true and (honey_count < petz.settings.max_honey_behive) then
				if vector.distance(pos, self.behive) <= self.view_range then
					mobkit.hq_gotobehive(self, 18, pos)
					return
				end
			end
		end

		--stay close behive
		if prty < 15 and behive_exists then
			if not(self.queen) then
			--minetest.chat_send_player("singleplayer", "testx")
				if math.abs(pos.x - self.behive.x) > self.view_range and math.abs(pos.z - self.behive.z) > self.view_range then
					mobkit.hq_approach_behive(self, pos, 15)
					return
				end
			end
		end

		if prty < 13 and self.queen == true then --if queen try to create a colony (beehive)
			if petz.bh_create_beehive(self, pos) then
				return
			end
		end

		if prty < 10 then
			if player then
				if petz.bh_attack_player(self, pos, 10, player) == true then
					return
				end
			end
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if mobkit.is_queue_empty_high(self) and self.status == "" then
			mobkit.hq_wanderfly(self, 0)
		end

	end
end

--
-- 4. AQUATIC BRAIN
--

function petz.aquatic_brain(self)

	local pos = self.object:get_pos()

	mobkit.vitals(self)

	-- Die Behaviour

	if self.hp <= 0 then
		petz.on_die(self)
		return
	elseif not(petz.is_night()) and self.die_at_daylight == true then --it dies when sun rises up
		if minetest.get_node_light(pos, minetest.get_timeofday()) >= self.max_daylight_level then
			petz.on_die(self)
			return
		end
	end

	if not(self.is_mammal) and not(petz.isinliquid(self)) then --if not mammal, air suffocation
		mobkit.hurt(self, petz.settings.air_damage)
	end

	mobkit.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)
		local player = mobkit.get_nearby_player(self)

		--Follow Behaviour
		if prty < 16 then
			if petz.bh_start_follow(self, pos, player, 16) == true then
				return
			end
		end

		if prty == 16 then
			if petz.bh_stop_follow(self, player) == true then
				return
			end
		end

		if prty < 10 then
			if player and (self.attack_player == true) then
				if petz.bh_attack_player(self, pos, 10, player) == true then
					return
				end
			end
		end

		if prty < 8 then
			if (self.can_jump) and not(self.status== "jump") and (pos.y < 2 and pos.y > 0) and (mobkit.is_in_deep(self)) then
				local random_number = math.random(1, 25)
				if random_number == 1 then
					--minetest.chat_send_player("singleplayer", "jump")
					mobkit.clear_queue_high(self)
					mobkit.hq_aqua_jump(self, 8)
				end
			end
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if mobkit.is_queue_empty_high(self)  and self.status == "" and not(self.status== "jump") then
			mobkit.hq_aqua_roam(self, 0, self.max_speed)
		end
	end
end

--
-- 5. SEMIAQUATIC BRAIN
--

function petz.semiaquatic_brain(self)

	local pos = self.object:get_pos()

	mobkit.vitals(self)

	-- Die Behaviour

	if self.hp <= 0 then
		petz.on_die(self)
		return
	elseif not(petz.is_night()) and self.die_at_daylight == true then --it dies when sun rises up
		if minetest.get_node_light(pos, minetest.get_timeofday()) >= self.max_daylight_level then
			petz.on_die(self)
			return
		end
	end

	if not(petz.isinliquid(self)) then
		mobkit.check_ground_suffocation(self, pos)
	end

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)
		local player = mobkit.get_nearby_player(self)

		if prty < 100 then
			--if petz.isinliquid(self) then
				--mobkit.hq_liquid_recovery(self, 100)
			--end
		end

		--Follow Behaviour
		if prty < 16 then
			if petz.bh_start_follow(self, pos, player, 16) == true then
				return
			end
		end

		if prty == 16 then
			if petz.bh_stop_follow(self, player) == true then
				return
			end
		end

		if prty < 10 then
			if player then
				if (self.tamed == false) or (self.tamed == true and self.status == "guard" and player:get_player_name() ~= self.owner) then
					local player_pos = player:get_pos()
					if vector.distance(pos, player_pos) <= self.view_range then	-- if player close
						if self.warn_attack == true then --attack player
							mobkit.clear_queue_high(self)							-- abandon whatever they've been doing
							if petz.isinliquid(self) then
								mobkit.hq_aqua_attack(self, 10, puncher, 6)				-- get revenge
							else
								mobkit.hq_hunt(self, 10, player)
							end
						end
					end
				end
			end
		end

		if prty < 6 then
			petz.bh_replace(self)
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		if self.petz_type == "beaver" then --beaver's dam
			petz.create_dam(self, pos)
		end

		--Roam default
		if mobkit.is_queue_empty_high(self) and self.status == "" then
			if petz.isinliquid(self) then
				mobkit.hq_aqua_roam(self, 0, self.max_speed)
			else
				mobkit.hq_roam(self, 0)
			end
		end
	end
end

--
-- 6. MONSTER BRAIN
--

function petz.monster_brain(self)

	local pos = self.object:get_pos() --pos of the petz

	mobkit.vitals(self)

	if self.hp <= 0 then -- Die Behaviour
		petz.on_die(self)
		return
	end

	mobkit.check_ground_suffocation(self, pos)

	if mobkit.timer(self, 1) then

		local prty = mobkit.get_queue_priority(self)

		if prty < 40 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 40)
			return
		end

		local pos = self.object:get_pos() --pos of the petz

		local player = mobkit.get_nearby_player(self) --get the player close

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		-- hunt a prey
		if prty < 12 then -- if not busy with anything important
			if self.tamed == false then
				local preys_list = petz.settings[self.type.."_preys"]
				if preys_list then
					local preys = string.split(preys_list, ',')
					for i = 1, #preys  do --loop  thru all preys
						--minetest.chat_send_player("singleplayer", "preys list="..preys[i])
						--minetest.chat_send_player("singleplayer", "node name="..node.name)
						local prey = mobkit.get_closest_entity(self, preys[i])	-- look for prey
						if prey then
							self.max_speed = 2.5
							--minetest.chat_send_player("singleplayer", "got it")
							mobkit.hq_hunt(self, 12, prey) -- and chase it
							return
						end
					end
				end
			end
		end

		if prty < 10 then
			if player then
				local werewolf = false
				if petz.settings["lycanthropy"] then
					if petz.is_werewolf(player) then
						werewolf = true
					end
				end
				if (self.tamed == false and werewolf == false) or (self.tamed == true and self.status == "guard" and player:get_player_name() ~= self.owner) then
					local player_pos = player:get_pos()
					if vector.distance(pos, player_pos) <= self.view_range then	-- if player close
						self.max_speed = 2.5
						mobkit.hq_hunt(self, 10, player)
						return
					end
				end
			end
		end

		--Replace nodes by others
		if prty < 6 then
			petz.bh_replace(self)
		end

		-- Default Random Sound
		mokapi.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if mobkit.is_queue_empty_high(self) then
			self.max_speed = 1.5
			mobkit.hq_roam(self, 0)
		end

	end
end
