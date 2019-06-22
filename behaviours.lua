local modpath, S = ...

--
--Herbivore Behaviour
--

function petz.herbivore_brain(self)
	
	-- Die Behaviour
	
	if self.object:get_hp() <= 100 then	
		petz.on_die(self)
		return
	end
	
	if mobkit.timer(self, 1) then 
	
		local prty = mobkit.get_queue_priority(self)		
		
		if prty < 20 and self.isinliquid then
			mobkit.hq_liquid_recovery(self, 20)
			return
		end		
		
		local pos = self.object:get_pos() 		
	
		--Runaway from predator
		if prty < 18  then
			if self.predator then			
				local pred = mobkit.get_closest_entity(self, 'petz:'..self.predator)
				if pred and vector.distance(pos,pred:get_pos()) < 8 then 
					mobkit.hq_runfrom(self, 18 , pred) 
					return
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
		
		--Replace nodes by others
		
		if prty < 6 then			
			petz.replace(self)
		end
		
		--Roam default
			
		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
		end
		
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

petz.arboreal_behaviour = function(self)
		local pos = self.object:get_pos() -- check the mob pos to togle between arboreal-terrestrial
		---
		---Change behaviour status
		---
		local pos_front = petz.pos_front(self, pos)
		local node_front = minetest.get_node_or_nil(pos_front)
		local pos_under = {x = pos.x, y = pos.y - 1.0, z = pos.z, }
		local node_under = minetest.get_node_or_nil(pos_under)
		local pos_top = {x = pos.x, y = pos.y + 0.5, z = pos.z,}
		local node_top = minetest.get_node_or_nil(pos_top)		
		if node_front and minetest.registered_nodes[node_front.name]
			and node_top and minetest.registered_nodes[node_top.name]
			and node_top.name == "air"
			and (minetest.registered_nodes[node_front.name].groups.wood
			or minetest.registered_nodes[node_front.name].groups.leaves
			or minetest.registered_nodes[node_front.name].groups.tree) then				
				if not(self.behaviour == "arboreal") then 
					petz.set_behaviour(self, "arboreal", "air")		
				end
		else
			if self.behaviour == "arboreal" then
				if node_front and minetest.registered_nodes[node_front.name] 
					and (not(minetest.registered_nodes[node_front.name].groups.wood)
					or not(minetest.registered_nodes[node_front.name].groups.tree)
					or not(minetest.registered_nodes[node_front.name].groups.leaves))
					then
						self.object:set_acceleration({x = 0, y = 0, z = 0 })   					
						petz.set_behaviour(self, "terrestrial", nil)					
				elseif node_top and minetest.registered_nodes[node_top.name]				
					and not(node_top.name == "air") then
							self.object:set_acceleration({x = 0, y = 0, z = 0 })   					
							petz.set_behaviour(self, "terrestrial", nil)											
				end
			end			
		end
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

--
--Fly Behaviour
--
petz.fly_behaviour = function(self)		
	local pos
	if self == nil then
		return
	else
		pos = self.object:get_pos()
	end
	local pos_under= { 
       	x = pos.x,
       	y = pos.y - 1,
   		z = pos.z,
   	}
    local node_under = minetest.get_node_or_nil(pos_under) 
 	if node_under == nil then
		return
	end   
    if node_under.name == "air" or minetest.registered_nodes[node_under.name].groups.water then
		if self.is_flying == false then
			self.is_flying = true
			self.animation = self.animation_fly
		end
	else
		if self.is_flying == true then
			self.is_flying = false
			self.animation = self.animation_ground
		end
    end
end
