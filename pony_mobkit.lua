--
--PONY
--
local S = ...

local pet_name = "pony"
table.insert(petz.mobs_list, pet_name)
local mesh = nil
local textures = {}
local textures_baby = {}
local fixed = {}
local scale_model = 2.2
local visual_size = {x=petz.settings.visual_size.x*scale_model, y=petz.settings.visual_size.y*scale_model}
local scale_baby = 0.5
local visual_size_baby = {x=petz.settings.visual_size.x*scale_model*scale_baby, y=petz.settings.visual_size.y*scale_model*scale_baby}
petz.pony = {}
local collisionbox = {}
local collisionbox_baby = {-0.5*scale_baby, -0.75*scale_model*scale_baby, -0.25, 0.375, -0.375, 0.375}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.0625, -0.0625, -0.375, 0.125, 0.125, -0.0625}, -- head
		{0.0625, -0.5, -0.1875, 0.125, -0.3125, -0.125}, -- front_left_leg
		{-0.0625, -0.3125, -0.1875, 0.125, -0.125, 0.25}, -- body
		{-0.0625, -0.125, -0.1875, 0.125, -0.0625, -0.0625}, -- neck
		{-0.0625, -0.5, -0.1875, -1.49012e-08, -0.3125, -0.125}, -- front_right_leg
		{0.0625, -0.5, 0.1875, 0.125, -0.3125, 0.25}, -- back_left_leg
		{-0.0625, 0.125, -0.125, 5.58794e-09, 0.25, -0.0625}, -- right_ear
		{0.0625, 0.125, -0.125, 0.125, 0.25, -0.0625}, -- left_ear
		{-0.0625, -0.5, 0.1875, 0, -0.3125, 0.25}, -- back_right_leg
		{0, -0.1875, 0.25, 0.0625, -0.125, 0.3125}, -- top_tail
		{0, -0.25, 0.3125, 0.0625, -0.1875, 0.375}, -- middle_tail
		{0, 0.125, -0.125, 0.0625, 0.1875, -0.0625}, -- mane_top
		{0, -0.125, -0.0625, 0.0625, 0.125, -6.14673e-08}, -- mane_bottom
		{0, -0.3125, 0.3125, 0.0625, -0.25, 0.375}, -- bottom_tail
	}
	petz.pony.tiles = {
		"petz_pony_top.png", "petz_pony_bottom.png", "petz_pony_right.png",
		"petz_pony_left.png", "petz_pony_back.png", "petz_pony_front.png"
	}
	petz.pony.tiles_saddle = {
		"petz_pony_top_saddle.png", "petz_pony_bottom.png", "petz_pony_right_saddle.png",
		"petz_pony_left_saddle.png", "petz_pony_back.png", "petz_pony_front.png"
	}	
	petz.register_cubic(node_name, fixed, petz.pony.tiles)			
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
else
	mesh = 'petz_pony.b3d'	
	textures = {"petz_pony_white.png"}	
	textures_baby = {"petz_pony_baby.png"}	
	collisionbox = {-0.5, -0.75*scale_model, -0.5, 0.375, -0.375, 0.375}
end

minetest.register_entity("petz:"..pet_name, {          
	--Petz specifics	
	type = pet_name,	
	init_timer = true,	
	is_pet = true,
	has_affinity = true,
	is_wild = false,
	give_orders = true,
	can_be_brushed = true,
	capture_item = "lasso",
	--Pony specific
	terrain_type = 3,
	scale_model = scale_model,
	scale_baby =scale_baby,
	driver_scale = {x = 1/visual_size.x, y = 1/visual_size.y},			
	driver_attach_at = {x = -0.0325, y = -0.125, z = -0.2},
	driver_eye_offset = {x = 0, y = 0, z = 0},	
	pregnant_count = 5,
	--predator = "wolf",
	follow = petz.settings.pony_follow,
	rotate = petz.settings.rotate,
	physical = true,
	stepheight = 0.1,	--EVIL!
	collide_with_objects = true,
	collisionbox = collisionbox,
	collisionbox_baby = collisionbox_baby,
	visual = petz.settings.visual,
	mesh = mesh,
	textures = textures,
	visual_size = visual_size,
	visual_size_baby = visual_size_baby,
	static_save = true,
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness= 0,
	buoyancy = 0.5, -- portion of hitbox submerged
	max_speed = 2,
	jump_height = 2.0,
	view_range = 10,
	lung_capacity = 10, -- seconds
	max_hp = 108,
	makes_footstep_sound = false,
		
	attack={range=0.5, damage_groups={fleshy=3}},	
	
	animation = {
		walk={range={x=1, y=12}, speed=20, loop=true},	
		run={range={x=13, y=25}, speed=20, loop=true},	
		stand={
			{range={x=26, y=46}, speed=5, loop=true},
			{range={x=47, y=59}, speed=5, loop=true},
			{range={x=82, y=94}, speed=5, loop=true},		
		},	
	},
	sounds = {
		misc = "petz_pony_neigh",
		moaning = "petz_pony_moaning",
	},
	
	brainfunc = petz.herbivore_brain,
	
	on_activate = function(self, staticdata, dtime_s) --on_activate, required
		mobkit.actfunc(self, staticdata, dtime_s)
		petz.set_herbibore(self, staticdata, dtime_s)
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)	
		if not(self.driver) then
			petz.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
		else
			petz.force_detach(self.driver)
		end
	end,
	
	on_rightclick = function(self, clicker)
		if self.tamed and self.owner == clicker:get_player_name() then    			
			if self.driver and clicker == self.driver then -- detatch player already riding horse
				petz.detach(clicker, {x = 1, y = 0, z = 1})
				mobkit.clear_queue_low(self)
			elseif self.saddle and clicker:get_wielded_item():get_name() == "petz:shears" then
				minetest.add_item(self.object:get_pos(), "petz:saddle")
				if petz.settings.type_model == "mesh" then
					petz.set_properties(self, {textures = {"petz_pony_"..self.skin_color..".png"}})
				else
					self.object:set_properties({tiles = petz.pony.tiles})
				end 
				self.saddle = false	
				mobkit.remember(self, "saddle", self.saddle)					
			elseif not self.driver and not self.saddle and not(self.is_baby) and clicker:get_wielded_item():get_name() == "petz:saddle" then -- Put on saddle if tamed
				local w = clicker:get_wielded_item() -- Put on saddle and take saddle from player's inventory
				if petz.settings.type_model == "mesh" then
					petz.set_properties(self, {textures =
						{"petz_pony_"..self.skin_color..".png" .. "^petz_pony_saddle.png"}
					})									
				else
					self.object:set_properties({tiles = petz.pony.tiles_saddle})
				end 
				self.saddle = true    
				mobkit.remember(self, "saddle", self.saddle)	
				if not minetest.settings:get_bool("creative_mode") then
					w:take_item()
					clicker:set_wielded_item(w)
				end
			elseif not self.driver and self.saddle then -- Mount horse	
				petz.set_properties(self, {stepheight = 1.1})					
				petz.attach(self, clicker)				
			else
				petz.on_rightclick(self, clicker)
			end
		else
			petz.on_rightclick(self, clicker)
		end		
	end, 
	
	on_step = function(self, dtime)	
		petz.init_timer(self)
		if self.driver then
			petz.drive(self, "walk", "stand", false, dtime) -- if driver present allow control of horse		
		else
			mobkit.stepfunc(self, dtime) -- required
		end	
	end,
})

petz:register_egg("petz:pony", S("Pony"), "petz_spawnegg_pony.png", 0)
