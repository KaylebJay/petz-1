local modpath, S = ...

petz.armor_destroy = function(name, player)
	local pos = player:getpos()
	if pos then
		minetest.sound_play({
			name = "brewing_break_armor_sound",
			pos = pos,
			gain = 0.5,
		})
	end
end

--Define the Silk Clothes
armor:register_armor("petz:prince_crown", {
	description = S("Prince Crown"),
	inventory_image = "petz_prince_crown_inv.png",
	texture = "petz_prince_crown.png",
	preview = "petz_prince_crown_preview.png",
	groups = {armor_head=1, armor_use=500, flammable=0},
	armor_groups = {fleshy=10, radiation=10},
	damage_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1},
	reciprocate_damage = true,
	on_destroy = function(player, index, stack)
		petz.armor_destroy("brewing_break_armor_sound", player)
	end,
})

armor:register_armor("petz:silk_dress_coat", {
	description = S("Silk Dress Coat"),
	inventory_image = "petz_silk_dress_coat_inv.png",
	texture = "petz_silk_dress_coat.png",
	preview = "petz_silk_dress_coat_preview.png",
	groups = {armor_torso=1, armor_use=500, flammable=0},
	armor_groups = {fleshy=10, radiation=10},
	damage_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1},
	reciprocate_damage = true,
	on_destroy = function(player, index, stack)
		petz.armor_destroy("brewing_break_armor_sound", player)	
	end,
})

armor:register_armor("petz:silk_pants", {
	description = S("Silk Pants"),
	inventory_image = "petz_silk_pants_inv.png",
	texture = "petz_silk_pants.png",
	preview = "petz_silk_pants_preview.png",
	groups = {armor_legs=1, armor_use=500, flammable=0},
	armor_groups = {fleshy=10, radiation=10},
	damage_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1},
	reciprocate_damage = true,
	on_destroy = function(player, index, stack)
		petz.armor_destroy("brewing_break_armor_sound", player)
	end,
})

armor:register_armor("petz:silk_boots", {
	description = S("Silk Boots"),
	inventory_image = "petz_silk_boots_inv.png",
	texture = "petz_silk_boots.png",
	preview = "petz_silk_boots_preview.png",
	groups = {armor_feet=1, armor_use=500, flammable=0},
	armor_groups = {fleshy=10, radiation=10},
	damage_groups = {cracky=3, snappy=3, choppy=3, crumbly=3, level=1},
	reciprocate_damage = true,
	on_destroy = function(player, index, stack)
		petz.armor_destroy("brewing_break_armor_sound", player)
	end,
})

--
--Define Silk Armor crafting recipe
--

minetest.register_craft({
	output = "petz:prince_crown",
	type = "shaped",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"petz:silk_bobbin", "petz:silk_bobbin", "petz:silk_bobbin"},
	},
})
minetest.register_craft({
	output = "petz:silk_dress_coat",
	type = "shaped",
	recipe = {
		{"petz:silk_bobbin", "dye:red", "petz:silk_bobbin"},
		{"petz:silk_bobbin", "petz:silk_bobbin", "petz:silk_bobbin"},
		{"petz:silk_bobbin", "petz:silk_bobbin", "petz:silk_bobbin"},
	},
})
minetest.register_craft({
	output = "petz:silk_pants",
	type = "shaped",
	recipe = {
		{"petz:silk_bobbin", "default:gold_ingot", "petz:silk_bobbin"},
		{"petz:silk_bobbin", "dye:brown", "petz:silk_bobbin"},
		{"petz:silk_bobbin", "", "petz:silk_bobbin"},
	},
})
minetest.register_craft({	
	output = "petz:silk_boots",
	type = "shaped",
	recipe = {
		{"petz:silk_bobbin", "", "petz:silk_bobbin"},
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"petz:silk_bobbin", "dye:brown", "petz:silk_bobbin"},		
	},
})
