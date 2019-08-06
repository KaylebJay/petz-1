--
--TURTLE
--
local S, modpath, mg_name = ...

local pet_name = "turtle"
local mesh = nil
local scale_turtle = 1.3
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
    speed_normal = 15, walk_start = 1, walk_end = 12,
    speed_run = 25, run_start = 13, run_end = 25,
    stand_start = 26, stand_end = 46,		
    stand2_start = 47, stand2_end = 59,	
}
local animation_aquatic = {
    speed_normal = 15, walk_start = 101, walk_end = 113, --swin
    speed_run = 25, run_start = 101, run_end = 113,
    stand_start = 113, stand_end = 125,		
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.1875, -0.4375, -0.125, 0.1875, -0.25, 0.1875}, -- shell
		{-0.125, -0.4375, -0.25, 0.125, -0.3125, -0.125}, -- head
		{0.0625, -0.5, -0.125, 0.1875, -0.4375, 2.23517e-08}, -- front_leg_left
		{-0.1875, -0.5, -0.125, -0.0625, -0.4375, 4.47035e-08}, -- front_right_leg
		{0.0625, -0.5, 0.0625, 0.1875, -0.4375, 0.1875}, -- back_left_leg
		{-0.1875, -0.5, 0.0625, -0.0625, -0.4375, 0.1875}, -- back_right_leg
		{-0.0625, -0.4375, 0.1875, 0.0625, -0.375, 0.25}, -- tail
	}
	tiles = {
		"petz_turtle_top.png",
		"petz_turtle_bottom.png",
		"petz_turtle_right.png",
		"petz_turtle_left.png",
		"petz_turtle_back.png",
		"petz_turtle_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:turtle_block"}
	collisionbox = {-0.35, -0.75*scale_turtle, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_turtle.b3d'	
	textures= {{"petz_turtle.png"}, {"petz_turtle2.png"}, {"petz_turtle3.png"}}
	collisionbox = {-0.35, -0.75*scale_turtle, -0.28, 0.35, -0.5, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_turtle, y=petz.settings.visual_size.y*scale_turtle},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	physical = true,
	collide_with_objects = true,
	makes_footstep_sound = false,
	walk_velocity = 0.1,
    run_velocity = 0.3,    
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = spawn_nodes,
    floats = 1,
	jump = false,
	follow = petz.settings.turtle_follow,
	drops = {
		{name = "petz:turtle_shell", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		--random = "petz_turtle_croak",
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
		if not self.custom_vars_set01 then
			self.custom_vars_set01 = 0
			self.petz_type = "turtle"
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

mobs:register_egg("petz:turtle", S("Turtle"), "petz_spawnegg_turtle.png", 0)

mobs:spawn({
	name = "petz:turtle",
	nodes = spawn_nodes,
	--neighbors = {"default:sand", "default:dirt", "group:seaplants"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.turtle_spawn_chance,
	min_height = -8,
	max_height = 200,
	day_toggle = true,
})
