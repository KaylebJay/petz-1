--
--PIGEON
--

local S = ...

local pet_name = "pigeon"
local scale_model = 1.2
local mesh = 'petz_pigeon.b3d'	
local textures= {"petz_pigeon.png", "petz_pigeon2.png", "petz_pigeon3.png"}
local collisionbox = {-0.25, -0.75*scale_model, -0.25, 0.25, -0.25, 0.25}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "pigeon",	
	init_tamagochi_timer = false,	
	can_fly = true,	
	is_pet = false,
	max_height = 5,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = false,
	capture_item = "net",
	follow = petz.settings.pigeon_follow,
	--automatic_face_movement_dir = 0.0,
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
	jump_height = 2.0,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 8,
	
	attack={range=0.5, damage_groups={fleshy=3}},	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
			{range={x=60, y=70}, speed=5, loop=true},		
			{range={x=71, y=91}, speed=5, loop=true},	
		},	
		fly={range={x=92, y=98}, speed=20, loop=true},	
		stand_fly={range={x=92, y=98}, speed=20, loop=true},	
	},
	sounds = {
		misc = "petz_pigeon_cooing",
		moaning = "petz_pigeon_moaning",
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

petz:register_egg("petz:pigeon", S("Pigeon"), "petz_spawnegg_pigeon.png", false)

