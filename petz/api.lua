local modpath, modname, S = ...

petz = {}

local creative_mode = minetest.settings:get_bool("creative_mode")

--
--The Petz
--

petz.petz_list = {"kitty", "puppy", "ducky", "lamb", "lion", "calf", "panda", --A table with all the petz names
	"grizzly", "pony", "parrot", "chicken", "piggy", "wolf"}

--
--Settings
--
petz.settings = {}
petz.settings.mesh = nil
petz.settings.visual_size = {}
petz.settings.rotate = 0
petz.settings.tamagochi_safe_nodes = {} --Table with safe nodes for tamagochi mode

--
--Form Dialog
--

--Context
petz.pet = {} -- A table of pet["owner_name"]="owner_name"

petz.create_form = function(player_name)
    local pet = petz.pet[player_name]
    local form_size = {w = 4, h = 3}
    local hungrystuff_pos = {x= 0, y = 0}
    local buttonexit_pos = {x = 1, y = 6}
    local form_title = ""
    local tamagochi_form_stuff = ''
    local affinity_stuff = ''
    local form_orders = ''
    local more_form_orders = ''
    local final_form = ''	
    local pet_icon = "image[0,0;1,1;petz_spawnegg_"..pet.type..".png]"
    if pet.affinity == nil then
       pet.affinity = 0
    end
    if petz.settings.tamagochi_mode == true then     
    	form_size.w= form_size.w + 1
		if pet.has_affinity == true then
			form_title = S("Orders")
			hungrystuff_pos = {x= 3, y = 2}
			affinity_stuff =
				"image[3,3;1,1;petz_affinity_heart.png]"..
				"label[4,3;".. tostring(pet.affinity).."%]"
		else
			form_size.w= form_size.w
			form_size.h= form_size.h + 1
			form_title = S("Status")
			hungrystuff_pos = {x= 1, y = 3}
		end
		tamagochi_form_stuff = 
            pet_icon ..
            "label[1,2;".. form_title .."]"..
            "image[".. hungrystuff_pos.x ..",".. hungrystuff_pos.y ..";1,1;petz_pet_bowl_inv.png]"..
            affinity_stuff            
        local hungry_label = ""
        if pet.fed == false then
            hungry_label = "Hungry"
        else
            hungry_label = "Satiated"
        end
        tamagochi_form_stuff = tamagochi_form_stuff .. "label[".. hungrystuff_pos.x +1 ..",".. hungrystuff_pos.y ..";"..S(hungry_label).."]"
    else
        tamagochi_form_stuff = pet_icon 
        if pet.has_affinity == true then
			tamagochi_form_stuff = tamagochi_form_stuff .. "label[1,2;".. S("Orders") .."]"	
		end
    end
    if pet.is_pet == true and pet.tamed == true then
		if not(pet.tag) then
			pet.tag = ""
		end
		local selected
		if pet.show_tag == true then
			selected = "true"
		else
			selected = "false"
		end
		tamagochi_form_stuff = tamagochi_form_stuff..
		"field[1,1;2,1;ipt_name;"..S("Name")..":"..";"..pet.tag.."]"..		
		"checkbox[3,1;btn_show_tag;"..S("Show tag")..";"..selected.."]"
	end
	if pet.breed == true then --Show the Gender
		local gender = ''
		if pet.is_male == true then
			gender = S("Male")
		else
			gender = S("Female")
		end				
		tamagochi_form_stuff = tamagochi_form_stuff..
			"label[3,0;"..gender.."]"
		local pregnant_icon_x
		local pregnant_icon_y 
		local pregnant_text_x
		local pregnant_text_y
		local infertile_text_x
		local infertile_text_y
		if pet.type == "pony" then
			pregnant_icon_x = 3
			pregnant_icon_y = 5
			pregnant_text_x = 4
			pregnant_text_y = 5
			infertile_text_x = 3 
			infertile_text_y = 5
		else			
			pregnant_icon_x = 3
			pregnant_icon_y = 2
			pregnant_text_x = 4
			pregnant_text_y = 2
			infertile_text_x = 3 
			infertile_text_y = 3
		end			
		if pet.is_male == false and pet.is_pregnant == true then
			tamagochi_form_stuff = tamagochi_form_stuff..
				"image["..pregnant_icon_x..","..pregnant_icon_y..";1,1;petz_"..pet.type.."_pregnant_icon.png]"..
				"label["..pregnant_text_x..","..pregnant_text_y..";"..S("Pregnant").."]"
		elseif pet.is_male == false and pet.pregnant_count <= 0 then
			tamagochi_form_stuff = tamagochi_form_stuff..				
				"label["..infertile_text_x..","..infertile_text_y..";"..S("Infertile").."]"
		end
	end
    if pet.type == "parrot" then
		form_size.h = form_size.h + 1
		buttonexit_pos.y = buttonexit_pos.y + 1
		more_form_orders = more_form_orders..
		"button_exit[0,6;1,1;btn_alight;"..S("Alight").."]"	..
		"button_exit[1,6;1,1;btn_fly;"..S("Fly").."]"..
		"button_exit[2,6;2,1;btn_perch_shoulder;"..S("Perch on shoulder").."]"
	elseif pet.type == "pony" then		
		more_form_orders = more_form_orders..			
			"image[3,4;1,1;petz_pony_velocity_icon.png]"..
			"label[4,4;".. tostring(pet.max_speed_forward).."/"..tostring(pet.max_speed_reverse)..'/'..tostring(pet.accel).."]"
    end
    if pet.give_orders == true then
		form_size.h= form_size.h + 4
		form_size.w= form_size.w + 1
		form_orders =
			"button_exit[0,3;3,1;btn_followme;"..S("Follow me").."]"..
			"button_exit[0,4;3,1;btn_standhere;"..S("Stand here").."]"..
			"button_exit[0,5;3,1;btn_ownthing;"..S("Do your own thing").."]"..	
			more_form_orders
	else
		if petz.settings.tamagochi_mode == true then
			buttonexit_pos.y = buttonexit_pos.y - 2
			form_size.h= form_size.h + 1
		else
			buttonexit_pos.y = buttonexit_pos.y - 4
			form_size.w= form_size.w + 1
		end
    end
    final_form =
		"size["..form_size.w..","..form_size.h..";]"..
		tamagochi_form_stuff..        
		form_orders..
		"button_exit["..buttonexit_pos.x..","..buttonexit_pos.y..";1,1;btn_close;"..S("Close").."]"
	return final_form
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if (formname ~= "petz:form_orders") then
		return false
	end
    local pet = petz.pet[player:get_player_name()] 
	if pet and pet.object then	
		--brewing.magic_sound("to_player", player, "brewing_select")
		if fields.btn_followme then
			if not(pet.can_fly) then
				mobkit.clear_queue_low(pet)
				mobkit.hq_follow(pet, 15, player)
			end			
		elseif fields.btn_standhere then
			mobkit.clear_queue_high(pet)
			petz.stand(pet)
			mobkit.lq_idle(pet, 2400)		
			if pet.can_fly == true then						
				if mobkit.node_name_in(pet, "below") == "air" then		
					mobkit.animate(pet, "fly")
				else					
					mobkit.animate(pet, "stand")
				end
			end
		elseif fields.btn_ownthing then
			mobkit.clear_queue_low(pet)			
			petz.ownthing(pet)
		elseif fields.btn_alight then
			mobkit.clear_queue_low(pet)
			mobkit.clear_queue_high(pet)	
			if not(mobkit.node_name_in(pet, "below") == "air") then		
				mobkit.animate(pet, "fly")				
			end					
			mobkit.hq_alight(pet, 0)			
		elseif fields.btn_fly then	
			mobkit.clear_queue_low(pet)		
			mobkit.clear_queue_high(pet)	
			pet.mov_status = "free"
			mobkit.hq_fly(pet, 0)		
			minetest.after(2.5, function(pet) 
				mobkit.clear_queue_low(pet)
				pet.object:set_acceleration({ x = 0, y = 0, z = 0 })    
				pet.object:set_velocity({ x = 0, y = 0, z = 0 })    
			end, pet)			
		elseif fields.btn_perch_shoulder then
			pet.object:set_attach(player, "Arm_Left", {x=0.5,y=-6.25,z=0}, {x=0,y=0,z=180}) 
			mobkit.animate(pet, "stand")	
			minetest.after(120.0, function(pet) 
				pet.object:set_detach()
			end, pet)
		elseif fields.btn_show_tag then			
			pet.show_tag = petz.to_boolean(fields.btn_show_tag)
			mobkit.remember(pet, "show_tag", pet.show_tag)
		end
		if fields.ipt_name then
			pet.tag = string.sub(fields.ipt_name, 1 , 12)
			mobkit.remember(pet, "tag", pet.tag)
		end
		petz.update_nametag(pet)
		return true
	else
		return false
	end
