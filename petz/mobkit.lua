local modpath, S = ...

function mobkit.lq_dumbfly(self, dest, speed_factor)
	local timer = 3			-- failsafe
	speed_factor = speed_factor or 1
	local func=function(self)
		mobkit.animate(self, 'fly')
		timer = timer - self.dtime
		if timer < 0 then return true end
		
		local pos = mobkit.get_stand_pos(self)
		local y = self.object:get_velocity().y

		if not(self.isonground) then
			mobkit.animate(self, 'fly')
			local dir = vector.normalize(vector.direction({x=pos.x,y=0,z=pos.z},
														{x=dest.x,y=0,z=dest.z}))
			dir = vector.multiply(dir,self.max_speed*speed_factor)
--			self.object:set_yaw(minetest.dir_to_yaw(dir))
			mobkit.turn2yaw(self,minetest.dir_to_yaw(dir))
			dir.y = y
			self.object:set_velocity(dir)
		end
	end
	mobkit.queue_low(self,func)
end


function mobkit.dumbfly(self, tpos, speed_factor)	
	mobkit.lq_turn2pos(self, tpos) 
	mobkit.lq_dumbfly(self, tpos, speed_factor)
	mobkit.lq_idle(self, math.random(1,6))
end

function mobkit.hq_wander_fly(self, prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) and not(self.isonground) then
			local pos = mobkit.get_stand_pos(self)
			local neighbor = math.random(8)
			local height, tpos, liquidflag = mobkit.is_neighbor_node_reachable(self, neighbor)
			if not liquidflag then
				mobkit.dumbfly(self, tpos, 0.3)
			end
		else

		end		
	end
	mobkit.queue_high(self,func,prty)
end
