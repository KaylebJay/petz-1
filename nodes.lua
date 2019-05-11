local modpath, S = ...

--Pet Hairbrush
    minetest.register_craftitem("petz:hairbrush", {
        description = S("Hairbrush"),
        inventory_image = "petz_hairbrush.png",
        wield_image = "petz_hairbrush.png"
    })

    minetest.register_craft({
        type = "shaped",
        output = "petz:hairbrush",
        recipe = {
            {"", "", ""},
            {"", "default:stick", "farming:string"},
            {"default:stick", "", ""},
        }
    })

--Pet Bowl
minetest.register_node("petz:pet_bowl", {
    description = S("Pet Bowl"),
    inventory_image = "petz_pet_bowl_inv.png",
    wield_image = "petz_pet_bowl_inv.png",
    tiles = {"petz_pet_bowl.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default_stone_sounds,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875}, -- bottom
            {-0.1875, -0.4375, -0.1875, 0.1875, -0.375, -0.125}, -- front
            {-0.1875, -0.4375, 0.125, 0.1875, -0.375, 0.1875}, -- back
            {-0.1875, -0.4375, -0.125, -0.125, -0.375, 0.125}, -- left
            {0.125, -0.4375, -0.125, 0.1875, -0.375, 0.125}, -- right
            },
        },
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:pet_bowl',
    recipe = {        
        {'group:wood', '', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'dye:red', ''},
    }
})

--Material for Pet's House

