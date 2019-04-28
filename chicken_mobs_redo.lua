--
--CHICKEN
--
local S = ...

local pet_name = "chicken"
local mesh = nil
local scale_chicken = 1.4
local textures = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, -0.0625, -0.0625, -0.4375, 7.45058e-09}, -- right_leg
		{0, -0.5, -0.0625, 0.0625, -0.4375, 1.86265e-08}, -- left_leg
		{-0.125, -0.4375, -0.125, 0.0625, -0.25, 0.0625}, -- body
		{-0.0625, -0.3125, 0.0625, 9.31323e-09, -0.25, 0.125}, -- tail
		{-0.0625, -0.25, -0.1875, 1.11759e-08, -0.1875, -0.125}, -- beak
		{-0.0625, -0.125, -0.125, -3.72529e-09, -0.0625, -0.0625}, -- crest
		{-0.125, -0.25, -0.125, 0.0625, -0.125, 9.68575e-08}, -- head
		{0.0625, -0.3125, -0.0625, 0.125, -0.25, 0.0625}, -- left_wing_top
		{0.0625, -0.375, -0.0625, 0.125, -0.3125, 0}, -- left_wing_bottom
		{-0.1875, -0.3125, -0.0625, -0.125, -0.25, 0.0625}, -- right_wing_top
		{-0.1875, -0.375, -0.0625, -0.125, -0.3125, 0}, -- right_wing_bottom
	}
	tiles = {
		"petz_chicken_top.png",
		"petz_chicken_bottom.png",
		"petz_chicken_right.png",
		"petz_chicken_left.png",
		"petz_chicken_back.png",
		"petz_chicken_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:chicken_block"}
	collisionbox = {-0.35, -0.75*scale_chicken, -0.28, 0.35, -0.3125, 0.28}
else
	mesh = 'petz_chicken.b3d'	
	textures= {{"petz_chicken.png"}, {"petz_chicken2.png"}, {"petz_chicken3.png"}}
	collisionbox = {-0.35, -0.75*scale_chicken, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_chicken, y=petz.settings.visual_size.y*scale_chicken},
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
	follow = petz.settings.chicken_follow,
	drops = {
		{name = "petz:raw_chicken", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_chicken_cluck",
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
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "chicken"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
		end
		petz.lay_egg(self)
	end,
})

mobs:register_egg("petz:chicken", S("Chicken"), "petz_spawnegg_chicken.png", 0)

mobs:spawn({
	name = "petz:chicken",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.chicken_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
