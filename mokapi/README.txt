---
DROP FUNCTIONS
---
- mokapi.drop_item(self, item, num)
Mob drops only one item.

- mokapi.drop_items(self, killed_by_player)
Mob drops a table list of items defined in the entity.
Example of the 'drops' definition:
	drops = {
		{name = "petz:mini_lamb_chop", chance = 1, min = 1, max = 1,},
		{name = "petz:bone", chance = 5, min = 1, max = 1,},
	},

- mokapi.node_drop_items(pos)
Node drops the "drops" list saved in the node metadata.

---
SOUND FUNCTIONS
---
- mokapi.make_misc_sound(self, chance, max_hear_distance)
Make a random sound from the "misc" sound definition.
The misc definition can be a single sound or a table of sounds.
Example of the 'misc' definition:
	sounds = {
		misc = {"petz_kitty_meow", "petz_kitty_meow2", "petz_kitty_meow3"},
	},

- mokapi.make_sound(dest_type, dest, soundfile, max_hear_distance)
Make a sound on dest accordingly dest_type.
dest_type can be "object, "player" or "pos".

---
REPLACE FUNCTION
---
- mokapi.replace(self, sound_name, max_hear_distance)
Replace a node to another. Useful for eating grass.
Example of the 'replace_what' definition:
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
    },
3 parameters: replace_what, replace_with and y_offset

