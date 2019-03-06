--
--KITTY
--
local S = ...

local pet_name = "kitty"
local mesh = nil
local textures = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
				{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
				{-0.125, -0.5, -0.1875, -0.0625, -0.375, -0.125}, -- front_right_leg
				{0, -0.5, -0.1875, 0.0625, -0.375, -0.125}, -- front_left_leg
				{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
				{-0.125, -0.375, -0.1875, 0.0625, -0.25, 0.125}, -- body
				{-0.125, -0.3125, -0.3125, 0.0625, -0.125, -0.125}, -- head
				{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- top_tail
				{-0.125, -0.125, -0.25, -0.0625, -0.0625, -0.1875}, -- right_ear
				{-0.0625, -0.375, 0.1875, 0.0, -0.3125, 0.3125}, -- bottom_tail
				{0, -0.125, -0.25, 0.0625, -0.0625, -0.1875}, -- left_ear
	}
	tiles = {
		"petz_kitty_top.png",
		"petz_kitty_bottom.png",
		"petz_kitty_right.png",
		"petz_kitty_left.png",
		"petz_kitty_back.png",
		"petz_kitty_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:kitty_block"}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_kitty.b3d'	
	textures= {{"petz_kitty.png"}, {"petz_kitty2.png"}, {"petz_kitty3.png"}}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.3125, 0.28}
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
	follow = petz.settings.kitty_follow,	
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
	water_damage = 2,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_kitty_meow",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 45,		
    	stand2_start = 46, stand2_end = 58,	
    	stand3_start = 59, stand3_end = 80,	
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
		petz.on_rightclick(self, clicker, pet_name)
	end,
	on_step = function(self, dtime)
		petz.on_step(self, dtime)
	end,
	after_activate = function(self, staticdata, def, dtime)
		self.init_timer = true
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set then
			self.custom_vars_set = 0
			self.affinity = 100
			self.init_timer = true
			self.fed= false
			self.brushed = false
		end
		if petz.settings.tamagochi_mode == true and self.init_timer == true then
        	petz.timer(self, pet_name)        
    	end
	end,
})

