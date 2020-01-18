local modpath, S = ...


--
-- Helpers Functions
--

function petz.bh_check_pack(self)
	if mobkit.get_closest_entity(self, "petz:"..self.type) then
		return true
	else
		return false
	end
end

function petz.get_player_back_pos(player, pos)	
	local yaw = player:get_look_horizontal()
	if yaw then
		local dir_x = -math.sin(yaw)
		local dir_z = math.cos(yaw)
		local back_pos = {
			x = pos.x - dir_x,
			y = pos.y,
			z = pos.z - dir_z,
		}	
		local node = minetest.get_node_or_nil(back_pos)
		if node and minetest.registered_nodes[node.name] then
			return node.name, back_pos
		else
			return nil, nil
		end
	else
		return nil, nil
	end
end

function mobkit.check_height(self)
	local yaw = self.object:get_yaw()
	local dir_x = -math.sin(yaw) * (self.collisionbox[4] + 0.5)
	local dir_z = math.cos(yaw) * (self.collisionbox[4] + 0.5)
	local pos = self.object:get_pos()
	local ypos = pos.y + self.collisionbox[2] -- just above floor
	if minetest.line_of_sight(
		{x = pos.x + dir_x, y = ypos, z = pos.z + dir_z}, {x = pos.x + dir_x, y = ypos - self.max_height, z = pos.z + dir_z}, 1) then
		return false
	end
	return true
end

function mobkit.check_is_on_surface(self)
	local pos = self.object:get_pos()
	if pos.y > 0 then
		return true
	else
		return false
	end
end

function mobkit.check_ground_suffocation(self)
	local spos = mobkit.get_stand_pos(self)
	spos.y = spos.y+0.01
	if self.type and mobkit.is_alive(self) and not(self.is_baby) then
		local stand_pos = spos
		stand_pos.y = spos.y + 0.5
		local stand_node_pos = mobkit.get_node_pos(stand_pos)
		local stand_node = mobkit.nodeatpos(stand_node_pos)
		if stand_node and stand_node.walkable and stand_node.drawtype == "normal" then
			local new_y = stand_pos.y + self.jump_height
			if new_y <= 30927 then
				self.object:set_pos({
					x = stand_pos.x,
					y = new_y,
					z = stand_pos.z
				})
			end
		end
	end
end

function petz.set_velocity(self, velocity)
	local yaw = self.object:get_yaw() or 0
	self.object:set_velocity({
		x = (math.sin(yaw) * -velocity.x),
		y = velocity.y or 0,
		z = (math.cos(yaw) * velocity.z),
	})
end

function mobkit.node_name_in(self, where)
	local pos = self.object:get_pos()
	local yaw = self.object:get_yaw() 	
	if yaw then
		local dir_x = -math.sin(yaw)
		local dir_z = math.cos(yaw)
		local pos2
		if where == "front" then
			pos2 = {
				x = pos.x + dir_x,
				y = pos.y,
				z = pos.z + dir_z,
			}	
		elseif where == "top" then
			pos2= {
				x = pos.x,
				y = pos.y + 0.5,
				z = pos.z,
			}
		elseif where == "below" then
			pos2= {
				x = pos.x,
				y = pos.y - 0.75,
				z = pos.z,
			}
		elseif where == "back" then	
			pos2 = {
				x = pos.x - dir_x,
				y = pos.y,
				z = pos.z - dir_z,
			}	
		end
		local node = minetest.get_node_or_nil(pos2)
		if node and minetest.registered_nodes[node.name] then
			--minetest.chat_send_player("singleplayer", node.name)	
			return node.name
		else
			return nil
		end
	else
		return nil
	end
end

petz.check_if_climb = function(self)
	local node_front_name = mobkit.node_name_in(self, "front")	
	--minetest.chat_send_player("singleplayer", node_front_name)		
	local node_top_name= mobkit.node_name_in(self, "top")	
	--minetest.chat_send_player("singleplayer", node_top_name)		
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
---COMMON BEHAVIOURS
---

--
-- Runaway from predator behaviour
--

