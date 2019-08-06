--
--FROG
--
local S, modpath, mg_name = ...

local pet_name = "frog"
local mesh = nil
local scale_frog = 0.8
local textures = {}
local collisionbox = {}
local fixed = {}
local tiles = {}
local spawn_nodes = {}
if mg_name == "valleys" then
   spawn_nodes = {"default:river_water_source"}
else
   spawn_nodes = {"default:water_source"}
end
local animation_terrestrial = {
    speed_normal = 15, walk_start = 26, walk_end = 38,
    speed_run = 25, run_start = 26, run_end = 38,
    stand_start = 0, stand_end = 12,
}
local animation_aquatic = {
    speed_normal = 15, walk_start = 39, walk_end = 51, --swin
    speed_run = 25, run_start = 39, run_end = 51,
    stand_start = 52, stand_end = 61,		
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.1875, -0.5, -0.1875, -0.125, -0.4375, -0.125}, -- front_right_finger
		{-0.25, -0.5, -0.125, -0.1875, -0.4375, -0.0625}, -- back_right_finger
		{-0.1875, -0.5, -0.125, -0.125, -0.375, -0.0625}, -- bottom_right_leg
		{-0.125, -0.4375, 0, -0.1875, -0.3125, -0.0625}, -- top_right_leg
		{-0.1875, -0.375, 0.0625, -0.125, -0.3125, 0.1875}, -- NodeBox5
		{-0.1875, -0.5, 0.125, -0.125, -0.4375, 0.1875}, -- NodeBox6
		{-0.25, -0.5, 0.125, -0.1875, -0.4375, 0.1875}, -- NodeBox8
		{-0.1875, -0.5, 0.0625, -0.125, -0.4375, 0.125}, -- NodeBox9
		{-0.125, -0.4375, -0.125, 0.0625, -0.375, 0.1875}, -- NodeBox10
		{-0.125, -0.375, -0.1875, 0.0625, -0.1875, 4.47035e-08}, -- NodeBox11
		{-0.125, -0.375, 0, 0.0625, -0.25, 0.125}, -- NodeBox12
		{0.0625, -0.5, -0.1875, 0.125, -0.4375, -0.125}, -- NodeBox14
		{0.125, -0.5, -0.125, 0.1875, -0.4375, -0.0625}, -- NodeBoX45
		{0.0625, -0.5, -0.125, 0.125, -0.375, -0.0625}, -- NodeBox15
		{0.0625, -0.4375, -0.0625, 0.125, -0.3125, 5.21541e-08}, -- NodeBox16
		{0.0625, -0.375, 0.0625, 0.125, -0.3125, 0.1875}, -- NodeBox17
		{0.0625, -0.5, 0.125, 0.125, -0.4375, 0.1875}, -- NodeBox18
		{0.125, -0.5, 0.125, 0.1875, -0.4375, 0.1875}, -- NodeBox19
		{0.0625, -0.5, 0.0625, 0.125, -0.4375, 0.125}, -- NodeBox20
		{-0.1875, -0.4375, 0.125, -0.125, -0.375, 0.25}, -- NodeBox21
		{0.0625, -0.4375, 0.125, 0.125, -0.375, 0.25}, -- NodeBox22
	}
	tiles = {
		"petz_frog_top.png",
		"petz_frog_bottom.png",
		"petz_frog_right.png",
		"petz_frog_left.png",
		"petz_frog_back.png",
		"petz_frog_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:frog_block"}
	collisionbox = {-0.35, -0.75*scale_frog, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_frog.b3d'	
	textures= {{"petz_frog.png"}, {"petz_frog2.png"}, {"petz_frog3.png"}}
	collisionbox = {-0.35, -0.75*scale_frog, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_frog, y=petz.settings.visual_size.y*scale_frog},
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
    fly_in = spawn_nodes,
    floats = 1,
	jump = true,
	follow = petz.settings.frog_follow,
	drops = {
		{name = "petz:frog_leg", chance = 1, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_frog_croak",
	},
    animation = animation_aquatic,
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
		if not self.custom_vars_set05 then
			self.custom_vars_set05 = 0
			self.petz_type = "frog"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false			
			self.animation_terrestrial = animation_terrestrial
			self.animation_aquatic = animation_aquatic
			self.capture_item = "net"	
		end
	petz.semiaquatic_behaviour(self)
	end,
})

mobs:register_egg("petz:frog", S("Frog"), "petz_spawnegg_frog.png", 0)

mobs:spawn({
	name = "petz:frog",
	nodes = spawn_nodes,
	--neighbors = {"default:sand", "default:dirt", "group:seaplants"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.frog_spawn_chance,
	min_height = -8,
	max_height = 200,
	day_toggle = true,
})
