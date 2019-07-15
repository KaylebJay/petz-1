--
--LAMB
--
local S = ...

local pet_name = "lamb"
table.insert(petz.mobs_list, pet_name)
local scale_model = 1.7
petz.lamb = {}
mesh = 'petz_lamb.b3d'	
local wool_colors = {"white", "grey", "dark_grey", "brown"}
local textures = {}
for n = 1, #wool_colors do
	textures[n] = "petz_"..pet_name.."_"..wool_colors[n]..".png"
end
local collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.3125, 0.28}

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "lamb",	
	init_timer = false,	
	is_pet = false,
	has_affinity = false,
	is_wild = false,
	give_orders = false,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.lamb_follow,
	drops = {
		{name = "petz:mini_lamb_chop", chance = 1, min = 1, max = 1,},
		{name = "petz:bone", chance = 5, min = 1, max = 1,},
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
	wool_colors = wool_colors,
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
			{range={x=82, y=94}, speed=5, loop=true},		
		},	
	},
	sounds = {
		misc = "petz_lamb_bleat",
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
	
 	on_replace = function(self, pos, oldnode, newnode)
		petz.lamb_wool_regrow(self)
    end,
    
})

petz:register_egg("petz:lamb", S("Lamb"), "petz_spawnegg_lamb.png", false)
