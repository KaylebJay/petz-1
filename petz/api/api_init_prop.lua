local modpath, S = ...

--
--'set_initial_properties' is call by 'on_activate' for each pet
--

petz.set_random_gender = function()	
	if math.random(1, 2) == 1 then	    
		return true
	else		
		return false
	end	
end

petz.get_gen = function(self)
	local textures_count
	if self.mutation then
		textures_count = #self.skin_colors -1
	else
		textures_count = #self.skin_colors
	end
	return math.random(1, textures_count)
end

petz.genetics_texture  = function(self, textures_count)	
	for i = 1, textures_count do
		if self.genes["gen1"] == i or self.genes["gen2"] == i then 
			return i
		end
	end
end

petz.load_vars = function(self)
	--Only specific mobs
	if self.type == "lamb" then
		self.shaved = mobkit.recall(self, "shaved") or false
		self.food_count_wool = mobkit.recall(self, "food_count_wool") or 0
	elseif self.is_mountable == true then
		self.saddle = mobkit.recall(self, "saddle") or false
		self.saddlebag = mobkit.recall(self, "saddlebag") or false		
		self.driver = mobkit.recall(self, "driver") or nil
		self.max_speed_forward = mobkit.recall(self, "max_speed_forward") or 1
		self.max_speed_reverse = mobkit.recall(self, "max_speed_reverse") or 1
		self.accel = mobkit.recall(self, "accel") or 1
		if self.has_saddlebag == true then		
			self.saddlebag_inventory = mobkit.recall(self, "saddlebag_inventory") or nil
		end
	elseif self.type == "puppy" then
		self.square_ball_attached = false --cos the square ball is detached when die/leave server...
	elseif self.type == "wolf" then
		self.wolf_to_puppy_count = mobkit.recall(self, "wolf_to_puppy_count") or petz.settings.wolf_to_puppy_count 
	end
	if self.milkable == true then
		self.milked = mobkit.recall(self, "milked") or false
	end
	if self.lay_eggs == true then
		self.eggs_count = mobkit.recall(self, "eggs_count") or 0
	end
	if self.sleep_at_night or self.sleep_at_day then
		self.sleep_start_time = mobkit.recall(self, "sleep_start_time") or 19500
		self.sleep_end_time = mobkit.recall(self, "sleep_end_time") or 23999
		--minetest.chat_send_player("singleplayer", "sleep_start_time="..tostring(self.sleep_start_time).."/sleep_end_time="..tostring(self.sleep_end_time))	
	end
	--Mobs that can have babies
	if self.breed == true then		
		self.is_male = mobkit.recall(self, "is_male") or false
		self.is_rut = mobkit.recall(self, "is_rut") or false
		self.is_pregnant = mobkit.recall(self, "is_pregnant") or false				
		self.pregnant_count = mobkit.recall(self, "pregnant_count") or petz.settings.pregnant_count 
		self.is_baby = mobkit.recall(self, "is_baby") or false
		self.genes = mobkit.recall(self, "genes") or {}
	end
	--All the mobs	
	self.tag = mobkit.recall(self, "tag") or ""
	self.show_tag = mobkit.recall(self, "show_tag") or false
	self.tamed = mobkit.recall(self, "tamed") or false
	self.owner = mobkit.recall(self, "owner") or nil
	--Insert in the table of petz by owner
	if self.owner then
		petz.insert_petz_list_by_owner(self)
	end
	self.affinity = mobkit.recall(self, "affinity") or 100
	self.fed = mobkit.recall(self, "fed") or true
	self.brushed = mobkit.recall(self, "brushed") or false
	if self.is_wild == true then
		self.lashed = mobkit.recall(self, "lashed") or false
		self.lashing_count = mobkit.recall(self, "lashing_count") or 0
	end
	self.food_count = mobkit.recall(self, "food_count") or 0
	self.beaver_oil_applied = mobkit.recall(self, "beaver_oil_applied") or false
	self.child = mobkit.recall(self, "child") or false
	self.dreamcatcher = mobkit.recall(self, "dreamcatcher") or false
	self.status = mobkit.recall(self, "status") or ""
end

