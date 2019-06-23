--
--KITTY
--
local S = ...

local pet_name = "kitty"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local textures = {}
local fixed = {}
local tiles = {}
local collisionbox = {}
local scale_model = 1.0

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
				{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
				{-0.125, -0.5, -0.1875, -0.0625, -0.375, -0.125}, -- front_right_leg
				{0, -0.5, -0.1875, 0.0625, -0.375, -0.125}, -- front_left_leg
				{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
				{-0.125, -0.375, -0.1875, 0.0625, -0.25, 0.125}, -- body
				{-0.125, -0.3125, -0.3125, 0.0625, -0.125, -0.125}, -- head
				{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- top_tail
				{-0.125, -0.125, -0.25, -0.0625, -0.0625, -0.1875}, -- right_ear
				{-0.0625, -0.375, 0.1875, 0.0, -0.3125, 0.3125}, -- bottom_tail
				{0, -0.125, -0.25, 0.0625, -0.0625, -0.1875}, -- left_ear
	}
	tiles = {
		"petz_kitty_top.png",
		"petz_kitty_bottom.png",
		"petz_kitty_right.png",
		"petz_kitty_left.png",
		"petz_kitty_back.png",
		"petz_kitty_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:kitty_block"}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_kitty.b3d'	
	textures= {"petz_kitty.png", "petz_kitty2.png", "petz_kitty3.png"}
	collisionbox = {-0.35, -0.75, -0.28, 0.35, -0.3125, 0.28}
end

minetest.register_entity("petz:"..pet_name, {          
	--Petz specifics	
	type = "kitty",	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "net",
	--predator = "wolf",
	follow = petz.settings.kitty_follow,
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
	makes_footstep_sound = false,
		
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
		misc = "petz_kitty_meow",
		moaning = "petz_kitty_moaning",
	},
	
	brainfunc = petz.herbivore_brain,
	
	on_activate = function(self, staticdata, dtime_s) --on_activate, required
		mobkit.actfunc(self, staticdata, dtime_s)
		petz.set_herbibore(self, staticdata, dtime_s)
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

petz:register_egg("petz:kitty", S("Kitty"), "petz_spawnegg_kitty.png", 0)

