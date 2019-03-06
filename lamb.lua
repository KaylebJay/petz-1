--
--LAMB
--

minetest.register_node("petz:lamb_block", {
	tiles = {
		"petz_lamb_top.png",
		"petz_lamb_bottom.png",
		"petz_lamb_right.png",
		"petz_lamb_left.png",
		"petz_lamb_back.png",
		"petz_lamb_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
			{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
			{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
			{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
			{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
			{-0.125, -0.3125, -0.25, 0.0625, -0.125, -0.0625}, -- head
			{-0.0625, -0.3125, 0.125, 1.11759e-08, -0.25, 0.1875}, -- tail
			{-0.1875, -0.1875, -0.1875, -0.125, -0.125, -0.125}, -- right_ear
			{0.0625, -0.1875, -0.1875, 0.125, -0.125, -0.125}, -- left_ear
		}
	}
})

minetest.register_node("petz:lamb_shaved", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
			{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
			{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
			{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
			{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
			{-0.125, -0.3125, -0.25, 0.0625, -0.125, -0.0625}, -- head
			{-0.0625, -0.3125, 0.125, 1.11759e-08, -0.25, 0.1875}, -- tail
			{-0.1875, -0.1875, -0.1875, -0.125, -0.125, -0.125}, -- right_ear
			{0.0625, -0.1875, -0.1875, 0.125, -0.125, -0.125}, -- left_ear
		},
	},
	tiles = {
		"petz_lamb_shaved_top.png",
		"petz_lamb_shaved_bottom.png",
		"petz_lamb_shaved_right.png",
		"petz_lamb_shaved_left.png",
		"petz_lamb_shaved_back.png",
		"petz_lamb_shaved_front.png"
	},
    groups = {not_in_creative_inventory = 1},
})


mobs:register_mob("petz:lamb", {
	type = "animal",
	passive = true,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	collisionbox = {-0.25, -1.3125, -0.25, 0.25, -0.25, 0.25},
	visual = "wielditem",
	visual_size = {x=1.75, y=1.75},
	textures = {"petz:lamb_block"},	
    --gotten_texture = {"petz:lamb_shaved"},
    rotate = 180,
	makes_footstep_sound = false,
	walk_velocity = 0.1,
    run_velocity = 0.75,
    runaway = true,
    pushable = true,
	jump = false,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 1,
		max = 1,},
		},
	drawtype = "front",
	water_damage = 2,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_lamb",
	},
    animation = {
			speed_normal = 15,
			speed_run = 15,
			stand_start = 0,
			stand_end = 80,
			walk_start = 81,
			walk_end = 100,
		},
    follow = {"farming:wheat", "default:grass_1"},
    view_range = 4,
    replace_rate = 10,
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
    },
    fear_height = 3,
    on_replace = function(self, pos, oldnode, newnode)

        self.food = (self.food or 0) + 1

        -- if lamb replaces 8x grass then it regrows wool
        if self.food >= 8 then

            self.food = 0
            self.gotten = false

            self.object:set_properties({
                textures = {"petz:lamb_block"},
                })
        end
    end,
    on_rightclick = function(self, clicker)
    tool = clicker:get_wielded_item():get_name()

        --are we feeding?
        if mobs:feed_tame(self, clicker, 8, true, true) then

            --if fed 7x grass or wheat then lamb regrows wool
            if self.food and self.food > 6 then

                self.gotten = false

                self.object:set_properties({
                    textures = {"petz:lamb_block"},
                })
            end

            return
        end

        if mobs:protect(self, clicker) then return end
        if mobs:capture_mob(self, clicker, "petz:lamb") then return end

    
		if tool == "mobs:shears" and clicker:get_inventory() and not self.empty then
			self.empty = true
			clicker:get_inventory():add_item("main", "wool:white")
            minetest.sound_play("petz_lamb_hurt",{pos=pos, max_hear_distance=3, gain=0.5, loop=false})
			self.object:set_properties({
				textures = {"petz:lamb_shaved"},
			})
		end
    end
    })
