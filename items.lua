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
        petz.do_sound_effect("object", user, "petz_whip")
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
    wield_image = {"petz_bucket_milk.png"},
    inventory_image = "petz_bucket_milk.png",
    groups = {milk_bucket = 1},
})

--Turtle Shell
minetest.register_craftitem("petz:turtle_shell", {
    description = S("Turtle Shell"),
    wield_image = {"petz_turtle_shell.png"},
    inventory_image = "petz_turtle_shell.png",
    groups = {},
})

--Beaver 

minetest.register_craftitem("petz:beaver_fur", {
    description = S("Beaver Fur"),
    inventory_image = "petz_beaver_fur.png",
    wield_image = "petz_beaver_fur.png"
})

minetest.register_craftitem("petz:duck", {
    description = S("Duck Feather"),
    inventory_image = "petz_duck_feather.png",
    wield_image = "petz_duck_feather.png"
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
        local itemstack_name= itemstack:get_name()
        local meta = minetest.get_meta(pos)
		local has_fish = meta:get_string("has_fish")			
        if itemstack_name == "petz:clownfish" then	
			if has_fish == "false" then
				meta:set_string("has_fish", "true")				
				minetest.add_entity({x=pos.x, y=pos.y, z=pos.z}, "petz:clownfish_entity_sprite")
				itemstack:take_item()			
				clicker:set_wielded_item(itemstack)
				return itemstack
			end
		elseif ((itemstack_name == "mobs:net") or (itemstack_name == "fireflies:bug_net")) and (has_fish == "true") then
			local inv = clicker:get_inventory()
			if inv:room_for_item("main", ItemStack("petz:clownfish")) then
				inv:add_item("main", "petz:clownfish")
				remove_fish(pos)
				meta:set_string("has_fish", "false")
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
		if has_fish == "true" then
			remove_fish(pos)
			minetest.add_entity(pos, "petz:clownfish")
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

minetest.register_entity("petz:clownfish_entity_sprite", {
	visual = "sprite",
	spritediv = {x = 1, y = 16},
	initial_sprite_basepos = {x = 0, y = 0},
	visual_size = {x=0.8, y=0.8},
	collisionbox = {0},
	physical = false,	
	textures = {"petz_clownfish_spritesheet.png"},
	groups = {fishtank = 1},
	on_activate = function(self, staticdata)
		local random_num = math.random(1)
		if random_num == 1 then
			self.textures[1] = self.textures[1] .. "^[transformFX"
		end
		self.object:set_sprite({x=0, y=0}, 16, 1.0, false)
		local pos = self.object:getpos()
		if minetest.get_node(pos).name ~= "petz:fishtank" then
			self.object:remove()
		end
	end,
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
