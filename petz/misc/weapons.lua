local modpath, S = ...

minetest.register_node("petz:jack_o_lantern_grenade", {
	description = S("Jack-o'-lantern Grenade").. " ("..S("use to throw")..")",	
	tiles = {"petz_jackolantern_grenade_top.png", "petz_jackolantern_grenade_bottom.png",
		"petz_jackolantern_grenade_right.png", "petz_jackolantern_grenade_left.png",
		"petz_jackolantern_grenade_back.png", "petz_jackolantern_grenade_front.png"},
	visual_scale = 0.35,
	is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		local strength = 20	
		petz.do_sound_effect("player", user, "petz_fireball")
		if not petz.spawn_throw_object(user, strength, "petz:ent_jack_o_lantern_grenade") then
			return -- something failed
		end	
		itemstack:take_item()			
		return itemstack
	end,	
})

minetest.register_entity("petz:ent_jack_o_lantern_grenade", {
	hp_max = 4,       -- possible to catch the arrow (pro skills)
	physical = false, -- use Raycast
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	visual = "wielditem",
	textures = {"petz:jack_o_lantern_grenade"},	
	visual_size = {x = 1.0, y = 1.0},
	old_pos = nil,
	shooter_name = "",
	parent_entity = nil,
	waiting_for_removal = false,

	on_activate = function(self)
		self.object:set_acceleration({x = 0, y = -9.81, z = 0})
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		return false
	end,
		
	on_step = function(self, dtime)		
		petz.throw(self, dtime, petz.settings.pumpkin_grenade_damage, "fire", nil)
	end,
})


minetest.register_craft({
	type = "shapeless",
	output = "petz:jack_o_lantern_grenade",
	recipe = {"petz:jack_o_lantern", "tnt:gunpowder", "farming:string"},
})
