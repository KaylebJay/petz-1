--
--PANDA
--
local S = ...

local pet_name = "panda"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local scale_model = 1.0
local textures = {}
local fixed = {}
local tiles = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
		fixed = {
			{-0.25, -0.5, 0.25, -0.0625, -0.25, 0.4375}, -- back_right_leg
			{-0.25, -0.5, -0.125, -0.0625, -0.25, 0.0625}, -- front_right_leg
			{0.0625, -0.5, -0.125, 0.25, -0.25, 0.0625}, -- front_left_leg
			{0.0625, -0.5, 0.25, 0.25, -0.25, 0.4375}, -- back_left_leg
			{-0.25, -0.25, -0.125, 0.25, 0.25, 0.4375}, -- body
			{-0.1875, -0.1875, -0.4375, 0.1875, 0.1875, -0.125}, -- head
			{-0.125, 0.1875, -0.3125, -0.0625, 0.25, -0.25}, -- right_ear
			{-0.0625, -0.125, 0.4375, 0.0625, 1.11759e-08, 0.5}, -- tail
			{0.0625, 0.1875, -0.3125, 0.125, 0.25, -0.25}, -- left_ear
			{-0.125, -0.1875, -0.5, 0.125, -0.0625001, -0.4375}, -- snout
		}
	tiles = {
		"petz_panda_top.png",
		"petz_panda_bottom.png",
		"petz_panda_right.png",
		"petz_panda_left.png",
		"petz_panda_back.png",
		"petz_panda_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:panda_block"}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_panda.b3d'	
	textures= {"petz_panda.png"}
	collisionbox = {-0.35, -0.75, -0.28, 0.5, 0.4, 0.5}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "panda",	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",	
	follow = petz.settings.panda_follow,
	drops = {
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
	max_hp = 12,
	
	attack={range=0.5, damage_groups={fleshy=3}},	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
			{range={x=60, y=81}, speed=5, loop=true},		
		},	
	},
	sounds = {
		misc = "petz_panda_sound",
		moaning = "petz_panda_moaning",
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

petz:register_egg("petz:panda", S("Panda"), "petz_spawnegg_panda.png", false)
