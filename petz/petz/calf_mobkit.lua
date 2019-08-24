--
--CALF
--
local S = ...

local pet_name = "calf"
local scale_model = 3.0
petz.calf = {}
local mesh = 'petz_calf.b3d'	
local textures= {"petz_calf.png", "petz_calf2.png", "petz_calf3.png"}	
local collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "calf",	
	init_tamagochi_timer = false,	
	is_pet = true,
	has_affinity = false,
	milkable = true,
	is_wild = false,
	give_orders = false,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.calf_follow,
	drops = {
		{name = "petz:beef", chance = 1, min = 1, max = 1,},		
		{name = "petz:leather", chance = 2, min = 1, max = 1,},
		{name = "petz:bone", chance = 4, min = 1, max = 1,},
	},
	replace_rate = 10,
	replace_offset = 0,
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
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
	replace_rate = 10,
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
    },
	static_save = true,
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2,
	jump_height = 1.5,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 15,
	makes_footstep_sound = true,

	attack={range=0.5, damage_groups={fleshy=3}},	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
		},	
	},
	sounds = {
		misc = "petz_calf_moo",
		moaning = "petz_calf_moaning",
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

petz:register_egg("petz:calf", S("Calf"), "petz_spawnegg_calf.png", 0)
