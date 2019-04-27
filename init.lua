--
-- petz 
-- License:GPL3
--

local modname = "petz"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

assert(loadfile(modpath .. "/api.lua"))(modpath, S)
assert(loadfile(modpath .. "/settings.lua"))(modpath, S) --Load the settings
assert(loadfile(modpath .. "/nodes.lua"))(modpath, S) --Load the nodes
assert(loadfile(modpath .. "/food.lua"))(modpath, S) --Load the food items

if petz.settings.kitty_spawn then
    assert(loadfile(modpath .. "/kitty_"..petz.settings.type_api..".lua"))(S) 
end
if petz.settings.puppy_spawn then
    assert(loadfile(modpath .. "/puppy_"..petz.settings.type_api..".lua"))(S) 
end
if petz.settings.ducky_spawn then
    assert(loadfile(modpath .. "/ducky_"..petz.settings.type_api..".lua"))(S) 
end
if petz.settings.beaver_spawn then
    assert(loadfile(modpath .. "/beaver_"..petz.settings.type_api..".lua"))(S, modpath, mg_name)    
end
if petz.settings.lamb_spawn then
    assert(loadfile(modpath .. "/lamb_"..petz.settings.type_api..".lua"))(S)    
end
if petz.settings.lion_spawn then
    assert(loadfile(modpath .. "/lion_"..petz.settings.type_api..".lua"))(S)    
end
if petz.settings.calf_spawn then
    assert(loadfile(modpath .. "/calf_"..petz.settings.type_api..".lua"))(S)
end
if petz.settings.panda_spawn then
    assert(loadfile(modpath .. "/panda_"..petz.settings.type_api..".lua"))(S)
end
if petz.settings.frog_spawn then
    assert(loadfile(modpath .. "/frog_"..petz.settings.type_api..".lua"))(S, modpath, mg_name)
end
if petz.settings.grizzly_spawn then
    assert(loadfile(modpath .. "/grizzly_"..petz.settings.type_api..".lua"))(S)
end
if petz.settings.pony_spawn then
    assert(loadfile(modpath .. "/pony_"..petz.settings.type_api..".lua"))(S)
end
if petz.settings.parrot_spawn then
    assert(loadfile(modpath .. "/parrot_"..petz.settings.type_api..".lua"))(S)
end
if petz.settings.chicken_spawn then
    assert(loadfile(modpath .. "/chicken_"..petz.settings.type_api..".lua"))(S)
end
