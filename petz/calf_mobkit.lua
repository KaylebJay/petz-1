--
--CALF
--
local S = ...

local pet_name = "calf"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local fixed = {}
local textures
local scale_model = 3.0
petz.calf = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.125, -0.0625, -0.375, 0.1875}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.125, 0.0625, -0.375, 0.1875}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.1875, 0.1875}, -- body
		{-0.125, -0.25, -0.1875, 0.0625, -0.0625001, 0.0}, -- head
		{-0.0625, -0.3125, 0.1875, 0.0, -0.1875, 0.25}, -- tail
		{0.0625, -0.125, -0.125, 0.125, 0.0, -0.0625}, -- left_horn
		{-0.1875, -0.125, -0.125, -0.125, 0.0, -0.0625}, -- right_horn
	}
	petz.calf.tiles = {
		"petz_calf_top.png", "petz_calf_bottom.png", "petz_calf_right.png",
		"petz_calf_left.png", "petz_calf_back.png", "petz_calf_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.calf.tiles)			
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_calf.b3d'	
	textures= {"petz_calf.png", "petz_calf2.png", "petz_calf3.png"}	
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "calf",	
	init_timer = false,	
	is_pet = true,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = true,
	capture_item = "lasso",
	--predator = "wolf",
	follow = petz.settings.calf_follow,
	drops = {
		{name = "petz:beef", chance = 1, min = 1, max = 1,},		
		{name = "petz:leather", chance = 2, min = 1, max = 1,},	
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
		misc = "petz_calf_moo",
		moaning = "petz_lamb_moaning",
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

petz:register_egg("petz:calf", S("Calf"), "petz_spawnegg_calf.png", 0)
