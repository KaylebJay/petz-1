local modpath, S, creative_mode = ...

petz.insert_petz_list_by_owner = function(self)
	if self.tag ~= "" then
		if (petz.petz_list_by_owner[self.owner] == nil) then
			petz.petz_list_by_owner[self.owner] = {}
		end
		local insert = true
		for i = 1, #petz.petz_list_by_owner[self.owner] do
			if petz.petz_list_by_owner[self.owner][i] == self then
				insert = false
				break
			end
		end
		if insert == true then --if not yet
			table.insert(petz.petz_list_by_owner[self.owner], self)
		end
	end
end

petz.remove_petz_list_by_owner = function(self)
	if self.tag ~= "" then
		if petz.petz_list_by_owner[self.owner] then
			local temp_table = {}
			for key, pet in ipairs(petz.petz_list_by_owner[self.owner]) do
				if pet ~= self then
					table.insert(temp_table, pet)
					--minetest.chat_send_player("singleplayer", self.tag)	
				end
			end
			petz.petz_list_by_owner[self.owner] = temp_table
		end
	end
end

petz.set_owner = function(self, owner_name, force)
	if self.is_wild == false or force == true then -- set owner if not a monster
		self.tamed = mobkit.remember(self, "tamed", true)
		self.owner = mobkit.remember(self, "owner", owner_name)
		petz.insert_petz_list_by_owner(self)
	end
end

petz.remove_owner = function(self)
	if self.tag ~= "" then --remove from the list of petz by owner
		local pets = set_list(petz.petz_list_by_owner)
		if pets[self] then
			petz.petz_list_by_owner[self] = nil
		end
	end
	self.tamed = mobkit.remember(self, "tamed", false)
	self.owner = mobkit.remember(self, "owner", nil)
end

petz.do_feed = function(self)
	petz.set_affinity(self, true, 5)                
	self.fed = mobkit.remember(self, "fed", true)
end

--
--Feed/Tame Function
--

petz.feed_tame = function(self, clicker, wielded_item, wielded_item_name, feed_count, tame)
	-- Can eat/tame with item in hand		
	if self.follow == wielded_item_name then		
		if creative_mode == false then -- if not in creative then take item
			wielded_item:take_item()
			clicker:set_wielded_item(wielded_item)
		end		
		mobkit.heal(self, 4)	
		petz.update_nametag(self)		
		if self.hp >= self.max_hp then
			self.hp = self.max_hp
			minetest.chat_send_player(clicker:get_player_name(), S("@1 at full health (@2)", self.type, tostring(self.hp)))							
		end		
		if self.tamed== true then
			petz.update_nametag(self)
		end
		-- Feed and Tame	
		self.food_count = mobkit.remember(self, "food_count", self.food_count + 1)
		if self.food_count >= feed_count then			
			self.food_count = mobkit.remember(self, "food_count", 0)   
			if tame then
				if self.tamed == false then
					petz.set_owner(self, clicker:get_player_name(), false)
					minetest.chat_send_player(clicker:get_player_name(), S("@1 has been tamed!", self.type))
					mobkit.clear_queue_high(self) -- clear behaviour (i.e. it was running away)	
					if petz.settings.tamagochi_mode == true then
						self.init_tamagochi_timer = true
					end
				end
			end			
		end
		mobkit.make_sound(self, "moaning")
		return true
	end	
	return false
end

--
--Tame with a whip mechanic
--

-- Whip/lashing behaviour

petz.do_lashing = function(self)
    if self.lashed == false then        
        self.lashed = mobkit.remember(self, "lashed", true) 
    end
    petz.do_sound_effect("object", self.object, "petz_"..self.type.."_moaning")
end

petz.tame_whip= function(self, hitter)	
		local wielded_item_name= hitter:get_wielded_item():get_name()
		if (wielded_item_name == "petz:whip") then
    		if self.tamed == false then
    		--The mob can be tamed lashed with a whip    	                	    	
    			self.lashing_count = self.lashing_count + 1        
				if self.lashing_count >= petz.settings.lashing_tame_count then
					self.lashing_count = mobkit.remember(self, "lashing_count", 0)	 --reset to 0
					petz.set_owner(self, hitter:get_player_name(), true)					
					minetest.chat_send_player(self.owner, S("A").." "..self.type.." "..S("has been tamed."))	
					mobkit.clear_queue_high(self) -- do not attack				
				end			
			else
				if (petz.settings.tamagochi_mode == true) and (self.owner == hitter:get_player_name()) then
	        		petz.do_lashing(self)
    	    	end
    	    end
    	    petz.do_sound_effect("object", user, "petz_whip")
		end
end
