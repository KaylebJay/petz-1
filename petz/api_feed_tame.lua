local modpath, S, creative_mode = ...

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
		self.food_count = self.food_count + 1	
		mobkit.remember(self, "food_count", self.food_count)
		if self.food_count >= feed_count then			
			self.food_count = 0
			mobkit.remember(self, "food_count", 0)   
			if tame then
				if self.tamed == false then
					self.tamed = true
					mobkit.remember(self, "tamed", true)   
					if not(self.owner) or self.owner == "" then
						self.owner = clicker:get_player_name()
						mobkit.remember(self, "owner", self.owner)						
					end
					minetest.chat_send_player(clicker:get_player_name(), S("@1 has been tamed!", self.type))
					mobkit.clear_queue_high(self) -- clear behaviour (i.e. it was running away)	
					if petz.settings.tamagochi_mode == true then
						self.init_timer = true
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
        self.lashed = true
        mobkit.remember(self, "lashed", self.lashed) 
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
					self.lashing_count = 0
					mobkit.remember(self, "lashing_count", self.lashing_count)					
					self.tamed = true			
					mobkit.remember(self, "tamed", self.tamed)
					self.owner = hitter:get_player_name()
					mobkit.remember(self, "owner", self.owner)
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
