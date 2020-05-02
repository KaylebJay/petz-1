local modpath, S = ...

minetest.register_tool("petz:shepherd_crock", {
    description = S("Shepherd's Crook"),
    inventory_image = "petz_shepherd_crook.png",
    liquids_pointable = false,
    tool_capabilities = {
        max_drop_level=3,
        groupcaps= {
            crumbly={times={[1]=4.00, [2]=1.50, [3]=1.00}, uses=70, maxlevel=1}
        }
    },
    damage_groups = {fleshy=1},
})

minetest.register_craft({
    type = "shaped",
    output = 'petz:shepherd_crock',
    recipe = {
        {'', 'group:wood', 'petz:whistle'},
        {'', 'group:wood', ''},
        {'', 'group:wood', ''},
    }
})
