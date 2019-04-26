--
--LION
--
local S = ...

local pet_name = "lion"

local mesh = nil
local fixed = {}
local textures
local scale_lion = 2.3
petz.lion = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.1875, -0.0625, -0.375, -0.125}, -- front_right_leg
		{0, -0.5, -0.1875, 0.0625, -0.375, -0.125}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.1875, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.375, -0.25, 0.0625, -0.0625, -0.1875}, -- head
		{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- top_tail
		{-0.1875, -0.0625, -0.1875, -0.125, 0.0, -0.125}, -- right_ear
		{-0.0625, -0.375, 0.1875, 0.0, -0.3125, 0.25}, -- bottom_tail
		{0.0625, -0.0625, -0.1875, 0.125, 0.0, -0.125}, -- left_ear
		{-0.125, -0.25, -0.3125, 0.0625, -0.1875, -0.25}, -- snout
		{0.0625, -0.3125, -0.25, 0.125, -0.1875, -0.1875}, -- mane_right
		{-0.1875, -0.3125, -0.25, -0.125, -0.1875, -0.1875}, -- mane_left
		{0.0625, -0.25, -0.1875, 0.125, -0.0625, -0.0625}, -- mane_back_right
		{-0.1875, -0.25, -0.1875, -0.125, -0.0625, -0.0625}, -- mane_back_left
		{-0.125, -0.25, -0.1875, 0.0625, 0.0, -0.0625}, -- mane_front
		{-0.1875, -0.25, -0.0625, 0.125, -0.125, 0.0}, -- mane_back
		{-0.1875, -0.3125, -0.1875, -0.125, -0.25, -0.125}, -- mane_bottom_left
		{0.0625, -0.3125, -0.1875, 0.125, -0.25, -0.125}, -- mane_bottom_right
	}
	petz.lion.tiles = {
		"petz_lion_top.png", "petz_lion_bottom.png", "petz_lion_right.png",
		"petz_lion_left.png", "petz_lion_back.png", "petz_lion_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.lion.tiles)		
	textures= {"petz:lion_block"}
	collisionbox = {-0.5, -0.75*scale_lion, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_lion.b3d'	
	textures = {"petz_lion.png"}	
	collisionbox = {-0.5, -0.75*scale_lion, -0.5, 0.375, -0.375, 0.375}
end

mobs:register_mob("petz:"..pet_name, {
	type = "monster",
	rotate = petz.settings.rotate,
	attack_type = 'dogfight',
	damage = 8,
    hp_min = 20,
    hp_max = 30,
    armor = 400,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_lion, y=petz.settings.visual_size.y*scale_lion},
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
	follow = petz.settings.lion_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_lion_roar",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand4_start = 82, stand4_end = 94,	
    	punch_start = 83, stand4_end = 95,	
	},
    view_range = 8,
    fear_height = 3,
    after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_punch = function (self, hitter, time_from_last_punch, tool_capabilities, direction)
		petz.tame_whip(self, hitter)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set04 then
			self.custom_vars_set04 = 0
			self.petz_type = "lion"
			self.is_pet = true
			self.is_wild = true
			self.give_orders = true
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
			self.lashed = false
			self.lashing_count = 0
		end
		petz.init_timer(self)
	end,
})

mobs:register_egg("petz:lion", S("Lion"), "petz_spawnegg_lion.png", 0)

mobs:spawn({
	name = "petz:lion",
	nodes = {"default:dirt_with_dry_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.lion_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
