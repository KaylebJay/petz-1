local modpath, S = ...

--
--Poop Engine
--

petz.poop = function(self, pos)
	if not(petz.settings.poop) or not(self.tamed) or not(self.poop) or self.child == true or self.object:get_velocity().y ~= 0 or math.random(1, petz.settings.poop_rate) > 1 then
		return
	end
	local node_name_below = mobkit.node_name_in(self, "below")	
	local node_name = mobkit.node_name_in(self, "self")	
	--minetest.chat_send_player("singleplayer", node_name)	
	if node_name == "air" and node_name_below ~= "air" then		
		pos.y = pos.y - 0.75	
		minetest.set_node(pos, {name = "petz:poop"})
	end
end
