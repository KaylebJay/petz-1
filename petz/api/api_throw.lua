local modpath, S = ...

--effects can be: fire

function petz.throw(self, dtime, damage, effect, particles)
	if self.shooter_name == "" then
		if self.object:get_attach() == nil then
			self.object:remove()
		end
		return
	end
	if self.waiting_for_removal then
		self.object:remove()
		return
	end
	local pos = self.object:get_pos()
	self.old_pos = self.old_pos or pos

	local cast = minetest.raycast(self.old_pos, pos, true, false)
	local thing = cast:next()
	while thing do		
		if thing.type == "object" and thing.ref ~= self.object then			
			--minetest.chat_send_player("singleplayer", thing.type)
			local thing_ent = thing.ref:get_luaentity()			
			if not(thing.ref:is_player()) or (thing.ref:is_player() and not(thing.ref:get_player_name() == self.shooter_name)) then
				if thing.ref:is_player() then
					thing.ref:punch(thing.ref, 1.0, {full_punch_interval = 1.0, damage_groups = {fleshy=damage}}, nil)
					 petz.do_sound_effect("player", thing.ref, "petz_firecracker")
				else
					mobkit.hurt(thing_ent, damage)
					petz.do_sound_effect("object", thing.ref, "petz_firecracker")
				end				
				petz.do_particles_effect(nil, pos, "fire")
				self.waiting_for_removal = true
				self.object:remove()
				return
			end
		elseif thing.type == "node" then
			local node_pos = thing.above
			local node = minetest.get_node(node_pos)
			local node_name = node.name
			--minetest.chat_send_player("singleplayer", node.name)
			if minetest.registered_items[node_name].walkable and minetest.registered_items[node_name] ~= "air" then					
				if effect then					
					if effect == "fire" then
						local pos_above = {
							x = node_pos.x,
							y = node_pos.y +1,
							z = node_pos.z,
						}
						local node_above = minetest.get_node(pos_above)
						if minetest.get_item_group(node_name, "flammable") > 1 then
							minetest.set_node(node_pos, {name = "fire:basic_flame"})
						end
						if node_above.name == "air" then
							--if minetest.get_node(pos_above).name == "air" then
							petz.do_particles_effect(nil, pos_above, "fire")
							--end
						end	
						petz.do_sound_effect("pos", node_pos, "petz_firecracker")					
					end
				end
				self.waiting_for_removal = true
				self.object:remove()
				return
			end
		end
		thing = cast:next()
	end
	self.old_pos = pos
end

function petz.spawn_throw_object(user, strength, entity)
	local pos = user:get_pos()
	pos.y = pos.y + 1.5 -- camera offset
	local dir = user:get_look_dir()
	local yaw = user:get_look_horizontal()
	local obj = minetest.add_entity(pos, entity)
	if not obj then
		return
	end
	local user_name
	if user:is_player() then
		user_name = user:get_player_name()
	else
		user_name = user.type
	end
	obj:get_luaentity().shooter_name = user_name
	obj:set_yaw(yaw - 0.5 * math.pi)
	obj:set_velocity(vector.multiply(dir, strength))
	return true
end
