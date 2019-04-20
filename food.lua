local modpath, S = ...

--Duck Egg

minetest.register_craftitem("petz:duck_egg", {
    description = S("Duck Egg"),
    inventory_image = "petz_duck_egg.png",
    wield_image = "petz_duck_egg.png",
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
