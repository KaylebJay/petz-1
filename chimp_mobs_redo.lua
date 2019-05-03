--
--CHIMP
--
local S = ...

local pet_name = "chimp"
local mesh = nil
local scale_chimp = 1.5
local textures = {}
local collisionbox = {}
local animation_terrestrial = {
   	speed_normal = 15, walk_start = 0, walk_end = 12,
   	--speed_run = 25, run_start = 13, run_end = 25,
   	stand_start = 24, stand_end = 36,		
   	stand2_start = 36, stand2_end = 48,	
   	stand3_start = 48, stand3_end = 63,	   	
   	stand4_start = 12, stand4_end = 24,
}

local animation_arboreal = {
	speed_normal = 15, walk_start = 78, walk_end = 90,
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.25, -0.1875, 0.125, -0.0624999, 4.47035e-08}, -- head
		{-0.0625, -0.4375, -0.125, 0.125, -0.25, 1.11759e-08}, -- body
		{-0.0625, -0.5, -0.125, -1.86265e-09, -0.4375, -0.0625}, -- right_leg
		{0.0625, -0.5, -0.125, 0.125, -0.4375, -0.0625}, -- left_leg
		{0.125, -0.1875, -0.125, 0.1875, -0.125, -0.0625}, -- left_ear
		{-0.125, -0.1875, -0.125, -0.0625, -0.125, -0.0625}, -- right_ear
		{-0.1875, -0.3125, -0.125, -0.0625, -0.25, -0.0625}, -- top_right_arm
		{-0.1875, -0.4375, -0.125, -0.125, -0.3125, -0.0625}, -- bottom_right_arm
		{0.125, -0.3125, -0.125, 0.25, -0.25, -0.0625}, -- top_left_arm
		{0.1875, -0.4375, -0.125, 0.25, -0.3125, -0.0625}, -- bottom_left_arm
		{0, -0.375, 0, 0.0625, -0.3125, 0.125}, -- bottom_tail
		{0, -0.3125, 0.0625, 0.0625, -0.1875, 0.125}, -- middle_tail
		{0, -0.25, 0.125, 0.0625, -0.1875, 0.1875}, -- top_tail
	}
	tiles = {
		"petz_chimp_top.png",
		"petz_chimp_bottom.png",
		"petz_chimp_right.png",
		"petz_chimp_left.png",
		"petz_chimp_back.png",
		"petz_chimp_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:chimp_block"}
	collisionbox = {-0.35, -0.75*scale_chimp, -0.28, 0.35, -0.3125, 0.28}
else
	mesh = 'petz_chimp.b3d'	
	textures= {{"petz_chimp.png"}}
	collisionbox = {-0.35, -0.75*scale_chimp, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_chimp, y=petz.settings.visual_size.y*scale_chimp},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,	
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1, 
    runaway = true,
    pushable = true,
    fly = false,    
    floats = 1,
	jump = true,
	jump_height = 8,
	follow = petz.settings.chimp_follow,
	drops = {
		--{name = "petz:raw_chimp", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_chimp_hoo",
	},
    animation = animation_terrestrial,
    view_range = 8,
    fear_height = 10,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "chimp"
			self.is_pet = true
			self.is_wild = false
			self.give_orders = true
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
			self.is_flying = true
			self.behaviour = "terrestrial"
			self.animation_terrestrial = animation_terrestrial
			self.animation_arboreal = animation_arboreal
		end
		petz.init_timer(self)		
		petz.arboreal_behaviour(self)		
	end,
})

mobs:register_egg("petz:chimp", S("Chimp"), "petz_spawnegg_chimp.png", 0)

mobs:spawn({
	name = "petz:chimp",
	nodes = {"default:jungleleaves"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.chimp_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
