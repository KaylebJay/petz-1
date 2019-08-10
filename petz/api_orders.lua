local modpath, S = ...

petz.ownthing = function(self)	
	self.mov_status = mobkit.remember(self, "mov_status", "free")
	mobkit.hq_roam(self, 0)
	mobkit.clear_queue_high(self)
end

petz.stand = function(self)		
	self.object:set_velocity({ x = 0, y = 0, z = 0 })   
	self.object:set_acceleration({ x = 0, y = 0, z = 0 }) 
end

petz.standhere = function(self)	
	self.mov_status = mobkit.remember(self, "mov_status", "stand")
	mobkit.clear_queue_high(self)
	petz.stand(self)
	mobkit.lq_idle(self, 2400)		
	if self.can_fly == true then						
		if mobkit.node_name_in(self, "below") == "air" then		
			mobkit.animate(self, "fly")
		else					
			mobkit.animate(self, "stand")
		end
	end
end

petz.guard = function(self)
	self.mov_status = mobkit.remember(self, "mov_status", "guard")
	mobkit.clear_queue_high(self)
	petz.stand(self)	
end
