--
--DUCKY
--
local S = ...

local pet_name = "ducky"
local mesh = nil
local scale_ducky = 1.3
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
	collisionbox = {-0.35, -0.75*scale_ducky, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_ducky.b3d'	
	textures= {{"petz_ducky.png"}, {"petz_ducky2.png"}, {"petz_ducky3.png"}}
	collisionbox = {-0.35, -0.75*scale_ducky, -0.28, 0.35, -0.3125, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_ducky, y=petz.settings.visual_size.y*scale_ducky},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,    
    runaway = true,
    pushable = true,
    floats = 1,
	jump = true,
	follow = petz.settings.ducky_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},
		{name = "petz:duck_feather", chance = 3, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_ducky_quack",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand3_start = 60, stand3_end = 70,	
    	stand4_start = 71, stand4_end = 91,	
		},
    view_range = 4,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set02 then
			self.custom_vars_set02 = 0
			self.petz_type = "ducky"
			self.is_pet = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false
		end
		if math.random(1, 150000) == 1 then
			minetest.add_item(self.object:get_pos(), "petz:duck_egg") --duck egg!
		end		
		local pos = self.object:get_pos()
		local lay_range = 1
		local nearby_nodes = minetest.find_nodes_in_area(
			{x = pos.x - lay_range, y = pos.y - 1, z = pos.z - lay_range},
			{x = pos.x + lay_range, y = pos.y + 1, z = pos.z + lay_range},
			"petz:duck_nest")
		if #nearby_nodes > 1 then
			local nest_to_lay = nearby_nodes[math.random(1, #nearby_nodes)]
			minetest.set_node(nest_to_lay, {name= "petz:duck_nest_egg"})
		end		
	end,
})

mobs:register_egg("petz:ducky", S("Ducky"), "petz_spawnegg_ducky.png", 0)

mobs:spawn({
	name = "petz:ducky",
	nodes = {"default:dirt_with_grass"},
	neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = 8000,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})
