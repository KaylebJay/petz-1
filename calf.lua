--
--CALF
--
petz = {}

local tiles = {
		"petz_calf_top.png",
		"petz_calf_bottom.png",
		"petz_calf_right.png",
		"petz_calf_left.png",
		"petz_calf_back.png",
		"petz_calf_front.png"
	}

local tiles2 = {
		"petz_calf2_top.png",
		"petz_calf2_bottom.png",
		"petz_calf2_right.png",
		"petz_calf2_left.png",
		"petz_calf2_back.png",
		"petz_calf2_front.png"
	}

local fixed = {
			{-0.125, -0.5, 0.125, -0.0625, -0.375, 0.1875}, -- back_right_leg
			{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
			{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
			{0, -0.5, 0.125, 0.0625, -0.375, 0.1875}, -- back_left_leg
			{-0.125, -0.375, -0.125, 0.0625, -0.1875, 0.1875}, -- body
			{-0.125, -0.25, -0.1875, 0.0625, -0.0625001, -1.63913e-07}, -- head
			{-0.0625, -0.3125, 0.1875, 1.11759e-08, -0.1875, 0.25}, -- tail
			{0.0625, -0.125, -0.125, 0.125, -1.86265e-08, -0.0625}, -- left_horn
			{-0.1875, -0.125, -0.125, -0.125, 1.49012e-08, -0.0625}, -- right_horn
		}

minetest.register_node("petz:calf_block", {
	tiles =tiles,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = fixed,
	}
})

minetest.register_node("petz:calf_block2", {
	tiles =tiles2,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = fixed,
	}
})

mobs:register_mob("petz:calf", {
	type = "animal",
	passive = false,
	gotten = false,
	attack_type = "dogfight",
	attack_npcs = false,
	reach = 2,
	damage = 4,
	hp_min = 5,
	hp_max = 20,
	armor = 200,
	collisionbox = {-0.6, -1.725, -0.5, 0.6, -0.15, 0.5},
	visual = "wielditem",
	visual_size = {x = 2.3, y = 2.3},
	rotate = 180,
	textures = {{"petz:calf_block2"}, {"petz:calf_block"}},
	makes_footstep_sound = true,
	walk_velocity = 0.35,
    run_velocity = 0.5,
	jump = false,
    pushable = true,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 1,
		max = 3,},
        {name = "mobs:leather",
		chance = 1,
		min = 1,
		max = 2,}
		},
	drawtype = "front",
	water_damage = 2,
	lava_damage = 5,
	light_damage = 0,
    sounds = {
		random = "petz_cow",
	},
    follow = {"farming:wheat", "default:grass_1"},
	view_range = 8,
	replace_rate = 10,
	replace_what = {
		{"group:grass", "air", 0},
		{"default:dirt_with_grass", "default:dirt", -1}
	},
	fear_height = 2,
	on_rightclick = function(self, clicker)
    	-- feed or tame
    	if mobs:feed_tame(self, clicker, 8, true, true) then
        	-- if fed 7x wheat or grass then cow can be milked again
        	if self.food and self.food > 6 then
            	self.gotten = false
        	end
        	return
    	end
    	if mobs:protect(self, clicker) then
    		return
    	end
		local tool = clicker:get_wielded_item()
    	local name = clicker:get_player_name()
    	-- milk cow with empty bucket
    	if tool:get_name() == "bucket:bucket_empty" then        
        	if self.child == true then
            	return
        	end
        	if self.gotten == true then
            	minetest.sound_play("petz_calfy",{pos=pos, max_hear_distance=3, gain=0.5, loop=false})
            	return
        	end
        	local inv = clicker:get_inventory()
        	tool:take_item()
        	clicker:set_wielded_item(tool)
        	if inv:room_for_item("main", {name = "petz:bucket_milk"}) then
            	clicker:get_inventory():add_item("main", "petz:bucket_milk")
        	else
            	local pos = self.object:get_pos()
            	pos.y = pos.y + 0.5
            	minetest.add_item(pos, {name = "petz:bucket_milk"})
        	end
       		self.gotten = true -- milked
        	return
        end
    end,
	on_replace = function(self, pos, oldnode, newnode)
		self.food = (self.food or 0) + 1
		-- if cow replaces 6x grass then it can be milked again
		if self.food >= 6 then
			self.food = 0
			self.gotten = false
		end
	end,
})

