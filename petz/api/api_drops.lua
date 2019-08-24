local modpath, S = ...

petz.drop_items = function(self)	
	if not self.drops or #self.drops == 0 then 	-- check for nil or no drops
		return
	end	
	if self.child then -- no drops for child mobs
		return
	end	
	local death_by_player = self.was_killed_by_player or nil -- was mob killed by player?
	local obj, item, num
	local pos = self.object:get_pos()
	for n = 1, #self.drops do
		if math.random(1, self.drops[n].chance) == 1 then
			num = math.random(self.drops[n].min or 0, self.drops[n].max or 1)
			item = self.drops[n].name
			if death_by_player then	-- only drop rare items (drops.min=0) if killed by player
				obj = minetest.add_item(pos, ItemStack(item .. " " .. num))
			elseif self.drops[n].min ~= 0 then
				obj = minetest.add_item(pos, ItemStack(item .. " " .. num))
			end
			if obj and obj:get_luaentity() then
				obj:set_velocity({
					x = math.random(-10, 10) / 9,
					y = 6,
					z = math.random(-10, 10) / 9,
				})
			elseif obj then
				obj:remove() -- item does not exist
			end
		end
	end
	self.drops = {}
end
