--
--CHIMP
--
local S = ...

local pet_name = "chimp"
local scale_model = 0.85
petz.chimp = {}
local mesh = 'petz_chimp.b3d'	
local textures = {"petz_chimp.png"}
local collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.3125, 0.28}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "chimp",	
	init_tamagochi_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_arboreal = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.chimp_follow,	
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
	jump_height = 5,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 10,
	makes_footstep_sound = true,	
	attack={range=0.5, damage_groups={fleshy=3}},	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=1, y=12}, speed=20, loop=true},	
		stand={
			{range={x=12, y=24}, speed=5, loop=true},		
			{range={x=24, y=36}, speed=10, loop=true},
			{range={x=36, y=48}, speed=10, loop=true},						
		},	
		sit = {range={x=51, y=60}, speed=5, loop=true},	
		hang = {range={x=63, y=75}, speed=5, loop=true},	
		climb= {range={x=78, y=90}, speed=5, loop=true},			
	},
	sounds = {
		misc = "petz_chimp_hoo",
		moaning = "petz_chimp_moaning",
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

petz:register_egg("petz:chimp", S("Chimp"), "petz_spawnegg_chimp.png", 0)
