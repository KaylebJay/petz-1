local abs = math.abs
local pi = math.pi
local floor = math.floor
local random = math.random
local sqrt = math.sqrt
local max = math.max
local min = math.min
local pow = math.pow

local function execute_queues(self)
	--Execute hqueue
	if #self.hqueue > 0 then
		local func = self.hqueue[1].func
		if func(self) then
			table.remove(self.hqueue,1)
			self.lqueue = {}
		end
	end
	-- Execute lqueue
	if #self.lqueue > 0 then
		local func = self.lqueue[1]
		if func(self) then
			table.remove(self.lqueue,1)
		end
	end
end

function petz.stepfunc(self,dtime)	-- not intended to be modified
	self.dtime = dtime
	self.height = mobkit.get_box_height(self)
--  physics comes first
--	self.object:set_acceleration({x=0,y=mobkit.gravity,z=0})
	local vel = self.object:get_velocity()
	
--	if self.lastvelocity.y == vel.y then
	if math.abs(self.lastvelocity.y-vel.y)<0.001 then
		self.isonground = true
	else
		self.isonground = false
	end
	
	-- dumb friction
	if self.isonground and not self.isinliquid and not(self.can_fly) then  --added by petz	
		self.object:set_velocity({x= vel.x> 0.2 and vel.x*mobkit.friction or 0,
								y=vel.y,
								z=vel.z > 0.2 and vel.z*mobkit.friction or 0})
	end
	
-- bounciness
	if self.springiness and self.springiness > 0 then
		local vnew = vector.new(vel)
		
		if not self.collided then						-- ugly workaround for inconsistent collisions
			for _,k in ipairs({'y','z','x'}) do			
				if vel[k]==0 and math.abs(self.lastvelocity[k])> 0.1 then 
					vnew[k]=-self.lastvelocity[k]*self.springiness 
				end
			end
		end
		
		if not vector.equals(vel,vnew) then
			self.collided = true
		else
			if self.collided then
				vnew = vector.new(self.lastvelocity)
			end
			self.collided = false
		end
		
		self.object:set_velocity(vnew)
	end
	
	-- buoyancy
	local spos = mobkit.get_stand_pos(self)
	spos.y = spos.y+0.01
	-- get surface height
--	local surface = mobkit.get_node_pos(spos).y+0.5
	local surface = nil
	local snodepos = mobkit.get_node_pos(spos)
	local surfnode = mobkit.nodeatpos(spos)
	if self.type and mobkit.is_alive(self) and not(self.is_baby) then -- self.type is for identify petz entities only --added by petz
		local stand_pos = spos --added by petz
		stand_pos.y = spos.y + 0.5 --added by petz
		local stand_node_pos = mobkit.get_node_pos(stand_pos) --added by petz
		local stand_node = mobkit.nodeatpos(stand_node_pos) --added by petz
		if stand_node and stand_node.walkable and stand_node.drawtype == "normal" then -- if standing inside solid block then jump to escape --added by petz
			local new_y = stand_pos.y + self.jump_height --added by petz
			if new_y <= 30927 then --added by petz
				self.object:set_pos({ --added by petz
					x = stand_pos.x, --added by petz
					y = new_y, --added by petz
					z = stand_pos.z --added by petz
				}) --added by petz
			end --added by petz
		end --added by petz
	end --added by petz	
	while surfnode and surfnode.drawtype == 'liquid' do
		surface = snodepos.y+0.5
		if surface > spos.y+self.height then break end
		snodepos.y = snodepos.y+1
		surfnode = mobkit.nodeatpos(snodepos)
	end
	if surface then				-- standing in liquid
		self.isinliquid = true
		local submergence = min(surface-spos.y,self.height)
		local balance = self.buoyancy*self.height
		local buoyacc = mobkit.gravity*((balance - submergence)^2/balance^2*sign(balance - submergence))
		self.object:set_acceleration({x=-vel.x*self.water_drag,y=buoyacc-vel.y*math.abs(vel.y)*0.7,z=-vel.z*self.water_drag})
	else
		self.isinliquid = false
		if not(self.can_fly) then  --added by petz
			self.object:set_acceleration({x=0,y=mobkit.gravity,z=0}) --added by petz
		end  --added by petz
	end
	
	
	
	-- local footnode = mobkit.nodeatpos(spos)
	-- local headnode
	-- if footnode and footnode.drawtype == 'liquid' then
		
		-- vel = self.object:get_velocity()
		-- headnode = mobkit.nodeatpos(mobkit.pos_shift(spos,{y=self.height or 0}))	-- TODO: height may be nil
		-- local submergence = headnode.drawtype=='liquid' 
			-- and	self.buoyancy-1
			-- or (self.buoyancy*self.height-(1-(spos.y+0.5)%1))^2/(self.buoyancy*self.height)^2*sign(self.buoyancy*self.height-(1-(spos.y+0.5)%1))

		-- local buoyacc = submergence * mobkit.gravity
		-- self.object:set_acceleration({x=-vel.x,y=buoyacc-vel.y*abs(vel.y)*0.5,z=-vel.z})

	-- end

	if self.brainfunc then
		-- vitals: fall damage
		vel = self.object:get_velocity()
		local velocity_delta = math.abs(self.lastvelocity.y - vel.y)
		if velocity_delta > mobkit.safe_velocity then
			self.hp = self.hp - math.floor((self.max_hp-100) * min(1, velocity_delta/mobkit.terminal_velocity))
		end
		
		-- vitals: oxygen
		if self.lung_capacity then
			local colbox = self.object:get_properties().collisionbox
			local headnode = mobkit.nodeatpos(mobkit.pos_shift(self.object:get_pos(),{y=colbox[5]})) -- node at hitbox top
			if headnode and headnode.drawtype == 'liquid' then 
				self.oxygen = self.oxygen - self.dtime
			else
				self.oxygen = self.lung_capacity
			end
				
			if self.oxygen <= 0 then self.hp=0 end	-- drown
		end

		
		if self.view_range then self:sensefunc() end
		self:brainfunc()
		execute_queues(self)
	end
	
	self.lastvelocity = self.object:get_velocity()
	self.time_total=self.time_total+self.dtime
end
