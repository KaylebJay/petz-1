local modpath, S = ...

--
--Herbivore Behaviour
--

function petz.herbivore_brain(self)
	
	if self.hp <= 0 then
		petz.on_die(self) -- Die Behaviour
		return		
	elseif not(petz.is_night()) and self.die_at_daylight == true then --it dies when sun rises up
		if minetest.get_node_light(self.object:get_pos(), minetest.get_timeofday()) >= self.max_daylight_level then
			petz.on_die(self)
			return
		end
	end			
	
	if mobkit.timer(self, 1) then 
	
		petz.env_damage(self) --enviromental damage: lava, fire...
	
		local prty = mobkit.get_queue_priority(self)		
		
		if prty < 20 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 20)
			return
		end
		
		local pos = self.object:get_pos()
		local player = mobkit.get_nearby_player(self)
			
		--Runaway from predator
		if prty < 18  then		
			local predator_list = petz.settings[self.type.."_predators"]
			if predator_list then
				local predators = string.split(predator_list, ',')
				for i = 1, #predators do --loop  thru all preys
					--minetest.chat_send_player("singleplayer", "spawn node="..spawn_nodes[i])	
					--minetest.chat_send_player("singleplayer", "node name="..node.name)	
					local predator = mobkit.get_closest_entity(self, predators[i])	-- look for predator						
					if predator then									
						if predator and vector.distance(pos, predator:get_pos()) <= self.view_range then						
							mobkit.hq_runfrom(self, 18, predator)
							return
						end
					end					
				end
			end	
		end
		
		--Follow Behaviour					
		if prty < 16 then
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()					
				if wielded_item_name == self.follow and vector.distance(pos, player:get_pos()) <= self.view_range then 
					self.status = mobkit.remember(self, "status", "follow")
					mobkit.hq_follow(self, 16, player)
					return
				end
			end
		end
		
		if prty == 16 then			
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()
				if wielded_item_name ~= self.follow then 
					self.status = mobkit.remember(self, "status", "")
					mobkit.hq_roam(self, 0)
					mobkit.clear_queue_high(self)
					return
				end
			else
				petz.ownthing(self)
			end			
		end
					
		--Runaway from Player		
		if prty < 14 then
			if self.tamed == false then --if no tamed
				if player then
					local wielded_item_name = player:get_wielded_item():get_name()	
					if self.is_pet == false and self.follow ~= wielded_item_name and vector.distance(pos, player:get_pos()) <= self.view_range then 
						mobkit.hq_runfrom(self, 14, player)
						return
					end
				end
			end
		end
		
		
		--Replace nodes by others		
		if prty < 6 then			
			petz.replace(self)
			if self.lay_eggs then
				petz.lay_egg(self)
			end
		end
		
		if prty < 5 then
			if self.breed == true and self.is_rut == true and self.is_male == true then --search a couple for a male!
				local couple_name = "petz:"..self.type
				if self.type ==  "elephant" then
					couple_name = couple_name.."_female"
				end				
				local couple_obj = mobkit.get_closest_entity(self, couple_name)	-- look for a couple
				if couple_obj then
					couple = couple_obj:get_luaentity()
					if couple and couple.is_rut == true and couple.is_pregnant == false and couple.is_male == false then --if couple and female and is not pregnant and is rut
						local couple_pos = couple.object:get_pos() --get couple pos						
						local copulation_distance = petz.settings[self.type.."_copulation_distance"] or 1
						if vector.distance(pos, couple_pos) <= copulation_distance then --if close
							--Changue some vars						
							self.is_rut = false
							mobkit.remember(self, "is_rut", self.is_rut)
							couple.is_rut = false
							mobkit.remember(couple, "is_rut", couple.is_rut)				
							couple.is_pregnant = true
							mobkit.remember(couple, "is_pregnant", couple.is_pregnant)	
							petz.do_particles_effect(couple.object, couple.object:get_pos(), "pregnant".."_"..couple.type)
							petz.init_pregnancy(couple, self)	
						end
					end
				end
			end
		end
		
		--if prty < 5 and self.type == "moth" then --search for a squareball			
			--local pos_torch_near = minetest.find_node_near(self.object:get_pos(), 10, "default:torch")	
			--if pos_torch_near then				
				--mobkit.hq_goto(self, 5, pos_torch_near)
			--end
		--end
		
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
		petz.random_mob_sound(self)
		
		if prty < 3 then
			--if self.is_arboreal == true then			
				--if petz.check_if_climb(self) then
					--mobkit.hq_climb(self, 3)
				--end
			--end
		end
		
		if prty < 2 then	--Sleep Behaviour
			petz.sleep(self, 2)
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

