--
--PUPPY
--
local S = ...

local pet_name= "puppy"
local scale_model = 1.5
local mesh = nil
local textures = {}
local fixed = {}
local tiles = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.375, -0.25, 0.0625, -0.1875, -0.0625001}, -- head
		{-0.0625, -0.3125, 0.125, 1.11759e-08, -0.25, 0.25}, -- tail
		{-0.125, -0.1875, -0.1875, -0.0625, -0.125, -0.125}, -- right_ear
		{0, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- left_ear
		{-0.125, -0.375, -0.3125, 0.0625, -0.3125, -0.25}, -- snout
		{-0.0625, -0.4375, -0.25, 3.72529e-09, -0.375, -0.1875}, -- tongue
	}
	tiles = {
		"petz_puppy_top.png",
		"petz_puppy_bottom.png",
		"petz_puppy_right.png",
		"petz_puppy_left.png",
		"petz_puppy_back.png",
		"petz_puppy_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:puppy_block"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_puppy.b3d'	
	textures= {"petz_puppy.png", "petz_puppy2.png", "petz_puppy3.png"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.3125, 0.28}
end

minetest.register_entity("petz:"..pet_name, {          
	--Petz specifics	
	type = "puppy",	
	init_tamagochi_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.puppy_follow,
	sleep_at_day = false,
	sleep_at_night = true,
	sleep_ratio = 0.4,
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
	max_hp = 8,
	makes_footstep_sound = false,
		
	attack={range=0.5, damage_groups={fleshy=3}},	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
			{range={x=81, y=94}, speed=5, loop=true},
		},	
		sit = {range={x=60, y=65}, speed=5, loop=false},
		sleep = {range={x=94, y=113}, speed=10, loop=false},
	},
	sounds = {
		misc = "petz_puppy_bark",
		moaning = "petz_puppy_moaning",
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

petz:register_egg("petz:puppy", S("Puppy"), "petz_spawnegg_puppy.png", 0)
