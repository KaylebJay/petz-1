minetest.register_chatcommand("clear_mobs", {
	description = "Clear all non-tamed mobs",
	privs = {
        server = true,
    },
    func = function(name, param)
		local modname = string.match(param, "([%a%d_-]+)")
		if not modname then
			return true, "Error: You have to specifiy a namespace (mod name)"
		end
		local player_pos = minetest.get_player_by_name(name):get_pos()
		if not player_pos then
			return
		end
		for _, obj in ipairs(minetest.get_objects_inside_radius(player_pos, 100)) do
			ent_name = obj:get_entity_name()
			if not(obj:is_player()) and minetest.registered_entities[ent_name] then
				colon_pos = string.find(ent_name, ':')
				ent_modname = string.sub(ent_name, 1, colon_pos-1)
				local ent = obj:get_luaentity()
				if ent_modname == modname and ent.type and not(ent.tamed) then
					mokapi.remove_mob(ent)
				end
			end
		end
    end,
})
