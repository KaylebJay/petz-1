--
--PONY
--
local S = ...

local pet_name = "pony"
local scale_model = 2.2
local visual_size = {x=petz.settings.visual_size.x*scale_model, y=petz.settings.visual_size.y*scale_model}
local scale_baby = 0.5
local visual_size_baby = {x=petz.settings.visual_size.x*scale_model*scale_baby, y=petz.settings.visual_size.y*scale_model*scale_baby}
petz.pony = {}
local mesh = 'petz_pony.b3d'	
local skin_colors = {"brown", "white", "yellow", "white_dotted", "gray_dotted", "black", "mutation"}
local textures = {}
for n = 1, #skin_colors do
	textures[n] = "petz_"..pet_name.."_"..skin_colors[n]..".png"
end
local textures_baby = {"petz_pony_baby.png"}	
local collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
local collisionbox_baby = {-0.5*scale_baby, -0.75*scale_model*scale_baby, -0.25, 0.375, -0.375, 0.375}

minetest.register_entity("petz:"..pet_name, {          
	--Petz specifics	
	type = pet_name,	
	is_mountable = true,
	driver = nil,
	init_tamagochi_timer = true,	
	is_pet = true,
	has_affinity = true,
	breed = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	mutation = true,
	--Pony specific
	terrain_type = 3,
	scale_model = scale_model,
	scale_baby =scale_baby,
	driver_scale = {x = 1/visual_size.x, y = 1/visual_size.y},			
	driver_attach_at = {x = -0.0325, y = -0.125, z = -0.2},
	driver_eye_offset = {x = 0, y = 0, z = 0},	
	pregnant_count = 5,
	follow = petz.settings.pony_follow,
	drops = {
		{name = "petz:bone", chance = 6, min = 1, max = 1,},
	},
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
	skin_color_mutation = {"vanilla"},
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
	max_hp = 15,
	makes_footstep_sound = false,	
		
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
		misc = "petz_pony_neigh",
		moaning = "petz_pony_moaning",
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
		if self.init_tamagochi_timer == true then
			petz.init_tamagochi_timer(self)
		end
		if self.driver then
			petz.drive(self, "walk", "stand", false, dtime) -- if driver present allow control of horse		
		else
			mobkit.stepfunc(self, dtime) -- required
		end	
	end,
})

petz:register_egg("petz:pony", S("Pony"), "petz_spawnegg_pony.png", 0)
