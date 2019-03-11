--
-- petz 
-- License:GPL3
--

local modname = "petz"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

assert(loadfile(modpath .. "/api.lua"))(S)
assert(loadfile(modpath .. "/settings.lua"))(modpath, S) --Load the settings
assert(loadfile(modpath .. "/nodes.lua"))(modpath, S) --Load the nodes

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