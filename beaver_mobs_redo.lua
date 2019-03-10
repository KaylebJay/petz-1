--
--BEAVER
--
local S, mg_name = ...

local pet_name = "beaver"
local mesh = nil
local scale_beaver = 1.3
local textures = {}
local collisionbox = {}
local spawn_nodes = {}
if mg_name == "valleys" then
   spawn_nodes = {"default:river_water_source"}
else
   spawn_nodes = {"default:water_source"}
end

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, -0.0625, -0.0625, -0.4375, 0.0}, -- right_leg
		{0, -0.5, -0.0625, 0.0625, -0.4375, 0.0}, -- left_leg
		{-0.125, -0.4375, -0.125, 0.0625, -0.25, 0.0625}, -- body
		{-0.125, -0.3125, 0.0625, 0.0625, -0.25, 0.125}, -- tail_top
		{-0.125, -0.25, -0.1875, 0.0625, -0.1875, -0.125}, -- beak
		{-0.125, -0.25, -0.125, 0.0625, -0.0625, 9.68575e-08}, -- head
		{0.0625, -0.3125, -0.0625, 0.125, -0.25, 0.0625}, -- left_wing_top
		{0.0625, -0.375, -0.0625, 0.125, -0.3125, 0}, -- left_wing_bottom
		{-0.1875, -0.3125, -0.0625, -0.125, -0.25, 0.0625}, -- right_wing_top
		{-0.1875, -0.375, -0.0625, -0.125, -0.3125, 0}, -- right_wing_bottom
		{-0.0625, -0.375, 0.0625, -3.35276e-08, -0.3125, 0.125}, -- tail_bottom
	}
	tiles = {
		"petz_beaver_top.png",
		"petz_beaver_bottom.png",
		"petz_beaver_right.png",
		"petz_beaver_left.png",
		"petz_beaver_back.png",
		"petz_beaver_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:beaver_block"}
	collisionbox = {-0.35, -0.75*scale_beaver, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_beaver.b3d'	
	textures= {{"petz_beaver.png"}}
	collisionbox = {-0.35, -0.75*scale_beaver, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_beaver, y=petz.settings.visual_size.y*scale_beaver},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,    
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = "default:water_source",
    floats = 1,
	jump = true,
	follow = petz.settings.beaver_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},
		{name = "petz:beaver_fur", chance = 1, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_beaver_quack",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand3_start = 60, stand3_end = 70,	
    	stand4_start = 71, stand4_end = 91,	
		},
    view_range = 4,
    fear_height = 3,
    stay_near= {
    	nodes = spawn_nodes,
    	chance = 3,
    },
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set02 then
			self.custom_vars_set02 = 0
			self.petz_type = "beaver"
			self.is_pet = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
		end
		if not self.custom_vars_set then
			self.custom_vars_set = 0
			self.dam_created = false
		end		
		local pos = self.object:get_pos() -- check the beaver pos to togle between aquatic-terrestrial
		local node = minetest.get_node_or_nil(pos)
		if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].groups.water then
    		self.fly = true --it is on water
		else
			local pos_underwater = { --check if water below (when the beaver is still terrestrial but float in the surface of the water)
            	x = pos.x,
            	y = pos.y - 3.5,
            	z = pos.z,
        	}
        	node = minetest.get_node_or_nil(pos_underwater)
        	if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].groups.water then
        		local pos_below = {
            		x = pos.x,
            		y = pos.y - 2.0,
            		z = pos.z,
	        	}
        		self.object:move_to(pos_below, true) -- move the beaver underwater
        		self.fly = true
        	else
        		self.fly = false -- make terrestrial
        	end
		end 
	end,
})

mobs:register_egg("petz:beaver", S("Beaver"), "petz_spawnegg_beaver.png", 0)

mobs:spawn({
	name = "petz:beaver",
    nodes = spawn_nodes,
    neighbors = {"group:water"},
    min_light = 3,
    max_light = 5,
    interval = 90,
    chance = 900, 
    min_height = -5,
    max_height = 0,
    day_toggle = false,
 })