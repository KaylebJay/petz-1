local modpath, S = ...

petz.calculate_damage = function(tool_capabilities)
	local damage_points
	if tool_capabilities.damage_groups["fleshy"] ~= nil or tool_capabilities.damage_groups["fleshy"] ~= "" then		
		damage_points = tool_capabilities.damage_groups["fleshy"] or 0
		--minetest.chat_send_player("singleplayer", "hp : "..tostring(damage_points))	
	else
		damage_points = 0
	end
	return damage_points
end

petz.kick_back= function(self, dir) 
	local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
	self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
end

petz.lookat=function(self, pos2)
	local pos1=self.object:get_pos()
	local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
	local yaw = math.atan(vec.z/vec.x)-math.pi/2
	if pos1.x >= pos2.x then
		yaw = yaw+math.pi
	end
   self.object:set_yaw(yaw+math.pi)
end

petz.afraid= function(self, pos) 
	petz.lookat(self, pos)
	local x = self.object:get_velocity().x
	local z = self.object:get_velocity().z	
	local hvel = vector.multiply(vector.normalize({x= x, y= 0 ,z= z}), 4)
	mobkit.clear_queue_high(self)
	self.object:set_velocity({x= hvel.x, y= 0, z= hvel.z})
end

petz.punch_tamagochi = function (self, puncher)
    if petz.settings.tamagochi_mode == true then         
        if self.owner == puncher:get_player_name() then
            if self.affinity == nil then
                self.affinity = 100       
            end
            petz.set_affinity(self, false, 20)            
        end
    end
end

--
--on_punch event for all the Mobs
--

function petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if mobkit.is_alive(self) then
		if self.is_wild == true then
			petz.tame_whip(self, puncher)
		end
		if type(puncher) == 'userdata' and puncher:is_player() then		
			if self.dreamcatcher == true and self.owner ~= puncher:get_player_name() then --The dreamcatcher protects the petz
				return
			end
			petz.punch_tamagochi(self, puncher) --decrease affinity when in Tamagochi mode
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			petz.update_nametag(self)
			self.was_killed_by_player = petz.was_killed_by_player(self, puncher)							
		end	
		petz.kick_back(self, dir) -- kickback	
		petz.do_sound_effect("object", self.object, "petz_default_punch")	
		if self.hp <= 0 and self.driver then --important for mountable petz!
			petz.force_detach(self.driver)
		end
		if self.tamed == false and self.attack_player == false then --if you hit it, will attack player
			self.attack_player = true	
			mobkit.clear_queue_high(self)
		end
	end
end
