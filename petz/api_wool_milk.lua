local modpath, S = ...

---
---Refill lamb or milk
---

petz.refill = function(self)
	if self.type == "lamb" then
		petz.lamb_wool_regrow(self)                       
	elseif self.milkable == true then     
		petz.milk_refill(self)
	end
end

--
--Lamb Wool
--

petz.lamb_wool_regrow = function(self)	
	if self.shaved == false then --only count if the lamb is shaved
		return
	end	
	local food_count_wool = self.food_count_wool + 1
	mobkit.remember(self, "food_count_wool", food_count_wool)
	if self.food_count_wool >= 5 then -- if lamb replaces 5x grass then it regrows wool
		self.food_count_wool = mobkit.remember(self, "food_count_wool", 0)
		self.shaved = mobkit.remember(self, "shaved", false)				
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
	self.shaved = mobkit.remember(self, "shaved", true)        
	self.food_count_wool = mobkit.remember(self, "food_count_wool", 0)	
	petz.afraid(self, clicker:get_pos())
end

---
--Calf Milk
---

petz.milk_refill = function(self)
	self.food_count = self.food_count + 1
	mobkit.remember(self, "food_count", self.food_count)      
	if self.food_count >= 5 then -- if calf replaces 5x grass then it refill milk
		self.food_count = mobkit.remember(self, "food_count", self.food_count) 
		self.milked = mobkit.remember(self, "milked", false) 
	end
end

petz.milk_milk = function(self, clicker)
	local inv = clicker:get_inventory()	
	if inv:room_for_item("main", "petz:bucket_milk") then		
		local wielded_item = clicker:get_wielded_item()
		wielded_item:take_item()
		clicker:set_wielded_item("petz:bucket_milk")		
		inv:add_item("main", wielded_item)
		petz.do_sound_effect("object", self.object, "petz_"..self.type.."_moaning")					
	else					
		minetest.add_item(self:get_pos(), "petz:bucket_milk")
	end
	self.milked = mobkit.remember(self, "milked", true)     
end
