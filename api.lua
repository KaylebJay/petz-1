local modpath, S = ...

petz = {}

petz.register_cubic = function(node_name, fixed, tiles)
		minetest.register_node(node_name, {
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = fixed,
		},
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
    	groups = {not_in_creative_inventory = 1},
	})		
end

petz.settings = {}
petz.settings.mesh = nil
petz.settings.visual_size = {}
petz.settings.rotate = 0
petz.settings.tamagochi_safe_nodes = {} --Table with safe nodes for tamagochi mode

--
--Helper Functions
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

--
--Form Dialog
--

--Context
petz.pet = {} -- A table of pet["owner_name"]="owner_name"

petz.create_form = function(player_name)
    local pet = petz.pet[player_name]
    local form_size = {w = 3, h = 2}
    local hungrystuff_pos = {x= 0, y = 0}
    local buttonexit_pos = {x = 1, y = 4}
    local form_title = ""
    local tamagochi_form_stuff = ''
    local affinity_stuff = ''
    local form_orders = ''
    local more_form_orders = ''
    local final_form = ''	
    if pet.affinity == nil then
       pet.affinity = 0
    end
    if petz.settings.tamagochi_mode == true then     
    	form_size.w= form_size.w + 2
		if pet.has_affinity == true then
			form_title = S("Orders")
			hungrystuff_pos = {x= 3, y = 1}
			affinity_stuff =
				"image[3,2;1,1;petz_affinity_heart.png]"..
				"label[4,2;".. tostring(pet.affinity).."%]"
		else
			form_size.w= form_size.w - 1
			form_size.h= form_size.h + 1
			form_title = S("Status")
			hungrystuff_pos = {x= 1, y = 1}
		end
		tamagochi_form_stuff = 
            "image[0,0;1,1;petz_spawnegg_"..pet.petz_type..".png]"..
            "label[1,0;".. form_title .."]"..
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
        tamagochi_form_stuff =
            "image[1,0;1,1;petz_spawnegg_"..pet.petz_type..".png]"
    end
    if pet.petz_type == "parrot" then
		form_size.h = form_size.h + 1
		buttonexit_pos.y = buttonexit_pos.y + 1
		more_form_orders = more_form_orders..
		"button_exit[0,4;1,1;btn_alight;"..S("Alight").."]"	..
		"button_exit[1,4;1,1;btn_fly;"..S("Fly").."]"..
		"button_exit[2,4;2,1;btn_perch_shoulder;"..S("Perch on shoulder").."]"
	elseif pet.petz_type == "pony" then
		local genre = ''
		if pet.is_male == true then
			genre = "Male"
		else
			genre = "Female"
		end		
		more_form_orders = more_form_orders..
			"label[3,0;"..genre.."]"..
			"image[3,3;1,1;petz_pony_velocity_icon.png]"..
			"label[4,3;".. tostring(pet.max_speed_forward).."/"..tostring(pet.max_speed_reverse)..'/'..tostring(pet.accel).."]"
		if pet.is_male == false and pet.is_pregnant == true then
			more_form_orders = more_form_orders..
				"image[3,4;1,1;petz_pony_pregnant_icon.png]"..
				"label[4,4;"..S("Pregnant").."]"
		elseif pet.is_male == false and pet.pregnant_count <= 0 then
			more_form_orders = more_form_orders..				
				"label[3,4;"..S("Infertile").."]"
		end
    end
    if pet.give_orders == true then
		form_size.h= form_size.h + 3
		form_orders =
			"button_exit[0,1;3,1;btn_followme;"..S("Follow me").."]"..
			"button_exit[0,2;3,1;btn_standhere;"..S("Stand here").."]"..
			"button_exit[0,3;3,1;btn_ownthing;"..S("Do your own thing").."]"..	
			more_form_orders
	else
		buttonexit_pos.y = buttonexit_pos.y - 2
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
	--brewing.magic_sound("to_player", player, "brewing_select")
	if pet and pet.object then
		if fields.btn_followme then
			pet.type = "npc"
			pet.order = "follow"
		elseif fields.btn_standhere then
			pet.type = "animal"
			pet.order = "stand"
			pet:set_animation("stand", true)
		elseif fields.btn_ownthing then
			petz.ownthing(pet)
		elseif fields.btn_alight then
			pet.object:set_acceleration({ x = 0, y = -1, z = 0 })
			pet:set_animation("stand", true)
		elseif fields.btn_fly then
			pet.object:set_acceleration({ x = 0, y = 1, z = 0 })
			pet:set_animation("fly", true)
			minetest.after(2.5, function(pet) 
				pet.object:set_acceleration({ x = 0, y = 0, z = 0 })    
				pet.object:set_velocity({ x = 0, y = 0, z = 0 })    
				petz.ownthing(pet)
			end, pet)	
		elseif fields.btn_perch_shoulder then
			pet.object:set_attach(player, "Arm_Left", {x=0.5,y=-6.25,z=0}, {x=0,y=0,z=180}) 
			pet:set_animation("stand", true)
			minetest.after(120.0, function(pet) 
				pet.object:set_detach()
			end, pet)	
		end
		return true
	else
		return false
	end
