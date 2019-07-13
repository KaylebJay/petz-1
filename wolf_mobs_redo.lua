--
--LION
--
local S = ...

local pet_name = "wolf"

local mesh = nil
local fixed = {}
local textures
local scale_wolf = 2.3
petz.wolf = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.375, -0.375, 0.0625, -0.3125, -0.25}, -- jaw
		{-0.125, -0.5, -0.1875, -0.0625, -0.3125, -0.125}, -- right_front_leg
		{0, -0.5, -0.1875, 0.0625, -0.3125, -0.125}, -- left_front_leg
		{-0.125, -0.3125, -0.375, 0.0625, -0.25, -0.3125}, -- snout
		{-0.125, -0.3125, -0.3125, 0.0625, -0.125, -0.1875}, -- head
		{-0.1875, -0.3125, -0.1875, 0.125, -0.125, -0.0625}, -- mane
		{-0.125, -0.3125, -0.0625, 0.0625, -0.125, 0.1875}, -- body
		{-0.125, -0.125, -0.25, -0.0625, -0.0625, -0.1875}, -- right_ear
		{0, -0.125, -0.25, 0.0625, -0.0625, -0.1875}, -- left_ear
		{0, -0.5, 0.125, 0.0625, -0.3125, 0.1875}, -- left_back_leg
		{-0.125, -0.5, 0.125, -0.0625, -0.3125, 0.1875}, -- right_back_leg
		{-0.0625, -0.1875, 0.1875, 0, -0.125, 0.375}, -- tail
	}
	petz.wolf.tiles = {
		"petz_wolf_top.png", "petz_wolf_bottom.png", "petz_wolf_right.png",
		"petz_wolf_left.png", "petz_wolf_back.png", "petz_wolf_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.wolf.tiles)		
	textures= {"petz:wolf_block"}
	collisionbox = {-0.5, -0.75*scale_wolf, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_wolf.b3d'	
	textures = {"petz_wolf.png"}	
	collisionbox = {-0.5, -0.75*scale_wolf, -0.5, 0.375, -0.375, 0.375}
end

mobs:register_mob("petz:"..pet_name, {
	type = "monster",
	rotate = petz.settings.rotate,
	attack_type = 'dogfight',
	damage = 8,
    hp_min = 20,
    hp_max = 25,
    armor = 350,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_wolf, y=petz.settings.visual_size.y*scale_wolf},
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
	follow = petz.settings.wolf_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_wolf_howl",
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
		if not self.custom_vars_set06 then
			self.custom_vars_set06 = 0
			self.petz_type = "wolf"
			self.is_pet = true
			self.is_wild = true
			self.give_orders = true
			self.has_affinity = true
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.can_be_brushed = true
			self.brushed = false
			self.beaver_oil_applied = false
			self.lashed = false
			self.lashing_count = 0
			self.capture_item = "lasso"
		end
		petz.init_timer(self)
	end,
})

mobs:register_egg("petz:wolf", S("Wolf"), "petz_spawnegg_wolf.png", 0)

mobs:spawn({
	name = "petz:wolf",
	nodes = {"default:dirt_with_dry_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.wolf_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
