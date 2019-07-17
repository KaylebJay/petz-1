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


function mobkit.hq_wanderfly(self, prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) then									
			mobkit.dumbstepfly(self)
		end
	end
	mobkit.queue_high(self,func,prty)
end

function mobkit.dumbstepfly(self, tpos)
	mobkit.lq_dumbfly(self, 0.3)	
	mobkit.lq_idle(self, math.random(1,6))
end

function mobkit.node_name_in(self, where)
	local pos = self.object:get_pos()
	local yaw = self.object:get_yaw() 
	local dir_x = -math.sin(yaw) + 0.5
	local dir_z = math.cos(yaw) + 0.5
	if where == "front" then
		local pos= {
			x = pos.x + dir_x + 0.5,
			y = pos.y + 0.5,
			z = pos.z + dir_z + 0.5,
		}	
	elseif where == "top" then
		local pos= {
			x = pos.x,
			y = pos.y + 0.5,
			z = pos.z,
		}
	else
		return nil
	end
	local node = minetest.get_node_or_nil(pos)
	if node and minetest.registered_nodes[node.name] then
		return node.name
	else
		return nil
	end
end

function mobkit.lq_dumbfly(self, speed_factor)
	--local timer = 3	-- failsafe
	local func=function(self)
		local random_num = math.random(1, 500)
		if random_num <= 1 then	
			local yaw = self.object:get_yaw() or 0
			yaw = self.object:set_yaw(yaw + 1.35, 8)		
			if yaw then
				local x = math.sin(yaw) * -1
				local z = math.cos(yaw) * 1
				local y = self.object:get_velocity().y
				self.object:set_velocity({
					x = x,
					y = y,
					z = z,
				})
			end
			minetest.chat_send_player("singleplayer", "test")	
		end
		mobkit.animate(self, 'fly')
		--local node_name_in_front = mobkit.node_name_in(self, "front")
		local vel = self.object:getvelocity()
		local mob = self.object
		local pos = mob:getpos()			
		local status
		local random_num
		if status == "stand" then -- stand
			self.object:setvelocity({
				x= vel.x,
				y= 0,
				z= vel.z,
			})
			random_num = math.random(1, 100)
			if random_num < 10 and mobkit.check_height(self) == false then
				status = "ascend"				
			elseif random_num < 20 then		
				status = "descend"							
			end		
		elseif status == "descend" then -- descend
			local y			
			y = -self.max_speed * speed_factor
			self.object:setvelocity({
				x = self.max_speed* speed_factor,
				y = y,
				z = self.max_speed* speed_factor,
			})
			random_num = math.random(1, 100)
			if random_num < 10 then
				status = "ascend"
			elseif random_num < 30 then		
				status = "stand"											
			end			
		else --ascend					
			local y
			if mobkit.check_height(self) then
				y = self.max_speed * speed_factor
				status = "ascend"
			else
				y = 0
				random_num = math.random(1, 100)
				if random_num < 50 then
					status = "descend"
				else
					status = "stand"
				end
			end			
			self.object:setvelocity({
				x = self.max_speed* speed_factor,
				y = y,
				z = self.max_speed* speed_factor,
			})
		end
	end
	mobkit.queue_low(self,func)
end
