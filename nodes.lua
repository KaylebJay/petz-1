local modpath, S = ...

--Pet Hairbrush
if petz.settings.tamagochi_mode then

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
end

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

--Duck Egg

minetest.register_craftitem("petz:duck_egg", {
    description = S("Duck Egg"),
    inventory_image = "petz_duck_egg.png",
    wield_image = "petz_duck_egg.png",
    on_use = minetest.item_eat(2),
    groups = {flammable = 2, food = 2},
})

--Duck Nest

minetest.register_node("petz:duck_nest", {
    description = S("Duck Nest"),
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
            local wielded_item_name= player:get_wielded_item():get_name()
            if wielded_item_name == "petz:duck_egg" then
                minetest.set_node(pos, {name= "petz:duck_nest_egg"})
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
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:duck_nest_egg',
    recipe = {        
        {'', '', ''},
        {'group:leaves', 'petz:duck_egg', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

-- Chance to hatch an egg into a duck
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