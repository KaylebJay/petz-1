-- spawning is too specific to be included in the api, this is an example.
-- a modder will want to refer to specific names according to games/mods they're using 
-- in order for mobs not to spawn on treetops, certain biomes etc.

local abr = minetest.get_mapgen_setting('active_block_range')
local spawn_rate = 0.8	 

local function spawnstep(dtime)

	for _,plyr in ipairs(minetest.get_connected_players()) do
		if math.random()<dtime*0.2 then	-- each player gets a spawn chance every 5s on average
			local vel = plyr:get_player_velocity()
			local spd = vector.length(vel)
			local chance = spawn_rate * 1/(spd*0.75+1)  -- chance is quadrupled for speed=4

			local yaw
			if spd > 1 then
				-- spawn in the front arc
				yaw = plyr:get_look_horizontal() + math.random()*0.35 - 0.75
			else
				-- random yaw
				yaw = math.random()*math.pi*2 - math.pi
			end
			local pos = plyr:get_pos()
			local dir = vector.multiply(minetest.yaw_to_dir(yaw),abr*16)
			local pos2 = vector.add(pos,dir)
			pos2.y=pos2.y-5
			local height, liquidflag = mobkit.get_terrain_height(pos2,32)
	
			if height and height >= 0 and not liquidflag -- and math.abs(height-pos2.y) <= 30 testin
			and mobkit.nodeatpos({x=pos2.x,y=height-0.01,z=pos2.z}).is_ground_content then

				local objs = minetest.get_objects_inside_radius(pos,abr*16+5)
				local wcnt=0
				local dcnt=0
				for _,obj in ipairs(objs) do				-- count mobs in abrange
					if not obj:is_player() then
						local name = obj:get_luaentity().name
						if name:find('petz:') then
							chance=chance + (1-chance)*0.4	-- chance reduced for every mob in range
							if name == 'petz:lamb' then wcnt=wcnt+1
							elseif name=='petz:lamb' then dcnt=dcnt+1 end
						end
					end
				end
--minetest.chat_send_all('chance '.. chance)
				if chance < math.random() then

					-- if no wolves and at least one deer spawn wolf, else deer
--					local mobname = (wcnt==0 and dcnt > 0) and 'wildlife:wolf' or 'wildlife:deer'
					local mobname = dcnt>wcnt+1 and 'petz:lamb' or 'petz:lamb'

					pos2.y = height+0.5
					objs = minetest.get_objects_inside_radius(pos2,abr*16-2)
					for _,obj in ipairs(objs) do				-- do not spawn if another player around
						if obj:is_player() then return end
					end
--minetest.chat_send_all('spawnin '.. mobname)
					minetest.add_entity(pos2,mobname)			-- ok spawn it already damnit
				end
			end
		end
	end
end


minetest.register_globalstep(spawnstep)
