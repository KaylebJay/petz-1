--
-- petz 
-- License:GPL3
--

local modname = "petz"
local modpath = minetest.get_modpath(modname)

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

assert(loadfile(modpath .. "/api.lua"))(S)
assert(loadfile(modpath .. "/settings.lua"))(modpath, S) --Load the settings
assert(loadfile(modpath .. "/nodes.lua"))(modpath, S) --Load the nodes

if petz.settings.kitty_spawn then

    assert(loadfile(modpath .. "/kitty_"..petz.settings.type_api..".lua"))(S) 

    mobs:register_egg("petz:kitty", S("Kitty"), "petz_spawnegg_kitty.png", 0)

    mobs:spawn({
        name = "petz:kitty",
        nodes = {"default:dirt_with_grass"},
        neighbors = {"group:leaves"},
        min_light = 3,
        max_light = 5,
        interval = 90,
        chance = 900, 
        min_height = 1,
        max_height = 300,
        day_toggle = false,
    })
end

if petz.settings.puppy_spawn then

    assert(loadfile(modpath .. "/puppy_"..petz.settings.type_api..".lua"))(S) 

    mobs:register_egg("petz:puppy", S("Puppy"), "petz_spawnegg_puppy.png", 0)

    mobs:spawn({
        name = "petz:puppy",
        nodes = {"default:dirt_with_grass"},
        neighbors = {"group:leaves"},
        min_light = 3,
        max_light = 5,
        interval = 90,
        chance = 900, 
        min_height = 1,
        max_height = 300,
        day_toggle = false,
    })
end

if petz.settings.ducky_spawn then

    assert(loadfile(modpath .. "/ducky_"..petz.settings.type_api..".lua"))(S) 

    mobs:register_egg("petz:ducky", S("Ducky"), "petz_spawnegg_ducky.png", 0)

    mobs:spawn({
        name = "petz:ducky",
        nodes = {"default:dirt_with_grass"},
        neighbors = {"default:river_water_source"},
        min_light = 3,
        max_light = 5,
        interval = 90,
        chance = 900, 
        min_height = 1,
        max_height = 300,
        day_toggle = false,
    })
end