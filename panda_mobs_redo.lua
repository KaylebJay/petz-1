--
--PANDA
--
local S = ...

local pet_name = "panda"
local mesh = nil
local scale_ducky = 1.0
local textures = {}
local fixed = {}
local tiles = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
		fixed = {
			{-0.25, -0.5, 0.25, -0.0625, -0.25, 0.4375}, -- back_right_leg
			{-0.25, -0.5, -0.125, -0.0625, -0.25, 0.0625}, -- front_right_leg
			{0.0625, -0.5, -0.125, 0.25, -0.25, 0.0625}, -- front_left_leg
			{0.0625, -0.5, 0.25, 0.25, -0.25, 0.4375}, -- back_left_leg
			{-0.25, -0.25, -0.125, 0.25, 0.25, 0.4375}, -- body
			{-0.1875, -0.1875, -0.4375, 0.1875, 0.1875, -0.125}, -- head
			{-0.125, 0.1875, -0.3125, -0.0625, 0.25, -0.25}, -- right_ear
			{-0.0625, -0.125, 0.4375, 0.0625, 1.11759e-08, 0.5}, -- tail
			{0.0625, 0.1875, -0.3125, 0.125, 0.25, -0.25}, -- left_ear
			{-0.125, -0.1875, -0.5, 0.125, -0.0625001, -0.4375}, -- snout
		}
	tiles = {
		"petz_panda_top.png",
		"petz_panda_bottom.png",
		"petz_panda_right.png",
		"petz_panda_left.png",
		"petz_panda_back.png",
		"petz_panda_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:panda_block"}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_panda.b3d'	
	textures= {"petz_panda.png"}
	collisionbox = {-0.35, -0.75, -0.28, 0.5, 0.4, 0.5}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    init_timer = true,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = petz.settings.visual_size,
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,
    runaway = true,
    pushable = true,
	jump = true,
	floats = 1,
	follow = petz.settings.panda_follow,	
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 1,
		max = 1,},
		},
	stay_near= {
    	nodes = "petz:pet_bowl",
    	chance = 1,
    },
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_panda_sound",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand3_start = 60, stand3_end = 81,	
		},
    view_range = 4,
    fear_height = 3,
    do_punch = function (self, hitter, time_from_last_punch, tool_capabilities, direction)
    	petz.do_punch(self, hitter, time_from_last_punch, tool_capabilities, direction)
	end,
    on_die = function(self, pos)
    	petz.on_die(self, pos)
    end,
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	on_step = function(self, dtime)
		petz.on_step(self, dtime)
	end,
	after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set05 then
			self.custom_vars_set05 = 0
			self.petz_type = "panda"
			self.is_pet = true
			self.is_wild = false
			self.give_orders = true
			self.has_affinity = true
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.can_be_brushed = true
			self.brushed = false
			self.beaver_oil_applied = false
			self.capture_item = "lasso"
		end
		petz.init_timer(self)
	end,
})

mobs:register_egg("petz:panda", S("Panda"), "petz_spawnegg_panda.png", 0)

mobs:spawn({
	name = "petz:panda",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.panda_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
