local modpath, S = ...

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
        if not(minetest.is_protected(pt_above, user)) then
			minetest.place_schematic(pt_above, modpath..'/schematics/kennel.mts', 0, nil, true)        
			itemstack:take_item()
			return itemstack
		end
    end,
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:kennel',
    recipe = {        
        {'group:wood', 'dye:red', 'group:wood'},
        {'group:wood', 'dye:blue', 'group:wood'},
        {'group:stone', 'dye:yellow', 'group:stone'},
    }
})

--Ducky Nest

minetest.register_node("petz:ducky_nest", {
    description = S("Nest"),
    inventory_image = "petz_ducky_nest_inv.png",
    wield_image = "petz_ducky_nest_inv.png",
    tiles = {"petz_ducky_nest.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest.b3d',
    visual_size = {x = 1.3, y = 1.3},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if player then
            local itemstack_name = itemstack:get_name()
            if itemstack_name == "petz:ducky_egg" or itemstack_name == "petz:chicken_egg" then --put the egg
				local egg_type = "" 
				if itemstack_name == "petz:ducky_egg" then
					egg_type = "ducky"
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
    output = 'petz:ducky_nest',
    recipe = {        
        {'', '', ''},
        {'group:leaves', '', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

minetest.register_node("petz:ducky_nest_egg", {
    description = S("Ducky Nest with Egg"),
    inventory_image = "petz_ducky_nest_egg_inv.png",
    wield_image = "petz_ducky_nest_egg_inv.png",
    tiles = {"petz_ducky_nest_egg.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest_egg.b3d',
    visual_size = {x = 1.3, y = 1.3},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		petz.extract_egg_from_nest(self, pos, player, "petz:ducky_egg") --extract the egg
	end,
})

minetest.register_node("petz:chicken_nest_egg", {
    description = S("Chicken Nest with Egg"),
    inventory_image = "petz_chicken_nest_egg_inv.png",
    wield_image = "petz_chicken_nest_egg_inv.png",
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest_egg.b3d',
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
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		petz.extract_egg_from_nest(self, pos, player, "petz:chicken_egg") --extract the egg
	end,
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:ducky_nest_egg',
    recipe = {        
        {'', '', ''},
        {'group:leaves', 'petz:ducky_egg', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

-- Chance to hatch an egg into a ducky or chicken
minetest.register_abm({
    nodenames = {"petz:ducky_nest_egg"},
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
            minetest.set_node(pos, {name= "petz:ducky_nest"})
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
            minetest.set_node(pos, {name= "petz:ducky_nest"})
        end
    end
})

--Vanilla Wool
minetest.register_node("petz:wool_vanilla", {
	description = S("Vanilla Wool"),
	tiles = {"wool_vanilla.png"},
	is_ground_content = false,
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
		flammable = 3, wool = 1},
	sounds = default.node_sound_defaults(),
})
minetest.register_alias("wool:vanilla", "petz:wool_vanilla")

--Parrot Stand

minetest.register_node("petz:bird_stand", {
    description = S("Bird Stand"),  
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0, 0.4375, 0}, -- down
			{-0.375, 0.4375, -0.0625, 0.3125, 0.5, -2.23517e-08}, -- top
			{-0.125, -0.5, -0.125, 0.0625, -0.4375, 0.0625}, -- base
		},
	},
	selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
    },
    visual_size = {x = 1.0, y = 1.0},
    tiles = {"default_wood.png"},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local player_name = player:get_player_name()	
		local pos_above = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z,
		}
		local obj_list = minetest.get_objects_inside_radius(pos_above, 1) --check if already a parrot
		for _, obj in ipairs(obj_list) do
			local entity = obj:get_luaentity()
			if entity and entity.name == "petz:parrot" then						
				minetest.chat_send_player(player_name, S("There's already a parrot on top."))
				return
			end
		end					
		local pet_name_egg = "petz:parrot_set"		
		if itemstack:get_name() == pet_name_egg then			
			if not minetest.is_protected(pos, player_name) then
				pos = {
					x = pos.x,
					y = pos.y + 1,
					z = pos.z - 0.125,
				}
				ent = petz.create_pet(player, itemstack, "petz:parrot", pos)
				petz.standhere(ent)
			end
			return itemstack
		end
    end,
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:bird_stand',
    recipe = {        
        {'default:stick', 'group:feather', 'default:stick'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})
