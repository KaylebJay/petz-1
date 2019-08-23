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
	if mobkit.node_name_in(self, "front") ~= "air" then			
		local yaw = self.object:get_yaw()
		if yaw then
			local rotation_integer = math.random(0, 5)
			local rotation_decimals = math.random()				
			local new_yaw = yaw + rotation_integer + rotation_decimals
			self.object:set_yaw(new_yaw)		
			mobkit.set_velocity(self, self.object:getvelocity())
		end
	end
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
		local vel = self.object:getvelocity()
		local velocity = {}
		local mob = self.object
		local pos = mob:getpos()			
		local random_num
		mobkit.animate(self, 'fly')
		random_num = math.random(1, 300)
		if random_num <= 1 then	
			local yaw = self.object:get_yaw()
			if yaw then
				local rotation_integer = math.random(0, 5)
				local rotation_decimals = math.random()				
				local new_yaw = yaw + rotation_integer + rotation_decimals
				self.object:set_yaw(new_yaw)		
				mobkit.set_velocity(self, self.object:getvelocity())
			end			
		end
		if mobkit.check_height(self) == false then --check if max height, then stand or descend
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
		--local node_name_in_front = mobkit.node_name_in(self, "front")
		if status == "stand" and timer < 0 then -- stand
			velocity = {
				x= vel.x*self.max_speed* speed_factor *2,
				y= 0,
				z= vel.z*self.max_speed* speed_factor *2,
			}
			mobkit.set_velocity(self, velocity)
			random_num = math.random(1, 100)
			if random_num < 20 and mobkit.check_height(self) == false then
				status = "descend"				
			elseif random_num < 40 then		
				status = "ascend"							
			end		
			--minetest.chat_send_player("singleplayer", "stand")
			return true
		elseif status == "descend"  and timer < 0 then -- descend
			local y			
			y = -self.max_speed * speed_factor
			velocity = {
				x = self.max_speed* speed_factor,
				y = y,
				z = self.max_speed* speed_factor,
			}
			mobkit.set_velocity(self, velocity)
			random_num = math.random(1, 100)
			if random_num < 20 then
				status = "stand"
			elseif random_num < 40 then		
				status = "ascend"											
			end
			--minetest.chat_send_player("singleplayer", "descend")	
			return true
		elseif timer < 0 then --ascend					
			local y
			y = self.max_speed * speed_factor * 2
			status = "ascend"
			velocity ={
				x = self.max_speed* speed_factor,				
				y = y,
				z = self.max_speed* speed_factor,
			}
			--minetest.chat_send_player("singleplayer", tostring(velocity.x))
			mobkit.set_velocity(self, velocity)
			--minetest.chat_send_player("singleplayer", "ascend")
			return true
		end
		if timer < 0 then
			timer = 3
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



--
-- AQUATIC BRAIN
--

function mobkit.hq_wanderswin(self, prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) then									
			mobkit.dumbstepswin(self)
		end
	end
	mobkit.queue_high(self,func,prty)
end

function mobkit.dumbstepswin(self)
	--mobkit.set_velocity(self, {x=1, y=0, z=1})	
	if minetest.get_item_group(mobkit.node_name_in(self, "front"), "water") < 1 then			
		local yaw = self.object:get_yaw()
		if yaw then
			local rotation_integer = math.random(0, 5)
			local rotation_decimals = math.random()				
			local new_yaw = yaw + rotation_integer + rotation_decimals
			self.object:set_yaw(new_yaw)		
			mobkit.set_velocity(self, self.object:getvelocity())
		end
	end
	mobkit.lq_dumbswin(self, 1.0)	
end

function mobkit.lq_dumbswin(self, speed_factor)
	local timer = 3
	local status = "descend"
	speed_factor = speed_factor or 1
	local func = function(self)
		timer = timer - self.dtime
		local vel = self.object:getvelocity()
		local velocity = {}
		local mob = self.object
		local pos = mob:getpos()			
		local random_num
		mobkit.animate(self, 'swin')
		random_num = math.random(1, 300)
		if random_num <= 1 then	
			local yaw = self.object:get_yaw()
			if yaw then
				local rotation_integer = math.random(0, 5)
				local rotation_decimals = math.random()				
				local new_yaw = yaw + rotation_integer + rotation_decimals
				self.object:set_yaw(new_yaw)		
				mobkit.set_velocity(self, self.object:getvelocity())
			end			
		end
		if mobkit.check_is_on_surface(self) == true then --check if mob close to surface
			random_num = math.random(1, 100)
			if random_num < 50 then
				status = "descend"
			else
				status = "stand"
			end
		else --check if water below, if no ascend
			local node_name = mobkit.node_name_in(self, "below")
			if minetest.get_item_group(node_name, "water") < 1  then
				status = "ascend"
			end
		end		
		--local node_name_in_front = mobkit.node_name_in(self, "front")
		if status == "stand" and timer < 0 then -- stand
			velocity = {
				x= vel.x*self.max_speed* speed_factor *2,
				y= 0,
				z= vel.z*self.max_speed* speed_factor *2,
			}
			mobkit.set_velocity(self, velocity)
			minetest.chat_send_player("singleplayer", "stand")
			random_num = math.random(1, 100)
			if random_num < 20 then
				status = "descend"				
			elseif random_num < 40 and mobkit.check_is_on_surface(self) == false then		
				status = "ascend"							
			end		
			return true
		elseif status == "ascend"  and timer < 0 then -- ascend
			local y			
			y = self.max_speed * speed_factor
			velocity = {
				x = self.max_speed* speed_factor,
				y = y,
				z = self.max_speed* speed_factor,
			}
			mobkit.set_velocity(self, velocity)
			minetest.chat_send_player("singleplayer", "ascend")	
			random_num = math.random(1, 100)
			if random_num < 20 then
				status = "stand"
			elseif random_num < 40 then		
				status = "descend"											
			end
			return true
		elseif timer < 0 then --descend
			local y
			y = - self.max_speed * speed_factor * 2
			status = "descend"
			velocity ={
				x = self.max_speed* speed_factor,				
				y = y,
				z = self.max_speed* speed_factor,
			}
			--minetest.chat_send_player("singleplayer", tostring(velocity.x))
			mobkit.set_velocity(self, velocity)
			minetest.chat_send_player("singleplayer", "descend")
			random_num = math.random(1, 100)
			if random_num < 20 then
				status = "stand"
			elseif random_num < 70 then		
				status = "ascend"											
			end
			return true
		end
		if timer < 0 then
			timer = 3
		end
	end
	mobkit.queue_low(self, func)
end
