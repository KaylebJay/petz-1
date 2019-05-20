--
--LAMB
--
local S = ...

local pet_name = "lamb"

local mesh = nil
local fixed = {}
local textures
local scale_lamb = 1.7
petz.lamb = {}
local collisionbox = {}

if petz.settings.type_model == "cubic" then
	local node_name = "petz:"..pet_name.."_block"
	fixed = {
		{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- back_right_leg
		{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- front_right_leg
		{0, -0.5, -0.125, 0.0625, -0.375, -0.0625}, -- front_left_leg
		{0, -0.5, 0.0625, 0.0625, -0.375, 0.125}, -- back_left_leg
		{-0.125, -0.375, -0.125, 0.0625, -0.25, 0.125}, -- body
		{-0.125, -0.3125, -0.25, 0.0625, -0.125, -0.0625}, -- head
		{-0.0625, -0.3125, 0.125, 0.0, -0.25, 0.1875}, -- tail
		{-0.1875, -0.1875, -0.1875, -0.125, -0.125, -0.125}, -- right_ear
		{0.0625, -0.1875, -0.1875, 0.125, -0.125, -0.125}, -- left_ear
	}
	petz.lamb.tiles = {
		"petz_lamb_top.png", "petz_lamb_bottom.png", "petz_lamb_right.png",
		"petz_lamb_left.png", "petz_lamb_back.png", "petz_lamb_front.png"
	}
	petz.lamb.tiles_shaved = {
		"petz_lamb_shaved_top.png", "petz_lamb_shaved_bottom.png", "petz_lamb_shaved_right.png",
		"petz_lamb_shaved_left.png", "petz_lamb_shaved_back.png", "petz_lamb_shaved_front.png"
	}
	petz.register_cubic(node_name, fixed, petz.lamb.tiles)		
	textures= {"petz:lamb_block"}
	collisionbox = {-0.35, -0.75*scale_lamb, -0.28, 0.35, -0.125, 0.28}
else
	mesh = 'petz_lamb.b3d'	
	textures = {"petz_lamb_white.png"}
	--petz.lamb.textures_shaved = {"petz_lamb_shaved_white.png"}
	collisionbox = {-0.35, -0.75*scale_lamb, -0.28, 0.35, -0.3125, 0.28}
end


minetest.register_entity("petz:lamb",{
	--Petz specifics
	petz_type = "lamb",
	is_pet = false,
	is_wild = false,
	give_orders = false,
	affinity = 100,
	init_timer = false,
	fed= false,
	brushed = false,
	beaver_oil_applied = false,
	shaved = false,
	food_count = 0,
	capture_item = "lasso",

	rotate = petz.settings.rotate,

	physical = true,
	stepheight = 0.1,				--EVIL!
	collide_with_objects = true,
	collisionbox = collisionbox,
	visual = petz.settings.visual,
	mesh = mesh,
	textures = textures,
	visual_size = {x=petz.settings.visual_size.x*scale_lamb, y=petz.settings.visual_size.y*scale_lamb},
	static_save = true,
	on_step = mobkit.stepfunc,	-- required
	on_activate = mobkit.actfunc,		-- required
	get_staticdata = mobkit.statfunc,
	-- api props
	springiness=0,
	buoyancy = 0.9,
	walk_speed = 5,
	jump_height = 1.26,
	view_range = 24,
	lung_capacity = 10, -- seconds
	max_hp = 8,
	attack={range=0.5,damage_groups={fleshy=3}},
	
	animation = {
		walk={range={x=1, y=12}, speed=25, loop=true},	
		run={range={x=13, y=25}, speed=25, loop=true},	
	},
	
	brainfunc = petz.herbivore_brain,
	
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
		self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})		
	end,
	
	on_rightclick = function(self, clicker)
		petz.on_rightclick(self, clicker)
	end,
	
 	on_replace = function(self, pos, oldnode, newnode)
		petz.lamb_wool_regrow(self)
    end,
    
    after_activate = function(self, staticdata, def, dtime)
    	if not self.custom_vars_set03 then --but do not set here! instead wait for the do-custom function to do it.
			self.custom_vars_set03 = 0
    		local color
    		if petz.settings.type_model == "mesh" then --set a random color    			
    			local random_number = math.random(1, 15)
    			if random_number == 1 then
					color = "brown"
				elseif random_number >= 2 and random_number <= 4 then
					color = "dark_grey"
				elseif random_number >= 5 and random_number <= 7 then				
					color = "grey"
				else				
					color = "white"
				end		
				self.textures_color = {"petz_lamb_"..color..".png"}
				self.textures_shaved = {"petz_lamb_shaved_"..color..".png"}
			else --if 'cubic'
				self.tiles_color = petz.lamb.tiles
				self.tiles_shaved = petz.lamb.tiles_shaved
				color = "white" --cubic lamb color is always white
			end
			self.wool_color = color							    			    	
		end 		
    	if self.shaved then
    		self.object:set_properties({textures = self.textures_shaved})
    	else
    		self.object:set_properties({textures = self.textures_color})
    	end
    end,
})
