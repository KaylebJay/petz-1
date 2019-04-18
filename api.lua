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
--Form Dialog
--

--Context
petz.pet = {} -- A table of pet["owner_name"]="owner_name"

petz.create_form = function(player_name)
    local pet = petz.pet[player_name]
    if pet.affinity == nil then
       pet.affinity = 0
    end
	local form_pet_orders
    if petz.settings.tamagochi_mode == true then        
		form_pet_orders = 
            "size[5,5;]"..
            "image[0,0;1,1;petz_spawnegg_"..pet.petz_type..".png]"..
            "label[1,0;".. S("Orders").."]"..
            "image[3,1;1,1;petz_affinity_heart.png]"..
            "label[4,1;".. tostring(pet.affinity).."%]"..
            "image[3,2;1,1;petz_pet_bowl_inv.png]"
        local hungry_label = ""
        if pet.fed == false then
            hungry_label = "Hungry"
        else
            hungry_label = "Saciated"
        end
        form_pet_orders = form_pet_orders .. "label[4,2;"..S(hungry_label).."]"
    else
        form_pet_orders =
            "size[3,5;]"..
            "image[1,0;1,1;petz_spawnegg_"..pet.petz_type..".png]"
    end
    form_pet_orders = form_pet_orders..
		"button_exit[0,1;3,1;btn_followme;"..S("Follow me").."]"..
		"button_exit[0,2;3,1;btn_standhere;"..S("Stand here").."]"..
		"button_exit[0,3;3,1;btn_ownthing;"..S("Do your own thing").."]"..	
		"button_exit[1,4;1,1;btn_close;"..S("Close").."]"
	return form_pet_orders
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if (formname ~= "petz:form_orders") then
		return false
	end
    local pet = petz.pet[player:get_player_name()] 
	if pet == nil then -- if pet dies after her formspec opened
		return false
	end
	--brewing.magic_sound("to_player", player, "brewing_select")
	if fields.btn_followme then
        pet.type = "npc"
		pet.order = "follow"
	elseif fields.btn_standhere then
        pet.type = "animal"
		pet.order = "stand"
	elseif fields.btn_ownthing then
        pet.type = "animal"
		pet.order = ""
		pet.state = "walk"
	end
	return true
end)

--
-- Increase/Descrease the pet affinity
--

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

--
-- Whip/lashing behaviour
--

petz.do_lashing = function(self)
    if self.lashed == false then        
        self.lashed = true
    end
    petz.do_sound_effect("object", self.object, "petz_"..self.petz_type.."_moaning")
end

--
--The Timer for the Tamagochi Mode

petz.init_timer = function(self)
    if (petz.settings.tamagochi_mode == true) and (self.tamed == true) and (self.init_timer == true) then
        petz.timer(self)
        return true
    else
        return false
    end
end

petz.timer = function(self)
    minetest.after(petz.settings.tamagochi_check_time, function(self)         
        if not(self.object== nil) then
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
            petz.set_affinity(self, false, 10)
            --Decrease health if pet has not fed
            if self.fed == false then
                local current_health = self.health
                new_health = current_health - petz.settings.tamagochi_hunger_damage
                if new_health>=0  then
                    self.health = new_health
                    petz.set_affinity(self, false, 33)
                else
                    self.health = 0
                end
            else
                self.fed = false --Reset the variable
            end
            --If the pet has not brushed
            if self.brushed == false then
                petz.set_affinity(self, false, 20)
            else
                self.brushed = false --Reset the variable
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
            elseif self.affinity == 0 then
                minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("has abandoned you!!!"))
                self.owner = "" --the pet abandon you
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
--Mobs Redo Events
--

petz.on_rightclick = function(self, clicker)
        if not(clicker:is_player()) then
            return false
        end
        local player_name = clicker:get_player_name()
        local wielded_item = clicker:get_wielded_item()
        local wielded_item_name= wielded_item:get_name()
        if ((self.is_pet == true) and (self.owner == player_name)) -- If brushing or spread beaver oil
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
            if self.petz_type == "lamb" then     
                petz.lamb_wool_regrow(self)                       
            elseif self.petz_type == "calf" then     
                petz.calf_milk_refill(self)
            end     
            petz.do_sound_effect("object", self.object, "petz_"..self.petz_type.."_moaning")
            petz.do_particles_effect(self.object, self.object:get_pos(), "heart")   
        elseif (wielded_item_name == "mobs:lasso") or (wielded_item_name == "mobs:net") then        
            if mobs:capture_mob(self, clicker, 0, 100, 100, true, nil) then
                minetest.chat_send_player(self.owner, S("Your").." "..self.petz_type.." "..S("has been captured."))
            end         
        elseif self.petz_type == "lamb" and wielded_item_name == "mobs:shears" and clicker:get_inventory() and not self.shaved then
            petz.lamb_wool_shave(self, clicker)
        elseif self.petz_type == "calf" and wielded_item_name == "bucket:bucket_empty" and clicker:get_inventory() then
			if not(self.milked) then
				petz.calf_milk_milk(self, clicker)
			else
				minetest.chat_send_player(clicker:get_player_name(), S("This calf has already been milked."))
			end
        --Else open the Form
        elseif (self.tamed == true) and (self.give_orders == true) then
            petz.pet[player_name]= self
            minetest.show_formspec(player_name, "petz:form_orders", petz.create_form(player_name))
        end
end

petz.on_die = function(self, pos)
    petz.pet[self.owner]= nil
end

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
--Effects
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
    if particle_type == "star" then
        texture_name = "petz_star_particle.png"
        particles_amount = 20
    elseif particle_type == "heart" then
        texture_name = "petz_affinity_heart.png"
        particles_amount = 10
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
        minsize = 1.0,
        maxsize = 1.5,
        collisiondetection = false,
        vertical = false,
        texture = texture_name,        
        glow = 14
    })
end

petz.do_sound_effect = function(dest, dest_name, soundfile)
    minetest.sound_play(soundfile, {dest = dest_name, gain = 0.4})
end

--
--Semiaquatic beahaviour
--for beaver and frog
--

petz.set_behaviour= function(self, behaviour, water_type)	
	if behaviour == "aquatic" then
		self.behaviour = "aquatic"
        self.fly = true     
        self.fly_in = water_type
        self.floats = 0
        self.animation = self.animation_aquatic
	elseif behaviour == "terrestrial" then
		self.behaviour = "terrestrial"
        self.fly = false -- make terrestrial
        self.floats = 1
        self.animation = self.animation_terrestrial        
	end
end

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
