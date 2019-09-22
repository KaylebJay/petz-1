local modpath, S = ...

--
--Helper Functions
--
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

petz.first_to_upper = function(str)
    return (str:gsub("^%l", string.upper))
end

petz.str_is_empty = function(str)
	return str == nil or str == ''
end
