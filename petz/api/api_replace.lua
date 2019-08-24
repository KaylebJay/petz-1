local modpath, S = ...

--
--Replace Engine
--

petz.replace = function(self)
	if not self.replace_rate or not self.replace_what or self.child == true or self.object:get_velocity().y ~= 0 or math.random(1, self.replace_rate) > 1 then
		return
	end
	local pos = self.object:get_pos()
	local what, with, y_offset
	if type(self.replace_what[1]) == "table" then
		local num = math.random(#self.replace_what)
		what = self.replace_what[num][1] or ""
		with = self.replace_what[num][2] or ""
		y_offset = self.replace_what[num][3] or 0
	else
		what = self.replace_what
		with = self.replace_with or ""
		y_offset = self.replace_offset or 0
	end
	pos.y = pos.y + y_offset
	if #minetest.find_nodes_in_area(pos, pos, what) > 0 then
		local oldnode = {name = what}
		local newnode = {name = with}
		local on_replace_return
		if self.on_replace then
			on_replace_return = self:on_replace(pos, oldnode, newnode)
		end
		if on_replace_return ~= false then
			minetest.set_node(pos, {name = with})
			petz.refill(self) --Refill wool, milk or nothing
		end
	end
end
