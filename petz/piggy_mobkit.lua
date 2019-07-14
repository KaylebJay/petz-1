--
--PIGGY
--
local S = ...

local pet_name = "piggy"
table.insert(petz.mobs_list, "piggy")
local mesh = nil
local fixed = {}
local textures
local scale_model = 0.85
petz.piggy = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
			{-0.1875, -0.5, 0.3125, -0.0625, -0.25, 0.4375}, -- back_right_leg
			{-0.1875, -0.5, -0.125, -0.0625, -0.25, 7.45058e-09}, -- front_right_leg
			{0.0625, -0.5, -0.125, 0.1875, -0.25, 1.11759e-08}, -- front_left_leg
			{0.0625, -0.5, 0.3125, 0.1875, -0.25, 0.4375}, -- back_left_leg
			{-0.1875, -0.25, -0.1875, 0.1875, 0.0625, 0.375}, -- body
			{-0.1875, -0.0625, -0.3125, 0.1875, 0.375, 0.0625}, -- head
			{0, -0.0625, 0.375, 0.0624999, -6.70552e-08, 0.4375}, -- top_tail
			{-0.3125, 0.1875, -0.1875, -0.1875, 0.3125, -0.0625}, -- right_ear
			{0, -0.1875, 0.375, 0.0625, -0.125, 0.4375}, -- bottom_tail
			{0.1875, 0.1875, -0.1875, 0.3125, 0.3125, -0.0625}, -- left_ear
			{-0.0625, -0.125, 0.375, -2.98023e-08, -0.0625001, 0.4375}, -- middle_tail
			{-0.125, 0, -0.375, 0.125, 0.1875, -0.3125}, -- snout
	}
	petz.piggy.tiles = {
		"petz_piggy_top.png", "petz_piggy_bottom.png", "petz_piggy_right.png",
		"petz_piggy_left.png", "petz_piggy_back.png", "petz_piggy_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.piggy.tiles)		
	textures= {"petz:piggy_block"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.3125, 0.28}
else
	mesh = 'petz_piggy.b3d'	
	textures = {"petz_piggy.png"}
	collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, 0.35, 0.28}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "piggy",	
	init_timer = false,	
	is_pet = true,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = false,
	capture_item = "lasso",
	--predator = "wolf",
	follow = petz.settings.calf_follow,
	drops = {
		{name = "petz:raw_porkchop", chance = 2, min = 1, max = 1,},		
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
	max_hp = 108,
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
})

petz:register_egg("petz:piggy", S("Piggy"), "petz_spawnegg_piggy.png", 0)
