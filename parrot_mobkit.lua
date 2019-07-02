local S = ...

local pet_name = "parrot"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local scale_model = 0.7
local textures = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.375, -0.1875, 0.125, -0.0625, -2.98023e-08}, -- bottom_body
		{-0.0625, -0.5, -0.125, 2.79397e-08, -0.375, -0.0625}, -- right_leg
		{0.0625, -0.5, -0.125, 0.125, -0.375, -0.0625}, -- left_leg
		{-0.0625, -0.0625, -0.125, 0.125, 0.0625, -1.49012e-08}, -- bottom_head
		{0, -0.0625, -0.25, 0.0625, 0.0625, -0.125}, -- beak
		{-0.0625, 0.0625, -0.1875, 0.125, 0.125, 1.49012e-08}, -- top_head
		{0, 0.125, -0.125, 0.0625, 0.1875, 0}, -- bottom_crest
		{0, 0.1875, -0.125, 0.0625, 0.25, -0.0625}, -- top_crest
		{0, 0.25, -0.0625, 0.0625, 0.3125, -2.04891e-08}, -- 01_crest
		{0, 0.1875, 0, 0.0625, 0.25, 0.0625}, -- 02_crest
		{0, 0.25, 0.0625, 0.0625, 0.3125, 0.125}, -- 03_crest
		{-0.125, -0.25, -0.1875, -0.0624999, -0.0624999, 3.72529e-09}, -- top_right_wing
		{-0.125, -0.25, 0, -0.0625, -0.125, 0.0625}, -- back_right_wing
		{-0.125, -0.3125, -0.125, -0.0625, -0.25, -0.0625}, -- front_right_wing
		{-0.125, -0.375, -0.0625, -0.0625, -0.25, 0.125}, -- bottom_right_wing
		{0.125, -0.25, -0.1875, 0.1875, -0.0625, 4.47035e-08}, -- top_left_wing
		{0.125, -0.25, 0, 0.1875, -0.125, 0.0624999}, -- back_left_wing
		{0.125, -0.3125, -0.125, 0.1875, -0.25, -0.0625}, -- front_left_wing
		{0.125, -0.375, -0.0625, 0.1875, -0.25, 0.125}, -- bottom_left_wing
		{-0.0625, -0.4375, 0, 0.125, -0.375, 0.125}, -- top_tail
		{-0.0625, -0.5, 0.0625, 0.125, -0.4375, 0.1875}, -- bottom_tail
	}
	tiles = {
		"petz_parrot_top.png",
		"petz_parrot_bottom.png",
		"petz_parrot_right.png",
		"petz_parrot_left.png",
		"petz_parrot_back.png",
		"petz_parrot_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:parrot_block"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_parrot.b3d'	
	textures= {"petz_parrot.png", "petz_parrot2.png", "petz_parrot3.png"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, 0.35, 0.28}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "parrot",	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "net",
	follow = petz.settings.parrot_follow,
	drops = {
		{name = "petz:raw_parrot", chance = 3, min = 1, max = 1,},
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
	jump_height = 2.0,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 108,
	
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
		misc = "petz_parrot_chirp",
		moaning = "petz_parrot_moaning",
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
		petz.init_timer(self)
	end,
    
})

petz:register_egg("petz:parrot", S("Parrot"), "petz_spawnegg_parrot.png", false)
