local modpath, S = ...

--Material for Pet's House

minetest.register_node("petz:red_gables", {
    description = S("Red Gables"),
    tiles = {"petz_red_gables.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("petz:yellow_paving", {
    description = S("Yellow Paving"),
    tiles = {"petz_yellow_paving.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("petz:blue_stained_wood", {
    description = S("Blue Stained Wood"),
    tiles = {"petz_blue_stained_planks.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

if minetest.get_modpath("stairs") ~= nil then
    stairs.register_stair_and_slab(
        "red_gables",
        "petz:red_gables",
        {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        {"petz_red_gables.png"},
        S("Red Gables Stair"),
        S("Red Gables Slab"),
        default.node_sound_wood_defaults()
    )
    stairs.register_stair_and_slab(
        "blue_stained_wood",
        "petz:blue_stained_wood",
        {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        {"petz_blue_stained_planks.png"},
        S("Blue Stained Stair"),
        S("Blue Stained Slab"),
        default.node_sound_wood_defaults()
    )
end

--Kennel Schematic

minetest.register_craftitem("petz:kennel", {
    description = S("Kennel"),
    wield_image = {"petz_kennel.png"},
    inventory_image = "petz_kennel.png",
    groups = {},
    on_use = function (itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then            
            return
        end        
        local pt_above = pointed_thing.above
        local pt_under = pointed_thing.under
        if not(minetest.is_protected(pt_above, user:get_player_name())) then
			minetest.place_schematic(pt_above, modpath..'/schematics/kennel.mts', 0, nil, true)        
			itemstack:take_item()
			return itemstack
		end
    end,
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:kennel',
    recipe = {        
        {'group:wood', 'dye:red', 'group:wood'},
        {'group:wood', 'dye:blue', 'group:wood'},
        {'group:stone', 'dye:yellow', 'group:stone'},
    }
})

--Ducky Nest

minetest.register_node("petz:ducky_nest", {
    description = S("Nest"),
    inventory_image = "petz_ducky_nest_inv.png",
    wield_image = "petz_ducky_nest_inv.png",
    tiles = {"petz_ducky_nest.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest.b3d',
    visual_size = {x = 1.3, y = 1.3},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        if player then
            local itemstack_name = itemstack:get_name()
            if itemstack_name == "petz:ducky_egg" or itemstack_name == "petz:chicken_egg" then --put the egg
				local egg_type = "" 
				if itemstack_name == "petz:ducky_egg" then
					egg_type = "ducky"
				else
					egg_type = "chicken"
				end
                itemstack:take_item()			
				player:set_wielded_item(itemstack)
				minetest.set_node(pos, {name= "petz:".. egg_type .."_nest_egg"})
				return itemstack		
            end
        end
    end,
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:ducky_nest',
    recipe = {        
        {'', '', ''},
        {'group:leaves', '', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

minetest.register_node("petz:ducky_nest_egg", {
    description = S("Ducky Nest with Egg"),
    inventory_image = "petz_ducky_nest_egg_inv.png",
    wield_image = "petz_ducky_nest_egg_inv.png",
    tiles = {"petz_ducky_nest_egg.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest_egg.b3d',
    visual_size = {x = 1.3, y = 1.3},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		petz.extract_egg_from_nest(self, pos, player, "petz:ducky_egg") --extract the egg
	end,
})

minetest.register_node("petz:chicken_nest_egg", {
    description = S("Chicken Nest with Egg"),
    inventory_image = "petz_chicken_nest_egg_inv.png",
    wield_image = "petz_chicken_nest_egg_inv.png",
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "mesh",
    mesh = 'petz_ducky_nest_egg.b3d',
    visual_size = {x = 1.3, y = 1.3},
    tiles = {"petz_chicken_nest_egg.png"},
    collision_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
    selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.75, -0.25, 0.25, -0.25, 0.25},
    },
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		petz.extract_egg_from_nest(self, pos, player, "petz:chicken_egg") --extract the egg
	end,
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:ducky_nest_egg',
    recipe = {        
        {'', '', ''},
        {'group:leaves', 'petz:ducky_egg', 'group:leaves'},
        {'default:papyrus', 'default:papyrus', 'default:papyrus'},
    }
})

-- Chance to hatch an egg into a ducky or chicken
minetest.register_abm({
    nodenames = {"petz:ducky_nest_egg"},
    neighbors = {},
    interval = 600.0, -- Run every 10 minuts
    chance = 5, -- Select every 1 in 3 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        local pos_above = {x = pos.x, y = pos.y +1, z= pos.z}
        if pos_above then
            if not minetest.registered_entities["petz:ducky"] then
                return
            end
            --pos.y = pos.y + 1
            local mob = minetest.add_entity(pos_above, "petz:ducky")
            local ent = mob:get_luaentity()
            minetest.set_node(pos, {name= "petz:ducky_nest"})
        end
    end
})

minetest.register_abm({
    nodenames = {"petz:chicken_nest_egg"},
    neighbors = {},
    interval = 600.0, -- Run every 10 minuts
    chance = 5, -- Select every 1 in 3 nodes
    action = function(pos, node, active_object_count, active_object_count_wider)
        local pos_above = {x = pos.x, y = pos.y +1, z= pos.z}
        if pos_above then
            if not minetest.registered_entities["petz:chicken"] then
                return
            end
            --pos.y = pos.y + 1
            local mob = minetest.add_entity(pos_above, "petz:chicken")
            local ent = mob:get_luaentity()
            minetest.set_node(pos, {name= "petz:ducky_nest"})
        end
    end
})

--Vanilla Wool
minetest.register_node("petz:wool_vanilla", {
	description = S("Vanilla Wool"),
	tiles = {"wool_vanilla.png"},
	is_ground_content = false,
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
		flammable = 3, wool = 1},
	sounds = default.node_sound_defaults(),
})
minetest.register_alias("wool:vanilla", "petz:wool_vanilla")

--Bird Stand

minetest.register_node("petz:bird_stand", {
    description = S("Bird Stand"),  
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default.node_sound_wood_defaults(),
    paramtype = "light",
    drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0, 0.4375, 0}, -- down
			{-0.375, 0.4375, -0.0625, 0.3125, 0.5, -2.23517e-08}, -- top
			{-0.125, -0.5, -0.125, 0.0625, -0.4375, 0.0625}, -- base
		},
	},
	selection_box = {
        type = "fixed",
        fixed= {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
    },
    visual_size = {x = 1.0, y = 1.0},
    tiles = {"default_wood.png"},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local player_name = player:get_player_name()	
		local pos_above = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z,
		}
		local bird_in_stand
		local obj_list = minetest.get_objects_inside_radius(pos_above, 1) --check if already a parrot
		local pos_parrot = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z - 0.125,
		} 
		local pos_toucan = {
			x = pos.x - 0.0625,
			y = pos.y + 1,
						z = pos.z + 0.0625,
		}		
		for _, obj in ipairs(obj_list) do
			local ent = obj:get_luaentity()
			if ent and (ent.name == "petz:parrot" or ent.name == "petz:toucan") then			
				bird_in_stand = true	
				local rotation = obj:get_rotation()
				local bird_pos = obj:get_pos()
				local z_offset
				if ent.name == "petz:parrot" then
					z_offset = 0.125
				else
					z_offset  = -0.125
				end
				if rotation.y == 0 then
					obj:set_rotation({x=0, y=math.pi, z=0})
					obj:set_pos({x= bird_pos.x, y=bird_pos.y, z=bird_pos.z+z_offset })
				else
					obj:set_rotation({x=0, y=0, z=0})
					if ent.name == "petz:parrot" then
						obj:set_pos(pos_parrot)
					else
						obj:set_pos(pos_toucan)
					end					
				end				
			end
		end					
		local itemstack_name = itemstack:get_name()
		if itemstack_name == "petz:parrot_set" or itemstack_name == "petz:toucan_set" then		
			if bird_in_stand == true then
				minetest.chat_send_player(player_name, S("There's already a bird on top."))	
				return
			end
			if not minetest.is_protected(pos, player_name) then
				local player_pos = player:get_pos()
				if itemstack_name == "petz:parrot_set" then
					pos = pos_parrot
				else --toucan
					pos = pos_toucan
				end
				ent = petz.create_pet(player, itemstack, itemstack_name:sub(1, -5) , pos)
				petz.standhere(ent)
			end
			return itemstack
		end
    end,
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:bird_stand',
    recipe = {        
        {'default:stick', 'group:feather', 'default:stick'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

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
		local	drops = {
			{name = "petz:honeycomb", chance = 1, min = 6, max= 6},		
		}
		meta:set_string("drops", minetest.serialize(drops))		
		local timer = minetest.get_node_timer(pos)
		timer:start(2.0) -- in seconds
		local honey_count = petz.settings.initial_honey_behive
		meta:set_int("honey_count", honey_count)
		local bee_count = petz.settings.max_bees_behive
		meta:set_int("total_bees", bee_count)
		meta:set_int("bee_count", bee_count)
		petz.set_infotext_behive(meta, honey_count, bee_count)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local honey_count = petz.settings.initial_honey_behive
		meta:set_int("honey_count", honey_count)		
		local bee_count
		if placer:is_player() then
			bee_count = 1
		else
			bee_count = petz.settings.max_bees_behive			
		end
		meta:set_int("bee_count", bee_count)	
		meta:set_int("total_bees", bee_count)
		petz.set_infotext_behive(meta, honey_count, bee_count)
	end,
	on_destruct = function(pos)
		minetest.add_entity(pos, "petz:queen_bee")
		petz.node_drop_items(pos)
	end,
	on_timer = function(pos)
		local meta, honey_count, bee_count = petz.get_behive_stats(pos)
		if bee_count > 0 then --if bee inside
			local tpos = {
				x = pos. x,
				y = pos.y - 4,
				z = pos.z,
			}	
			local ray = minetest.raycast(pos, tpos, false, false) --check if fire/torch (igniter) below
			local igniter_below = false			
			for thing in ray do
				if thing.type == "node" then
					local node_name = minetest.get_node(thing.under).name
					--minetest.chat_send_player("singleplayer", node_name)
					if minetest.get_item_group(node_name, "igniter") >0 or minetest.get_item_group(node_name, "torch") > 0 then
						igniter_below = true
						--minetest.chat_send_player("singleplayer", S("igniter"))
						break
					end					
				end
			end
			local bee_outing_ratio
			if igniter_below == false then
				bee_outing_ratio = petz.settings.bee_outing_ratio
			else
				bee_outing_ratio = 1
			end
			if math.random(1, bee_outing_ratio) == 1 then --opportunitty to go out
				local spawn_bee_pos = petz.spawn_bee_pos(pos)
				if spawn_bee_pos then
					local bee = minetest.add_entity(spawn_bee_pos, "petz:bee")	
					local bee_entity = bee:get_luaentity()
					bee_entity.behive = mobkit.remember(bee_entity, "behive", pos)
					bee_count = bee_count - 1
					meta:set_int("bee_count", bee_count)
					petz.set_infotext_behive(meta, honey_count, bee_count)
				end
			end
		end
        return true
    end,   
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local wielded_item = player:get_wielded_item()
		local wielded_item_name = wielded_item:get_name()
		local meta, honey_count, bee_count = petz.get_behive_stats(pos)
		local player_name = player:get_player_name()	
		if wielded_item_name == "vessels:glass_bottle" then			
			if honey_count > 0 then
				local inv = player:get_inventory()
				if inv:room_for_item("main", "petz:honey_bottle") then
					local itemstack_name = itemstack:get_name()
					local stack = ItemStack("petz:honey_bottle 1")
					if (itemstack_name == "petz:honey_bottle" or itemstack_name == "") and (itemstack:get_count() < itemstack:get_stack_max()) then					
						itemstack:add_item(stack)					
					else						
						inv:add_item("main", stack)				
					end		
					itemstack:take_item()
					honey_count = honey_count - 1
					meta:set_int("honey_count", honey_count)
					petz.set_infotext_behive(meta, honey_count, bee_count)
					return itemstack
				else
					minetest.chat_send_player(player_name, S("No room in your inventory for the honey bottle."))
				end
			else
				minetest.chat_send_player(player_name, S("No honey in the behive."))
			end
		elseif wielded_item_name == "petz:bee_set" then
			local total_bees = meta:get_int("total_bees") or petz.settings.max_bees_behive
			if total_bees < petz.settings.max_bees_behive then
				bee_count = bee_count + 1
				total_bees = total_bees + 1
				meta:set_int("bee_count", bee_count)
				meta:set_int("total_bees", total_bees)
				petz.set_infotext_behive(meta, honey_count, bee_count)
				itemstack:take_item()	
				return itemstack
			else
				minetest.chat_send_player(player_name, S("This behive already has").." "..tostring(petz.settings.max_bees_behive).." "..S("bees inside."))
			end
		end
	end,
})

minetest.register_craft({
	type = "shaped",
	output = "petz:beehive",
	recipe = {
		{"petz:honeycomb", "petz:honeycomb", "petz:honeycomb"},
		{"petz:honeycomb", "petz:bee_set", "petz:honeycomb"},
		{"petz:honeycomb", "petz:honeycomb", "petz:honeycomb"},
	}
})

--Halloween Update

minetest.register_node("petz:jack_o_lantern", {
    description = S("Jack-o'-lantern"),
    groups = { snappy=3, flammable=3, oddly_breakable_by_hand=2 },
  	sounds = default.node_sound_wood_defaults({
		dig = { name = "default_dig_oddly_breakable_by_hand" },
		dug = { name = "default_dig_choppy" }
	}),
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 11,
	sunlight_propagates = true,
    tiles = {
		"petz_jackolantern_top.png", "petz_jackolantern_bottom.png",
		"petz_jackolantern_right.png", "petz_jackolantern_left.png",
		"petz_jackolantern_back.png", "petz_jackolantern_front.png"
    },
})

if minetest.get_modpath("farming") ~= nil and farming.mod == "redo" then
	minetest.register_craft({
		type = "shapeless",
		output = "petz:jack_o_lantern",
		recipe = {"farming:pumpkin", "petz:beeswax_candle"},
	})
	minetest.register_craft({
		type = "shapeless",
		output = "petz:jack_o_lantern",
		recipe = {"farming:pumpkin", "default:torch"},
	})
end

if minetest.get_modpath("crops") ~= nil then	
	minetest.register_craft({
		type = "shapeless",
		output = "petz:jack_o_lantern",
		recipe = {"crops:pumpkin", "petz:beeswax_candle"},
	})
	minetest.register_craft({
		type = "shapeless",
		output = "petz:jack_o_lantern",
		recipe = {"crops:pumpkin", "default:torch"},
	})
end
