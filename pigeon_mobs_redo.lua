--
--PIGEON
--
local S = ...

local pet_name = "pigeon"
local mesh = nil
local scale_pigeon = 1.2
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
		{-0.125, -0.5, -0.0625, -0.0625, -0.4375, 7.45058e-09}, -- right_leg
		{0, -0.5, -0.0625, 0.0625, -0.4375, 1.86265e-08}, -- left_leg
		{-0.125, -0.4375, -0.125, 0.0625, -0.25, 0.0625}, -- body
		{-0.125, -0.375, 0.0625, 0.0625, -0.3125, 0.125}, -- front_tail
		{-0.0625, -0.25, -0.1875, 1.11759e-08, -0.1875, -0.125}, -- beak
		{-0.125, -0.25, -0.125, 0.0625, -0.125, 9.68575e-08}, -- head
		{0.0625, -0.3125, -0.0625, 0.125, -0.25, 0.0625}, -- left_wing_top
		{0.0625, -0.375, -0.0625, 0.125, -0.3125, 0}, -- left_wing_bottom
		{-0.1875, -0.3125, -0.0625, -0.125, -0.25, 0.0625}, -- right_wing_top
		{-0.1875, -0.375, -0.0625, -0.125, -0.3125, 0}, -- right_wing_bottom
		{-0.0625, -0.375, 0.125, 3.72529e-09, -0.3125, 0.1875}, -- back_tail
	}
	tiles = {
		"petz_pigeon_top.png",
		"petz_pigeon_bottom.png",
		"petz_pigeon_right.png",
		"petz_pigeon_left.png",
		"petz_pigeon_back.png",
		"petz_pigeon_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:pigeon_block"}
	collisionbox = {-0.35, -0.75*scale_pigeon, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_pigeon.b3d'	
	textures= {{"petz_pigeon.png"}, {"petz_pigeon2.png"}, {"petz_pigeon3.png"}}
	collisionbox = {-0.25, -0.75*scale_pigeon, -0.25, 0.25, -0.25, 0.25}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_pigeon, y=petz.settings.visual_size.y*scale_pigeon},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	physical = true,
	collide_with_objects = true,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1, 
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = "air",
    floats = 1,
	jump = false,
	follow = petz.settings.pigeon_follow,
	drops = {
		--{name = "petz:raw_pigeon", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_pigeon_cooing",
	},
    animation = animation_fly,
    view_range = 5,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set01 then
			self.custom_vars_set01 = 0
			self.petz_type = "pigeon"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
			self.is_flying = true		
			self.animation_ground = animation_ground
			self.animation_fly = animation_fly
			self.capture_item = "net"
		end
		petz.init_timer(self)
		petz.fly_behaviour(self)
	end,
})

mobs:register_egg("petz:pigeon", S("Pigeon"), "petz_spawnegg_pigeon.png", 0)

mobs:spawn({
	name = "petz:pigeon",
	nodes = {"default:leaves"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.pigeon_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
