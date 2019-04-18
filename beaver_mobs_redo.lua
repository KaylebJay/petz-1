--
--BEAVER
--
local S, modpath, mg_name = ...

local pet_name = "beaver"
local mesh = nil
local scale_beaver = 1.2
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
    stand2_start = 47, stand2_end = 59,	 --sit   
    stand3_start = 71, stand3_end = 91,	
    stand4_start = 82, stand4_end = 95,	
}
local animation_aquatic = {
    speed_normal = 15, walk_start = 96, walk_end = 121, --swin
    speed_run = 25, run_start = 96, run_end = 121,
    stand_start = 26, stand_end = 46,		
    stand2_start = 82, stand2_end = 95,	
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.1875, -0.375, -0.25, 0.125, -0.0625002, 0.1875}, -- body
		{-0.1875, -0.375, -0.375, 0.125, -0.125, -0.25}, -- head
		{-0.125, -0.375, -0.4375, 0.0625, -0.25, -0.375}, -- snout
		{-0.125, -0.25, 0.1875, 0.0625, -0.1875, 0.5}, -- tail
		{-0.0625, -0.4375, -0.4375, -5.58794e-09, -0.375, -0.375}, -- teeth
		{0, -0.5, -0.25, 0.125, -0.375, -0.125}, -- front_left_leg
		{-0.1875, -0.5, -0.25, -0.0625, -0.375, -0.125}, -- front_right_leg
		{0, -0.5, 0.0625, 0.125, -0.375, 0.1875}, -- back_left_leg
		{-0.1875, -0.5, 0.0625, -0.0625, -0.375, 0.1875}, -- back_right_leg
		{-0.25, -0.25, -0.3125, -0.1875, -0.1875, -0.25}, -- left_ear
		{0.125, -0.25, -0.3125, 0.1875, -0.1875, -0.25}, -- right_ear
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
    fly_in = spawn_nodes,
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
		random = "petz_beaver_sound",
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
			self.petz_type = "beaver"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
			self.dam_created = false	
			self.animation_terrestrial = animation_terrestrial
			self.animation_aquatic = animation_aquatic			
		end
	petz.semiaquatic_behaviour(self)
	end,
})

mobs:register_egg("petz:beaver", S("Beaver"), "petz_spawnegg_beaver.png", 0)

mobs:spawn({
	name = "petz:beaver",
	nodes = spawn_nodes,
	--neighbors = {"default:sand", "default:dirt", "group:seaplants"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.beaver_spawn_chance,
	min_height = -8,
	max_height = 200,
	day_toggle = true,
})
