--
--ELEPHANT
--
local S = ...

local pet_name = "elephant"
local scale_model = 3.0
petz.elephant = {}
local mesh = 'petz_elephant.b3d'	
local textures = {"petz_elephant_gray.png"}	
local collisionbox = {-0.187500*scale_model, -0.75*scale_model, -0.187500*scale_model, 0.125*scale_model, -0.0625*scale_model, 0.3125*scale_model}

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	attack_type = 'dogfight',
	damage = 8,
    hp_min = 20,
    hp_max = 40,
    armor = 550,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_model, y=petz.settings.visual_size.y*scale_model},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,    
    runaway = true,
    pushable = true,
	jump = true,
	follow = petz.settings.elephant_follow,
	drops = {
		{name = "petz:elephant_tusk", chance = 1, min = 2, max = 2,},		
		{name = "petz:bone", chance = 3, min = 1, max = 2,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_elephant_trumpeting",
	},	
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand2_start = 81, stand2_end = 101,	
    	stand2_start = 101, stand2_end = 121,	
	},
    view_range = 8,
    fear_height = 3,
    after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "elephant"
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
			self.lashed = false
			self.lashing_count = 0
			self.capture_item = "lasso"
		end
		petz.init_timer(self)
	end,
})

mobs:register_egg("petz:elephant", S("Elephant"), "petz_spawnegg_elephant.png", 0)

mobs:spawn({
	name = "petz:elephant",
	nodes = {"default:dirt_with_dry_grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.elephant_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