function petz.bh_runaway_from_predator(self, pos)
	local predator_list = petz.settings[self.type.."_predators"]
	if predator_list then
		predator_list = petz.str_remove_spaces(predator_list)
		local predators = string.split(predator_list, ',')
		for i = 1, #predators do --loop  thru all preys
			--minetest.chat_send_player("singleplayer", "spawn node="..spawn_nodes[i])	
			--minetest.chat_send_player("singleplayer", "node name="..node.name)	
			local predator = mobkit.get_closest_entity(self, predators[i])	-- look for predator						
			if predator then
				local predator_pos = predator:get_pos()	
				if predator and vector.distance(pos, predator_pos) <= self.view_range then						
					mobkit.hq_runfrom(self, 18, predator)
					return true
				else
					return false
				end
			end					
		end
	end	
end

--
-- Attack Player Behaviour
--

function petz.bh_attack_player(self, pos, prty, player)
	if not(self.attack_player) and not(self.warn_attack) then
		if petz.bh_check_pack(self) then
			self.warn_attack = true
		end
	end
	local werewolf = false
	if petz.settings["lycanthropy"] then
		if petz.is_werewolf(player) then
			werewolf = true
		end
	end
	if (self.tamed == false and werewolf == false) or (self.tamed == true and self.status == "guard" and player:get_player_name() ~= self.owner) then					
		local player_pos = player:get_pos()
		if vector.distance(pos, player_pos) <= self.view_range then	-- if player close
			if self.attack_player == true or self.warn_attack == true then --attack player	
				if self.can_swin then
					mobkit.hq_aqua_attack(self, prty, player, 6)
				else
					mobkit.hq_hunt(self, prty, player) -- try to repel them
				end
				return true
			else
				if not(self.can_swin) then
					mobkit.hq_runfrom(self, prty, player)  -- run away from player
					return true
				else
					return false
				end
			end	
		else
			return false
		end
	else
		return false
	end
end

--
-- Enviromental Damage
--

function petz.bh_env_damage(self, prty)
	local stand_pos= mobkit.get_stand_pos(self)
	if petz.env_damage(self, stand_pos)	== true then
		local air_pos = minetest.find_node_near(stand_pos, self.view_range, "air", false)
		if air_pos then
			mobkit.hq_goto(self, prty, air_pos)
		end
	end
end

--
-- Replace Behaviour
--

function petz.bh_replace(self)
	petz.replace(self)
	if self.lay_eggs then
		petz.lay_egg(self)
	end
end

--
-- Teleport Behaviour
--

function petz.bh_teleport(self, pos, player, player_pos)
	local node, back_pos = petz.get_player_back_pos(player, player_pos)
	if node and node == "air" then
		petz.do_particles_effect(self.object, self.object:get_pos(), "pumpkin")
		self.object:set_pos(back_pos)
		mobkit.make_sound(self, 'laugh')
	end
end

--
-- Breed Behaviour
--

function petz.bh_breed(self, pos)
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
					couple.father_genes = mobkit.remember(couple, "father_genes", self.genes)	
					petz.do_particles_effect(couple.object, couple.object:get_pos(), "pregnant".."_"..couple.type)
				end
			end
		end
	end
end

--
-- FOLLOW BEHAVIOURS
-- 2 types: for terrestrial and for flying/aquatic mobs.

--
-- Follow behaviours for terrestrial mobs (2 functions; start & stop)
--

function petz.bh_start_follow(self, pos, player, prty)
	if player then
		local wielded_item_name = player:get_wielded_item():get_name()	
		local tpos = player:get_pos()
		if petz.item_in_itemlist(wielded_item_name, self.follow) and vector.distance(pos, tpos) <= self.view_range then 			
			self.status = mobkit.remember(self, "status", "follow")			
			if (self.can_fly) or (self.can_swin and self.isinliquid) then								
				mobkit.hq_followliquidair(self, prty, player)
			else			
				mobkit.hq_follow(self, prty, player)				
			end
			return true
		else
			return false
		end
	end
end

function petz.bh_stop_follow(self, player)
	if player then
		local wielded_item_name = player:get_wielded_item():get_name()
		if wielded_item_name ~= self.follow then 			
			petz.ownthing(self)
			return true
		else
			return false
		end
	else
		petz.ownthing(self)
	end	
