local modpath, S = ...

petz.breed = function(self, clicker, wielded_item, wielded_item_name)
	if self.is_rut == false and self.is_pregnant == false then
		wielded_item:take_item()
		clicker:set_wielded_item(wielded_item)
		self.is_rut = true
		mobkit.remember(self, "is_rut", self.is_rut)
		petz.do_particles_effect(self.object, self.object:get_pos(), "heart")
		petz.do_sound_effect("object", self.object, "petz_"..self.type.."_moaning")
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
		meta:set_string("petz_type", self.type)
		meta:set_int("max_speed_forward", self.max_speed_forward)
		meta:set_int("max_speed_reverse", self.max_speed_reverse)
		meta:set_int("accel", self.accel)
		clicker:set_wielded_item(new_wielded_item)
	elseif wielded_item_name == "petz:glass_syringe_sperm" and self.is_male== false then	 
		local meta = wielded_item:get_meta()
		local petz_type = meta:get_string("petz_type")
		if self.is_pregnant == false and self.pregnant_count > 0 and self.type == petz_type then
			self.is_pregnant = true
			mobkit.remember(self, "is_pregnant", self.is_pregnant)
			local pregnant_count = self.pregnant_count - 1
			mobkit.remember(self, "pregnant_count", pregnant_count)	
			local max_speed_forward = meta:get_int("max_speed_forward")
			local max_speed_reverse = meta:get_int("max_speed_reverse")
			local accel = meta:get_int("accel")		
			petz.init_mountable_pregnancy(self, max_speed_forward, max_speed_reverse, accel)
			petz.do_particles_effect(self.object, self.object:get_pos(), "pregnant".."_"..self.type)
			clicker:set_wielded_item("petz:glass_syringe")	
		end
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
	local baby_type = "petz:"..self.type
	if self.type == "elephant_female" then
		if math.random(1, 2) == 1 then
			baby_type = "petz:elephant" --could be a baby male elephant
		end
	end
	local baby = minetest.add_entity(pos, baby_type, minetest.serialize(baby_properties))
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

petz.init_mountable_pregnancy = function(self, max_speed_forward, max_speed_reverse, accel)
    minetest.after(petz.settings.pregnancy_time, function(self, max_speed_forward, max_speed_reverse, accel)         
        if not(self.object:get_pos() == nil) then
			local baby_entity = petz.childbirth(self)
			--Set the genetics accordingly the father and the mother
			local random_number = math.random(-1, 1)
			local new_max_speed_forward = petz.round((max_speed_forward + self.max_speed_forward)/2, 0) + random_number
			if new_max_speed_forward <= 0 then
				new_max_speed_forward = 0
			elseif new_max_speed_forward > 10 then
				new_max_speed_forward = 10
			end
			local new_max_speed_reverse = petz.round((max_speed_reverse  + self.max_speed_reverse)/2, 0) + random_number
			if new_max_speed_reverse <= 0 then
				new_max_speed_reverse = 0
			elseif new_max_speed_reverse > 10 then
				new_max_speed_reverse = 10
			end
			local new_accel  = petz.round((accel + self.accel)/2, 0)	+ random_number
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
