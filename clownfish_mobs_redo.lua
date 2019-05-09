--
--CLOWNFISH
--
local S = ...

local pet_name = "clownfish"
local mesh = nil
local scale_clownfish = 1.0
local textures = {}
local collisionbox = {}
local fixed = {}
local tiles = {}
local spawn_nodes = {"default:coral_orange"}
local animation_aquatic = {
    speed_normal = 15, walk_start = 1, walk_end = 13, --swin
    speed_run = 25, run_start = 1, run_end = 13,
    stand_start = 13, stand_end = 25,		
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.5, -0.3125, 0.125, -0.3125, 0.0625}, -- body
		{0, -0.4375, 0.0625, 0.0625, -0.375, 0.1875}, -- font_tail_fin
		{0, -0.375, 0.125, 0.0625, -0.3125, 0.25}, -- top_tail_fin
		{0, -0.5, 0.125, 0.0625, -0.4375, 0.25}, -- bottom_tail_fin
		{0.125, -0.5, -0.125, 0.1875, -0.375, -0.0625}, -- fin_left
		{0.1875, -0.4375, -0.125, 0.25, -0.375, -0.0625}, -- fin_top_left
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- fin_right
		{-0.1875, -0.4375, -0.125, -0.125, -0.375, -0.0625}, -- fin_right_top
		{0, -0.3125, -0.25, 0.0625, -0.25, 0}, -- dorsal_fin
	}
	tiles = {
		"petz_clownfish_top.png",
		"petz_clownfish_bottom.png",
		"petz_clownfish_right.png",
		"petz_clownfish_left.png",
		"petz_clownfish_back.png",
		"petz_clownfish_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:clownfish_block"}
	collisionbox = {-0.35, -0.75*scale_clownfish, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_clownfish.b3d'	
	textures= {{"petz_clownfish.png"}}
	collisionbox = {-0.35, -0.75*scale_clownfish, -0.28, 0.35, -0.5, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_clownfish, y=petz.settings.visual_size.y*scale_clownfish},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1.0,    
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = "default:water_source",
    floats = 1,
	jump = false,
	follow = petz.settings.clownfish_follow,
	drops = {
		--{name = "petz:clownfish_shell", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		--random = "petz_clownfish_croak",
	},
    animation = animation_aquatic,
    view_range = 4,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "clownfish"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false			
			self.animation = animation_aquatic
		end	
	end,
})

mobs:register_egg("petz:clownfish", S("Clownfish"), "petz_spawnegg_clownfish.png", 0)

mobs:spawn({
	name = "petz:clownfish",
	nodes = spawn_nodes,
	--neighbors = {"default:sand", "default:dirt", "group:seaplants"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.clownfish_spawn_chance,
	min_height = -8,
	max_height = 200,
	day_toggle = true,
})