end

--
-- Follow Fly/Water Behaviours (2 functions: HQ & LQ)
--

function mobkit.hq_followliquidair(self, prty, player)
	local func=function(self)
		local pos = mobkit.get_stand_pos(self)
		local tpos = player:get_pos()
		if self.can_swin then
			if not(petz.isinliquid(self)) then
				--check if water below, dolphins
				local node_name = mobkit.node_name_in(self, "below")
				if minetest.get_item_group(node_name, "water") == 0  then
					petz.ownthing(self)
					return true	
				end
			end
		end		
		if pos and tpos then
			local distance = vector.distance(pos, tpos)
			if (distance < self.view_range) then
				if mobkit.is_queue_empty_low(self) then			
					mobkit.lq_followliquidair(self, pos, tpos)
				end
			elseif distance >= self.view_range then				
				petz.ownthing(self)
				return true
			end
		else
			return true
		end
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_followliquidair(self, pos, tpos)
	local func = function(self)
		local dir = vector.direction(pos, tpos)
		local velocity = {
			x= self.max_speed* dir.x,
			y= self.max_speed* dir.y,
			z= self.max_speed* dir.z,
		}
		local new_yaw = minetest.dir_to_yaw(dir)
		self.object:set_yaw(new_yaw)   
		self.object:set_velocity(velocity)
		return true
	end
	mobkit.queue_low(self,func)
end

--
-- Approach Torch Behaviour
-- for moths (not finished!!!)
--

function mobkit.hq_approach_torch(self, prty, tpos)
	local func=function(self)
		local pos = self.object:get_pos()
		if pos and tpos then
			local distance = vector.distance(pos, tpos)
			if distance < self.view_range and (distance >= self.view_range) then
				if mobkit.is_queue_empty_low(self) then			
					mobkit.lq_followliquidair(self, pos, tpos)					
				end
			elseif distance >= self.view_range then				
				petz.ownthing(self)
				return true
			end
		else
			return true
		end
	end
	mobkit.queue_high(self, func, prty)
end

--
-- WANDER FLY BEHAVIOUR (2 functions: HQ & LQ)
--

function mobkit.hq_wanderfly(self, prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) then									
			mobkit.lq_dumbfly(self, 0.3)
		end
	end
	mobkit.queue_high(self,func,prty)
end

--3 fly status: ascend, descend and stand right.
--Each 3 seconds:
--1) Search if 'max_height' defined for each mob is reached, if yes: descend or stand.
--2) Check if over water, if yes: ascend.
--3) Check if node in front, if yes: random rotation backwards. This does mobs not stuck.
--4) Random rotation, to avoid mob go too much further.
--5) In each status a chance to change of status, important: more preference for 'ascend'
--than descend, cos this does the mobs stand on air, and climb mountains and trees.

