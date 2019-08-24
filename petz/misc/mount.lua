local modpath, S = ...

local enable_crash = false
local crash_threshold = 6.5 -- ignored if enable_crash=false
------------------------------------------------------------------------------
--
-- Helper functions
--

petz.fallback_node = minetest.registered_aliases["mapgen_dirt"] or "default:dirt"

local node_ok = function(pos, fallback)
	fallback = fallback or petz.fallback_node
	local node = minetest.get_node_or_nil(pos)
	if node and minetest.registered_nodes[node.name] then
		return node
	end
	return {name = fallback}
end

local function node_is(pos)
	local node = node_ok(pos)
	if node.name == "air" then
		return "air"
	end
	if minetest.get_item_group(node.name, "lava") ~= 0 then
		return "lava"
	end
	if minetest.get_item_group(node.name, "liquid") ~= 0 then
		return "liquid"
	end
	if minetest.registered_nodes[node.name].walkable == true then
		return "walkable"
	end
	return "other"
end

local function get_sign(i)
	i = i or 0
	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end

local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end


local function get_v(v)
	return math.sqrt(v.x * v.x + v.z * v.z)
end

petz.force_detach = function(player)
	local attached_to = player:get_attach()
	if not attached_to then
		return
	end
	local entity = attached_to:get_luaentity()
	if entity.driver and entity.driver == player then
		entity.driver = nil
	end
	player:set_detach()
	default.player_attached[player:get_player_name()] = false
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	default.player_set_animation(player, "stand" , 30)
	player:set_properties({visual_size = {x = 1, y = 1}, pointable = true })	
end

-------------------------------------------------------------------------------
minetest.register_on_leaveplayer(function(player)
	petz.force_detach(player)
end)

minetest.register_on_shutdown(function()
	local players = minetest.get_connected_players()
	for i = 1, #players do
		petz.force_detach(players[i])
	end
end)

minetest.register_on_dieplayer(function(player)
	petz.force_detach(player)
	return true
end)

-------------------------------------------------------------------------------

function petz.attach(entity, player)
	local attach_at, eye_offset = {}, {}
	entity.player_rotation = entity.player_rotation or {x = 0, y = 0, z = 0}
	entity.driver_attach_at = entity.driver_attach_at or {x = 0, y = 0, z = 0}
	entity.driver_eye_offset = entity.driver_eye_offset or {x = 0, y = 0, z = 0}
	entity.driver_scale = entity.driver_scale or {x = 1, y = 1}
	local rot_view = 0
	if entity.player_rotation.y == 90 then
		rot_view = math.pi/2
	end
	attach_at = entity.driver_attach_at
	eye_offset = entity.driver_eye_offset
	entity.driver = player	
	petz.force_detach(player)
	player:set_attach(entity.object, "", attach_at, entity.player_rotation)
	default.player_attached[player:get_player_name()] = true
	player:set_eye_offset(eye_offset, {x = 0, y = 0, z = 0})
	player:set_properties({
		visual_size = {
			x = entity.driver_scale.x,
			y = entity.driver_scale.y
		},
		pointable = false
	})
	minetest.after(0.2, function()
		default.player_set_animation(player, "sit" , 30)
	end)
	player:set_look_horizontal(entity.object:get_yaw() - rot_view)
end

function petz.detach(player, offset)
	petz.force_detach(player)
	default.player_set_animation(player, "stand" , 30)
	local pos = player:get_pos()
	pos = {x = pos.x + offset.x, y = pos.y + 0.2 + offset.y, z = pos.z + offset.z}
	minetest.after(0.1, function()
		player:set_pos(pos)
	end)
end


function petz.drive(entity, moving_anim, stand_anim, can_fly, dtime)
	local rot_steer, rot_view = math.pi/2, 0
	if entity.player_rotation.y == 90 then
		rot_steer, rot_view = 0, math.pi/2
	end
	local acce_y = 0
	local velo = entity.object:get_velocity()
	entity.v = get_v(velo) * get_sign(entity.v)
	-- process controls
	if entity.driver then
		--print ("---velo", get_v(velo))
		local ctrl = entity.driver:get_player_control()
		-- move forwards
		if ctrl.up then
			entity.v = entity.v + entity.accel / 10
		-- move backwards
		elseif ctrl.down then
			if entity.max_speed_reverse == 0 and entity.v == 0 then
				return
			end
			entity.v = entity.v - entity.accel / 10
		end
		-- fix mob rotation
		local horz = entity.driver:get_look_horizontal() or 0
		entity.object:set_yaw(horz - entity.rotate)
		-- jump
		if ctrl.jump then
			if velo.y == 0 then
				velo.y = velo.y + entity.jump_height
				acce_y = acce_y + (acce_y * 3) + 1
			end
		end
	end
	-- if not moving then set animation and return
	if entity.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		mobkit.animate(entity, stand_anim)								
		return
	end
	-- set moving animation
	if moving_anim then
		mobkit.animate(entity, moving_anim)				
	end
	-- Stop!
	local s = get_sign(entity.v)
	entity.v = entity.v - 0.02 * s
	if s ~= get_sign(entity.v) then
		entity.object:set_velocity({x = 0, y = 0, z = 0})
		entity.v = 0
		return
	end
	-- enforce speed limit forward and reverse
	local max_spd = entity.max_speed_reverse

	if get_sign(entity.v) >= 0 then
		max_spd = entity.max_speed_forward
	end
	if math.abs(entity.v) > max_spd then
		entity.v = entity.v - get_sign(entity.v)
	end
	-- Set position, velocity and acceleration
	local p = entity.object:get_pos()
	local new_velo = {x = 0, y = 0, z = 0}
	local new_acce = {x = 0, y = -9.8, z = 0}
	p.y = p.y - 0.5
	local ni = node_is(p)
	local v = entity.v
	if ni == "air" then
		if can_fly == true then
			new_acce.y = 0
		end
	elseif ni == "liquid" or ni == "lava" then
		if ni == "lava" and entity.lava_damage ~= 0 then
			entity.lava_counter = (entity.lava_counter or 0) + dtime
			if entity.lava_counter > 1 then
				minetest.sound_play("default_punch", {
					object = entity.object,
					max_hear_distance = 5
				})

				entity.object:punch(entity.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = entity.lava_damage}
				}, nil)

				entity.lava_counter = 0
			end
		end
		if entity.terrain_type == 2
		or entity.terrain_type == 3 then
			new_acce.y = 0
			p.y = p.y + 1
			if node_is(p) == "liquid" then
				if velo.y >= 5 then
					velo.y = 5
				elseif velo.y < 0 then
					new_acce.y = 20
				else
					new_acce.y = 5
				end
			else
				if math.abs(velo.y) < 1 then
					local pos = entity.object:get_pos()
					pos.y = math.floor(pos.y) + 0.5
					entity.object:set_pos(pos)
					velo.y = 0
				end
			end
		else
			v = v * 0.25
		end
	end
	new_velo = get_velocity(v, entity.object:get_yaw() - rot_view, velo.y)
	new_acce.y = new_acce.y + acce_y
	entity.object:set_velocity(new_velo)
	entity.object:set_acceleration(new_acce)
	-- CRASH!
	if enable_crash then
		local intensity = entity.v2 - v
		if intensity >= crash_threshold then
		--print("----------- crash", intensity)
			entity.object:punch(entity.object, 1.0, {
				full_punch_interval = 1.0,
				damage_groups = {fleshy = intensity}
			}, nil)
		end
	end
	entity.v2 = v
end
