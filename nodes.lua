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