petz.check_if_climb = function(self)
	local node_front_name = mobkit.node_name_in(self, "front")	
	minetest.chat_send_player("singleplayer", node_front_name)		
	local node_top_name= mobkit.node_name_in(self, "top")	
	minetest.chat_send_player("singleplayer", node_top_name)		
	if node_front_name and minetest.registered_nodes[node_front_name]
		and node_top_name and minetest.registered_nodes[node_top_name]
		and node_top_name == "air"
		and (minetest.registered_nodes[node_front_name].groups.wood
		or minetest.registered_nodes[node_front_name].groups.leaves
		or minetest.registered_nodes[node_front_name].groups.tree) then		
			return true
	else
		return false
	end
end

petz.set_behaviour= function(self, behaviour, fly_in)	
	if behaviour == "aquatic" then
		self.behaviour = "aquatic"
        self.fly = true     
        self.fly_in = fly_in
        self.floats = 0
        self.animation = self.animation_aquatic
	elseif behaviour == "terrestrial" then
		self.behaviour = "terrestrial"
        self.fly = false -- make terrestrial
        self.floats = 1
        self.animation = self.animation_terrestrial  
	elseif behaviour == "arboreal" then
		self.behaviour = "arboreal"
        self.fly = true     
        self.fly_in = fly_in
        self.floats = 0
        self.animation = self.animation_arboreal
        self.object:set_acceleration({x = 0, y = 0.5, z = 0 })
	end
end

--
--Predator Behaviour
--

function petz.predator_brain(self)
	
	if self.hp <= 0 then -- Die Behaviour
		petz.on_die(self)
		return	
	end
	
	if mobkit.timer(self, 1) then 
	
		petz.env_damage(self) --enviromental damage: lava, fire...
	
		local prty = mobkit.get_queue_priority(self)		
		
		if prty < 20 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 20)
			return
		end		
		
		local pos = self.object:get_pos() --pos of the petz		
		local player = mobkit.get_nearby_player(self) --get the player close
			
		--Follow Behaviour
		if prty < 16 then
			if player and self.tamed == true then
				local wielded_item_name = player:get_wielded_item():get_name()					
				if wielded_item_name == self.follow and vector.distance(pos, player:get_pos()) <= self.view_range then 	
					mobkit.hq_follow(self, 16, player)
					return
				end				
			end
		end
		
		if prty == 16 then
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()
				if wielded_item_name ~= self.follow then 
					mobkit.hq_roam(self, 0)
					mobkit.clear_queue_high(self)
					return
				end
			else
				petz.ownthing(self)
			end			
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
							minetest.chat_send_player("singleplayer", "got it")	
							mobkit.hq_hunt(self, 12, prey) -- and chase it
							return
						end					
					end
				end				
			end
		end
						
		if prty < 10 then
			if player then
				if (self.tamed == false) or (self.tamed == true and self.status == "guard" and player:get_player_name() ~= self.owner) then
					if vector.distance(pos, player:get_pos()) <= self.view_range then	-- if player close
						if self.attack_player == true then --attack player										
							mobkit.hq_warn(self, 10, player) -- try to repel them
							return
						else
							mobkit.hq_runfrom(self, 10, player)  -- run away from player
							return
						end	
					end
				end
			end
		end

		--Replace nodes by others		
		if prty < 6 then			
			petz.replace(self)
			if self.lay_eggs then
				petz.lay_egg(self)
			end
		end
		
		-- Default Random Sound		
		petz.random_mob_sound(self)
		
		--Roam default			
		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
		end
		
	end
end

--
--Aquatic Behaviour
--

