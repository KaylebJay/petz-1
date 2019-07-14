--
--DUCKY
--
local S = ...

local pet_name = "ducky"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local scale_model = 1.3
local textures = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, -0.0625, -0.0625, -0.4375, 0.0}, -- right_leg
		{0, -0.5, -0.0625, 0.0625, -0.4375, 0.0}, -- left_leg
		{-0.125, -0.4375, -0.125, 0.0625, -0.25, 0.0625}, -- body
		{-0.125, -0.3125, 0.0625, 0.0625, -0.25, 0.125}, -- tail_top
		{-0.125, -0.25, -0.1875, 0.0625, -0.1875, -0.125}, -- beak
		{-0.125, -0.25, -0.125, 0.0625, -0.0625, 9.68575e-08}, -- head
		{0.0625, -0.3125, -0.0625, 0.125, -0.25, 0.0625}, -- left_wing_top
		{0.0625, -0.375, -0.0625, 0.125, -0.3125, 0}, -- left_wing_bottom
		{-0.1875, -0.3125, -0.0625, -0.125, -0.25, 0.0625}, -- right_wing_top
		{-0.1875, -0.375, -0.0625, -0.125, -0.3125, 0}, -- right_wing_bottom
		{-0.0625, -0.375, 0.0625, -3.35276e-08, -0.3125, 0.125}, -- tail_bottom
	}
	tiles = {
		"petz_ducky_top.png",
		"petz_ducky_bottom.png",
		"petz_ducky_right.png",
		"petz_ducky_left.png",
		"petz_ducky_back.png",
		"petz_ducky_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:ducky_block"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_ducky.b3d'	
	textures= {"petz_ducky.png", "petz_ducky2.png", "petz_ducky3.png"}	
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.3125, 0.28}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "ducky",	
	init_timer = false,	
	is_pet = true,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = false,
	capture_item = "net",
	lay_eggs = true,
	follow = petz.settings.ducky_follow,
	drops = {
		{name = "petz:raw_ducky", chance = 3, min = 1, max = 1,},
		{name = "petz:ducky_feather", chance = 3, min = 1, max = 2,},
		{name = "petz:bone", chance = 6, min = 1, max = 1,},
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
	},
	sounds = {
		misc = "petz_ducky_quack",
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
})

petz:register_egg("petz:ducky", S("Ducky"), "petz_spawnegg_ducky.png", 0)
