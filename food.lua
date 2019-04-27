local modpath, S = ...

--Duck/Chicken Eggs

minetest.register_craftitem("petz:duck_egg", {
    description = S("Duck Egg"),
    inventory_image = "petz_duck_egg.png",
    wield_image = "petz_duck_egg.png",
    on_use = minetest.item_eat(2),
    groups = {flammable = 2, food = 2},
})

minetest.register_craftitem("petz:chicken_egg", {
    description = S("Chicken Egg"),
    inventory_image = "petz_chicken_egg.png",
    wield_image = "petz_chicken_egg.png",
    on_use = minetest.item_eat(2),
    groups = {flammable = 2, food = 2},
})

--Frog Leg and Roasted Frog Leg
minetest.register_craftitem("petz:frog_leg", {
    description = S("Frog Leg"),
    inventory_image = "petz_frog_leg.png",
    wield_image = "petz_frog_leg.png"
})

minetest.register_craftitem("petz:frog_leg_roasted", {
	description = S("Roasted Frog Leg"),
	inventory_image = "petz_frog_leg_roasted.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:frog_leg_roasted",
	recipe = "petz:frog_leg",
	cooktime = 2,
})

--Parrot Food
minetest.register_craftitem("petz:raw_parrot", {
    description = S("Raw Parrot"),
    inventory_image = "petz_raw_parrot.png",
    wield_image = "petz_raw_parrot.png"
})

minetest.register_craftitem("petz:roasted_parrot", {
	description = S("Roasted Parrot"),
	inventory_image = "petz_roasted_parrot.png",	
	on_use = minetest.item_eat(2),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:roasted_parrot",
	recipe = "petz:raw_parrot",
	cooktime = 2,
})

--Chicken Food
minetest.register_craftitem("petz:raw_chicken", {
    description = S("Raw Chicken"),
    inventory_image = "petz_raw_chicken.png",
    wield_image = "petz_raw_chicken.png"
})

minetest.register_craftitem("petz:roasted_chickent", {
	description = S("Roasted Chicken"),
	inventory_image = "petz_roasted_chicken.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:roasted_chicken",
	recipe = "petz:raw_chicken",
	cooktime = 2,
})
