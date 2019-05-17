--
--LAMB
--
local S = ...

local pet_name = "lamb"

local mesh = nil
local fixed = {}
local textures
local scale_lamb = 1.7
petz.lamb = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.3125, -0.25, 0.0625, -0.125, -0.0625}, -- head
		{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- tail
		{-0.1875, -0.1875, -0.1875, -0.125, -0.125, -0.125}, -- right_ear
		{0.0625, -0.1875, -0.1875, 0.125, -0.125, -0.125}, -- left_ear
	}
	petz.lamb.tiles = {
		"petz_lamb_top.png", "petz_lamb_bottom.png", "petz_lamb_right.png",
		"petz_lamb_left.png", "petz_lamb_back.png", "petz_lamb_front.png"
	}
	petz.lamb.tiles_shaved = {
		"petz_lamb_shaved_top.png", "petz_lamb_shaved_bottom.png", "petz_lamb_shaved_right.png",
		"petz_lamb_shaved_left.png", "petz_lamb_shaved_back.png", "petz_lamb_shaved_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.lamb.tiles)		
	textures= {"petz:lamb_block"}
	collisionbox = {-0.35, -0.75*scale_lamb, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_lamb.b3d'	
	textures = {"petz_lamb_white.png"}
	--petz.lamb.textures_shaved = {"petz_lamb_shaved_white.png"}
	collisionbox = {-0.35, -0.75*scale_lamb, -0.28, 0.35, -0.3125, 0.28}
end


mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_lamb, y=petz.settings.visual_size.y*scale_lamb},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,    
    runaway = true,
    pushable = true,
    floats = 1,
	jump = true,
	follow = petz.settings.lamb_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_lamb_bleat",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand4_start = 82, stand4_end = 94,	
	},
    view_range = 4,
    fear_height = 3,
    replace_rate = 10,
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
    },
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
 	on_replace = function(self, pos, oldnode, newnode)
		petz.lamb_wool_regrow(self)
    end,
    after_activate = function(self, staticdata, def, dtime)
    	if not self.custom_vars_set03 then --but do not set here! instead wait for the do-custom function to do it.
    		local color
    		if petz.settings.type_model == "mesh" then --set a random color    			
    			local random_number = math.random(1, 15)
    			if random_number == 1 then
					color = "brown"
				elseif random_number >= 2 and random_number <= 4 then
					color = "dark_grey"
				elseif random_number >= 5 and random_number <= 7 then				
					color = "grey"
				else				
					color = "white"
				end		
				self.textures_color = {"petz_lamb_"..color..".png"}
				self.textures_shaved = {"petz_lamb_shaved_"..color..".png"}
			else --if 'cubic'
				self.tiles_color = petz.lamb.tiles
				self.tiles_shaved = petz.lamb.tiles_shaved
				color = "white" --cubic lamb color is always white
			end
			self.wool_color = color				    			    	
		end 		
    	if self.shaved then
    		self.object:set_properties({textures = self.textures_shaved})
    	else
    		self.object:set_properties({textures = self.textures_color})
    	end
    end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set04 then
			self.custom_vars_set04 = 0
			self.petz_type = "lamb"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false			
			self.shaved = false
			self.food_count = 0
			self.capture_item = "lasso"
		end	
	end,
})

mobs:register_egg("petz:lamb", S("Lamb"), "petz_spawnegg_lamb.png", 0)

mobs:spawn({
	name = "petz:lamb",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.lamb_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})

petz.lamb_wool_regrow = function(self)
	self.food_count = (self.food_count or 0) + 1        
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
    clicker:get_inventory():add_item("main", "wool:"..self.wool_color)
    petz.do_sound_effect("object", self.object, "petz_lamb_moaning")
	if petz.settings.type_model == "mesh" then
		self.object:set_properties({textures = self.textures_shaved})
	else
		self.object:set_properties({tiles = petz.lamb.tiles_shaved})
	end 
	self.shaved = true           
end
