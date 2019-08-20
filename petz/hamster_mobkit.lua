--
--HAMSTER
--
local S = ...

local pet_name = "hamster"
local scale_model = 0.75
local scale_baby = 0.5
local visual_size = {x=petz.settings.visual_size.x*scale_model, y=petz.settings.visual_size.y*scale_model}
local visual_size_baby = {x=petz.settings.visual_size.x*scale_model*scale_baby, y=petz.settings.visual_size.y*scale_model*scale_baby}
petz.hamster = {}
local mesh = 'petz_hamster.b3d'	
local skin_colors = {"golden", "dark_brown", "light_brown", "dark_gray", "light_gray", "white", "pink"}
local textures = {}
for n = 1, #skin_colors do
	textures[n] = "petz_"..pet_name.."_"..skin_colors[n]..".png"
end
local collisionbox = {-0.35, -0.75*scale_model, -0.28, 0.35, -0.0625, 0.28}
local collisionbox_baby = {-0.35*scale_baby, -0.75*scale_model*scale_baby, -0.28, 0.35, -0.0625, 0.28}


minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "hamster",	
	init_tamagochi_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "net",
	breed = true,
	mutation = true,	
	follow = petz.settings.hamster_follow,
	rotate = petz.settings.rotate,
	physical = true,
	stepheight = 0.1,	--EVIL!
	collide_with_objects = true,
	collisionbox = collisionbox,
	collisionbox_baby = collisionbox_baby,
	visual = petz.settings.visual,
	mesh = mesh,
	textures = textures,
	skin_colors = skin_colors,
	visual_size = visual_size,
	visual_size_baby = visual_size_baby,
	static_save = true,
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2,
	jump_height = 1.5,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 10,
	makes_footstep_sound = true,
	
	attack={range=0.5, damage_groups={fleshy=3}},		
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
		},	
		sit={range={x=60, y=65}, speed=20, loop=false},
	},
	sounds = {
		misc = "petz_hamster_squeak",
		moaning = "petz_hamster_moaning",
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

petz:register_egg("petz:hamster", S("Hamster"), "petz_spawnegg_hamster.png", 0)
