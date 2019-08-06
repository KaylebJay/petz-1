--
--TROPICAL FISH
--
local S = ...

local pet_name = "tropicalfish"
local mesh = nil
local scale_tropicalfish = 1.0
local textures = {}
local collisionbox = {}
local fixed = {}
local tiles = {}
local spawn_nodes = {"default:coral_brown"}
local animation_aquatic = {
    speed_normal = 15, walk_start = 1, walk_end = 13, --swin
    speed_run = 25, run_start = 1, run_end = 13,
    stand_start = 13, stand_end = 25,		
}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.5, -0.3125, 0.125, -0.3125, 0.0625}, -- body
		{0, -0.4375, 0.0625, 0.0625, -0.375, 0.1875}, -- font_tail_fin
		{0, -0.375, 0.125, 0.0625, -0.3125, 0.25}, -- top_tail_fin
		{0, -0.5, 0.125, 0.0625, -0.4375, 0.25}, -- bottom_tail_fin
		{0.125, -0.5, -0.125, 0.1875, -0.375, -0.0625}, -- fin_left
		{0.1875, -0.4375, -0.125, 0.25, -0.375, -0.0625}, -- fin_top_left
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- fin_right
		{-0.1875, -0.4375, -0.125, -0.125, -0.375, -0.0625}, -- fin_right_top
		{0, -0.3125, -0.25, 0.0625, -0.25, 0}, -- dorsal_fin
	}
	tiles = {
		"petz_tropicalfish_top.png",
		"petz_tropicalfish_bottom.png",
		"petz_tropicalfish_right.png",
		"petz_tropicalfish_left.png",
		"petz_tropicalfish_back.png",
		"petz_tropicalfish_front.png"
	}
	petz.register_cubic(node_name, fixed, tiles)		
	textures= {"petz:tropicalfish_block"}
	collisionbox = {-0.35, -0.75*scale_tropicalfish, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_tropicalfish.b3d'	
	textures= {{"petz_tropicalfish.png"}, {"petz_tropicalfish2.png"}, {"petz_tropicalfish3.png"}}
	collisionbox = {-0.35, -0.75*scale_tropicalfish, -0.28, 0.35, -0.5, 0.28}
end

mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_tropicalfish, y=petz.settings.visual_size.y*scale_tropicalfish},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	physical = true,
	collide_with_objects = true,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1.0,    
    runaway = true,
    pushable = true,
    fly = true,
    fly_in = "default:water_source",
    floats = 1,
	jump = false,
	follow = petz.settings.tropicalfish_follow,
	drops = {
		{name = "default:coral_brown", chance = 5, min = 1, max = 1,},
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		--random = "petz_tropicalfish_croak",
	},
    animation = animation_aquatic,
    view_range = 4,
    fear_height = 3,
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	do_custom = function(self, dtime)
		if not self.custom_vars_set00 then
			self.custom_vars_set00 = 0
			self.petz_type = "tropicalfish"
			self.groups = {fish= 1, fishtank = 1}
			self.is_pet = true
			self.is_wild = false
			self.is_mammal = false
			self.has_affinity = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.can_be_brushed = false
			self.brushed = false			
			self.animation = animation_aquatic
			self.capture_item = "net"
		end
		petz.aquatic_behaviour(self)		
	end,
})

minetest.register_entity("petz:tropicalfish_entity_sprite", {
	visual = "sprite",
	spritediv = {x = 1, y = 16},
	initial_sprite_basepos = {x = 0, y = 0},
	visual_size = {x=0.8, y=0.8},
	collisionbox = {0},
	physical = false,	
	textures = {"petz_tropicalfish_spritesheet.png"},
	groups = {fishtank = 1},
	on_activate = function(self, staticdata)
		local pos = self.object:getpos()
		if minetest.get_node(pos).name ~= "petz:fishtank" then
			self.object:remove()
		end
	end,
})

local fish_itemstack = mobs:register_egg("petz:tropicalfish", S("Tropical Fish"), "petz_spawnegg_tropicalfish.png", 0)

mobs:spawn({
	name = "petz:tropicalfish",
	nodes = spawn_nodes,
	--neighbors = {"default:sand", "default:dirt", "group:seaplants"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.tropicalfish_spawn_chance,
	min_height = -8,
	max_height = 200,
	day_toggle = true,
})
