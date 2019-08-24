--
--PIGGY
--
local S = ...

local pet_name = "piggy"
local scale_model = 0.85
petz.piggy = {}
local mesh = 'petz_piggy.b3d'	
local textures = {"petz_piggy.png"}
local collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, 0.35, 0.28}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "piggy",	
	init_tamagochi_timer = false,	
	is_pet = true,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = false,
	capture_item = "lasso",
	follow = petz.settings.piggy_follow,
	drops = {
		{name = "petz:raw_porkchop", chance = 2, min = 1, max = 1,},		
		{name = "petz:bone", chance = 5, min = 1, max = 1,},
	},
	rotate = petz.settings.rotate,
	physical = true,
	stepheight = 0.1,	--EVIL!
	collide_with_objects = true,
	collisionbox = collisionbox,
	visual = petz.settings.visual,
	mesh = mesh,
	textures = textures,
	visual_size = {x=petz.settings.visual_size.x*scale_model, y=petz.settings.visual_size.y*scale_model},
	static_save = true,
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2,
	jump_height = 1.5,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 10,
	makes_footstep_sound = true,
	
	attack={range=0.5, damage_groups={fleshy=3}},		
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
			{range={x=82, y=94}, speed=5, loop=true},		
		},	
	},
	sounds = {
		misc = "petz_piggy_squeal",
		moaning = "petz_piggy_moaning",
	},
	
	brainfunc = petz.herbivore_brain,
	
	on_activate = function(self, staticdata, dtime_s) --on_activate, required
		mobkit.actfunc(self, staticdata, dtime_s)
		petz.set_initial_properties(self, staticdata, dtime_s)
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)		
		petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	end,
	
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	
	on_step = function(self, dtime)	
		mobkit.stepfunc(self, dtime) -- required
		if self.init_tamagochi_timer == true then
			petz.init_tamagochi_timer(self)
		end
	end,
})

petz:register_egg("petz:piggy", S("Piggy"), "petz_spawnegg_piggy.png", 0)
