local modpath, S = ...

local lycanthropy = {}
lycanthropy.clans = {
	{
		name = S("The Savage Stalkers")
	},
	{
		name = S("The Bravehide Pride")
	},
	{
		name = S("The Hidden Tails")
	},
}
lycanthropy.werewolf = {}
lycanthropy.werewolf.model = "petz_werewolf.b3d"
lycanthropy.werewolf.textures = {"petz_werewolf_gray.png"} 
lycanthropy.werewolf.collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
lycanthropy.werewolf.animation_speed = 30
lycanthropy.werewolf.animations = {
	stand = {x = 0,   y = 79},
	lay = {x = 162, y = 166},
	walk = {x = 168, y = 187},
	mine = {x = 189, y = 198},
	walk_mine = {x = 200, y = 219},
	sit = {x = 81,  y = 160},
}

player_api.register_model(lycanthropy.werewolf.model, {
	textures = lycanthropy.werewolf.textures,
	animation_speed = lycanthropy.werewolf.animation_speed,
	animations = lycanthropy.werewolf.animations,
	collisionbox = lycanthropy.werewolf.collisionbox ,
	stepheight = 0.6,
	eye_height = 1.47,
})

petz.set_lycanthropy = function(player)
	local meta = player:get_meta()
	local player_name = player:get_player_name()
	player_api.set_model(player, lycanthropy.werewolf.model)
	player:set_local_animation(
		{x = 0,   y = 79},
		{x = 168, y = 187},
		{x = 189, y = 198},
		{x = 200, y = 219},
		30
	)
	local werewolf = meta:get_int("petz:werewolf")
	local werewolf_texture_no = 1
	local werewolf_texture
	if werewolf == 0 then
		meta:set_int("petz:lycanthropy", 1)
		meta:set_int("petz:werewolf", 1)
		werewolf_texture_no = math.random(1, #lycanthropy.werewolf.textures)
		werewolf_texture = lycanthropy.werewolf.textures[werewolf_texture_no]
		meta:set_int("petz:werewolf_texture_no", werewolf_texture_no)
		local clan_index = math.random(1, #lycanthropy.clans)
		meta:set_int("petz:werewolf_clan_idx", clan_index)
		minetest.chat_send_player(player_name, S("You've fallen ill with Lycanthropy!"))	
	else
		werewolf_texture_no = meta:get_int("petz:werewolf_texture_no")
		werewolf_texture = lycanthropy.werewolf.textures[werewolf_texture_no]		
	end
	if minetest.get_modpath("3d_armor") ~= nil then
		petz.set_3d_armor_lycanthropy(player)	
	else
		player_api.set_textures(player, {werewolf_texture})
	end
	--petz.set_properties(player, {textures = {werewolf_texture}})		
	--player:set_properties({textures = {werewolf_texture}})
end

petz.unset_lycanthropy = function(player)
	local meta = player:get_meta()
	local player_name = player:get_player_name()
	if minetest.get_modpath("3d_armor") ~= nil then
		player_api.set_model(player, "3d_armor_character.b3d")
	else
		player_api.set_model(player, "character.b3d")		
	end
	meta:set_int("petz:werewolf", 0)
	if minetest.get_modpath("3d_armor") ~= nil then
		petz.unset_3d_armor_lycanthropy(player)	
	else
		player_api.set_textures(player, {"character.png"})	
	end
end

petz.reset_lycanthropy = function(player)
	local player_name = player:get_player_name()
	local meta = player:get_meta()
	if meta:get_int("petz:werewolf") == 1 then
		petz.unset_lycanthropy(player)
	end
	meta:set_int("petz:lycanthropy", 0)
	minetest.chat_send_player(player_name, S("You've cured of Lycanthropy"))
	
end

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if not(hitter.type == "petz:wolf") then
		return
	end
	petz.set_lycanthropy(player)
end)

local timer = 0
local last_period_of_day

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 5 then --only check each 30 seconds
		timer = 0
		local current_period_of_day = petz.is_night()
		--minetest.chat_send_player("singleplayer", "current="..tostring(current_period_of_day))
		--minetest.chat_send_player("singleplayer", "last="..tostring(last_period_of_day))
		if (current_period_of_day ~= last_period_of_day) then --only continue if there is a change day-night or night-day
			last_period_of_day = current_period_of_day
			for _, player in pairs(minetest.get_connected_players()) do				
				local player_name = player:get_player_name()
				local meta = player:get_meta()		
				local msg = ""
				if meta:get_int("petz:lycanthropy") == 1 then
					if petz.is_night() == true then
						petz.set_lycanthropy(player)
						msg = S("You are now a werewolf")
					else
						petz.unset_lycanthropy(player)
						msg = S("You are now a human")
					end
				end
				minetest.chat_send_player(player_name, msg)	
			end
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()	
	if meta:get_int("petz:werewolf") == 1 then
		petz.set_lycanthropy(player)		
	end
end)

