--
-- petz 
-- License:GPLv3
--

local modname = "petz"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- internationalization boilerplate
local S = minetest.get_translator(minetest.get_current_modname())

--
--The Petz
--

petz = {}

--
--Settings
--
petz.settings = {}
petz.settings.mesh = nil
petz.settings.visual_size = {}
petz.settings.rotate = 0

assert(loadfile(modpath .. "/settings.lua"))(modpath, S) --Load the settings

petz.petz_list_by_owner = {} --a list of tamed petz with owner

assert(loadfile(modpath .. "/api/api.lua"))(modpath, modname, S)
assert(loadfile(modpath .. "/misc/mount.lua"))(modpath, S) --Load the mount engine
assert(loadfile(modpath .. "/misc/brains.lua"))(modpath, S)
assert(loadfile(modpath .. "/misc/behaviours.lua"))(modpath, S)
assert(loadfile(modpath .. "/misc/nodes.lua"))(modpath, S) --Load the nodes
assert(loadfile(modpath .. "/misc/items.lua"))(modpath, S) --Load the items
assert(loadfile(modpath .. "/misc/chests.lua"))(modpath, S) --Load the chests
assert(loadfile(modpath .. "/misc/food.lua"))(modpath, S) --Load the food items
if minetest.get_modpath("3d_armor") ~= nil then --Armors (optional)
	assert(loadfile(modpath .. "/misc/armors.lua"))(modpath, S)
end
assert(loadfile(modpath .. "/misc/weapons.lua"))(modpath, S) --Load the spawn engine
--if minetest.get_modpath("awards") ~= nil then	
	--assert(loadfile(modpath .. "/misc/awards.lua"))(modpath, S) --Load the awards
--end

petz.file_exists = function(name)
   local f = io.open(name,"r")
   if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

for i = 1, #petz.petz_list do --load all the petz.lua files
	local file_name = modpath .. "/petz/"..petz.petz_list[i].."_"..petz.settings.type_api..".lua"
	if petz.file_exists(file_name) then
		assert(loadfile(file_name))(S) 
	end
end
