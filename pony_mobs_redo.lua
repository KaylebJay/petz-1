--
--PONY
--
local S = ...

local pet_name = "pony"

local mesh = nil
local textures = {}
local textures_baby = {}
local fixed = {}
local scale_pony = 2.2
local scale_baby = 0.5
petz.pony = {}
local collisionbox = {}
local collisionbox_baby = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.0625, -0.375, 0.125, 0.125, -0.0625}, -- head
		{0.0625, -0.5, -0.1875, 0.125, -0.3125, -0.125}, -- front_left_leg
		{-0.0625, -0.3125, -0.1875, 0.125, -0.125, 0.25}, -- body
		{-0.0625, -0.125, -0.1875, 0.125, -0.0625, -0.0625}, -- neck
		{-0.0625, -0.5, -0.1875, -1.49012e-08, -0.3125, -0.125}, -- front_right_leg
		{0.0625, -0.5, 0.1875, 0.125, -0.3125, 0.25}, -- back_left_leg
		{-0.0625, 0.125, -0.125, 5.58794e-09, 0.25, -0.0625}, -- right_ear
		{0.0625, 0.125, -0.125, 0.125, 0.25, -0.0625}, -- left_ear
		{-0.0625, -0.5, 0.1875, 0, -0.3125, 0.25}, -- back_right_leg
		{0, -0.1875, 0.25, 0.0625, -0.125, 0.3125}, -- top_tail
		{0, -0.25, 0.3125, 0.0625, -0.1875, 0.375}, -- middle_tail
		{0, 0.125, -0.125, 0.0625, 0.1875, -0.0625}, -- mane_top
		{0, -0.125, -0.0625, 0.0625, 0.125, -6.14673e-08}, -- mane_bottom
		{0, -0.3125, 0.3125, 0.0625, -0.25, 0.375}, -- bottom_tail
	}
	petz.pony.tiles = {
		"petz_pony_top.png", "petz_pony_bottom.png", "petz_pony_right.png",
		"petz_pony_left.png", "petz_pony_back.png", "petz_pony_front.png"
	}
	petz.pony.tiles_saddle = {
		"petz_pony_top_saddle.png", "petz_pony_bottom.png", "petz_pony_right_saddle.png",
		"petz_pony_left_saddle.png", "petz_pony_back.png", "petz_pony_front.png"
	}	
	petz.register_cubic(node_name, fixed, petz.pony.tiles)			
	collisionbox = {-0.5, -0.75*scale_pony, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_pony.b3d'	
	textures = {"petz_pony_white.png"}	
	textures_baby = {"petz_pony_baby.png"}	
	collisionbox = {-0.5, -0.75*scale_pony, -0.5, 0.375, -0.375, 0.375}
end


mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_pony, y=petz.settings.visual_size.y*scale_pony},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1.0,    
    runaway = true,
    pushable = true,
    floats = 1,
	jump = true,
	follow = petz.settings.pony_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_pony_neigh",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand4_start = 82, stand4_end = 94,	
	},
    view_range = 7,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		if self.tamed and self.owner == clicker:get_player_name() then    			
			if self.driver and clicker == self.driver then -- detatch player already riding horse
				mobs.detach(clicker, {x = 1, y = 0, z = 1})
			elseif self.saddle and clicker:get_wielded_item():get_name() == "mobs:shears" then
				minetest.add_item(self.object:get_pos(), "mobs:saddle")
				if petz.settings.type_model == "mesh" then
					self.object:set_properties({textures = self.textures})
				else
					self.object:set_properties({tiles = petz.pony.tiles})
				end 
				self.saddle = false					
			elseif not self.driver and not self.saddle and not(self.is_baby) and clicker:get_wielded_item():get_name() == "mobs:saddle" then -- Put on saddle if tamed
				local w = clicker:get_wielded_item() -- Put on saddle and take saddle from player's inventory
				if petz.settings.type_model == "mesh" then
					self.object:set_properties({textures = self.textures_saddle})
				else
					self.object:set_properties({tiles = petz.pony.tiles_saddle})
				end 
				self.saddle = true    
				if not minetest.settings:get_bool("creative_mode") then
					w:take_item()
					clicker:set_wielded_item(w)
				end
			elseif not self.driver and self.saddle then -- Mount horse				
				self.object:set_properties({stepheight = 1.1})
				mobs.attach(self, clicker)		
			else
				petz.on_rightclick(self, clicker)
			end			
		end
	end, 	
	do_custom = function(self, dtime)
		if not self.custom_vars_set03 then --change in after_activate function below too
			self.custom_vars_set03 = 0
			self.petz_type = "pony"
			self.is_pet = true
			self.is_wild = false
			self.give_orders = true
			self.scale_pony = scale_pony
			self.scale_baby = scale_baby
			self.has_affinity = true
			self.affinity = 100
			self.init_timer = true
			self.fed = false			
			self.is_male = true
			self.pregnant_count = 5
			self.is_pregnant = false
			self.can_be_brushed = true
			self.brushed = false
			self.beaver_oil_applied = false			
			self.food_count = 0
			self.saddle = false
			self.terrain_type = 3
			self.capture_item = "lasso"
			self.driver_attach_at = {x = -0.0325, y = -0.125, z = -0.2}
			self.driver_eye_offset = {x = 0, y = 0, z = 0}
			self.driver_scale = {x = 1/self.visual_size.x, y = 1/self.visual_size.y}
			self.visual_size_baby = {x=petz.settings.visual_size.x*scale_pony*0.5, y=petz.settings.visual_size.y*scale_pony*0.5}
			--set a random genre
			random_number = math.random(1, 2)
			if random_number == 1 then
				self.is_male = true
			else
				self.is_male = false
			end
		end
		petz.init_timer(self)
		if self.driver then
			mobs.drive(self, "walk", "stand", false, dtime) -- if driver present allow control of horse
			return false -- skip rest of mob functions
		end		
	end,
	on_die = function(self, pos)
		if self.saddle then -- drop saddle when horse is killed while riding
			minetest.add_item(pos, "mobs:saddle")
		end
		if self.driver then -- also detach from horse properly
			mobs.detach(self.driver, {x = 1, y = 0, z = 1})
		end
	end,
	after_activate = function(self, staticdata, def, dtime)		
		if (staticdata== "baby") or (self.is_baby== true) then							
			petz.init_growth(self)
			self.object:set_properties({
				visual_size = {x=petz.settings.visual_size.x*scale_pony*scale_baby, y=petz.settings.visual_size.y*scale_pony*scale_baby},
				collisionbox = {-0.5*scale_baby, -0.75*scale_pony*scale_baby, -0.25, 0.375, -0.375, 0.375}
			})		
		end
		self.init_timer = true
    	if not self.custom_vars_set03 then --but do not set here! instead wait for the do-custom function to do it.  
    		if not(staticdata== "baby") then
				--set a random velocity for walk and run
				self.max_speed_forward= math.random(2, 4)				
				self.max_speed_reverse= math.random(2, 4)	
				self.accel= math.random(2, 4)	
			end
    		local color
    		if petz.settings.type_model == "mesh" then --set a random color    			
    			local random_number = math.random(1, 6)
    			if random_number == 1 then
					color = "brown"
				elseif random_number == 2 then
					color = "white"				
				elseif random_number == 3 then
					color = "yellow"				
				elseif random_number == 4 then
					color = "white_dotted"				
				elseif random_number == 5 then
					color = "gray_dotted"		
				else
					color = "black"
				end		
				self.textures_color = {"petz_pony_"..color..".png"}
				self.textures_saddle = {"petz_pony_"..color..".png" .. "^petz_pony_saddle.png"}
			else --if 'cubic'
				self.tiles_color = petz.pony.tiles
				self.tiles_saddle = petz.pony.tiles_saddle
				color = "brown" --cubic horse color is always brown
			end
			self.skin_color = color
		end 				
    	if self.saddle then
    		self.object:set_properties({textures = self.textures_saddle})
    	else
    		self.object:set_properties({textures = self.textures_color})
    	end
    	if self.is_pregnant == true then
			petz.init_pregnancy(self, self.max_speed_forward, self.max_speed_reverse, self.accel)
    	end
	end,
})

mobs:register_egg("petz:pony", S("Pony"), "petz_spawnegg_pony.png", 0)

mobs:spawn({
	name = "petz:pony",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.pony_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
