local modpath, S = ...

--Pet Hairbrush
    minetest.register_craftitem("petz:hairbrush", {
        description = S("Hairbrush"),
        inventory_image = "petz_hairbrush.png",
        wield_image = "petz_hairbrush.png"
    })

    minetest.register_craft({
        type = "shaped",
        output = "petz:hairbrush",
        recipe = {
            {"", "", ""},
            {"", "default:stick", "farming:string"},
            {"default:stick", "", ""},
        }
    })

--Pet Bowl
minetest.register_node("petz:pet_bowl", {
    description = S("Pet Bowl"),
    inventory_image = "petz_pet_bowl_inv.png",
    wield_image = "petz_pet_bowl_inv.png",
    tiles = {"petz_pet_bowl.png"},
    groups = {snappy=1, bendy=2, cracky=1},
    sounds = default_stone_sounds,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875}, -- bottom
            {-0.1875, -0.4375, -0.1875, 0.1875, -0.375, -0.125}, -- front
            {-0.1875, -0.4375, 0.125, 0.1875, -0.375, 0.1875}, -- back
            {-0.1875, -0.4375, -0.125, -0.125, -0.375, 0.125}, -- left
            {0.125, -0.4375, -0.125, 0.1875, -0.375, 0.125}, -- right
            },
        },
})
 
minetest.register_craft({
    type = "shaped",
    output = 'petz:pet_bowl',
    recipe = {        
        {'group:wood', '', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'dye:red', ''},
    }
})

--Beaver Oil

minetest.register_craftitem("petz:beaver_oil", {
    description = S("Beaver Oil"),
    inventory_image = "petz_beaver_oil.png",
    wield_image = "petz_beaver_oil.png"
})

minetest.register_craft({
    type = "shaped",
    output = "petz:beaver_oil",
    recipe = {
        {"", "", ""},
        {"", "petz:beaver_fur", ""},
        {"", "vessels:glass_bottle", ""},
    }
})

