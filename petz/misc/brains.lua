--
-- FLY BRAIN
--

--
-- Function Helpers
--

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

function mobkit.set_velocity(self, velocity)
	local yaw = self.object:get_yaw() or 0
	self.object:set_velocity({
		x = (math.sin(yaw) * -velocity.x),
		y = velocity.y,
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
				x = pos.x +dir_x,
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

--
-- Wander Fly Behaviour (3 functions)
--

function mobkit.hq_wanderfly(self, prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) then									
			mobkit.dumbstepfly(self)
		end
	end
	mobkit.queue_high(self,func,prty)
end

function mobkit.dumbstepfly(self)
	mobkit.lq_dumbfly(self, 0.3)	
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
	local timer = 3
	local status = "ascend"
	speed_factor = speed_factor or 1
	local func = function(self)
		timer = timer - self.dtime		
		if timer < 0 then
			--minetest.chat_send_player("singleplayer", tostring(timer))		
			local velocity = self.object:getvelocity()
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
					status = "descend"
				else
					status = "stand"
				end
			else --check if water below, if yes ascend
				local node_name = mobkit.node_name_in(self, "below")
				if minetest.get_item_group(node_name, "water") > 1  then
					status = "ascend"
				end
			end	
			--minetest.chat_send_player("singleplayer", status)		
			--local node_name_in_front = mobkit.node_name_in(self, "front")
			if status == "stand" then -- stand
				velocity = {
					x= self.max_speed* speed_factor *2,
					y= 0.0,
					z= self.max_speed* speed_factor *2,
				}
				random_num = math.random(1, 100)
				if random_num < 20 and mobkit.check_height(self) == false then
					status = "descend"				
				elseif random_num < 40 then		
					status = "ascend"							
				end		
				--minetest.chat_send_player("singleplayer", "stand")			
			elseif status == "descend" then -- descend				
				velocity = {
					x = self.max_speed* speed_factor,
					y = -self.max_speed * speed_factor,
					z = self.max_speed* speed_factor,
				}
				random_num = math.random(1, 100)
				if random_num < 20 then
					status = "stand"
				elseif random_num < 40 then		
					status = "ascend"											
				end
				--minetest.chat_send_player("singleplayer", "descend")	
			elseif status == "ascend" then --ascend			
				status = "ascend"
				velocity ={
					x = self.max_speed* speed_factor,				
					y = self.max_speed * speed_factor * 2,
					z = self.max_speed* speed_factor,
				}
				--minetest.chat_send_player("singleplayer", tostring(velocity.x))
				--minetest.chat_send_player("singleplayer", "ascend")			
			end		
			timer = 3
			mobkit.set_velocity(self, velocity)
			return true
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


function mobkit.hq_liquid_recovery_flying(self, prty)	
	local func=function(self)		
		self.object:set_acceleration({ x = 0.0, y = 0.125, z = 0.0 })
		self.object:set_velocity({ x = 1.0, y = 1.0, z = 1.0 })
		if self.isinliquid == false then			
			self.object:set_acceleration({ x = 0.0, y = 0.0, z = 0.0 })
			return true
		end
	end
	mobkit.queue_high(self, func, prty)
end

--
-- Alight Behaviour ( 2 funtions)
--

function mobkit.hq_alight(self, prty)
	local func = function(self)
		local node_name = mobkit.node_name_in(self, "below")
		if node_name == "air" then
			mobkit.lq_alight(self)
		elseif minetest.get_item_group(node_name, "water") > 1  then
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
---Aquatic Brain
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
		mobkit.set_velocity(self, velocity)
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
---Bee Brain
---

function mobkit.hq_gotopollen(self, prty, tpos)
	local func = function(self)
		mobkit.lq_search_flower(self, tpos)
	end
	mobkit.queue_high(self, func, prty)
end

function mobkit.lq_search_flower(self, tpos)
	local func = function(self)				
		local pos = self.object:get_pos() --pos of the petz	
		local dir = vector.direction(pos, tpos)
		mobkit.set_velocity(self, dir)
		if vector.distance(pos, tpos) <=1 then		
			self.pollen = true
			return true
		end
	end
	mobkit.queue_low(self, func)
end