end)

petz.ownthing= function(pet)	
    pet.type = "animal"
	pet.order = ""
	pet.state = "walk"	
end

--
--The Tamagochi Mode
--

-- Increase/Descrease the pet affinity

petz.set_affinity = function(self, increase, amount)
    local new_affinitty
    if increase == true then
        new_affinitty = self.affinity +  amount
    else
        new_affinitty = self.affinity - amount
    end
    if new_affinitty > 100 then
        new_affinitty = 100
    elseif new_affinitty <0 then     
        new_affinitty = 0
    end
    self.affinity = new_affinitty
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

petz.set_health = function(self, amount)
	local current_health = self.health
    local new_health = current_health + amount
    if new_health >= 0  then
		if new_health >= self.hp_max then
			self.health = self.hp_max
		else
			self.health = new_health               
		end
    else
        self.health = 0
    end
    return self.health
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
                        return
                    end    
                end                
            else  --if the pos is nil, it means that the pet died before 'minetest.after_effect'
                self.init_timer = false --so no more timer
                return
            end
            --Decrease affinitty always a bit amount because the pet lost some affinitty
            if self.has_affinity == true then
				petz.set_affinity(self, false, 10)
			end
            --Decrease health if pet has not fed
            if self.fed == false then
				local damage_amount = - petz.settings.tamagochi_hunger_damage
				local new_health = petz.set_health(self, damage_amount) 
                if (new_health >= 0)  and (self.has_affinity == true) then
					petz.set_affinity(self, false, 33)
				end                
            else
                self.fed = false --Reset the variable
            end
            --If the pet has not brushed
            if self.can_be_brushed == true then
				if self.brushed == false then
					if self.has_affinity == true then
						petz.set_affinity(self, false, 20)
					end
				else
					self.brushed = false --Reset the variable
				end
			end
            --If the petz is a lion had to been lashed
            if self.petz_type== "lion" then
                if self.lashed == false then
                    petz.set_affinity(self, false, 25)                
                else
                    self.lashed = false
                end
            end            
            --If the pet starves to death
            if self.health == 0 then
                minetest.chat_send_player(self.owner, S("Your").. " "..self.petz_type.." "..S("has starved to death!!!"))
                self.init_timer  = false -- no more timing
            --I the pet get bored of you
            elseif (self.has_affinity == true) and (self.affinity == 0) then
                minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("has abandoned you!!!"))
                self.tamed = false --the pet abandon you
                self.owner = ""
                if self.is_wild == true then
                    self.type = "monster" -- if the animal was wild (ie a lion) can attack you!
                end
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
--Lamb Functions
--

petz.lamb_wool_regrow = function(self)
	if self.shaved == false then --only for shaved lambs
		return
	end
	self.food_count = self.food_count + 1        
	if self.food_count >= 5 then -- if lamb replaces 5x grass then it regrows wool
		self.food_count = 0
		self.shaved = false
		if petz.settings.type_model == "mesh" then
			self.object:set_properties({textures = self.textures_color})
		else
			self.object:set_properties({tiles = petz.lamb.tiles})
		end
	end
end

petz.lamb_wool_shave = function(self, clicker)
	local inv = clicker:get_inventory()	
	local new_stack = "wool:"..self.wool_color
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		minetest.add_item(self.object:get_pos(), new_stack)
	end
	self.object:set_properties({textures = self.textures_shaved})
	petz.mob_sound(self, "petz_lamb_moaning.ogg", 1.0, 10)
	petz.afraid_behaviour(self, clicker)
	self.shaved = true  
	self.food_count = 0 --important: reinit the count to 0         	
end

--
--Capture Mobs Mechanics
--

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

-- Wolf turn into Puppy Mechanism

