local modpath, modname, S = ...

local creative_mode = minetest.settings:get_bool("creative_mode")

petz = {}

--
--The Petz
--

petz.petz_list = {"kitty", "puppy", "ducky", "lamb", "lion", "calf", "panda", --A table with all the petz names
	"grizzly", "pony", "parrot", "chicken", "piggy", "wolf", "elephant",
	"elephant_female", "pigeon", "moth", "camel", "clownfish", "bat"}

petz.petz_list_by_owner = {} --a list of tamed petz with owner

--
--Settings
--
petz.settings = {}
petz.settings.mesh = nil
petz.settings.visual_size = {}
petz.settings.rotate = 0
petz.settings.tamagochi_safe_nodes = {} --Table with safe nodes for tamagochi mode

assert(loadfile(modpath .. "/api_helper_functions.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_orders.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_init_prop.lua"))(modpath, S) --Load the init the properties for the entities
assert(loadfile(modpath .. "/api_forms.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_on_rightclick.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_on_die.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_on_punch.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_drops.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_replace.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_feed_tame.lua"))(modpath, S, creative_mode)
assert(loadfile(modpath .. "/api_capture.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_tamagochi.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_breed.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_wool_milk.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_mount.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_dreamcatcher.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_eggs.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_squareball.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_wolf_to_puppy.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_nametag.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_dam_beaver.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_sound.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_particles.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_whistle.lua"))(modpath, S)
assert(loadfile(modpath .. "/api_silk.lua"))(modpath, S)
