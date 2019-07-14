--
--WOLF
--
local S = ...

local pet_name = "wolf"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local fixed = {}
local textures
local scale_model = 1.8
petz.wolf = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
			{-0.125, -0.375, -0.375, 0.0625, -0.3125, -0.25}, -- jaw
			{-0.125, -0.5, -0.1875, -0.0625, -0.3125, -0.125}, -- right_front_leg
			{0, -0.5, -0.1875, 0.0625, -0.3125, -0.125}, -- left_front_leg
			{-0.125, -0.3125, -0.375, 0.0625, -0.25, -0.3125}, -- snout
			{-0.125, -0.3125, -0.3125, 0.0625, -0.125, -0.1875}, -- head
			{-0.1875, -0.3125, -0.1875, 0.125, -0.125, -0.0625}, -- mane
			{-0.125, -0.3125, -0.0625, 0.0625, -0.125, 0.1875}, -- body
			{-0.125, -0.125, -0.25, -0.0625, -0.0625, -0.1875}, -- right_ear
			{0, -0.125, -0.25, 0.0625, -0.0625, -0.1875}, -- left_ear
			{0, -0.5, 0.125, 0.0625, -0.3125, 0.1875}, -- left_back_leg
			{-0.125, -0.5, 0.125, -0.0625, -0.3125, 0.1875}, -- right_back_leg
			{-0.0625, -0.1875, 0.1875, 0, -0.125, 0.375}, -- tail
	}
	petz.wolf.tiles = {
		"petz_wolf_top.png", "petz_wolf_bottom.png", "petz_wolf_right.png",
		"petz_wolf_left.png", "petz_wolf_back.png", "petz_wolf_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.wolf.tiles)		
	textures= {"petz:wolf_block"}
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_wolf.b3d'	
	textures = {"petz_wolf.png", "petz_wolf2.png", "petz_wolf3.png"}	
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
end

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "wolf",	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = true,
	attack_player = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	follow = petz.settings.wolf_follow,	
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
	max_hp = 20,  		
	
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
		misc = "petz_wolf_howl",
		moaning = "petz_wolf_moaning",
	},
	
	--punch_start = 83, stand4_end = 95,
	
	brainfunc = petz.predator_brain,
	
	on_activate = function(self, staticdata, dtime_s) --on_activate, required
		mobkit.actfunc(self, staticdata, dtime_s)
		petz.set_initial_properties(self, staticdata, dtime_s)
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)		
		petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)					
		if self.tamed == false and self.attack_player == false then --if you hit it, will attack player
			self.attack_player = true	
			mobkit.clear_queue_high(self)
		end
	end,
	
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
    
})

petz:register_egg("petz:wolf", S("Wolf"), "petz_spawnegg_wolf.png", 0)
