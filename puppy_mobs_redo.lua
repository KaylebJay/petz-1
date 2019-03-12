--
--PUPPY
--
local S = ...

local pet_name= "puppy"
local scale_puppy = 1.5
local mesh = nil
local textures = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.375, -0.25, 0.0625, -0.1875, -0.0625001}, -- head
		{-0.0625, -0.3125, 0.125, 1.11759e-08, -0.25, 0.25}, -- tail
		{-0.125, -0.1875, -0.1875, -0.0625, -0.125, -0.125}, -- right_ear
		{0, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- left_ear
		{-0.125, -0.375, -0.3125, 0.0625, -0.3125, -0.25}, -- snout
		{-0.0625, -0.4375, -0.25, 3.72529e-09, -0.375, -0.1875}, -- tongue
	}
	tiles = {
		"petz_puppy_top.png",
		"petz_puppy_bottom.png",
		"petz_puppy_right.png",
		"petz_puppy_left.png",
		"petz_puppy_back.png",
		"petz_puppy_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:puppy_block"}
	collisionbox = {-0.35, -0.75*scale_puppy, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_puppy.b3d'	
	textures= {{"petz_puppy.png"}, {"petz_puppy2.png"}, {"petz_puppy3.png"}}
	collisionbox = {-0.35, -0.75*scale_puppy, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    affinity = 100,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_puppy, y=petz.settings.visual_size.y*scale_puppy},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,
    runaway = true,
    pushable = true,
	jump = true,
	floats = 1,
	follow = petz.settings.puppy_follow,	
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 1,
		max = 1,},
		},
	stay_near= {
    	nodes = "petz:pet_bowl",
    	chance = 1,
    },
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_puppy_bark",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand3_start = 60, stand3_end = 81,	
    	stand4_start = 82, stand4_end = 94,	
		},
    view_range = 4,
    fear_height = 3,
    do_punch = function (self, hitter, time_from_last_punch, tool_capabilities, direction)
    	petz.do_punch(self, hitter, time_from_last_punch, tool_capabilities, direction)
	end,
    on_die = function(self, pos)
    	petz.on_die(self, pos)
    end,
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	on_step = function(self, dtime)
		petz.on_step(self, dtime)
	end,
	after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set02 then
			self.custom_vars_set02 = 0
			self.petz_type = "puppy"
			self.is_pet = true
			self.give_orders = true
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
		end
		petz.init_timer(self)
	end,
})

mobs:register_egg("petz:puppy", S("Puppy"), "petz_spawnegg_puppy.png", 0)

mobs:spawn({
	name = "petz:puppy",
	nodes = {"default:dirt_with_grass"},
	neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = 8000,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})