minetest.register_node("petz:beaver_dam_branches", {
    description = S("Beaver Dam Branches"),
    drawtype = "allfaces_optional",
    paramtype = "light",
    walkable = true,
    tiles = {"petz_beaver_dam_branches.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

--Whip

minetest.register_craftitem("petz:whip", {
    description = S("Whip"),
    inventory_image = "petz_whip.png",
    wield_image = "petz_whip.png",
    after_use = function(itemstack, user, node, digparams)
        petz.do_sound_effect("player", user, "petz_whip")
    end,
})

minetest.register_craft({
    type = "shaped",
    output = "petz:whip",
    recipe = {
        {'', '', 'farming:string'},
        {'', 'farming:string', 'dye:brown'},
        {'default:stick', '', ''},
    }
})

--Bucket Milk
minetest.register_craftitem("petz:bucket_milk", {
    description = S("Milk Bucket"),
    stack_max = 1,
    wield_image = {"petz_bucket_milk.png"},
    inventory_image = "petz_bucket_milk.png",
    groups = {milk_bucket = 1, food = 3},
    on_use = function (itemstack, user, pointed_thing)
        return minetest.do_item_eat(3, "bucket:bucket_empty", itemstack, user, pointed_thing)
    end,	
})

minetest.register_alias("petz:bucket_milk", "mobs:bucket_milk")

--Turtle Shell
minetest.register_craftitem("petz:turtle_shell", {
    description = S("Turtle Shell"),
    wield_image = {"petz_turtle_shell.png"},
    inventory_image = "petz_turtle_shell.png",
    groups = {},
})

minetest.register_craftitem("petz:leather", {
    description = S("Leather"),
    inventory_image = "petz_leather.png",
    wield_image = "petz_leather.png"
})

minetest.register_craftitem("petz:beaver_fur", {
    description = S("Beaver Fur"),
    inventory_image = "petz_beaver_fur.png",
    wield_image = "petz_beaver_fur.png"
})

minetest.register_craftitem("petz:ducky_feather", {
    description = S("Ducky Feather"),
    inventory_image = "petz_ducky_feather.png",
    wield_image = "petz_ducky_feather.png",
    groups = {feather = 1},
})

--Material for Lion's Cage

minetest.register_node("petz:gray_paving_stone", {
    description = S("Gray Paving Stone"),
    tiles = {"petz_gray_paving_stone.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

---
---Fishtank
---

local function remove_fish(pos)
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	if not objs then
		return
	end
	for _, obj in pairs(objs) do
		if obj and obj:get_luaentity() and obj:get_luaentity().groups.fishtank then					
			obj:remove()
			break			
		end
	end
end

minetest.register_node("petz:fishtank", {
	description = S("Fish Tank"),
	drawtype = "glasslike_framed",
	tiles = {"petz_fishtank_top.png", "petz_fishtank_bottom.png"},
	special_tiles = {"petz_fishtank_bottom.png"},
	inventory_image = "petz_fishtank_inv.png",
	walkable = false,
	groups = {snappy = 2},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	param2 = 50,
	sunlight_propagates = true,
	use_texture_alpha = true,
	light_source = LIGHT_MAX - 1,
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 0.4, 0.25 },
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)		
		local itemstack_meta = itemstack:get_meta()
		local itemstack_name
		itemstack_name= itemstack_meta:get_string("petz_type") --Captured mobs have a entity name ended in '_set', so cannot use itemstack:get_name()
		if itemstack_name == "" then
			itemstack_name = itemstack:get_name()
		else
			itemstack_name= "petz:"..itemstack_name
		end
        local itemstack_group = minetest.get_item_group(itemstack_name, "spawn_egg")
        --minetest.chat_send_player("singleplayer", itemstack_name)        
        local meta = minetest.get_meta(pos)
		local has_fish = meta:get_string("has_fish")			
        if (itemstack_group >= 1) or (itemstack_name == "petz:clownfish" or itemstack_name == "petz:tropicalfish") then	
			if has_fish == "false" then
				meta:set_string("has_fish", "true")				
				meta:set_string("fish_type", itemstack_name)	
				local fish_entity = minetest.add_entity({x=pos.x, y=pos.y, z=pos.z}, itemstack_name.."_entity_sprite")
				fish_entity:set_properties({textures=itemstack_meta:get_string("textures").."^[transformFX"}) 		
				fish_entity:set_sprite({x=0, y=0}, 16, 1.0, false)		
				itemstack:take_item()			
				clicker:set_wielded_item(itemstack)
				return itemstack
			end
		elseif ((itemstack_name == "mobs:net") or (itemstack_name == "fireflies:bug_net")) and (has_fish == "true") then
			local inv = clicker:get_inventory()
			local fish_type = meta:get_string("fish_type")
			if fish_type and inv:room_for_item("main", ItemStack(fish_type)) then
				inv:add_item("main", fish_type)
				remove_fish(pos)
				meta:set_string("has_fish", "false")
				meta:set_string("fish_texture", nil)
			end
		end
    end,
	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "petz:fishtank", param2 = 1})
		local meta = minetest.get_meta(pos)
		meta:set_string("has_fish", "false")
	end,
	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		local has_fish = meta:get_string("has_fish")
		local fish_type = meta:get_string("fish_type")	
		if fish_type and has_fish == "true" then
			remove_fish(pos)
			minetest.add_entity(pos, fish_type)
		end
	end
})

minetest.register_craft({
	type = "shaped",
	output = "petz:fishtank",
	recipe = {
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:water_source", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"},
	}
})

--Metal Syringe

minetest.register_craftitem("petz:glass_syringe", {
    description = S("Glass Syringe"),
    inventory_image = "petz_glass_syringe.png",
    wield_image = "petz_glass_syringe.png"
})

minetest.register_craftitem("petz:glass_syringe_sperm", {
    description = S("Glass Syringe with sperm"),
    inventory_image = "petz_glass_syringe_sperm.png",
    wield_image = "petz_glass_syringe_sperm.png"
})

minetest.register_craft({
    type = "shaped",
    output = "petz:glass_syringe",
    recipe = {
        {"", "", "vessels:glass_fragments"},
        {"", "vessels:glass_fragments", ""},
        {"default:steel_ingot", "", ""},
    }
})

-- Shears	
minetest.register_tool("petz:shears", {
	description = S("Shears"),
	inventory_image = "petz_shears.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	type = "shaped",
	output = 'petz:shears',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'group:stick', 'default:steel_ingot'},
	}
})