function petz.aquatic_brain(self)
	
	-- Die Behaviour
	
	if self.hp <= 0 then
		petz.on_die(self)
		return		
	elseif not(petz.is_night()) and self.die_at_daylight == true then --it dies when sun rises up
		if minetest.get_node_light(self.object:get_pos(), minetest.get_timeofday()) >= self.max_daylight_level then
			petz.on_die(self)
			return
		end
	end		
	
	if mobkit.timer(self, 1) then 
	
		local prty = mobkit.get_queue_priority(self)				
		local pos = self.object:get_pos() 		
			
		--Runaway from predator
		if prty < 18  then		
			local predator_list = petz.settings[self.type.."_predators"]
			if predator_list then
				local predators =  string.split(predator_list, ',')
				for i = 1, #predators  do --loop  thru all preys
					--minetest.chat_send_player("singleplayer", "spawn node="..spawn_nodes[i])	
					--minetest.chat_send_player("singleplayer", "node name="..node.name)	
					local predator = mobkit.get_closest_entity(self, predators[i])	-- look for predator						
					if predator then									
						if predator and vector.distance(pos, predator:get_pos()) < 8 then						
							mobkit.hq_runfrom(self, 18, predator)
							return
						end
					end					
				end
			end	
		end
		
		--Follow Behaviour
					
		if prty < 16 then
			local player = mobkit.get_nearby_player(self)
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()					
				if wielded_item_name == self.follow and vector.distance(pos, player:get_pos()) < 8 then 
					mobkit.hq_follow(self, 16, player)
					return
				end
			end
		end
		
		if prty == 16 then
			local player = mobkit.get_nearby_player(self)
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()
				if wielded_item_name ~= self.follow then 
					mobkit.hq_roam(self, 0)
					mobkit.clear_queue_high(self)
					return
				end
			else
				petz.ownthing(self)
			end			
		end
		
		--Runaway from Player
		
		if prty < 14 then
			local player = mobkit.get_nearby_player(self)
			if player then
				local wielded_item_name = player:get_wielded_item():get_name()	
				if self.is_pet == false and self.tamed == false and self.follow ~= wielded_item_name and vector.distance(pos, player:get_pos()) < 8 then 
					mobkit.hq_runfrom(self, 14, player)
					return
				end
			end
		end				
		
		-- Default Random Sound		
		petz.random_mob_sound(self)
		
		--Roam default			
		if mobkit.is_queue_empty_high(self) and not(self.status == "stand") then			
			mobkit.hq_wanderswin(self, 0)
		end
		
	end
end



--
--Semiaquatic beahaviour
--for beaver and frog
--

petz.semiaquatic_behaviour = function(self)
		local pos = self.object:get_pos() -- check the beaver pos to togle between aquatic-terrestrial
		local node = minetest.get_node_or_nil(pos)
		if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].groups.water then			
			if not(self.behaviour == "aquatic") then 
				petz.set_behaviour(self, "aquatic", node.name)		
			end
    		if self.petz_type == "beaver" then --beaver's dam
				petz.create_dam(self, pos)
			end
		else
			local pos_underwater = { --check if water below (when the mob is still terrestrial but float in the surface of the water)
            	x = pos.x,
            	y = pos.y - 3.5,
            	z = pos.z,
        	}        	        	
        	node = minetest.get_node_or_nil(pos_underwater)        	
        	if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].groups.water
        		and self.floats == false then
        			local pos_below = {
	            		x = pos.x,
    	        		y = pos.y - 2.0,
        	    		z = pos.z,
	        		}
        			self.object:move_to(pos_below, true) -- move the mob underwater        
					if not(self.behaviour == "aquatic") then 
						petz.set_behaviour(self, "aquatic", node.name)
					end	
					if self.petz_type == "beaver" then --beaver's dam
						petz.create_dam(self, pos)
					end
        	else
        	if not(self.behaviour == "terrestrial") then 
				petz.set_behaviour(self, "terrestrial", nil)
			end        		
        	end
		end 
end

---
---Arboreal Behaviour
---

petz.pos_front = function(self, pos)
	local yaw = self.object:get_yaw()
	local dir_x = -math.sin(yaw) * (self.collisionbox[4] + 0.5)
	local dir_z = math.cos(yaw) * (self.collisionbox[4] + 0.5)	
	local pos_front = {	-- what is in front of mob?
		x = pos.x + dir_x,
		y = pos.y - 0.75,
		z = pos.z + dir_z
	}
	return pos_front
end

---
---Aquatic Behaviour
---
petz.aquatic_behaviour = function(self)
	if self.is_mammal == false then --if not mammal, air suffocation
		local pos = self.object:get_pos() 
		local pos_under = {x = pos.x, y = pos.y - 0.75, z = pos.z, }
		--Check if the aquatic animal is on water
		local node_under = minetest.get_node_or_nil(pos_under)
		if node_under and minetest.registered_nodes[node_under.name] 
			and (not(minetest.registered_nodes[node_under.name].groups.water)) then
				local air_damage = - petz.settings.air_damage
				petz.set_health(self, air_damage)
		end	
	end
end
