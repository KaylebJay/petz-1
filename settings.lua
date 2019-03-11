local modpath, S = ...

local settings = Settings(modpath .. "/petz.conf")

petz.settings.type_model = settings:get("type_model", "mesh")
petz.settings.tamagochi_mode = settings:get_bool("tamagochi_mode", true)
petz.settings.tamagochi_check_time = tonumber(settings:get("tamagochi_check_time"))
petz.settings.tamagochi_hunger_damage = tonumber(settings:get("tamagochi_hunger_damage"))
petz.settings.tamagochi_safe_node = settings:get("tamagochi_safe_node", "")
petz.settings.type_api = settings:get("type_api", "mobs_redo")
petz.settings.kitty_spawn = settings:get_bool("kitty_spawn", true)
petz.settings.kitty_follow = settings:get("kitty_follow", "")
petz.settings.puppy_spawn = settings:get_bool("puppy_spawn", true)
petz.settings.puppy_follow = settings:get("puppy_follow", "")
petz.settings.ducky_spawn = settings:get_bool("ducky_spawn", true)
petz.settings.ducky_follow = settings:get("ducky_follow", "")
petz.settings.beaver_spawn = settings:get_bool("beaver_spawn", true)
petz.settings.beaver_follow = settings:get("beaver_follow", "")
petz.settings.beaver_create_dam = settings:get_bool("beaver_create_dam", true)

if petz.settings.type_model == "mesh" then
    petz.settings.visual = "mesh"
    petz.settings.visual_size = {x=15.0, y=15.0}
    petz.settings.rotate = 0
else -- is 'cubic'
    petz.settings.visual = "wielditem"
    petz.settings.visual_size = {x=1.0, y=1.0}
    petz.settings.rotate = 180
end