-- Lasso
minetest.register_tool("petz:lasso", {
	description = S("Lasso"),
	inventory_image = "petz_lasso.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	output = "petz:lasso",
	recipe = {
		{"farming:string", "", "farming:string"},
		{"", "default:diamond", ""},
		{"farming:string", "", "farming:string"},		}
})

-- Saddle

minetest.register_craftitem("petz:saddle", {
	description = S("Saddle"),
	inventory_image = "petz_saddle.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	type = "shaped",
	output = "petz:saddle",
	recipe = {
		{"petz:leather", "petz:leather", "petz:leather"},
		{"petz:leather", "default:steel_ingot", "petz:leather"},
		{"petz:leather", "default:steel_ingot", "petz:leather"},
	}
})

minetest.register_craftitem("petz:saddlebag", {
	description = S("Saddlebag"),
	inventory_image = "petz_saddlebag.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	type = "shaped",
	output = "petz:saddlebag",
	recipe = {
		{"petz:leather", "petz:leather", "petz:leather"},
		{"petz:leather", "", "petz:leather"},
		{"petz:leather", "petz:leather", "petz:leather"},
	}
})

--Bone
minetest.register_craftitem("petz:bone", {
    description = S("Bone"),
    inventory_image = "petz_bone.png",
    wield_image = "petz_bone.png"
})

-- Elephant Tusk

minetest.register_craftitem("petz:elephant_tusk", {
	description = S("Elephant Tusk"),
	inventory_image = "petz_elephant_tusk.png",
	groups = {},
})

-- Dreamcatcher

minetest.register_craftitem("petz:dreamcatcher", {
	description = S("Pet Dreamcatcher"),
	inventory_image = "petz_dreamcatcher.png",
	groups = {},
})

minetest.register_craft({
	type = "shaped",
	output = "petz:dreamcatcher",
	recipe = {
		{"", "group:wood", ""},
		{"farming:string", "farming:string", "farming:string"},
		{"petz:ducky_feather", "petz:ducky_feather", "petz:ducky_feather"},
	}
})

minetest.register_node("petz:bottle_moth", {
	description = S("Bottle with Moth"),
	drawtype = "plantlike",
	tiles = {"petz_bottle_moth.png"},
	inventory_image = "petz_bottle_moth_inv.png",
	walkable = false,
	groups = {snappy = 2},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	param2 = 50,
	sunlight_propagates = true,
	use_texture_alpha = true,
	light_source = LIGHT_MAX - 1,
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 0.4, 0.25 },
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		--local meta_itemstack = itemstack:get_meta()
		local meta = minetest.get_meta(pos)
		--meta = meta_itemstack
		local placer_name = ""
		if placer:is_player() then
			placer_name = placer:get_player_name()
		end		
		meta:set_string("owner", placer_name)
	end,
	on_destruct = function(pos)
		local ent = minetest.add_entity(pos, "petz:moth")
		local meta = minetest.get_meta(pos)		
		petz.set_owner(ent, meta:get_string("owner"), false) --set owner
		--minetest.chat_send_player("singleplayer", meta:get_string("owner"))
	end,
})

--Bonemeal support
if minetest.get_modpath("bonemeal") ~= nil then	
	minetest.register_craft({
		type = "shapeless",
		output = "bonemeal:bonemeal",
		recipe = {"petz:bone"},
	})
end
