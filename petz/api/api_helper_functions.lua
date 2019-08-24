local modpath, S = ...

--
--Helper Functions
--

function petz.to_boolean(val)
	if val and (val == "true" or val == 1) then
		return true
	else
		return false
	end	
end

function petz.is_night()
	local timeofday = minetest.get_timeofday() * 24000
	if (timeofday < 4500) or (timeofday > 19500) then
		return true
	else
		return false
	end 
end

function petz.round(x, n)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function petz.set_list(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

petz.pos_front_player = function(player)
	local pos = player:get_pos()
	local yaw = player:get_look_horizontal()
	local dir_x = -math.sin(yaw) + 0.5
	local dir_z = math.cos(yaw) + 0.5	
	local pos_front_player = {	-- what is in front of mob?
		x = pos.x + dir_x,
		y = pos.y + 0.5,
		z = pos.z + dir_z
	}
	return pos_front_player
end
