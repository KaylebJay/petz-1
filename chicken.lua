--
--CHICKEN
--
minetest.register_node("petz:chicken_block", {
	tiles = {
		"petz_chicken_top.png",
		"petz_chicken_bottom.png",
		"petz_chicken_right.png",
		"petz_chicken_left.png",
		"petz_chicken_back.png",
		"petz_chicken_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
    groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.0625, -0.0625, -0.4375, 7.45058e-09}, -- right_leg
			{0, -0.5, -0.0625, 0.0625, -0.4375, 1.86265e-08}, -- left_leg
			{-0.125, -0.4375, -0.125, 0.0625, -0.25, 0.0625}, -- body
			{-0.0625, -0.3125, 0.0625, 9.31323e-09, -0.25, 0.125}, -- tail
			{-0.0625, -0.25, -0.1875, 1.11759e-08, -0.1875, -0.125}, -- beak
			{-0.0625, -0.125, -0.125, -3.72529e-09, -0.0625, -0.0625}, -- crest
			{-0.125, -0.25, -0.125, 0.0625, -0.125, 9.68575e-08}, -- head
			{0.0625, -0.3125, -0.0625, 0.125, -0.25, 0.0625}, -- left_wing_top
			{0.0625, -0.375, -0.0625, 0.125, -0.3125, 0}, -- left_wing_bottom
			{-0.1875, -0.3125, -0.0625, -0.125, -0.25, 0.0625}, -- right_wing_top
			{-0.1875, -0.375, -0.0625, -0.125, -0.3125, 0}, -- right_wing_bottom
		}
	}
})

mobs:register_mob("petz:chicken", {
	type = "animal",
	rotate = 180,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = "wielditem",
	visual_size = {x=1.0, y=1.0},
	textures = {"petz:chicken_block"},
	collisionbox = {-0.2, -0.75, -0.2, 0.2, -0.125, 0.2},
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,
    runaway = true,
    pushable = true,
	jump = true,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 1,
		max = 1,},
		},
	water_damage = 2,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_chicken",
	},
    animation = {
			speed_normal = 15,
			speed_run = 15,
			stand_start = 0,
			stand_end = 80,
			walk_start = 81,
			walk_end = 100,
		},
    view_range = 4,
    fear_height = 3,
    })
