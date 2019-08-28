--
--DOLPHIN
--
local S = ...

local pet_name = "dolphin"
local scale_model = 1.35
local mesh = 'petz_dolphin.b3d'	
local textures= {"petz_dolphin_bottlenose.png"}	
local collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.125, 0.28}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "dolphin",	
	can_swin = true,
	groups = {fish= 1},
	is_mammal = true,
	init_tamagochi_timer = false,	
	is_pet = false,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = false,
	capture_item = "lasso",
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
	on_step = mobkit.stepfunc,	-- required
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2.0,
	jump_height = 2.0,
	view_range = 10,
	lung_capacity = 32767, -- seconds
	max_hp = 4,
		    
	animation = {
		swin={range={x=1, y=13}, speed=20, loop=true},			
		stand={
			{range={x=13, y=25}, speed=5, loop=true},				
			{range={x=28, y=43}, speed=5, loop=true},	
		},	
	},

	sounds = {
		misc = "petz_dolphin_clicking",
		moaning = "petz_dolphin_moaning",
	},

	drops = {
		{name = "default:coral_cyan", chance = 5, min = 1, max = 1,},
	},

	brainfunc = petz.aquatic_brain,
	
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
})

petz:register_egg("petz:dolphin", S("Dolphin"), "petz_spawnegg_dolphin.png", 0)
