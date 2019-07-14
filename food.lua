local modpath, S = ...

--Ducky/Chicken Eggs

minetest.register_craftitem("petz:ducky_egg", {
    description = S("Ducky Egg"),
    inventory_image = "petz_ducky_egg.png",
    wield_image = "petz_ducky_egg.png",
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

minetest.register_craftitem("petz:roasted_chicken", {
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

--Piggy Porkchop
minetest.register_craftitem("petz:raw_porkchop", {
    description = S("Raw Porkchop"),
    inventory_image = "petz_raw_porkchop.png",
    wield_image = "petz_raw_porkchop.png"
})

minetest.register_craftitem("petz:roasted_porkchop", {
	description = S("Roasted Porkchop"),
	inventory_image = "petz_roasted_porkchop.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:roasted_porkchop",
	recipe = "petz:raw_porkchop",
	cooktime = 3,
})

--Lamb Chop
minetest.register_craftitem("petz:mini_lamb_chop", {
    description = S("Mini Lamb Chop"),
    inventory_image = "petz_mini_lamb_chop.png",
    wield_image = "petz_mini_lamb_chop.png"
})

minetest.register_craftitem("petz:roasted_lamb_chop", {
	description = S("Roasted Lamb Chop"),
	inventory_image = "petz_roasted_lamb_chop.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:roasted_lamb_chop",
	recipe = "petz:mini_lamb_chop",
	cooktime = 3,
})

--Beef
minetest.register_craftitem("petz:beef", {
    description = S("Beef"),
    inventory_image = "petz_beef.png",
    wield_image = "petz_beef.png"
})

minetest.register_craftitem("petz:steak", {
	description = S("Beef Steak"),
	inventory_image = "petz_steak.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:steak",
	recipe = "petz:beef",
	cooktime = 2,
})

--Ducky
minetest.register_craftitem("petz:raw_ducky", {
    description = S("Raw Ducky"),
    inventory_image = "petz_raw_ducky.png",
    wield_image = "petz_raw_ducky.png"
})

minetest.register_craftitem("petz:roasted_ducky", {
	description = S("Roasted Ducky"),
	inventory_image = "petz_roasted_ducky.png",	
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "petz:roasted_ducky",
	recipe = "petz:raw_ducky",
	cooktime = 2,
})
