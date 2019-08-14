local modpath, S = ...

petz.init_convert_to_chrysalis = function(self)
	minetest.after(math.random(1200, 1500), function(self) 
		if not(mobkit.is_alive(self)) then 
			return
		end
		local pos = self.object:get_pos()
		if minetest.get_node(pos) and minetest.get_node(pos).name ~= "air" then
			return
		end
		minetest.set_node(pos, {name= "petz:cocoon"})
		self.object:remove()
	end, self)
end

petz.init_lay_eggs = function(self)
	minetest.after(math.random(150, 240), function(self) 
		if not(mobkit.is_alive(self)) then 
			return
		end
		if self.eggs_count > 0 then
			return
		end
		petz.alight(self)
		minetest.after(10.0, function(self)
			if not(mobkit.is_alive(self)) then 
				return
			end
			local pos = self.object:get_pos()
			--minetest.chat_send_player("singleplayer", "go")	
			if minetest.get_node(pos) and minetest.get_node(pos).name ~= "air" then
				return
			end
			local node_name = mobkit.node_name_in(self, "below")
			--minetest.chat_send_player("singleplayer", "node name=".. node_name)	
			local spawn_egg = false
			--minetest.chat_send_player("singleplayer", string.sub(petz.settings.silkworn_lay_egg_on_node, 1, 5))	
			if string.sub(petz.settings.silkworn_lay_egg_on_node, 1, 5) == "group" then				
				--minetest.chat_send_player("singleplayer", string.sub(petz.settings.silkworn_lay_egg_on_node, 7))					
				local node_group = minetest.get_item_group(node_name, string.sub(petz.settings.silkworn_lay_egg_on_node, 7)) 
				if node_group > 0 then
					spawn_egg = true
				end
			else								
				if node_name == petz.settings.silkworn_lay_egg_on_node then
					spawn_egg = true
				end											
			end
			if spawn_egg == true then
				minetest.set_node(pos, {name= "petz:silkworn_egg"})
				self.eggs_count = mobkit.remember(self, "eggs_count", (self.eggs_count+1)) --increase the count of eggs			
			end
			petz.init_lay_eggs(self) --reinit the timer
			petz.ownthing(self)
		end, self)
    end, self)
end