function mobkit.lq_dumbfly(self, speed_factor)
	local timer = petz.settings.fly_check_time
	local fly_status = "ascend"
	speed_factor = speed_factor or 1
	local func = function(self)
		timer = timer - self.dtime			
		if timer < 0 then			
			--minetest.chat_send_player("singleplayer", tostring(timer))		
			local velocity
			local mob = self.object
			local pos = mob:getpos()					
			mobkit.animate(self, 'fly')
			local random_num = math.random(1, 5)
			if random_num <= 1 or mobkit.node_name_in(self, "front") ~= "air" then	
				local yaw = self.object:get_yaw()
				if yaw then
					--minetest.chat_send_player("singleplayer", "test")	
					local rotation_integer = math.random(0, 4)
					local rotation_decimals = math.random()				
					local new_yaw = yaw + rotation_integer + rotation_decimals
					self.object:set_yaw(new_yaw)				
				end			
			end
			if mobkit.check_height(self) == false or mobkit.node_name_in(self, "top") ~= "air" then --check if max height, then stand or descend, or a node above the petz
				random_num = math.random(1, 100)
				if random_num < 70 then
					fly_status = "descend"
				else
					fly_status = "stand"
				end
			else --check if water below, if yes ascend
				local node_name = mobkit.node_name_in(self, "below")
				if minetest.get_item_group(node_name, "water") >= 1  then
					fly_status = "ascend"
				end
			end	
			--minetest.chat_send_player("singleplayer", status)		
			--local node_name_in_front = mobkit.node_name_in(self, "front")
			if fly_status == "stand" then -- stand
				velocity = {
					x= self.max_speed* speed_factor *2,
					y= 0.0,
					z= self.max_speed* speed_factor *2,
				}
				random_num = math.random(1, 100)
				if random_num < 20 and mobkit.check_height(self) == false then
					fly_status = "descend"				
				elseif random_num < 40 then		
					fly_status = "ascend"							
				end		
				--minetest.chat_send_player("singleplayer", "stand")			
			elseif fly_status == "descend" then -- descend				
				velocity = {
					x = self.max_speed* speed_factor,
					y = -self.max_speed * speed_factor,
					z = self.max_speed* speed_factor,
				}
				random_num = math.random(1, 100)
				if random_num < 20 then
					fly_status = "stand"
				elseif random_num < 40 then		
					fly_status = "ascend"											
				end
				--minetest.chat_send_player("singleplayer", "descend")	
			else --ascend			
				fly_status = "ascend"
				velocity ={
					x = self.max_speed * speed_factor,				
					y = self.max_speed * speed_factor * 2,
					z = self.max_speed * speed_factor,
				}
				--minetest.chat_send_player("singleplayer", tostring(velocity.x))
				--minetest.chat_send_player("singleplayer", "ascend")			
			end		
			timer = petz.settings.fly_check_time
			petz.set_velocity(self, velocity)
			self.fly_velocity = velocity --save the velocity to set in each step, not only each x seconds
			return true
		else
			if self.fly_velocity then
				petz.set_velocity(self, self.fly_velocity)
			else
				petz.set_velocity(self, {x = 0.0, y = 0.0, z = 0.0})
			end		
		end
	end
	mobkit.queue_low(self,func)
end

--
-- 'Take Off' Behaviour ( 2 funtions)
--

function mobkit.hq_fly(self, prty)
	local func=function(self)		
		mobkit.animate(self, "fly")	
		mobkit.lq_fly(self)	
		mobkit.clear_queue_high(self)
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_fly(self)
	local func=function(self)
		self.object:set_acceleration({ x = 0, y = 1, z = 0 })
	end
	mobkit.queue_low(self,func)
end

-- Function to recover flying mobs from water

function mobkit.hq_liquid_recovery_flying(self, prty)	
	local func=function(self)		
		self.object:set_acceleration({ x = 0.0, y = 0.125, z = 0.0 })
		self.object:set_velocity({ x = 1.0, y = 1.0, z = 1.0 })
		if not(petz.isinliquid(self)) then			
			self.object:set_acceleration({ x = 0.0, y = 0.0, z = 0.0 })
			return true
		end
	end
	mobkit.queue_high(self, func, prty)
end

--
-- Alight Behaviour ( 2 funtions: HQ & LQ)
--

function mobkit.hq_alight(self, prty)
	local func = function(self)
		local node_name = mobkit.node_name_in(self, "below")
		if node_name == "air" then
			mobkit.lq_alight(self)
		elseif minetest.get_item_group(node_name, "water") >= 1  then
			mobkit.hq_wanderfly(self, 0)
			return true
		else
			--minetest.chat_send_player("singleplayer", "on ground")				
			mobkit.animate(self, "stand")
			mobkit.lq_idle(self, 2400)	
			self.status = "stand"		
			return true
		end
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_alight(self)
	local func=function(self)
		--minetest.chat_send_player("singleplayer", "alight")	
		self.object:set_acceleration({ x = 0, y = -1, z = 0 })
		return true
	end
	mobkit.queue_low(self, func)
end

--
-- ARBOREAL BRAIN
--

function mobkit.hq_climb(self, prty)
	local func=function(self)	
		if not(petz.check_if_climb) then
			self.object:set_acceleration({x = 0, y = 0, z = 0 })   								
			mobkit.clear_queue_low(self)
			mobkit.clear_queue_high(self)			
			return true
		else
			mobkit.animate(self, 'climb')
			self.object:set_acceleration({x = 0, y = 0.25, z = 0 })			
		end					
	end
	mobkit.queue_high(self,func,prty)
