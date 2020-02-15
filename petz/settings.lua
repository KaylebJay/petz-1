local modpath, S = ...

local settings = Settings(modpath .. "/petz.conf")

--A list with all the petz names
petz.settings.petz_list = settings:get("petz_list", "")
petz.petz_list = string.split(petz.settings.petz_list, ',')
petz.settings.disable_monsters = settings:get_bool("disable_monsters", false)
petz.settings.type_model = settings:get("type_model", "mesh")
--Tamagochi Mode
petz.settings.tamagochi_mode = settings:get_bool("tamagochi_mode", true)
petz.settings.tamagochi_check_time = tonumber(settings:get("tamagochi_check_time"))
petz.settings.tamagochi_reduction_factor = tonumber(settings:get("tamagochi_reduction_factor")) or 0.1
petz.settings.tamagochi_punch_rate = tonumber(settings:get("tamagochi_punch_rate")) or 0.1
petz.settings.tamagochi_feed_hunger_rate = tonumber(settings:get("tamagochi_feed_hunger_rate")) or 0.1
petz.settings.tamagochi_brush_rate = tonumber(settings:get("tamagochi_brush_rate")) or 0.1
petz.settings.tamagochi_beaver_oil_rate = tonumber(settings:get("tamagochi_beaver_oil_rate")) or 0.1
petz.settings.tamagochi_lashing_rate = tonumber(settings:get("tamagochi_lashing_rate")) or 0.1
petz.settings.tamagochi_check_if_player_online = settings:get_bool("tamagochi_check_if_player_online", true)
--Create a table with safe nodes
local tamagochi_safe_nodes = settings:get("tamagochi_safe_nodes", "")
petz.settings.tamagochi_safe_nodes = {} --Table with safe nodes for tamagochi mode
petz.settings.tamagochi_safe_nodes = string.split(tamagochi_safe_nodes, ',')
--Enviromental Damage
petz.settings.air_damage = tonumber(settings:get("air_damage"))
petz.settings.igniter_damage = tonumber(settings:get("igniter_damage")) --lava & fire
--API Type
petz.settings.type_api = settings:get("type_api", "mobs_redo")
--Capture Mobs
petz.settings.rob_mobs = settings:get_bool("rob_mobs", false)
--Spawn Engine
petz.settings.spawn_interval = tonumber(settings:get("spawn_interval"))
petz.settings.spawn_chance = tonumber(settings:get("spawn_chance"))
petz.settings.max_mobs = tonumber(settings:get("max_mobs"))
--Lay Eggs
petz.settings.lay_egg_chance = tonumber(settings:get("lay_egg_chance"))
--Misc Random Sound Chance
petz.settings.misc_sound_chance = tonumber(settings:get("misc_sound_chance"))
petz.settings.max_hear_distance = tonumber(settings:get("max_hear_distance"))
--Fly Behaviour
petz.settings.fly_check_time = tonumber(settings:get("fly_check_time")) 
--Breed Engine
petz.settings.pregnant_count = tonumber(settings:get("pregnant_count"))
petz.settings.pregnancy_time = tonumber(settings:get("pregnancy_time"))
petz.settings.growth_time = tonumber(settings:get("growth_time"))
--Blood
petz.settings.blood = settings:get_bool("blood", false)
--Blood
petz.settings.poop = settings:get_bool("poop", true)
petz.settings.poop_rate = tonumber(settings:get("poop_rate", "200"))
petz.settings.poop_decay = tonumber(settings:get("poop_decay", "1200"))
--Cobweb
petz.settings.cobweb_decay = tonumber(settings:get("cobweb_decay", "1200"))
--Mount Pointable Driver
petz.settings.pointable_driver = settings:get_bool("pointable_driver", true)
petz.settings.gallop_time =  tonumber(settings:get("gallop_time", "5"))
petz.settings.gallop_recover_time =  tonumber(settings:get("gallop_recover_time", "5"))
--Falling
petz.settings.falling = settings:get_bool("falling", true)
--Lashing
petz.settings.lashing_tame_count = tonumber(settings:get("lashing_tame_count", "3"))
--Bee Stuff
petz.settings.initial_honey_behive = tonumber(settings:get("initial_honey_behive", "3"))
petz.settings.max_honey_behive = tonumber(settings:get("max_honey_behive", "10"))
petz.settings.max_bees_behive = tonumber(settings:get("max_bees_behive", "3"))
petz.settings.bee_outing_ratio = tonumber(settings:get("bee_outing_ratio", "20"))
--petz.settings.behive_spawn_chance  = tonumber(settings:get("behive_spawn_chance")) or 0.0
--petz.settings.max_behives_in_area  = tonumber(settings:get("max_behives_in_area")) or 0.0
--Weapons
petz.settings.pumpkin_grenade_damage = tonumber(settings:get("pumpkin_grenade_damage", "8"))
--Horseshoes
petz.settings.horseshoe_speedup = tonumber(settings:get("horseshoe_speedup", "1"))
--Lycanthropy
petz.settings.lycanthropy = settings:get_bool("lycanthropy", true)
petz.settings.lycanthropy_infection_chance_by_wolf = tonumber(settings:get("lycanthropy_infection_chance_by_wolf", "200")) 
petz.settings.lycanthropy_infection_chance_by_werewolf = tonumber(settings:get("lycanthropy_infection_chance_by_werewolf", "10")) 
--Mobs Specific
for i = 1, #petz.petz_list do --load the settings
	local petz_type = petz.petz_list[i]
	petz.settings[petz_type.."_spawn"]  = settings:get_bool(petz_type.."_spawn", false)
	petz.settings[petz_type.."_spawn_chance"]  = tonumber(settings:get(petz_type.."_spawn_chance")) or 0.0
	petz.settings[petz_type.."_spawn_nodes"]  = settings:get(petz_type.."_spawn_nodes", "")
	petz.settings[petz_type.."_spawn_biome"]  = settings:get(petz_type.."_spawn_biome", "default")
	petz.settings[petz_type.."_spawn_herd"] = tonumber(settings:get(petz_type.."_spawn_herd")) or 1
	petz.settings[petz_type.."_seasonal"] = settings:get(petz_type.."_seasonal", "")
	petz.settings[petz_type.."_follow"] = settings:get(petz_type.."_follow", "")
	petz.settings[petz_type.."_breed"]  = settings:get(petz_type.."_breed", "")
	petz.settings[petz_type.."_predators"]  = settings:get(petz_type.."_predators", "")
	petz.settings[petz_type.."_preys"] = settings:get(petz_type.."_preys", "")
	petz.settings[petz_type.."_colorized"] = settings:get_bool(petz_type.."_colorized", false)
	petz.settings[petz_type.."_copulation_distance"] = tonumber(settings:get(petz_type.."_copulation_distance")) or 0.0
	petz.settings[petz_type.."_convert"] = settings:get(petz_type.."_convert", nil)
	petz.settings[petz_type.."_convert_to"] = settings:get(petz_type.."_convert_to", nil)
	petz.settings[petz_type.."_convert_count"] = tonumber(settings:get(petz_type.."_convert_count")) or nil
	if petz_type == "beaver" then
		petz.settings[petz_type.."_create_dam"] = settings:get_bool(petz_type.."_create_dam", false)		
	elseif petz_type == "silkworm" then
		petz.settings[petz_type.."_lay_egg_on_node "] = settings:get(petz_type.."_lay_egg_on_node", "")
	end	
end

if petz.settings.type_model == "mesh" then
    petz.settings.visual = "mesh"
    petz.settings.visual_size = {x=10, y=10}
    petz.settings.rotate = 0
else -- is 'cubic'
    petz.settings.visual = "wielditem"
    petz.settings.visual_size = {x=1.0, y=1.0}
    petz.settings.rotate = 180
end