petz.set_3d_armor_lycanthropy = function(player)
	local player_name = player:get_player_name()
	local meta = player:get_meta()
	default.player_set_textures(player, {
		lycanthropy.werewolf.textures[meta:get_int("petz:werewolf_texture_no")],
		armor.textures[player_name].armor,
		armor.textures[player_name].wielditem,
	})
end

petz.unset_3d_armor_lycanthropy = function(player)
	local player_name = player:get_player_name()
	default.player_set_textures(player, {
		armor.textures[player_name].skin,
		armor.textures[player_name].armor,
		armor.textures[player_name].wielditem,
	})
end

if minetest.get_modpath("3d_armor") ~= nil then --Armors (optional)
	armor:register_on_update(function(player)
		local meta = player:get_meta()
		if meta:get_int("petz:werewolf") == 1 then			
			petz.set_3d_armor_lycanthropy(player)
		end
	end)
end

--
--CHAT COMMANDS
--
minetest.register_chatcommand("werewolf", {
	description = "Convert a player into a werewolf",
	privs = {
        server = true,
    },
    func = function(name, param)
		local subcommand, player_name = string.match(param, "([%a%d_-]+) ([%a%d_-]+)")	
		if not(subcommand == "set") and not(subcommand == "unset") and not(subcommand == "reset") then							
			return true, "Error: The subcomands for the werewolf command are 'set' / 'unset'"
		end
		if player_name then	
			local player = minetest.get_player_by_name(player_name)
			if player then
				if subcommand == "set" then
					petz.set_lycanthropy(player)
					return true, player_name .." ".."set to werewolf!"
				elseif subcommand == "unset" then
					petz.unset_lycanthropy(player)
					return true, "The werewolf".." "..player_name .." ".."reseted to human!"
				elseif subcommand == "reset" then
					petz.reset_lycanthropy(player)
					return true, "The lycanthropy of".." "..player_name .." ".."was cured!"
				end
			else
				return false, player_name .." ".."not online!"
			end
		else
			return true, "Not a player name in command"
		end
    end,
})

--Lycanthropy Items

minetest.register_craftitem("petz:lycanthropy_remedy", {
    description = S("Lycanthropy Remedy"),
    inventory_image = "petz_lycanthropy_remedy.png",
    wield_image = "petz_lycanthropy_remedy.png"
})

minetest.register_craft({
    type = "shaped",
    output = "petz:lycanthropy_remedy",
    recipe = {
        {"", "petz:wolf_jaw", ""},
        {"", "petz:wolf_fur", ""},
        {"", "petz:beaver_oil", ""},
    }
})

--
-- WEREWOLF MONSTER
--

local pet_name = "werewolf"
local scale_model = 1.0
local mesh = lycanthropy.werewolf.model	
local textures = lycanthropy.werewolf.textures
local collisionbox = lycanthropy.werewolf.collisionbox

minetest.register_entity("petz:"..pet_name,{          
	--Petz specifics	
	type = "werewolf",	
	init_tamagochi_timer = false,		
	is_pet = false,
	is_monster = true,
	is_boss = true,
	has_affinity = false,
	is_wild = true,
	attack_player = true,
	give_orders = false,
	can_be_brushed = false,
	capture_item = nil,
	follow = petz.settings.werewolf_follow,	
	drops = {
		{name = "petz:christmas_present", chance = 3, min = 1, max = 1,},
		{name = "petz:gingerbread_cookie", chance = 1, min = 1, max = 6,},
		{name = "petz:candy_cane", chance = 1, min = 1, max = 6,},
	},
	rotate = petz.settings.rotate,
	physical = true,
	stepheight = 0.1,	--EVIL!
	collide_with_objects = true,
	collisionbox = collisionbox,
	visual = petz.settings.visual,
	mesh = mesh,
	textures = textures,
	visual_size = {x=1.0*scale_model, y=1.0*scale_model},
	static_save = true,
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 1.5,
	jump_height = 1.5,
	view_range = 20,
	lung_capacity = 10, -- seconds
	max_hp = 50,  		
	
	attack={range=0.5, damage_groups={fleshy=9}},	
	animation = {
		walk={range={x=168, y=187}, speed=30, loop=true},	
		run={range={x=168, y=187}, speed=30, loop=true},	
		stand={range={x=0, y=79}, speed=30, loop=true},	
	},
	sounds = {
		misc = "petz_merry_christmas",
		attack = "petz_ho_ho_ho",
		laugh = "petz_ho_ho_ho",
		die = "petz_monster_die",
	},
	
	logic = petz.monster_brain,
	
	on_activate = function(self, staticdata, dtime_s) --on_activate, required
		mobkit.actfunc(self, staticdata, dtime_s)
		petz.set_initial_properties(self, staticdata, dtime_s)
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)		
		petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	end,
	
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	
	on_step = function(self, dtime)	
		mobkit.stepfunc(self, dtime) -- required
		petz.on_step(self, dtime)
	end,
    
})

petz:register_egg("petz:werewolf", S("Werewolf"), "petz_spawnegg_werewolf.png", false)
