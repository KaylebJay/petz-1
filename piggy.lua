--
--PIGGY
--

minetest.register_node("petz:piggy_block", {
	tiles = {
		"petz_piggy_top.png",
		"petz_piggy_bottom.png",
		"petz_piggy_right.png",
		"petz_piggy_left.png",
		"petz_piggy_back.png",
		"petz_piggy_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
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
	}
})

mobs:register_mob("petz:piggy", {
	type = "animal",
	rotate= 180,
	passive = true,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	collisionbox = {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
	--selectionbox = {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
	visual = "wielditem",
	visual_size = {x = 0.85, y = 0.85},
	textures = {"petz:piggy_block"},
	makes_footstep_sound = false,
	walk_velocity = 0.45,
    run_velocity = 1.25,
    runaway = true,
    jump = true,
    fear_height = 2,
	drops = {
		{name = "mobs:pork_raw",
		chance = 1,
		min = 1,
		max = 2,},
		},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_piggy",
	},
    follow = {"default:apple"},
    view_range = 5,
})

-- raw porkchop
minetest.register_craftitem("petz:pork_raw", {
	description = "Raw Porkchop",
	inventory_image = "petz_pork_raw.png",
	on_use = minetest.item_eat(4),
})

-- cooked porkchop
minetest.register_craftitem("petz:pork_cooked", {
	description = "Cooked Porkchop",
	inventory_image = "petz_pork_cooked.png",
	on_use = minetest.item_eat(8),
})

minetest.register_craft({
	type = "cooking",
	output = "petz:pork_cooked",
	recipe = "petz:pork_raw",
	cooktime = 5,
})
