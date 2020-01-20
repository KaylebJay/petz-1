local modpath, S = ...

--Bonemeal support

if minetest.get_modpath("bonemeal") ~= nil then	
	minetest.register_craft({
		type = "shapeless",
		output = "bonemeal:bonemeal",
		recipe = {"petz:bone"},
	})
end

minetest.register_craft({
	output = "bonemeal:gelatin_powder 4",
	recipe = {
			{"petz:bone", "petz:bone", "petz:bone"},
			{"bucket:bucket_water", "bucket:bucket_water", "bucket:bucket_water"},
			{"bucket:bucket_water", "default:torch", "bucket:bucket_water"},
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty 5"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "petz:bone 2",
	recipe = {"bonemeal:bone"},
})