end)

petz.ownthing = function(self)	
	self.mov_status = "free"
	mobkit.hq_roam(self, 0)
	mobkit.clear_queue_high(self)
end

petz.stand = function(self)	
	self.mov_status = "stand"	
	self.object:set_velocity({ x = 0, y = 0, z = 0 })   
	self.object:set_acceleration({ x = 0, y = 0, z = 0 }) 
	mobkit.clear_queue_high(self)
end

--
--Misc Functions
--

function petz:split(inSplitPattern, outResults)
  if not inSplitPattern then
    inSplitPattern = ','
  end
  if not outResults then
    outResults = { }
  end
  self = self:gsub("%s+", "") --firstly trim spaces
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  while theSplitStart do
    table.insert(outResults, string.sub(self, theStart, theSplitStart-1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  end
  table.insert(outResults, string.sub(self, theStart))
  return outResults
end

function petz.to_boolean(val)
	if val and (val == "true" or val == 1) then
		return true
	else
		return false
	end	
end

--
--The Tamagochi Mode
--

-- Increase/Descrease the pet affinity

petz.set_affinity = function(self, increase, amount)
    local new_affinity    
    if increase == true then
        new_affinity = self.affinity +  amount
    else
        new_affinity = self.affinity - amount
    end
    if new_affinity > 100 then
        new_affinity = 100
    elseif new_affinity < 0 then     
        new_affinity = 0
    end
    self.affinity = new_affinity
    mobkit.remember(self, "affinity", self.affinity)
end

--The Tamagochi Timer

petz.init_timer = function(self)	
    if (petz.settings.tamagochi_mode == true) and (self.tamed == true) and (self.init_timer == true) then
        petz.timer(self)
        return true
    else
        return false
    end
end

local function round(x, n)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

--
--Tamagochi Mode Timer
--

petz.timer = function(self)
    minetest.after(petz.settings.tamagochi_check_time, function(self)         
        if not(self.object== nil) then
			if (not(minetest.is_singleplayer())) and (petz.settings.tamagochi_check_if_player_online == true) then
				if minetest.player_exists(self.owner) == false then --if pet owner is not online
					return
				end
			end       
            local pos = self.object:get_pos()
            if not(pos == nil) then --important for if the pet dies
                local pos_below = {
                    x = pos.x,
                    y = pos.y - 1.5,
                    z = pos.z,
                }
                local node = minetest.get_node_or_nil(pos_below)
                --minetest.chat_send_player(self.owner, petz.settings.tamagochi_safe_node)
                for i = 1, #petz.settings.tamagochi_safe_nodes do --loop  thru all safe nodes
                    if node and (node.name == petz.settings.tamagochi_safe_nodes[i]) then
						self.init_timer = true
						mobkit.remember(self, "init_timer", self.init_timer)    
                        return
                    end    
                end                
            else  --if the pos is nil, it means that the pet died before 'minetest.after_effect'
                self.init_timer = false
                mobkit.remember(self, "init_timer", self.init_timer)   --so no more timer
                return
            end
            --Decrease affinitty always a bit amount because the pet lost some affinitty	
            if self.has_affinity == true then
				petz.set_affinity(self, false, 10)
			end
            --Decrease health if pet has not fed
            if self.fed == false then				
				local damage_amount = - petz.settings.tamagochi_hunger_damage
				mobkit.hurt(self, damage_amount)
				petz.update_nametag(self)
                if (self.hp > 0)  and (self.has_affinity == true) then
					petz.set_affinity(self, false, 33)
				end                
            else
                self.fed = false
                mobkit.remember(self, "fed", self.fed) --Reset the variable
            end
            --If the pet has not brushed            
            if self.can_be_brushed == true then				
				if self.brushed == false then
					if self.has_affinity == true then
						petz.set_affinity(self, false, 20)
					end
				else
					self.brushed = false
					mobkit.remember(self, "brushed", self.brushed) --Reset the variable
				end
			end
            --If the petz is a lion had to been lashed
            if self.type== "lion" then				
                if self.lashed == false then
                    petz.set_affinity(self, false, 25)                
                else
                    self.lashed = false
                    mobkit.remember(self, "lashed", self.lashed)
                end
            end            
            --If the pet starves to death            
            if self.hp <= 0 then
                minetest.chat_send_player(self.owner, S("Your").. " "..self.type.." "..S("has starved to death!!!"))
                self.init_timer  = false -- no more timing
            --I the pet get bored of you
            elseif (self.has_affinity == true) and (self.affinity == 0) then
                minetest.chat_send_player(self.owner, S("Your").." "..self.type.." "..S("has abandoned you!!!"))
                petz.delete_nametag(self)
                self.owner = "" --the pet abandon you
                mobkit.remember(self, "owner", self.owner)
                self.tamed = false
                mobkit.remember(self, "tamed", self.tamed)
                self.init_timer  = false -- no more timing
            --Else reinit the timer, to check again in the future
            else
                self.init_timer  = true
            end
        end
    end, self)
    self.init_timer = false --the timer is reinited in the minetest.after function
end

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

petz.get_second_gen = function(self)
	return math.random(1, #self.skin_colors-1)
end

petz.genetics_lamb_texture  = function(self)	
	if self.genes["gen1"] == 1 or self.genes["gen2"] == 1 then 
		return 1
	elseif self.genes["gen1"] == 2 or self.genes["gen2"] == 2 then
		return 2
	elseif self.genes["gen1"] == 3 or self.genes["gen2"] == 3 then
		return 3
	elseif self.genes["gen1"] == 4 or self.genes["gen2"] == 4 then
		return 4
	else
		return 5
	end
end

petz.load_vars = function(self)
	--Only specific mobs
	if self.type == "lamb" then
		self.shaved = mobkit.recall(self, "shaved") or false
		self.food_count_wool = mobkit.recall(self, "food_count_wool") or 0
	elseif self.type == "calf" then
		self.milked = mobkit.recall(self, "milked") or false
	elseif self.type == "pony" then
		self.saddle = mobkit.recall(self, "saddle") or false
		self.driver = mobkit.recall(self, "driver") or false
		self.max_speed_forward = mobkit.recall(self, "max_speed_forward") or 1
		self.max_speed_reverse = mobkit.recall(self, "max_speed_reverse") or 1
		self.accel = mobkit.recall(self, "accel") or 1
	elseif self.type == "puppy" then
		self.square_ball_attached = false --cos the square ball is detached when die/leave server...
	elseif self.type == "wolf" then
		self.wolf_to_puppy_count = mobkit.recall(self, "wolf_to_puppy_count") or petz.settings.wolf_to_puppy_count 
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
		if self.type == "lamb" and petz.settings.type_model == "mesh" then --set a random color 
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
			self.food_count_wool = 0
			mobkit.remember(self, "food_count_wool", self.food_count_wool)	
			self.shaved = false
			mobkit.remember(self, "shaved", self.shaved)			
		elseif self.type == "puppy" then		
			self.square_ball_attached = false
			mobkit.remember(self, "square_ball_attached", self.square_ball_attached)			
		elseif self.type == "wolf" then		
			self.wolf_to_puppy_count = petz.settings.wolf_to_puppy_count
			mobkit.remember(self, "wolf_to_puppy_count", self.wolf_to_puppy_count)
		elseif self.type == "pony" then		
			if baby_born == false then
				self.max_speed_forward= math.random(2, 4) --set a random velocity for walk and run
				mobkit.remember(self, "max_speed_forward", self.max_speed_forward)				
				self.max_speed_reverse= math.random(2, 4)	
				mobkit.remember(self, "max_speed_reverse", self.max_speed_reverse)				
				self.accel= math.random(2, 4)	
				mobkit.remember(self, "accel", self.accel)	
			end							
    		self.texture_no = math.random(1, #self.skin_colors) --set a random texture
			self.driver = false
			mobkit.remember(self, "driver", self.driver)			
		end
		--Mobs that can have babies
		if self.breed == true then
			self.is_male = petz.set_random_gender() --set a random gender			
			mobkit.remember(self, "is_male", self.is_male)
			self.is_rut = false
			mobkit.remember(self, "is_rut", self.is_rut)
			self.is_pregnant = false
			mobkit.remember(self, "is_pregnant", self.is_pregnant)
			self.pregnant_count = petz.settings.pregnant_count
			mobkit.remember(self, "pregnant_count", self.pregnant_count)			
			self.is_baby = false
			mobkit.remember(self, "is_baby", self.is_baby)			
			--Genetics
			self.genes = {}
			if not(self.type == "pony") then
				local genes_mutation = false
				if math.random(1, 200) == 1 then
					genes_mutation = true
				end
				if genes_mutation == false then
					if baby_born == false then
						self.genes["gen1"] = self.texture_no
						self.genes["gen2"] = petz.get_second_gen(self)
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
						self.texture_no = petz.genetics_lamb_texture(self)		
					end				
				else -- mutation
					self.genes["gen1"] = 5 --vanilla
					self.genes["gen2"] = 5 -- vanilla
					self.texture_no = 5 -- vanilla
				end
			end
			mobkit.remember(self, "genes", self.genes)
		end		
		--ALL the mobs
		self.set_vars = true
		mobkit.remember(self, "set_vars", self.set_vars)
		self.tag = ""
		mobkit.remember(self, "tag", self.tag)
		self.show_tag = false
		mobkit.remember(self, "show_tag", self.show_tag)
		self.tamed = false
		mobkit.remember(self, "tamed", self.tamed)
		self.owner = ""
		mobkit.remember(self, "owner", self.owner)				
		self.food_count = 0
		mobkit.remember(self, "food_count", self.food_count)							
		self.was_killed_by_player = false
		mobkit.remember(self, "was_killed_by_player", self.was_killed_by_player)	
		if self.init_timer== true then
			petz.init_timer(self)
		end
		if self.has_affinity == true then
			self.affinity = 100
			mobkit.remember(self, "affinity", self.affinity)	
		end
		if self.is_wild == true then
			self.lashed = false
			mobkit.remember(self, "lashed", self.lashed)	
			self.lashing_count = 0
			mobkit.remember(self, "lashing_count", self.lashing_count)	
		end
	elseif captured_mob == false then	
		petz.load_vars(self) --Load memory variables			
	--
	--CAPTURED MOBS
	--
	else 
		--Mob Specific		
		if self.type == "lamb" then --Lamb
			self.food_count_wool = tonumber(static_data_table["fields"]["food_count_wool"])
			mobkit.remember(self, "food_count_wool", self.food_count_wool) 
			self.shaved = petz.to_boolean(static_data_table["fields"]["shaved"])				
			mobkit.remember(self, "shaved", self.shaved) 		
		elseif self.type == "wolf" then
			self.wolf_to_puppy_count = tonumber(static_data_table["fields"]["wolf_to_puppy_count"])
			mobkit.remember(self, "wolf_to_puppy_count", self.wolf_to_puppy_count) 
		elseif self.type == "pony" then		
			self.max_speed_forward =  tonumber(static_data_table["fields"]["max_speed_forward"]	)
			mobkit.remember(self, "max_speed_forward", self.max_speed_forward) 
			self.max_speed_reverse = tonumber(static_data_table["fields"]["max_speed_reverse"])
			mobkit.remember(self, "max_speed_reverse", self.max_speed_reverse) 
			self.accel = tonumber(static_data_table["fields"]["accel"])			
			mobkit.remember(self, "accel", self.accel) 
			mobkit.remember(self, "saddle", false) --no shaddle
			mobkit.remember(self, "driver", false) --no driver
		end
		--Mobs that can have babies
		if self.breed == true then
			self.is_male = petz.to_boolean(static_data_table["fields"]["is_male"])			
			mobkit.remember(self, "is_male", self.is_male) 
			self.is_rut = petz.to_boolean(static_data_table["fields"]["is_rut"])
			mobkit.remember(self, "is_rut", self.is_rut) 
			self.is_pregnant = petz.to_boolean(static_data_table["fields"]["is_pregnant"])
			mobkit.remember(self, "is_pregnant", self.is_pregnant) 
			self.is_baby = petz.to_boolean(static_data_table["fields"]["is_baby"])
			mobkit.remember(self, "is_baby", self.is_baby) 
			self.pregnant_count = tonumber(static_data_table["fields"]["pregnant_count"])
			mobkit.remember(self, "pregnant_count", self.pregnant_count) 	
			self.genes = minetest.deserialize(static_data_table["fields"]["genes"])
			mobkit.remember(self, "genes", self.genes) 	
		end		
		--ALL the mobs
		self.texture_no = tonumber(static_data_table["fields"]["texture_no"])
		self.set_vars = true
		mobkit.remember(self, "set_vars", self.set_vars) 		
		self.tag = static_data_table["fields"]["tag"]	
		mobkit.remember(self, "tag", self.tag) 
		self.show_tag = petz.to_boolean(static_data_table["fields"]["show_tag"])
		mobkit.remember(self, "show_tag", self.show_tag) 
		self.tamed = petz.to_boolean(static_data_table["fields"]["tamed"])		
		mobkit.remember(self, "tamed", self.tamed)	
		self.owner = static_data_table["fields"]["owner"]	
		mobkit.remember(self, "owner", self.owner) 
		self.food_count = tonumber(static_data_table["fields"]["food_count"])
		mobkit.remember(self, "food_count", self.food_count) 
		if self.has_affinity == true then
			self.affinity = tonumber(static_data_table["fields"]["affinity"])
			mobkit.remember(self, "affinity", self.affinity) 
		end
		if self.is_wild == true then
			self.lashed = false
			mobkit.remember(self, "lashed", self.lashed)	
			self.lashing_count = tonumber(static_data_table["fields"]["lashing_count"]	)
			mobkit.remember(self, "lashing_count", self.lashing_count)	
		end
	end		
	--Custom textures
	if captured_mob == true or self.type == "lamb" or self.type == "pony" then
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
		elseif self.type == "pony" then	
			if self.saddle then
				texture = "petz_pony_"..self.skin_colors[self.texture_no]..".png" .. "^petz_pony_saddle.png"
			else
				texture = "petz_pony_"..self.skin_colors[self.texture_no]..".png"
			end
		else
			texture = self.textures[self.texture_no]
		end
		mobkit.remember(self, "texture_no", self.texture_no) 	
		petz.set_properties(self, {textures = {texture}})	
	end
	if self.breed == true then
		if self.is_pregnant == true then
			if self.type == "pony" then
				petz.init_pony_pregnancy(self, self.max_speed_forward, self.max_speed_reverse, self.accel)				
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
end

--
--Replace Engine
--

petz.replace = function(self)
	if not self.replace_rate or not self.replace_what or self.child == true or self.object:get_velocity().y ~= 0 or math.random(1, self.replace_rate) > 1 then
		return
	end
	local pos = self.object:get_pos()
	local what, with, y_offset
	if type(self.replace_what[1]) == "table" then
		local num = math.random(#self.replace_what)
		what = self.replace_what[num][1] or ""
		with = self.replace_what[num][2] or ""
		y_offset = self.replace_what[num][3] or 0
	else
		what = self.replace_what
		with = self.replace_with or ""
		y_offset = self.replace_offset or 0
	end
	pos.y = pos.y + y_offset
	if #minetest.find_nodes_in_area(pos, pos, what) > 0 then
		local oldnode = {name = what}
		local newnode = {name = with}
		local on_replace_return
		if self.on_replace then
			on_replace_return = self:on_replace(pos, oldnode, newnode)
		end
		if on_replace_return ~= false then
			minetest.set_node(pos, {name = with})
		end
	end
end

--
-- Drop Items Engine
--

petz.drop_items = function(self)	
	if not self.drops or #self.drops == 0 then 	-- check for nil or no drops
		return
	end	
	if self.child then -- no drops for child mobs
		return
	end	
	local death_by_player = self.was_killed_by_player or nil -- was mob killed by player?
	local obj, item, num
	local pos = self.object:get_pos()
	for n = 1, #self.drops do
		if math.random(1, self.drops[n].chance) == 1 then
			num = math.random(self.drops[n].min or 0, self.drops[n].max or 1)
			item = self.drops[n].name
			if death_by_player then	-- only drop rare items (drops.min=0) if killed by player
				obj = minetest.add_item(pos, ItemStack(item .. " " .. num))
			elseif self.drops[n].min ~= 0 then
				obj = minetest.add_item(pos, ItemStack(item .. " " .. num))
			end
			if obj and obj:get_luaentity() then
				obj:set_velocity({
					x = math.random(-10, 10) / 9,
					y = 6,
					z = math.random(-10, 10) / 9,
				})
			elseif obj then
				obj:remove() -- item does not exist
			end
		end
	end
	self.drops = {}
end

--
--Lamb Functions
--

petz.lamb_wool_regrow = function(self)	
	if self.shaved == false then --only count if the lamb is shaved
		return
	end	
	self.food_count_wool = self.food_count_wool + 1
	mobkit.remember(self, "food_count_wool", self.food_count_wool)
	if self.food_count_wool >= 5 then -- if lamb replaces 5x grass then it regrows wool
		self.food_count_wool = 0
		mobkit.remember(self, "food_count_wool", self.food_count_wool)
		self.shaved = false
		mobkit.remember(self, "shaved", self.shaved)				
		local lamb_texture = "petz_lamb_"..self.skin_colors[self.texture_no]..".png"
		petz.set_properties(self, {textures = {lamb_texture}})
	end
end

petz.lamb_wool_shave = function(self, clicker)
	local inv = clicker:get_inventory()	
	local new_stack = "wool:"..self.skin_colors[self.texture_no]
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		minetest.add_item(self.object:get_pos(), new_stack)
	end
    petz.do_sound_effect("object", self.object, "petz_lamb_moaning")
    local lamb_texture = "petz_lamb_shaved_"..self.skin_colors[self.texture_no]..".png"
	if petz.settings.type_model == "mesh" then
		petz.set_properties(self, {textures = {lamb_texture}})		
	else
		petz.set_properties(self, {tiles = petz.lamb.tiles_shaved})		
	end 
	petz.mob_sound(self, "petz_lamb_moaning.ogg", 1.0, 10)	
	self.shaved = true
	mobkit.remember(self, "shaved", self.shaved)        
	self.food_count_wool = 0 --reset the food count
	mobkit.remember(self, "food_count_wool", self.food_count_wool)	
	petz.afraid(self, clicker:get_pos())
end

--
--Capture Mobs Mechanics
--

--
-- Register Egg
--

function petz:register_egg(pet_name, desc, inv_img, no_creative)
	local grp = {spawn_egg = 1}
	minetest.register_craftitem(pet_name .. "_set", { -- register new spawn egg containing mob information
		description = S("@1 (Tamed)", desc),
		inventory_image = inv_img,
		groups = {spawn_egg = 2},
		stack_max = 1,
		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above
			-- am I clicking on something with existing on_rightclick function?
			local under = minetest.get_node(pointed_thing.under)
			local def = minetest.registered_nodes[under.name]
			if def and def.on_rightclick then
				return def.on_rightclick(pointed_thing.under, under, placer, itemstack)
			end
			if pos and not minetest.is_protected(pos, placer:get_player_name()) then
				if not minetest.registered_entities[pet_name] then
					return
				end
				pos.y = pos.y + 1
				local meta = itemstack:get_meta()				
				local meta_table = meta:to_table()
				local sdata = minetest.serialize(meta_table)
				local mob = minetest.add_entity(pos, pet_name, sdata)
				local ent = mob:get_luaentity()
				-- set owner if not a monster
				if ent.is_wild == false then					
					ent.owner = placer:get_player_name()
					mobkit.remember(ent, "owner", ent.owner)
					ent.tamed = true
					mobkit.remember(ent, "tamed", ent.tamed)
				end
				itemstack:take_item() -- since mob is unique we remove egg once spawned
			end
			return itemstack
		end,
	})
end

petz.check_capture_items = function(self, wielded_item_name, clicker, check_inv_room)	
	local capture_item_type
	if wielded_item_name == "mobs:lasso" or wielded_item_name == "petz:lasso" then
		capture_item_type = "lasso"
	elseif (wielded_item_name == "mobs:net") or (wielded_item_name == "fireflies:bug_net") then
		capture_item_type = "net"
	else		
		return false
	end
	if capture_item_type == self.capture_item then
		if check_inv_room == true then
			--check for room in inventory
			local inv = clicker:get_inventory()
			if inv:room_for_item("main", ItemStack("air")) then
				return true
			else
				minetest.chat_send_player(clicker:get_player_name(), S("No room in your inventory to capture it."))
				return false				
			end
		else
			return true
		end
	else
		return false
	end
end

petz.capture = function(self, clicker)
	local new_stack = ItemStack(self.name .. "_set") 	-- add special mob egg with all mob information
	local stack_meta = new_stack:get_meta()	
	--local sett ="---TABLE---: "
	for key, value in pairs(self) do
		local t = type(value)
		if  t ~= "function" and t ~= "nil" and t ~= "userdata" then
			stack_meta:set_string(key, self[key])	
			--sett= sett .. ", ".. tostring(key).." : ".. tostring(self[key])
			--minetest.chat_send_player("singleplayer", sett)				
		end
	end	
	--Save some extra values-->
	stack_meta:set_string("captured", "true") --mark as captured
	stack_meta:set_string("texture_no", tostring(self.texture_no)) --Save the current texture_no
	stack_meta:set_string("tamed", tostring(self.tamed))	 --Save if tamed	
	stack_meta:set_string("tag", self.tag) --Save the current tag
	stack_meta:set_string("show_tag", tostring(self.show_tag))
	if self.type == 'lamb' then
		stack_meta:set_string("shaved", tostring(self.shaved))	 --Save if shaved
	elseif self.type == 'pony' then
		stack_meta:set_string("max_speed_forward", tostring(self.max_speed_forward))
		stack_meta:set_string("max_speed_reverse", tostring(self.max_speed_reverse))
		stack_meta:set_string("accel", tostring(self.accel))
	end
	if self.breed == true then
		stack_meta:set_string("is_male", tostring(self.is_male))
		stack_meta:set_string("is_rut", tostring(self.is_rut))
		stack_meta:set_string("is_baby", tostring(self.is_baby))
		stack_meta:set_string("is_pregnant", tostring(self.is_pregnant))
		stack_meta:set_string("pregnant_count", tostring(self.pregnant_count))
		stack_meta:set_string("genes", minetest.serialize(self.genes))
	end
	local inv = clicker:get_inventory()	
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		minetest.add_item(clicker:get_pos(), new_stack)
	end
	self.object:remove()
end

--
--on_punch event for all the Mobs
--
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

petz.do_punch = function(self, puncher, tool_capabilities)
	local puncher_pos = puncher:get_pos()
	local petz_pos = self.object:get_pos()
	if vector.distance(puncher_pos, petz_pos) <= 5 then	-- a way to decrease punch range without dependences		
		--minetest.chat_send_player("singleplayer", "OLD hp : "..tostring(petz_hp))	
		local weapon_damage = petz.calculate_damage(tool_capabilities)
		--minetest.chat_send_player("singleplayer", "damage points: ".. weapon_damage)	
		mobkit.hurt(self, weapon_damage)
		petz.update_nametag(self)
		--minetest.chat_send_player("singleplayer", "NEW hp : "..tostring(new_hp))	
	end
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

function petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if mobkit.is_alive(self) then
		if self.is_wild == true then
			petz.tame_whip(self, puncher)
		end
		if type(puncher) == 'userdata' and puncher:is_player() then		
			petz.punch_tamagochi(self, puncher) --decrease affinity when in Tamagochi mode
			--petz.do_punch(self, puncher, tool_capabilities)
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			petz.update_nametag(self)
			self.was_killed_by_player = petz.was_killed_by_player(self, puncher)							
		end	
		petz.kick_back(self, dir) -- kickback	
		petz.do_sound_effect("object", self.object, "petz_default_punch")	
		if self.hp <= 0 and self.driver then --important for ponies!		
			petz.force_detach(self.driver)
		end
	end
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

petz.wolf_to_puppy= function(self, player_name)
	self.wolf_to_puppy_count = self.wolf_to_puppy_count - 1	
	mobkit.remember(self, "wolf_to_puppy_count", self.wolf_to_puppy_count)
	if self.wolf_to_puppy_count <= 0 then
		local pos = self.object:get_pos()
		local puppy = minetest.add_entity(pos, "petz:puppy")
		local puppy_entity = puppy:get_luaentity()
		puppy_entity.tamed = true
		mobkit.remember(puppy_entity, "tamed", puppy_entity.tamed)
		puppy_entity.owner = player_name 
		mobkit.remember(puppy_entity, "owner", puppy_entity.owner)
		self.object:remove()	
		minetest.chat_send_player(player_name , S("The wolf turn into puppy."))
	end	
end

--
--on_rightclick event for all the Mobs
--

petz.on_rightclick = function(self, clicker)
        if not(clicker:is_player()) then
            return false
        end
        local player_name = clicker:get_player_name()
        local wielded_item = clicker:get_wielded_item()
        local wielded_item_name = wielded_item:get_name()
        local show_form = false
        if ((self.is_pet == true) and (self.owner == player_name) and (self.can_be_brushed == true))-- If brushing or spread beaver oil
            and ((wielded_item_name == "petz:hairbrush") or (wielded_item_name == "petz:beaver_oil")) then                       
                if petz.settings.tamagochi_mode == true then
                    if wielded_item_name == "petz:hairbrush" then
                        if self.brushed == false then
                            petz.set_affinity(self, true, 5)
                            self.brushed = true
                            mobkit.remember(self, "brushed", self.brushed) 
                        else
                            minetest.chat_send_player(self.owner, S("Your").." "..self.type.." "..S("had already been brushed."))
                        end                
                    else --it's beaver_oil						
                        if self.beaver_oil_applied == false then
                            petz.set_affinity(self, true, 20)
                            self.beaver_oil_applied = true
                            mobkit.remember(self, "beaver_oil_applied", self.beaver_oil_applied)
                        else 
                            minetest.chat_send_player(self.owner, S("Your").." "..self.type.." "..S("had already been spreaded with beaver oil."))
                        end     
                    end
                end
                petz.do_sound_effect("object", self.object, "petz_brushing")
                petz.do_particles_effect(self.object, self.object:get_pos(), "star")
        --If feeded
        elseif petz.feed_tame(self, clicker, wielded_item, wielded_item_name, 5, true) then
            if petz.settings.tamagochi_mode == true and self.fed == false then
                petz.set_affinity(self, true, 5)                
                self.fed = true
                mobkit.remember(self, "fed", self.fed)            
            end
            if self.type == "lamb" then     
                petz.lamb_wool_regrow(self)                       
            elseif self.type == "calf" then     
                petz.calf_milk_refill(self)
            elseif self.type == "wolf" and wielded_item_name == "petz:bone" then
				petz.wolf_to_puppy(self, player_name)
            end     
            petz.do_sound_effect("object", self.object, "petz_"..self.type.."_moaning")
            petz.do_particles_effect(self.object, self.object:get_pos(), "heart")   
        elseif petz.check_capture_items(self, wielded_item_name, clicker, true) == true then          	
			local player_name = clicker:get_player_name()
			if (self.is_pet == true and self.owner and self.owner ~= player_name and petz.settings.rob_mobs == false) then
				minetest.chat_send_player(player_name, S("You are not the owner of the").." "..self.type..".")	
				return
			end
			if self.owner== nil or self.owner== "" or (self.owner ~= player_name and petz.settings.rob_mobs == true) then				
				self.tamed = true
				mobkit.remember(self, "tamed", self.tamed )
				self.owner = player_name
				mobkit.remember(self, "owner", self.owner) 
			end			
			petz.capture(self, clicker)
			minetest.chat_send_player("singleplayer", S("Your").." "..self.type.." "..S("has been captured")..".")				            
        elseif self.type == "lamb" then
			if (wielded_item_name == "mobs:shears" or wielded_item_name == "petz:shears") and clicker:get_inventory() and not self.shaved then
				petz.lamb_wool_shave(self, clicker) --shear it!
			elseif wielded_item_name == "default:blueberries" and not(self.is_baby) then
				petz.breed(self, clicker, wielded_item, wielded_item_name)		
			else
				show_form = true
			end
        elseif self.type == "calf" and wielded_item_name == "bucket:bucket_empty" and clicker:get_inventory() then
			if not(self.milked) then
				petz.calf_milk_milk(self, clicker)
			else
				minetest.chat_send_player(clicker:get_player_name(), S("This calf has already been milked."))
			end
		elseif self.type == "pony" and (wielded_item_name == "petz:glass_syringe" or wielded_item_name == "petz:glass_syringe_sperm") then
			if not(self.is_baby) then
				petz.pony_breed(self, clicker, wielded_item, wielded_item_name)	
			end
        --Else open the Form
        elseif (self.tamed == true) and (self.is_pet == true) and (self.owner == player_name) then
			show_form = true
        end
        if show_form == true then
			petz.pet[player_name]= self
            minetest.show_formspec(player_name, "petz:form_orders", petz.create_form(player_name))
        end
end

---
--Calf Milk
---

petz.calf_milk_refill = function(self)
	self.food_count = self.food_count + 1
	mobkit.remember(self, "food_count", self.food_count)      
	if self.food_count >= 5 then -- if calf replaces 5x grass then it refill milk
		self.food_count = 0
		mobkit.remember(self, "food_count", self.food_count) 
		self.milked = false
		mobkit.remember(self, "milked", self.milked) 
	end
end

petz.calf_milk_milk = function(self, clicker)
	local inv = clicker:get_inventory()	
	if inv:room_for_item("main", "petz:bucket_milk") then		
		local wielded_item = clicker:get_wielded_item()
		wielded_item:take_item()
		clicker:set_wielded_item("petz:bucket_milk")		
		inv:add_item("main", wielded_item)
		petz.do_sound_effect("object", self.object, "petz_calf_moaning")					
	else					
		minetest.add_item(self:get_pos(), "petz:bucket_milk")
	end
	self.milked = true
	mobkit.remember(self, "milked", self.milked)     
end

--
--Breed Mechanics
--

petz.breed = function(self, clicker, wielded_item, wielded_item_name)
	if self.is_rut == false and self.is_pregnant == false then
		wielded_item:take_item()
		clicker:set_wielded_item(wielded_item)
		self.is_rut = true
		mobkit.remember(self, "is_rut", self.is_rut)
		petz.do_particles_effect(self.object, self.object:get_pos(), "heart")
	else
		if self.is_rut then
			minetest.chat_send_player(clicker:get_player_name(), S("This animal is already rut."))			
		else
			minetest.chat_send_player(clicker:get_player_name(), S("This animal is already pregnant."))
		end
	end
end

petz.pony_breed = function(self, clicker, wielded_item, wielded_item_name)
	if wielded_item_name == "petz:glass_syringe" and self.is_male== true then		
		local new_wielded_item = ItemStack("petz:glass_syringe_sperm")
		local meta = new_wielded_item:get_meta()
		meta:set_int("max_speed_forward", self.max_speed_forward)
		meta:set_int("max_speed_reverse", self.max_speed_reverse)
		meta:set_int("accel", self.accel)
		clicker:set_wielded_item(new_wielded_item)
	elseif wielded_item_name == "petz:glass_syringe_sperm" and self.is_male== false then	 
		if self.is_pregnant == false and self.pregnant_count > 0 then
			self.is_pregnant = true
			mobkit.remember(self, "is_pregnant", self.is_pregnant)
			self.pregnant_count = self.pregnant_count - 1
			mobkit.remember(self, "pregnant_count", self.pregnant_count)	
			local meta = wielded_item:get_meta()
			local max_speed_forward = meta:get_int("max_speed_forward")
			local max_speed_reverse = meta:get_int("max_speed_reverse")
			local accel = meta:get_int("accel")		
			petz.init_pony_pregnancy(self, max_speed_forward, max_speed_reverse, accel)
			petz.do_particles_effect(self.object, self.object:get_pos(), "pregnant".."_"..self.type)
		end
		clicker:set_wielded_item("petz:glass_syringe")	
	end
end

petz.childbirth = function(self, father)
	local pos = self.object:get_pos()		
	self.is_pregnant = false
	mobkit.remember(self, "is_pregnant", self.is_pregnant)
	local baby_properties = {}
	baby_properties["baby_born"] = true
	if father and father.genes then
		baby_properties["gen1_father"] = father.genes["gen1"]
		baby_properties["gen2_father"] = father.genes["gen2"]
	else
		baby_properties["gen1_father"] = math.random(1, #self.skin_colors-1)
		baby_properties["gen2_father"] = math.random(1, #self.skin_colors-1)
	end
	if self and self.genes then
		baby_properties["gen1_mother"] = self.genes["gen1"]
		baby_properties["gen2_mother"] = self.genes["gen2"]
	else
		baby_properties["gen1_mother"] = math.random(1, #self.skin_colors-1)
		baby_properties["gen2_mother"] = math.random(1, #self.skin_colors-1)
	end
	local baby = minetest.add_entity(pos, "petz:"..self.type, minetest.serialize(baby_properties)) --add a baby petz with staticdata = "baby"
	local baby_entity = baby:get_luaentity()
	baby_entity.is_baby = true
	mobkit.remember(baby_entity, "is_baby", baby_entity.is_baby)
	if not(self.owner== nil) and not(self.owner== "") then					
		baby_entity.tamed = true
		mobkit.remember(baby_entity, "tamed", baby_entity.tamed)
		baby_entity.owner = self.owner
		mobkit.remember(baby_entity, "owner", baby_entity.owner)
	end	
	return baby_entity
end

petz.init_pregnancy = function(self, father)	
    minetest.after(petz.settings.pregnancy_time, function(self, father)         
        if not(self.object:get_pos() == nil) then
			local baby_entity = petz.childbirth(self, father)
		end
    end, self, father)
end

petz.init_pony_pregnancy = function(self, max_speed_forward, max_speed_reverse, accel)
    minetest.after(petz.settings.pregnancy_time, function(self, max_speed_forward, max_speed_reverse, accel)         
        if not(self.object:get_pos() == nil) then
			local baby_entity = petz.childbirth(self)
			--Set the genetics accordingly the father and the mother
			local random_number = math.random(-1, 1)
			local new_max_speed_forward = round((max_speed_forward + self.max_speed_forward)/2, 0) + random_number
			if new_max_speed_forward <= 0 then
				new_max_speed_forward = 0
			elseif new_max_speed_forward > 10 then
				new_max_speed_forward = 10
			end
			local new_max_speed_reverse = round((max_speed_reverse  + self.max_speed_reverse)/2, 0) + random_number
			if new_max_speed_reverse <= 0 then
				new_max_speed_reverse = 0
			elseif new_max_speed_reverse > 10 then
				new_max_speed_reverse = 10
			end
			local new_accel  = round((accel + self.accel)/2, 0)	+ random_number
			if new_accel <= 0 then
				new_accel = 0
			elseif new_accel > 10 then
				new_accel = 10
			end
			baby_entity.max_speed_forward = new_max_speed_forward 
			mobkit.remember(baby_entity, "max_speed_forward", baby_entity.max_speed_forward)
			baby_entity.max_speed_reverse = new_max_speed_reverse
			mobkit.remember(baby_entity, "max_speed_reverse", baby_entity.max_speed_reverse)
			baby_entity.accel = new_accel
			mobkit.remember(baby_entity, "accel", baby_entity.accel)	
		end
    end, self, max_speed_forward, max_speed_reverse, accel)
end

petz.init_growth = function(self)
    minetest.after(petz.settings.growth_time, function(self)         
        if not(self.object:get_pos() == nil) then
			self.is_baby = false
			mobkit.remember(self, "is_baby", self.is_baby)
			petz.set_properties(self, {
				jump = false,
				is_baby = false,
				visual_size = self.visual_size,
				collisionbox = self.collisionbox 
			})		
		end
    end, self)
end

--
--on_die event for all the mobs
--

petz.on_die = function(self)	
	--Specific of each mob
	if self.type == "pony" then
		if self.saddle then -- drop saddle when horse is killed while riding
			minetest.add_item(self.object:get_pos(), "petz:saddle")
		end
	elseif self.type == "puppy" then
		if self.square_ball_attached == true and self.attached_squared_ball then
			self.attached_squared_ball.object:set_detach()
		end
	end
	--For all the mobs
    local props = self.object:get_properties()
    props.collisionbox[2] = props.collisionbox[1]
	petz.set_properties(self, {collisionbox=props.collisionbox})
	petz.drop_items(self)
	mobkit.clear_queue_high(self)
	mobkit.hq_die(self)
    petz.pet[self.owner]= nil 
end

--
--do_punch event for all the mobs
--

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
--Particle Effects
--

petz.do_particles_effect = function(obj, pos, particle_type)
    local minpos
    minpos = {
        x = pos.x,
        y = pos.y,
        z = pos.z
    }        
    local maxpos
    maxpos = {
        x = minpos.x+0.4,
        y = minpos.y-0.5,
        z = minpos.z+0.4
    }    
    local texture_name
    local particles_amount
    local min_size
    local max_size
    if particle_type == "star" then
        texture_name = "petz_star_particle.png"
        particles_amount = 20
		min_size = 1.0
		max_size = 1.5
    elseif particle_type == "heart" then
        texture_name = "petz_affinity_heart.png"
        particles_amount = 10
 		min_size = 1.0
		max_size = 1.5
    elseif particle_type == "pregnant_pony" then
        texture_name = "petz_pony_pregnant_icon.png"
        particles_amount = 10
        min_size = 5.0
		max_size = 6.0 
	elseif particle_type == "pregnant_lamb" then
        texture_name = "petz_lamb_pregnant_icon.png"
        particles_amount = 10
        min_size = 5.0
		max_size = 6.0 
    end
    minetest.add_particlespawner({
        --attached = obj,
        amount = particles_amount,
        time = 1.5,
        minpos = minpos,
        maxpos = maxpos,
        --minvel = {x=1, y=0, z=1},
        --maxvel = {x=1, y=0, z=1},
        --minacc = {x=1, y=0, z=1},
        --maxacc = {x=1, y=0, z=1},
        minexptime = 1,
        maxexptime = 1,
        minsize = min_size,
        maxsize =max_size,
        collisiondetection = false,
        vertical = false,
        texture = texture_name,        
        glow = 14
    })
end

--
--Sound System
--
petz.random_mob_sound = function(self)
	local random_number = math.random(1, petz.settings.misc_sound_chance)
	if random_number == 1 then
		if self.sounds and self.sounds['misc'] then 
			petz.mob_sound(self, self.sounds['misc'], 1.0, 10)
		end
	end
end

-- play sound
petz.mob_sound = function(self, sound, _gain, _max_hear_distance)
	if sound then
		minetest.sound_play(sound, {object = self.object, gain = _gain, max_hear_distance = _max_hear_distance})
	end
end

petz.do_sound_effect = function(dest, dest_name, soundfile)
    minetest.sound_play(soundfile, {dest = dest_name, gain = 0.4})
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

--
--Duck and Chicken mechanics
--

--Lay Egg
petz.lay_egg = function(self)
	local pos = self.object:get_pos()
	if math.random(1, petz.settings.lay_egg_chance) == 1 then
		minetest.add_item(self.object:get_pos(), "petz:"..self.type.."_egg") --chicken egg!
	end			
	local lay_range = 1
	local nearby_nodes = minetest.find_nodes_in_area(
		{x = pos.x - lay_range, y = pos.y - 1, z = pos.z - lay_range},
		{x = pos.x + lay_range, y = pos.y + 1, z = pos.z + lay_range},
		"petz:ducky_nest")
	if #nearby_nodes > 1 then
		local nest_to_lay = nearby_nodes[math.random(1, #nearby_nodes)]
		minetest.set_node(nest_to_lay, {name= "petz:"..self.type.."_nest_egg"})
	end		
end

--Extract Egg from a Nest
petz.extract_egg_from_nest = function(self, pos, player, egg_type)
	local inv = player:get_inventory()			
	if inv:room_for_item("main", egg_type) then
		inv:add_item("main", egg_type) --add the egg to the player's inventory
		minetest.set_node(pos, {name= "petz:ducky_nest"}) --Replace the node to a empty nest
	else
		minetest.chat_send_player(player:get_player_name(), "No room in your inventory for the egg.")			
	end
end

--
--Create Dam Beaver Mechanic
--

petz.create_dam = function(self, pos)		
	if petz.settings.beaver_create_dam == true and self.dam_created == false then --a beaver can create only one dam
		if math.random(1, 60000) > 1 then --chance of the dam to be created
			return false
		end		
		local pos_underwater = { --check if water below (when the beaver is still terrestrial but float in the surface of the water)
        	x = pos.x,
        	y = pos.y - 4.5,
    		z = pos.z,
    	}
    	if minetest.get_node(pos_underwater).name == "default:sand" then
    		local pos_dam = { --check if water below (when the beaver is still terrestrial but float in the surface of the water)
        		x = pos.x,
        		y = pos.y - 2.0,
    			z = pos.z,
    		}
    		minetest.place_schematic(pos_dam, modpath..'/schematics/beaver_dam.mts', 0, nil, true)    	
    		self.dam_created = true
    		return true
    	end
    end
    return false
end

petz.was_killed_by_player = function(self, puncher)	
	if self.hp <= 0 then
		if puncher:is_player() then
			return true
		else
			return false
		end
	else
		return false
	end
end

petz.set_properties = function(self, properties)
	self.object:set_properties(properties) 			
end

petz.update_nametag = function(self)
	local name_tag
	if self.show_tag == true and self.tag and not(self.tag == "") then
		name_tag = self.tag
		self.object:set_nametag_attributes({text = name_tag .." ♥ "..tostring(self.hp).."/"..tostring(self.max_hp),})
	else
		self.object:set_nametag_attributes({text = "",})
	end	
end

petz.delete_nametag = function(self)
	self.object:set_nametag_attributes({text = nil,})
end

--
--Square Ball Game for the Puppy
--

function petz.spawn_square_ball(user, strength)
	local pos = user:get_pos()
	pos.y = pos.y + 1.5 -- camera offset
	local dir = user:get_look_dir()
	local yaw = user:get_look_horizontal()

	local obj = minetest.add_entity(pos, "petz:ent_square_ball")
	if not obj then
		return
	end
	obj:get_luaentity().shooter_name = user:get_player_name()
	obj:set_yaw(yaw - 0.5 * math.pi)
	obj:set_velocity(vector.multiply(dir, strength))
	return true
end

minetest.register_node("petz:square_ball", {
	description = S("Square Ball (use to throw)"),
	--inventory_image = "petz_square_ball.png",
	tiles = {"petz_square_ball.png", "petz_square_ball.png", "petz_square_ball.png", "petz_square_ball.png",
					"petz_square_ball.png", "petz_square_ball.png"},
	visual_scale = 0.35,
	is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		local strength = 20	
		if not petz.spawn_square_ball(user, strength) then
			return -- something failed
		end	
		itemstack:take_item()			
		return itemstack
	end,	
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:square_ball',
    recipe = {        
        {'wool:blue', 'wool:white', 'wool:red'},
        {'wool:white', 'farming:string', 'wool:white'},
        {'wool:yellow', 'wool:white', 'wool:white'},
    }
})

petz.attach_squareball = function(self, thing_ent, thing_ref, shooter_name)
	self.object:set_properties({visual = "cube",  physical = true, visual_size = {x = 0.045, y = 0.045},
			textures = {"petz_square_ball.png", "petz_square_ball.png", "petz_square_ball.png", "petz_square_ball.png",
			"petz_square_ball.png", "petz_square_ball.png"}, groups = {immortal = 1}, collisionbox = {-0.15, -0.15, -0.15, 0.15, 0.15, 0.15},})
	self.object:set_attach(thing_ref, "head", {x=-0.0, y=0.5, z=-0.45}, {x=0, y=0, z=0}) 						
	thing_ent.square_ball_attached = true
	thing_ent.attached_squared_ball = self
	mobkit.remember(thing_ent, "square_ball_attached", thing_ent.square_ball_attached)	
	mobkit.make_sound(thing_ent, "moaning")				
	if shooter_name then
		local player = minetest.get_player_by_name(shooter_name)		
		if player then
			mobkit.clear_queue_low(thing_ent)	
			mobkit.hq_follow(thing_ent, 15, player)						
			self.shooter_name = "" --disable de 'on_step' event
		end
	end
end

minetest.register_entity("petz:ent_square_ball", {
	hp_max = 4,       -- possible to catch the arrow (pro skills)
	physical = false, -- use Raycast
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	visual = "wielditem",
	textures = {"petz:square_ball"},
	visual_size = {x = 0.2, y = 0.15},
	old_pos = nil,
	shooter_name = "",
	parent_entity = nil,
	waiting_for_removal = false,

	on_activate = function(self)
		self.object:set_acceleration({x = 0, y = -9.81, z = 0})
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		return false
	end,
	
	on_rightclick = function(self, clicker)		
		if self.object:get_attach() then --if attached				
			local attach = self.object:get_attach()	
			local inv = clicker:get_inventory()			
			local new_stack = "petz:square_ball"
			if inv:room_for_item("main", new_stack) then
				inv:add_item("main", new_stack)
			else			
				local parent_pos = attach:get_pos()
				minetest.add_item(parent_pos, new_stack)
			end			
			self.object:set_detach()
			local parent_ent = attach:get_luaentity()
			parent_ent.square_ball_attached = false				
			parent_ent.attached_squared_ball = nil
			mobkit.clear_queue_low(parent_ent)
			petz.ownthing(parent_ent)			
			self.object:remove()	--remove the square ball
			mobkit.clear_queue_low(parent_ent)
			petz.ownthing(parent_ent)
		end
	end,
	
	on_step = function(self, dtime)
		if self.shooter_name == "" then
			if self.object:get_attach() == nil then
				self.object:remove()
			end
			return
		end
		if self.waiting_for_removal then
			self.object:remove()
			return
		end
		local pos = self.object:get_pos()
		self.old_pos = self.old_pos or pos

		local cast = minetest.raycast(self.old_pos, pos, true, false)
		local thing = cast:next()
		while thing do
			if thing.type == "object" and thing.ref ~= self.object then
				--minetest.chat_send_player("singleplayer", thing.type)
				local thing_ent = thing.ref:get_luaentity()
				if not(thing.ref:is_player()) and not(thing.ref:get_player_name() == self.shooter_name)
					and (thing_ent.type == "puppy") and not(thing_ent.square_ball_attached) then
						petz.attach_squareball(self, thing_ent, thing.ref, self.shooter_name)
						return
				end
			elseif thing.type == "node" then
				local name = minetest.get_node(thing.under).name
				if minetest.registered_items[name].walkable then
					itemstack_squareball = ItemStack("petz:square_ball")
					--local meta = itemstack_squareball:get_meta()
					--meta:set_string("shooter_name", self.shooter_name)
					minetest.item_drop(itemstack_squareball,
						nil, vector.round(self.old_pos))
					self.waiting_for_removal = true
					self.object:remove()
					return
				end
			end
			thing = cast:next()
		end
		self.old_pos = pos
	end,
})
