--
--calf
--
local S = ...

local pet_name = "calf"

local mesh = nil
local fixed = {}
local textures
local scale_calf = 3.0
petz.calf = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.125, -0.0625, -0.375, 0.1875}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.125, 0.0625, -0.375, 0.1875}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.1875, 0.1875}, -- body
		{-0.125, -0.25, -0.1875, 0.0625, -0.0625001, 0.0}, -- head
		{-0.0625, -0.3125, 0.1875, 0.0, -0.1875, 0.25}, -- tail
		{0.0625, -0.125, -0.125, 0.125, 0.0, -0.0625}, -- left_horn
		{-0.1875, -0.125, -0.125, -0.125, 0.0, -0.0625}, -- right_horn
	}
	petz.calf.tiles = {
		"petz_calf_top.png", "petz_calf_bottom.png", "petz_calf_right.png",
		"petz_calf_left.png", "petz_calf_back.png", "petz_calf_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.calf.tiles)			
	collisionbox = {-0.5, -0.75*scale_calf, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_calf.b3d'	
	textures= {{"petz_calf.png"}, {"petz_calf2.png"}, {"petz_calf3.png"}}
	collisionbox = {-0.5, -0.75*scale_calf, -0.5, 0.375, -0.375, 0.375}
end


mobs:register_mob("petz:"..pet_name, {
	type = "animal",
	rotate = petz.settings.rotate,
	damage = 8,
    hp_min = 4,
    hp_max = 8,
    armor = 200,
	visual = petz.settings.visual,
	visual_size = {x=petz.settings.visual_size.x*scale_calf, y=petz.settings.visual_size.y*scale_calf},
	mesh = mesh,
	textures = textures,
	collisionbox = collisionbox,
	makes_footstep_sound = false,
	walk_velocity = 0.75,
    run_velocity = 1,    
    runaway = true,
    pushable = true,
    floats = 1,
	jump = true,
	follow = petz.settings.calf_follow,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1,},		
		{name = "mobs:leather", chance = 2, min = 1, max = 1,},	
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
    sounds = {
		random = "petz_calf_moo",
	},
    animation = {
    	speed_normal = 15, walk_start = 1, walk_end = 12,
    	speed_run = 25, run_start = 13, run_end = 25,
    	stand_start = 26, stand_end = 46,		
    	stand2_start = 47, stand2_end = 59,	
    	stand4_start = 82, stand4_end = 94,	
	},
    view_range = 4,
    fear_height = 3,
    replace_rate = 10,
    replace_what = {
        {"group:grass", "air", -1},
        {"default:dirt_with_grass", "default:dirt", -2}
    },
    on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end, 	
	do_custom = function(self, dtime)
		if not self.custom_vars_set03 then
			self.custom_vars_set03 = 0
			self.petz_type = "calf"
			self.is_pet = false
			self.is_wild = false
			self.give_orders = false
			self.affinity = 100
			self.init_timer = false
			self.fed= false
			self.brushed = false
			self.beaver_oil_applied = false			
			self.food_count = 0
			self.milked = false
		end	
	end,
})

mobs:register_egg("petz:calf", S("Calf"), "petz_spawnegg_calf.png", 0)

mobs:spawn({
	name = "petz:calf",
	nodes = {"default:dirt_with_grass"},
	--neighbors = {"group:grass"},
	min_light = 14,
	interval = 90,
	chance = petz.settings.calf_spawn_chance,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})

petz.calf_milk_refill = function(self)
	self.food_count = (self.food_count or 0) + 1        
	if self.food_count >= 5 then -- if calf replaces 5x grass then it refill milk
		self.food_count = 0
		self.milked= false
	end
end

petz.calf_milk_milk = function(self, clicker)
    clicker:set_wielded_item("petz:bucket_milk")
    petz.do_sound_effect("object", self.object, "petz_calf_moaning")
	self.milked = true           
end