petz.wolf_to_puppy = function(self, player_name)
	self.wolf_to_puppy_count = self.wolf_to_puppy_count - 1
	if self.wolf_to_puppy_count <= 0 then
		local pos = self.object:get_pos()
		local puppy = minetest.add_entity(pos, "petz:puppy")
		local puppy_entity = puppy:get_luaentity()
		puppy_entity.tamed = true		
		puppy_entity.owner = player_name 		
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
        local wielded_item_name= wielded_item:get_name()
        if ((self.is_pet == true) and (self.owner == player_name) and (self.can_be_brushed == true))-- If brushing or spread beaver oil
            and ((wielded_item_name == "petz:hairbrush") or (wielded_item_name == "petz:beaver_oil")) then                       
                if petz.settings.tamagochi_mode == true then
                    if wielded_item_name == "petz:hairbrush" then
                        if self.brushed == false then
                            petz.set_affinity(self, true, 5)
                            self.brushed = true
                        else
                            minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("had already been brushed."))
                        end                
                    else --it's beaver_oil
                        if self.beaver_oil_applied == false then
                            petz.set_affinity(self, true, 20)
                            self.beaver_oil_applied = true
                        else 
                            minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("had already been spreaded with beaver oil."))
                        end     
                    end
                end
                petz.do_sound_effect("object", self.object, "petz_brushing")
                petz.do_particles_effect(self.object, self.object:get_pos(), "star")
        --If feeded
        elseif mobs:feed_tame(self, clicker, 5, false, true) then
            if petz.settings.tamagochi_mode == true and self.fed == false then
                petz.set_affinity(self, true, 5)                
                self.fed = true             
            end
            if petz.settings.tamagochi_mode == true then
				self.init_timer = true
			end
            if self.petz_type == "lamb" then     
                petz.lamb_wool_regrow(self)                       
            elseif self.petz_type == "calf" then     
                petz.calf_milk_refill(self)
            elseif self.petz_type == "wolf" and wielded_item_name == "petz:bone" then
				petz.wolf_to_puppy(self, player_name)			
            end     
            petz.do_sound_effect("object", self.object, "petz_"..self.petz_type.."_moaning")
            petz.do_particles_effect(self.object, self.object:get_pos(), "heart")   
        elseif petz.check_capture_items(self, wielded_item_name, clicker, true) == true then  
			local player_name = clicker:get_player_name()
			if (self.is_pet == true and self.owner and self.owner ~= player_name and petz.settings.rob_mobs == false) then
				minetest.chat_send_player(self.owner, S("You are not the owner of the").." "..self.petz_type..".")	
				return
			end
			if self.owner== nil or self.owner== "" or (self.owner ~= player_name and petz.settings.rob_mobs == true) then
				self.tamed = true
				self.owner = player_name
			end
			petz.capture(self, clicker)
			minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("has been captured")..".")				            
        elseif self.petz_type == "lamb" and wielded_item_name == "mobs:shears" and clicker:get_inventory() and not self.shaved then
            petz.lamb_wool_shave(self, clicker)
        elseif self.petz_type == "calf" and wielded_item_name == "bucket:bucket_empty" and clicker:get_inventory() then
			if not(self.milked) then
				petz.calf_milk_milk(self, clicker)
			else
				minetest.chat_send_player(clicker:get_player_name(), S("This calf has already been milked."))
			end
		elseif self.petz_type == "pony" and not(self.is_baby) and (wielded_item_name == "petz:glass_syringe" or wielded_item_name == "petz:glass_syringe_sperm") then
			petz.breed(self, clicker, wielded_item, wielded_item_name)	
        --Else open the Form
        elseif (self.tamed == true) and (self.is_pet == true) then
            petz.pet[player_name]= self
            minetest.show_formspec(player_name, "petz:form_orders", petz.create_form(player_name))
        end
end

--
--Capture Mechanics
--

petz.capture = function(self, clicker)
	local new_stack = ItemStack(self.name .. "_set") 	-- add special mob egg with all mob information
	local meta = new_stack:get_meta()	
	for _,stat in pairs(self) do
		local t = type(stat)
		if  t ~= "function" and t ~= "nil" and t ~= "userdata" then
			meta:set_string(_, self[_])			
		end
	end	
	local inv = clicker:get_inventory()
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		minetest.add_item(clicker:get_pos(), new_stack)
	end
	self.object:remove()
	self:mob_sound("default_place_node_hard")
end

--
--Breed Mechanics
--

