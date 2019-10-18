local modpath, S = ...

petz.set_infotext_behive = function(meta, honey_count, bee_count)
	meta:set_string("infotext", S("Honey")..": "..tostring(honey_count) .." | "..S("Bees")..": "..tostring(bee_count))
end

petz.behive_exists = function(self)
	if self.behive and minetest.get_node_or_nil(self.behive).name == "petz:beehive" then
		return true
	else
		self.behive = nil
		return false
	end
end

petz.spawn_bee_pos = function(pos)	--Check a pos close to a behive to spawn a bee
	local pos_1 = {
		x = pos.x - 1,
		y = pos.y - 1,
		z = pos.z - 1,
	}
	local pos_2 = {
		x = pos.x + 1,
		y = pos.y + 1,
		z = pos.z + 1,
	}		
	spawn_pos_list = minetest.find_nodes_in_area(pos_1, pos_2, {"air"})	
	if #spawn_pos_list > 0 then
		return spawn_pos_list[math.random(1, #spawn_pos_list)]
	else
		return nil
	end
end

--Beehive
minetest.register_node("petz:beehive", {
	description = S("Beehive"),
	tiles = {"petz_beehive.png"},
	is_ground_content = false,
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
		flammable = 3, wool = 1},
	sounds = default.node_sound_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("bee_count", 3)
		meta:set_int("honey_count", 3)
		local timer = minetest.get_node_timer(pos)
		timer:start(5.0) -- in seconds
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
        local bee_count = meta:get_int("bee_count") or 0
		if bee_count > 0 then --if bee inside
			if math.random(1, 1) == 1 then --opportunitty to go out
				local spawn_bee_pos = petz.spawn_bee_pos(pos)
				if spawn_bee_pos then
					local bee = minetest.add_entity(spawn_bee_pos, "petz:bee")	
					local bee_entity = bee:get_luaentity()
					bee_entity.behive = mobkit.remember(bee_entity, "behive", pos)
					bee_count = bee_count - 1
					meta:set_int("bee_count", bee_count)
					local honey_count = meta:get_int("honey_count") or 0	
					petz.set_infotext_behive(meta, honey_count, bee_count)
				end
			end
		end
        return true
    end
})
