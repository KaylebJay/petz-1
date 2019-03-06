--
--PANDA
--

minetest.register_node("petz:panda_block", {
	tiles = {
		"petz_panda_top.png",
		"petz_panda_bottom.png",
		"petz_panda_right.png",
		"petz_panda_left.png",
		"petz_panda_back.png",
		"petz_panda_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
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
	}
})

mobs:register_mob("petz:panda", {
	type = "animal",
	rotate= 180,
	passive = true,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	collisionbox = {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
	--selectionbox = {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
	visual = "wielditem",
	visual_size = {x = 1.0, y = 1.0},
	textures = {"petz:panda_block"},
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
		random = "petz_panda",
	},
    follow = {"default:apple"},
    view_range = 5,
})