petz.breed = function(self, clicker, wielded_item, wielded_item_name)
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
			self.pregnant_count = self.pregnant_count - 1	
			local meta = wielded_item:get_meta()
			local max_speed_forward = meta:get_int("max_speed_forward")
			local max_speed_reverse = meta:get_int("max_speed_reverse")
			local accel = meta:get_int("accel")		
			petz.init_pregnancy(self, max_speed_forward, max_speed_reverse, accel)
			petz.do_particles_effect(self.object, self.object:get_pos(), "pregnant")
		end
		clicker:set_wielded_item("petz:glass_syringe")	
	end
end

petz.init_pregnancy = function(self, max_speed_forward, max_speed_reverse, accel)
    minetest.after(petz.settings.pony_pregnancy_time, function(self, max_speed_forward, max_speed_reverse, accel)         
        if not(self.object:get_pos() == nil) then
			local pos = self.object:get_pos()		
			self.is_pregnant = false
			local baby = minetest.add_entity(pos, "petz:pony", "baby")	
			local baby_entity = baby:get_luaentity()
			baby_entity.is_baby = true
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
			baby_entity.max_speed_forward= new_max_speed_forward 
			baby_entity.max_speed_reverse = new_max_speed_reverse
			baby_entity.accel = new_accel 
			if not(self.owner== nil) and not(self.owner== "") then					
				baby_entity.owner = self.owner
				baby_entity.tamed = true
			end			
		end
    end, self, max_speed_forward, max_speed_reverse, accel)
end

petz.init_growth = function(self)
    minetest.after(petz.settings.pony_growth_time, function(self)         
        if not(self.object:get_pos() == nil) then
			self.is_baby = false
			self.jump = false
			self.object:set_properties({
				jump = false,
				is_baby = false,
				visual_size = {x=petz.settings.visual_size.x*self.scale_pony, y=petz.settings.visual_size.y*self.scale_pony},
				collisionbox = {-0.5, -0.75*self.scale_pony, -0.5, 0.375, -0.375, 0.375}
			})		
		end
    end, self, max_speed_forward, max_speed_reverse, accel)
end

--
--ondie event for all the mobs
--

petz.on_die = function(self, pos)
    petz.pet[self.owner]= nil
end

--
--do_punch event for all the mobs
--

petz.do_punch = function (self, hitter, time_from_last_punch, tool_capabilities, direction)
    if petz.settings.tamagochi_mode == true then         
        if self.owner == hitter:get_player_name() then
            if self.affinity == nil then
                self.affinity = 0       
            end
            self.affinity = self.affinity - 20
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
    elseif particle_type == "pregnant" then
        texture_name = "petz_pony_pregnant_icon.png"
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
    end
    petz.do_sound_effect("object", self.object, "petz_"..self.petz_type.."_moaning")
end

petz.tame_whip= function(self, hitter)	
		local wielded_item_name= hitter:get_wielded_item():get_name()
		if (wielded_item_name == "petz:whip") then
    		if self.tamed == false then
    		--The grizzly can be tamed lashed with a whip    	                	    	
    			self.lashing_count = (self.lashing_count or 0) + 1        
				if self.lashing_count >= petz.settings.count_lashing_tame then -- tame grizzly
					self.lashing_count = 0
					self.type = "animal"
					self.tamed = true			
					self.owner = hitter:get_player_name()
					minetest.chat_send_player(self.owner, S("A").." "..self.petz_type.." "..S("has been tamed."))					
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
--Ducky and Chicken mechanics
--

--Lay Egg
petz.lay_egg = function(self)
	local pos = self.object:get_pos()
	if math.random(1, petz.settings.lay_egg_chance) == 1 then
		minetest.add_item(self.object:get_pos(), "petz:"..self.petz_type.."_egg") --chicken egg!
	end			
	local lay_range = 1
	local nearby_nodes = minetest.find_nodes_in_area(
		{x = pos.x - lay_range, y = pos.y - 1, z = pos.z - lay_range},
		{x = pos.x + lay_range, y = pos.y + 1, z = pos.z + lay_range},
		"petz:ducky_nest")
	if #nearby_nodes > 1 then
		local nest_to_lay = nearby_nodes[math.random(1, #nearby_nodes)]
		minetest.set_node(nest_to_lay, {name= "petz:"..self.petz_type.."_nest_egg"})
	end		
end

--Extract Egg from a Nest

petz.extract_egg_from_nest = function(self, pos, player, egg_type)
	local inv = player:get_inventory()			
	if inv:room_for_item("main", egg_type) then
		inv:add_item("main", egg_type)
		minetest.set_node(pos, {name= "petz:ducky_nest"})
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
