--
--PARROT
--
local S = ...

local pet_name = "parrot"
local mesh = nil
local scale_parrot = 1.3
local textures = {}
local collisionbox = {}
local animation_ground = {
   	speed_normal = 15, walk_start = 1, walk_end = 12,
   	speed_run = 25, run_start = 13, run_end = 25,
   	stand_start = 26, stand_end = 46,		
   	stand2_start = 47, stand2_end = 59,	
   	stand3_start = 60, stand3_end = 70,	
   	stand4_start = 71, stand4_end = 91,	  	
}

local animation_fly = {
	stand_start = 92, stand_end = 98,	
	speed_fly= 50, fly_start = 92, fly_end = 98,  	
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.375, -0.1875, 0.125, -0.0625, -2.98023e-08}, -- bottom_body
		{-0.0625, -0.5, -0.125, 2.79397e-08, -0.375, -0.0625}, -- right_leg
		{0.0625, -0.5, -0.125, 0.125, -0.375, -0.0625}, -- left_leg
		{-0.0625, -0.0625, -0.125, 0.125, 0.0625, -1.49012e-08}, -- bottom_head
		{0, -0.0625, -0.25, 0.0625, 0.0625, -0.125}, -- beak
		{-0.0625, 0.0625, -0.1875, 0.125, 0.125, 1.49012e-08}, -- top_head
		{0, 0.125, -0.125, 0.0625, 0.1875, 0}, -- bottom_crest
		{0, 0.1875, -0.125, 0.0625, 0.25, -0.0625}, -- top_crest
		{0, 0.25, -0.0625, 0.0625, 0.3125, -2.04891e-08}, -- 01_crest
		{0, 0.1875, 0, 0.0625, 0.25, 0.0625}, -- 02_crest
		{0, 0.25, 0.0625, 0.0625, 0.3125, 0.125}, -- 03_crest
		{-0.125, -0.25, -0.1875, -0.0624999, -0.0624999, 3.72529e-09}, -- top_right_wing
		{-0.125, -0.25, 0, -0.0625, -0.125, 0.0625}, -- back_right_wing
		{-0.125, -0.3125, -0.125, -0.0625, -0.25, -0.0625}, -- front_right_wing
		{-0.125, -0.375, -0.0625, -0.0625, -0.25, 0.125}, -- bottom_right_wing
		{0.125, -0.25, -0.1875, 0.1875, -0.0625, 4.47035e-08}, -- top_left_wing
		{0.125, -0.25, 0, 0.1875, -0.125, 0.0624999}, -- back_left_wing
		{0.125, -0.3125, -0.125, 0.1875, -0.25, -0.0625}, -- front_left_wing
		{0.125, -0.375, -0.0625, 0.1875, -0.25, 0.125}, -- bottom_left_wing
		{-0.0625, -0.4375, 0, 0.125, -0.375, 0.125}, -- top_tail
		{-0.0625, -0.5, 0.0625, 0.125, -0.4375, 0.1875}, -- bottom_tail
	}
	tiles = {
		"petz_parrot_top.png",
		"petz_parrot_bottom.png",
		"petz_parrot_right.png",
		"petz_parrot_left.png",
		"petz_parrot_back.png",
		"petz_parrot_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:parrot_block"}
	collisionbox = {-0.35, -0.75*scale_parrot, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_parrot.b3d'	
	textures= {{"petz_parrot.png"}, {"petz_parrot2.png"}, {"petz_parrot3.png"}}
	collisionbox = {-0.35, -0.75*scale_parrot, -0.28, 0.35, 0.35, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_parrot, y=petz.settings.visual_size.y*scale_parrot},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,	
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1, 
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = "air",
    floats = 1,
	jump = false,
	follow = petz.settings.parrot_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 5, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_parrot_chirp",
	},
    animation = animation_fly,
    view_range = 4,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "parrot"
			self.is_pet = true
			self.is_wild = false
			self.give_orders = true
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
			self.is_flying = true		
			self.animation_ground = animation_ground
			self.animation_fly = animation_fly
		end
		petz.fly_behaviour(self)
	end,
})

mobs:register_egg("petz:parrot", S("Parrot"), "petz_spawnegg_parrot.png", 0)

mobs:spawn({
	name = "petz:parrot",
	nodes = {"default:jungleleaves"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.parrot_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