function petz.set_initial_properties(self, staticdata, dtime_s)	
	local static_data_table = minetest.deserialize(staticdata)	
	local captured_mob = false
	local baby_born = false
	--minetest.chat_send_player("singleplayer", staticdata)	
	if static_data_table and static_data_table["fields"] and static_data_table["fields"]["captured"] then 
		captured_mob = true
	elseif static_data_table and static_data_table["baby_born"] and static_data_table["baby_born"] == true then
		baby_born = true	
	end
	if mobkit.recall(self, "set_vars") == nil and captured_mob == false then	--set some vars		
		--Mob Specific
		--Lamb
		if self.type == "lamb" then --set a random color 
			local random_number = math.random(1, 15)
			if random_number == 1 then
				self.texture_no = 4 --brown
			elseif random_number >= 2 and random_number <= 4 then
				self.texture_no = 3 --drak grey
			elseif random_number >= 5 and random_number <= 7 then				
				self.texture_no = 2 --grey
			else				
				self.texture_no = 1 --white, from 8 to 15
			end
			self.food_count_wool = mobkit.remember(self, "food_count_wool", 0)	
			self.shaved = mobkit.remember(self, "shaved", false)	
		elseif self.type == "panda" then
			local random_number = math.random(1, 6)
			if random_number < 6 then
				self.texture_no = 1 --black
			else
				self.texture_no = 2 --brown
			end
		elseif self.type == "elephant" then		
			self.texture_no = math.random(1, #self.skin_colors-1) --set a random texture
		elseif self.type == "puppy" then		
			self.square_ball_attached = mobkit.remember(self, "square_ball_attached", false)			
		elseif self.type == "wolf" then		
			self.wolf_to_puppy_count = mobkit.remember(self, "wolf_to_puppy_count", petz.settings.wolf_to_puppy_count)
		elseif self.is_mountable == true then		
			if baby_born == false then
				self.max_speed_forward= mobkit.remember(self, "max_speed_forward", math.random(2, 4)) --set a random velocity for walk and run
				self.max_speed_reverse= 	mobkit.remember(self, "max_speed_reverse", math.random(1, 2))				
				self.accel= mobkit.remember(self, "accel", math.random(2, 4))	
			end							
    		self.texture_no = math.random(1, #self.skin_colors-1) --set a random texture
			self.driver = mobkit.remember(self, "driver", nil)			
			--Saddlebag
			self.saddle = mobkit.remember(self, "saddle", false)		
			if self.has_saddlebag == true then			
				self.saddlebag_ref = nil
				self.saddlebag_inventory = mobkit.remember(self, "saddlebag_inventory", {})
			end
		end
		if self.sleep_at_night or self.sleep_at_day then
			local sleep_time = (self.sleep_ratio or 1) * 4499
			local sleep_max_end_time = 23999 - sleep_time
			local sleep_start_time = math.random(19500, sleep_max_end_time)
			self.sleep_start_time = mobkit.remember(self, "sleep_start_time", sleep_start_time)	
			local sleep_end_time = sleep_start_time + sleep_time					
			self.sleep_end_time = mobkit.remember(self, "sleep_end_time", sleep_end_time)	
			--minetest.chat_send_player("singleplayer", "sleep_time="..tostring(sleep_time).."/sleep_start_time="..tostring(sleep_start_time).."/sleep_end_time="..tostring(sleep_end_time))	
		end
		--Mobs that can have babies
		if self.breed == true then
			if self.is_male == nil then
				self.is_male = petz.set_random_gender() --set a random gender			
			end
			mobkit.remember(self, "is_male", self.is_male)
			self.is_rut = mobkit.remember(self, "is_rut", false)
			self.is_pregnant = mobkit.remember(self, "is_pregnant", false)
			self.pregnant_count = mobkit.remember(self, "pregnant_count", petz.settings.pregnant_count)			
			self.is_baby = mobkit.remember(self, "is_baby", false)			
			--Genetics
			self.genes = {}
			if not(self.type == "pony") then
				local genes_mutation = false
				if self.mutation and math.random(1, 200) == 1 then
					genes_mutation = true
				end
				if genes_mutation == false then
					if baby_born == false then
						self.genes["gen1"] = petz.get_gen(self)
						self.genes["gen2"] = petz.get_gen(self)
					else
						if math.random(1, 2) == 1 then
							self.genes["gen1"] = static_data_table["gen1_father"]					
						else
							self.genes["gen1"] = static_data_table["gen2_father"]
						end
						if math.random(1, 2) == 1 then
							self.genes["gen2"] = static_data_table["gen1_mother"]					
						else
							self.genes["gen2"] = static_data_table["gen2_mother"]
						end
						local textures_count
						if self.mutation then
							textures_count = #self.skin_colors - 1
						else
							textures_count = #self.skin_colors
						end
						self.texture_no = petz.genetics_texture(self, textures_count)		
					end				
				else -- mutation
					local mutation_gen = #self.skin_colors --the last skin is always the mutation
					self.genes["gen1"] = mutation_gen 
					self.genes["gen2"] = mutation_gen 
					self.texture_no = mutation_gen
				end
			end
			mobkit.remember(self, "genes", self.genes)
		end	
		if self.lay_eggs == true then
			self.eggs_count = mobkit.remember(self, "eggs_count", 0)
		end	
		--ALL the mobs
		if not(self.texture_no) then --for piggy, moth... petz with only one texture
			self.texture_no = 1
		end
		self.set_vars = mobkit.remember(self, "set_vars", true)
		self.tag = mobkit.remember(self, "tag", "")
		self.show_tag = mobkit.remember(self, "show_tag", false)
		self.tamed = mobkit.remember(self, "tamed", false)
		self.owner = mobkit.remember(self, "owner", nil)				
		self.food_count = mobkit.remember(self, "food_count", 0)							
		self.was_killed_by_player = mobkit.remember(self, "was_killed_by_player", false)	
		self.dreamcatcher = mobkit.remember(self, "dreamcatcher", false)	
		self.status = mobkit.remember(self, "status", "")
		if self.init_tamagochi_timer== true then
			petz.init_tamagochi_timer(self)
		end
		if self.has_affinity == true then
			self.affinity = mobkit.remember(self, "affinity", 100)	
		end
		if self.is_wild == true then
			self.lashed = mobkit.remember(self, "lashed", false)	
			self.lashing_count = mobkit.remember(self, "lashing_count", 0)	
		end
	elseif captured_mob == false then	
		petz.load_vars(self) --Load memory variables	
	--
	--CAPTURED MOBS
	--
	else 
		--Mob Specific		
		if self.type == "lamb" then --Lamb
			self.food_count_wool = mobkit.remember(self, "food_count_wool", tonumber(static_data_table["fields"]["food_count_wool"])) 
			self.shaved = mobkit.remember(self, "shaved", petz.to_boolean(static_data_table["fields"]["shaved"])) 		
		elseif self.type == "wolf" then
			self.wolf_to_puppy_count = mobkit.remember(self, "wolf_to_puppy_count", tonumber(static_data_table["fields"]["wolf_to_puppy_count"])) 
		end
		if self.is_mountable == true then		
			self.saddle = petz.to_boolean(static_data_table["fields"]["saddle"])	
			self.saddlebag = petz.to_boolean(static_data_table["fields"]["saddlebag"])
			self.saddlebag_inventory = minetest.deserialize(static_data_table["fields"]["saddlebag_inventory"])
			self.max_speed_forward = mobkit.remember(self, "max_speed_forward", tonumber(static_data_table["fields"]["max_speed_forward"]	)) 
			self.max_speed_reverse = mobkit.remember(self, "max_speed_reverse", tonumber(static_data_table["fields"]["max_speed_reverse"])) 
			self.accel = mobkit.remember(self, "accel", tonumber(static_data_table["fields"]["accel"])) 			
			mobkit.remember(self, "driver", nil) --no driver
		end
		if self.sleep_at_night or self.sleep_at_day then
			self.sleep_start_time = mobkit.remember(self, "sleep_start_time", tonumber(static_data_table["fields"]["sleep_start_time"])) 
			self.sleep_end_time = mobkit.remember(self, "sleep_end_time", tonumber(static_data_table["fields"]["sleep_end_time"])) 			
		end
		--Mobs that can have babies
		if self.breed == true then
			self.is_male = mobkit.remember(self, "is_male", petz.to_boolean(static_data_table["fields"]["is_male"])	) 
			self.is_rut = mobkit.remember(self, "is_rut", petz.to_boolean(static_data_table["fields"]["is_rut"])) 
			self.is_pregnant = mobkit.remember(self, "is_pregnant", petz.to_boolean(static_data_table["fields"]["is_pregnant"])) 
			self.is_baby = mobkit.remember(self, "is_baby", petz.to_boolean(static_data_table["fields"]["is_baby"])) 
			self.pregnant_count = mobkit.remember(self, "pregnant_count", tonumber(static_data_table["fields"]["pregnant_count"])) 	
			self.genes = mobkit.remember(self, "genes", minetest.deserialize(static_data_table["fields"]["genes"])) 	
		end		
		if self.lay_eggs == true then
			self.eggs_count = tonumber(static_data_table["fields"]["eggs_count"])
		end		
		--ALL the mobs		
		self.texture_no = tonumber(static_data_table["fields"]["texture_no"])
		self.set_vars = mobkit.remember(self, "set_vars", true) 		
		self.tag = mobkit.remember(self, "tag", static_data_table["fields"]["tag"]) or ""
		self.show_tag = mobkit.remember(self, "show_tag", petz.to_boolean(static_data_table["fields"]["show_tag"])) 
		self.dreamcatcher = mobkit.remember(self, "dreamcatcher", petz.to_boolean(static_data_table["fields"]["dreamcatcher"])) 
		self.status = mobkit.remember(self, "status", static_data_table["fields"]["status"]) or ""
		self.tamed = mobkit.remember(self, "tamed", petz.to_boolean(static_data_table["fields"]["tamed"]))	
		self.owner = mobkit.remember(self, "owner", static_data_table["fields"]["owner"]) 
		self.food_count = mobkit.remember(self, "food_count", tonumber(static_data_table["fields"]["food_count"])) 
		if self.has_affinity == true then
			self.affinity = mobkit.remember(self, "affinity", tonumber(static_data_table["fields"]["affinity"])) 
		end
		if self.is_wild == true then
			self.lashed = mobkit.remember(self, "lashed", false)	
			self.lashing_count = mobkit.remember(self, "lashing_count", tonumber(static_data_table["fields"]["lashing_count"]	))	
		end
	end		
	--Custom textures
	if captured_mob == true or self.breed == true then
		local texture		
		---
		---DELETE FROM THIS LINE...
		---
		if self.type == "lamb" or self.type == "pony" then
			if self.texture_no == nil then
				self.texture_no = math.random(1, #self.skin_colors)
			end
		end
		----
		----TO THIS LINE
		----
		--Mob Specific
		--Lamb
		if self.type == "lamb" then
			local shaved_string = ""
			if self.shaved == true then
				shaved_string = "_shaved"
			end
			texture = "petz_lamb".. shaved_string .."_"..self.skin_colors[self.texture_no]..".png"
		elseif self.is_mountable == true then	
			if self.saddle then
				texture = "petz_"..self.type.."_"..self.skin_colors[self.texture_no]..".png" .. "^petz_"..self.type.."_saddle.png"
			else
				texture = "petz_"..self.type.."_"..self.skin_colors[self.texture_no]..".png"
			end
			if self.saddlebag then
				texture = texture .. "^petz_"..self.type.."_saddlebag.png"
			end
		else
			texture = self.textures[self.texture_no]
		end
		mobkit.remember(self, "texture_no", self.texture_no) 	
		petz.set_properties(self, {textures = {texture}})	
	end
	if self.breed == true then
		if self.is_pregnant == true then
			if self.is_mountable == true then
				petz.init_mountable_pregnancy(self, self.max_speed_forward, self.max_speed_reverse, self.accel)				
			else
				petz.init_pregnancy(self)
			end
		elseif (self.is_baby == true) or (baby_born == true) then
			petz.set_properties(self, {
				visual_size = self.visual_size_baby,
				collisionbox = self.collisionbox_baby 
			})
			petz.init_growth(self)
		end
	end
	--ALL the mobs
	if self.is_pet and self.tamed then
		petz.update_nametag(self)
	end
	if self.status and self.status ~= "" then
		if self.status == "stand" then
			petz.standhere(self)			
		elseif self.status == "guard" then
			petz.guard(self)	
		elseif self.status == "sleep" then
			self.status = "" --reset
		else
			self.status = ""
		end
	end
end
