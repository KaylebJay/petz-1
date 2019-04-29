--
--LAMB
--
local S = ...

local pet_name = "piggy"

local mesh = nil
local fixed = {}
local textures
local scale_piggy = 0.85
petz.piggy = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
			{-0.1875, -0.5, 0.3125, -0.0625, -0.25, 0.4375}, -- back_right_leg
			{-0.1875, -0.5, -0.125, -0.0625, -0.25, 7.45058e-09}, -- front_right_leg
			{0.0625, -0.5, -0.125, 0.1875, -0.25, 1.11759e-08}, -- front_left_leg
			{0.0625, -0.5, 0.3125, 0.1875, -0.25, 0.4375}, -- back_left_leg
			{-0.1875, -0.25, -0.1875, 0.1875, 0.0625, 0.375}, -- body
			{-0.1875, -0.0625, -0.3125, 0.1875, 0.375, 0.0625}, -- head
			{0, -0.0625, 0.375, 0.0624999, -6.70552e-08, 0.4375}, -- top_tail
			{-0.3125, 0.1875, -0.1875, -0.1875, 0.3125, -0.0625}, -- right_ear
			{0, -0.1875, 0.375, 0.0625, -0.125, 0.4375}, -- bottom_tail
			{0.1875, 0.1875, -0.1875, 0.3125, 0.3125, -0.0625}, -- left_ear
			{-0.0625, -0.125, 0.375, -2.98023e-08, -0.0625001, 0.4375}, -- middle_tail
			{-0.125, 0, -0.375, 0.125, 0.1875, -0.3125}, -- snout
	}
	petz.piggy.tiles = {
		"petz_piggy_top.png", "petz_piggy_bottom.png", "petz_piggy_right.png",
		"petz_piggy_left.png", "petz_piggy_back.png", "petz_piggy_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.piggy.tiles)		
	textures= {"petz:piggy_block"}
	collisionbox = {-0.35, -0.75*scale_piggy, -0.28, 0.35, -0.3125, 0.28}
else
	mesh = 'petz_piggy.b3d'	
	textures = {"petz_piggy.png"}
	collisionbox = {-0.35, -0.75*scale_piggy, -0.28, 0.35, 0.35, 0.28}
end


mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_piggy, y=petz.settings.visual_size.y*scale_piggy},
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
	follow = petz.settings.piggy_follow,
	drops = {
		{name = "petz:raw_porkchop", chance = 2, min = 1, max = 1,},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_piggy_squeal",
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
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set03 then
			self.custom_vars_set03 = 0
			self.petz_type = "piggy"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false			
			self.food_count = 0	
		end	
	end,
})

mobs:register_egg("petz:piggy", S("Piggy"), "petz_spawnegg_piggy.png", 0)

mobs:spawn({
	name = "petz:piggy",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.piggy_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
