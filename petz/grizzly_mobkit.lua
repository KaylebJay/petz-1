--
--GRIZZLY
--
local S = ...

local pet_name = "grizzly"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local fixed = {}
local textures
local scale_model = 2.2
petz.grizzly = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.1875, -0.0625, -0.375, -0.125}, -- front_right_leg
		{0, -0.5, -0.1875, 0.0625, -0.375, -0.125}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.1875, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.375, -0.25, 0.0625, -0.0625, -0.1875}, -- head
		{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- top_tail
		{-0.1875, -0.0625, -0.1875, -0.125, 0.0, -0.125}, -- right_ear
		{-0.0625, -0.375, 0.1875, 0.0, -0.3125, 0.25}, -- bottom_tail
		{0.0625, -0.0625, -0.1875, 0.125, 0.0, -0.125}, -- left_ear
		{-0.125, -0.25, -0.3125, 0.0625, -0.1875, -0.25}, -- snout
		{0.0625, -0.3125, -0.25, 0.125, -0.1875, -0.1875}, -- mane_right
		{-0.1875, -0.3125, -0.25, -0.125, -0.1875, -0.1875}, -- mane_left
		{0.0625, -0.25, -0.1875, 0.125, -0.0625, -0.0625}, -- mane_back_right
		{-0.1875, -0.25, -0.1875, -0.125, -0.0625, -0.0625}, -- mane_back_left
		{-0.125, -0.25, -0.1875, 0.0625, 0.0, -0.0625}, -- mane_front
		{-0.1875, -0.25, -0.0625, 0.125, -0.125, 0.0}, -- mane_back
		{-0.1875, -0.3125, -0.1875, -0.125, -0.25, -0.125}, -- mane_bottom_left
		{0.0625, -0.3125, -0.1875, 0.125, -0.25, -0.125}, -- mane_bottom_right
	}
	petz.grizzly.tiles = {
		"petz_grizzly_top.png", "petz_grizzly_bottom.png", "petz_grizzly_right.png",
		"petz_grizzly_left.png", "petz_grizzly_back.png", "petz_grizzly_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.grizzly.tiles)		
	textures= {"petz:grizzly_block"}
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_grizzly.b3d'	
	textures= {"petz_grizzly.png", "petz_grizzly2.png"}
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "grizzly",	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = true,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.grizzly_follow,	
	drops = {
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
	on_step = mobkit.stepfunc,	-- required
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2.3,
	jump_height = 2.0,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 25,  		
	
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
		misc = "petz_grizzly_growl",
		moaning = "petz_grizzly_moaning",
	},
	
	--punch_start = 83, stand4_end = 95,
	
	brainfunc = petz.predator_brain,
	
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

petz:register_egg("petz:grizzly", S("Grizzly"), "petz_spawnegg_grizzly.png", 0)