minetest.register_node("petz:red_gables", {
    description = S("Red Gables"),
    tiles = {"petz_red_gables.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("petz:yellow_paving", {
    description = S("Yellow Paving"),
    tiles = {"petz_yellow_paving.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("petz:blue_stained_wood", {
    description = S("Blue Stained Wood"),
    tiles = {"petz_blue_stained_planks.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

if minetest.get_modpath("stairs") ~= nil then
    stairs.register_stair_and_slab(
        "red_gables",
        "petz:red_gables",
        {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        {"petz_red_gables.png"},
        S("Red Gables Stair"),
        S("Red Gables Slab"),
        default.node_sound_wood_defaults()
    )
    stairs.register_stair_and_slab(
        "blue_stained_wood",
        "petz:blue_stained_wood",
        {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        {"petz_blue_stained_planks.png"},
        S("Blue Stained Stair"),
        S("Blue Stained Slab"),
        default.node_sound_wood_defaults()
    )
end

--Kennel Schematic

minetest.register_craftitem("petz:kennel", {
    description = S("Kennel"),
    wield_image = {"petz_kennel.png"},
    inventory_image = "petz_kennel.png",
    groups = {},
    on_use = function (itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then            
            return
        end
        local pt_above = pointed_thing.above
        local pt_under = pointed_thing.under
        minetest.place_schematic(pt_above, modpath..'/schematics/kennel.mts', 0, nil, true)        
    end,
})

--Duck Nest

minetest.register_node("petz:duck_nest", {
    description = S("Nest"),
    inventory_image = "petz_duck_nest_inv.png",
    wield_image = "petz_duck_nest_inv.png",
    tiles = {"petz_duck_nest.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_duck_nest.b3d',
    visual_size = {x = 1.3, y = 1.3},
    tiles = {"petz_duck_nest_egg.png"},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if not(player == nil) then
            local itemstack_name = itemstack:get_name()
            if itemstack_name == "petz:duck_egg" or itemstack_name == "petz:chicken_egg" then
				local egg_type = "" 
				if itemstack_name == "petz:duck_egg" then
					egg_type = "duck"
				else
					egg_type = "chicken"
				end
                itemstack:take_item()			
				player:set_wielded_item(itemstack)
				minetest.set_node(pos, {name= "petz:".. egg_type .."_nest_egg"})
				return itemstack
            end
        end
    end,
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:duck_nest',
    recipe = {        
        {'', '', ''},
        {'group:leaves', '', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

minetest.register_node("petz:duck_nest_egg", {
    description = S("Duck Nest with Egg"),
    inventory_image = "petz_duck_nest_egg_inv.png",
    wield_image = "petz_duck_nest_egg_inv.png",
    tiles = {"petz_duck_nest_egg.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_duck_nest_egg.b3d',
    visual_size = {x = 1.3, y = 1.3},
    tiles = {"petz_duck_nest_egg.png"},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
})

minetest.register_node("petz:chicken_nest_egg", {
    description = S("Chicken Nest with Egg"),
    inventory_image = "petz_chicken_nest_egg_inv.png",
    wield_image = "petz_chicken_nest_egg_inv.png",
    tiles = {"petz_chicken_nest_egg.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_duck_nest_egg.b3d',
    visual_size = {x = 1.3, y = 1.3},
    tiles = {"petz_chicken_nest_egg.png"},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:duck_nest_egg',
    recipe = {        
        {'', '', ''},
        {'group:leaves', 'petz:duck_egg', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

-- Chance to hatch an egg into a duck or chicken
minetest.register_abm({
    nodenames = {"petz:duck_nest_egg"},
    neighbors = {},
    interval = 600.0, -- Run every 10 minuts
    chance = 5, -- Select every 1 in 3 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        local pos_above = {x = pos.x, y = pos.y +1, z= pos.z}
        if pos_above then
            if not minetest.registered_entities["petz:ducky"] then
                return
            end
            --pos.y = pos.y + 1
            local mob = minetest.add_entity(pos_above, "petz:ducky")
            local ent = mob:get_luaentity()
            minetest.set_node(pos, {name= "petz:duck_nest"})
        end
    end
})

minetest.register_abm({
    nodenames = {"petz:chicken_nest_egg"},
    neighbors = {},
    interval = 600.0, -- Run every 10 minuts
    chance = 5, -- Select every 1 in 3 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        local pos_above = {x = pos.x, y = pos.y +1, z= pos.z}
        if pos_above then
            if not minetest.registered_entities["petz:chicken"] then
                return
            end
            --pos.y = pos.y + 1
            local mob = minetest.add_entity(pos_above, "petz:chicken")
            local ent = mob:get_luaentity()
            minetest.set_node(pos, {name= "petz:duck_nest"})
        end
    end
})

--Beaver 

minetest.register_craftitem("petz:beaver_fur", {
    description = S("Beaver Fur"),
    inventory_image = "petz_beaver_fur.png",
    wield_image = "petz_beaver_fur.png"
})

minetest.register_craftitem("petz:duck", {
    description = S("Duck Feather"),
    inventory_image = "petz_duck_feather.png",
    wield_image = "petz_duck_feather.png"
})

--Beaver Oil

minetest.register_craftitem("petz:beaver_oil", {
    description = S("Beaver Oil"),
    inventory_image = "petz_beaver_oil.png",
    wield_image = "petz_beaver_oil.png"
})

minetest.register_craft({
    type = "shaped",
    output = "petz:beaver_oil",
    recipe = {
        {"", "", ""},
        {"", "petz:beaver_fur", ""},
        {"", "vessels:glass_bottle", ""},
    }
})

minetest.register_node("petz:beaver_dam_branches", {
    description = S("Beaver Dam Branches"),
    drawtype = "allfaces_optional",
    paramtype = "light",
    walkable = true,
    tiles = {"petz_beaver_dam_branches.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

--Whip

minetest.register_craftitem("petz:whip", {
    description = S("Whip"),
    inventory_image = "petz_whip.png",
    wield_image = "petz_whip.png",
    after_use = function(itemstack, user, node, digparams)
        petz.do_sound_effect("object", user, "petz_whip")
    end,
})

minetest.register_craft({
    type = "shaped",
    output = "petz:whip",
    recipe = {
        {'', '', 'farming:string'},
        {'', 'farming:string', 'dye:brown'},
        {'default:stick', '', ''},
    }
})

--Material for Lion's Cage

minetest.register_node("petz:gray_paving_stone", {
    description = S("Gray Paving Stone"),
    tiles = {"petz_gray_paving_stone.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

--Bucket Milk
minetest.register_craftitem("petz:bucket_milk", {
    description = S("Milk Bucket"),
    wield_image = {"petz_bucket_milk.png"},
    inventory_image = "petz_bucket_milk.png",
    groups = {milk_bucket = 1},
})

--Turtle Shell
minetest.register_craftitem("petz:turtle_shell", {
    description = S("Turtle Shell"),
    wield_image = {"petz_turtle_shell.png"},
    inventory_image = "petz_turtle_shell.png",
    groups = {},
})

---
---Fishtank
---

local function remove_fish(pos)
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	if not objs then
		return
	end
	for _, obj in pairs(objs) do
		if obj and obj:get_luaentity() and obj:get_luaentity().name == "petz:clownfish_entity_sprite" then					
			obj:remove()
			break			
		end
	end
end

minetest.register_node("petz:fishtank", {
	description = S("Fish Tank"),
	drawtype = "glasslike_framed",
	tiles = {"petz_fishtank_top.png", "petz_fishtank_bottom.png"},
	special_tiles = {"petz_fishtank_bottom.png"},
	inventory_image = "petz_fishtank_inv.png",
	walkable = false,
	groups = {snappy = 2, attached_node = 1},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	param2 = 50,
	sunlight_propagates = true,
	use_texture_alpha = true,
	light_source = LIGHT_MAX - 1,
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 0.4, 0.25 },
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local itemstack_name= itemstack:get_name()
        local meta = minetest.get_meta(pos)
		local has_fish = meta:get_string("has_fish")			
        if itemstack_name == "petz:clownfish" then	
			if has_fish == "false" then
				meta:set_string("has_fish", "true")				
				minetest.add_entity({x=pos.x, y=pos.y, z=pos.z}, "petz:clownfish_entity_sprite")
				itemstack:take_item()			
				clicker:set_wielded_item(itemstack)
				return itemstack
			end
		elseif (itemstack_name == "fireflies:bug_net") and (has_fish == "true") then
			local inv = clicker:get_inventory()
			if inv:room_for_item("main", ItemStack("petz:clownfish")) then
				inv:add_item("main", "petz:clownfish")
				remove_fish(pos)
				meta:set_string("has_fish", "false")
			end
		end
    end,
	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "petz:fishtank", param2 = 1})
		local meta = minetest.get_meta(pos)
		meta:set_string("has_fish", "false")
	end,
	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		local has_fish = meta:get_string("has_fish")
		if has_fish == "true" then
			remove_fish(pos)
			minetest.add_entity(pos, "petz:clownfish")
		end
	end
})

minetest.register_craft({
	type = "shaped",
	output = "petz:fishtank",
	recipe = {
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:water_source", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"},
	}
})

minetest.register_entity("petz:clownfish_entity_sprite", {
	visual = "sprite",
	spritediv = {x = 1, y = 16},
	initial_sprite_basepos = {x = 0, y = 0},
	visual_size = {x=0.8, y=0.8},
	collisionbox = {0},
	physical = false,	
	textures = {"petz_clownfish_spritesheet.png"},
	groups = {fishtank = 1},
	on_activate = function(self, staticdata)
		local random_num = math.random(1)
		if random_num == 1 then
			self.textures[1] = self.textures[1] .. "^[transformFX"
		end
		self.object:set_sprite({x=0, y=0}, 16, 1.0, false)
		local pos = self.object:getpos()
		if minetest.get_node(pos).name ~= "petz:fishtank" then
			self.object:remove()
		end
	end,
})