end

---
--- Aquatic Behaviours
---

function mobkit.hq_aqua_jump(self, prty)
	local func = function(self)
		--minetest.chat_send_player("singleplayer", "test")		
		local vel_impulse = 4.0
		local velocity = {
			x = self.max_speed * (vel_impulse/3),
			y = self.max_speed * vel_impulse,
			z = self.max_speed * (vel_impulse/3),
		}		
		petz.set_velocity(self, velocity)
		self.object:set_acceleration({x=1.0, y=vel_impulse, z=1.0})
		self.status = "jump"
		petz.do_sound_effect("object", self.object, "petz_splash")
		minetest.after(0.5, function(self, velocity)
			if mobkit.is_alive(self.object) then
				self.status = ""
				mobkit.clear_queue_high(self)
			end
		end, self, velocity)
		return true
	end
	mobkit.queue_high(self, func, prty)
end

---
--- Bee Behaviours
---

function mobkit.hq_gotopollen(self, prty, tpos)
	local func = function(self)	
		if self.pollen == true then
			--mobkit.clear_queue_low(self)
			--mobkit.clear_queue_high(self)	
			return true
		end
		mobkit.animate(self, "fly")
		mobkit.lq_search_flower(self, tpos)
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_search_flower(self, tpos)
	local func = function(self)	
		local pos = self.object:get_pos()			
		local y_distance = tpos.y - pos.y				
		local abs_y_distance = math.abs(y_distance)		
		if (abs_y_distance > 1) and (abs_y_distance < self.view_range) then
			petz.set_velocity(self, {x= 0.0, y= y_distance, z= 0.0})	
		end
		if mobkit.drive_to_pos(self, tpos, 1.5, 6.28, 0.5) then					
			self.pollen = true
			petz.do_particles_effect(self.object, self.object:get_pos(), "pollen")
			return true
		end
	end
	mobkit.queue_low(self, func)
end

function mobkit.hq_gotobehive(self, prty, pos)
	local func = function(self)	
		if self.pollen == false or not(self.behive) then
			return true
		end
		mobkit.animate(self, "fly")
		mobkit.lq_search_behive(self)
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_search_behive(self)
	local func = function(self)	
		local tpos
		if self.behive then
			tpos = self.behive
		else
			return true
		end
		local pos = self.object:get_pos()			
		local y_distance = tpos.y - pos.y
		local abs_y_distance = math.abs(y_distance)	
		if (abs_y_distance > 1) and (abs_y_distance < self.view_range) then
			petz.set_velocity(self, {x= 0.0, y= y_distance, z= 0.0})	
		end
		if mobkit.drive_to_pos(self, tpos, 1.5, 6.28, 1.01)  then
				if petz.behive_exists(self) then
					self.object:remove()
					local meta, honey_count, bee_count = petz.get_behive_stats(self.behive)
					bee_count = bee_count + 1
					meta:set_int("bee_count", bee_count)
					honey_count = honey_count + 1
					meta:set_int("honey_count", honey_count)
					petz.set_infotext_behive(meta, honey_count, bee_count)											
					self.pollen = false	
				end
		end						
	end
	mobkit.queue_low(self, func)
end

function mobkit.hq_approach_behive(self, pos, prty)
	local func = function(self)			
		if math.abs(pos.x - self.behive.x) <= (self.view_range / 2) or math.abs(pos.z - self.behive.z) <= (self.view_range / 2) then
			mobkit.clear_queue_low(self)
			mobkit.clear_queue_high(self)	
			return true
		end
		mobkit.lq_approach_behive(self)
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_approach_behive(self)
	local func = function(self)		
		local tpos
		if self.behive then
			tpos = self.behive
		else
			return true
		end
		local pos = self.object:get_pos()			
		local y_distance = tpos.y - pos.y
		local abs_y_distance = math.abs(y_distance)
		if mobkit.drive_to_pos(self, tpos, 1.5, 6.28, (self.view_range / 4) ) then
			mobkit.clear_queue_high(self)	
			return true
		end
	end
	mobkit.queue_low(self, func)
end
