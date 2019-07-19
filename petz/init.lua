--
-- petz 
-- License:GPLv3
--

local modname = "petz"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

assert(loadfile(modpath .. "/api.lua"))(modpath, modname, S)
assert(loadfile(modpath .. "/mobkit.lua"))(modpath, S)
assert(loadfile(modpath .. "/mobkit_plus.lua"))(modpath, S)
assert(loadfile(modpath .. "/behaviours.lua"))(modpath, S)
assert(loadfile(modpath .. "/settings.lua"))(modpath, S) --Load the settings
assert(loadfile(modpath .. "/nodes.lua"))(modpath, S) --Load the nodes
assert(loadfile(modpath .. "/items.lua"))(modpath, S) --Load the items
assert(loadfile(modpath .. "/food.lua"))(modpath, S) --Load the food items
assert(loadfile(modpath .. "/spawn.lua"))(modpath, S) --Load the spawn engine
assert(loadfile(modpath .. "/mount.lua"))(modpath, S) --Load the mount engine

 for i = 1, #petz.petz_list do --load all the petz.lua files
	if petz.settings[petz.petz_list[i].."_spawn"] then
		assert(loadfile(modpath .. "/"..petz.petz_list[i].."_"..petz.settings.type_api..".lua"))(S) 
	end	
 end
