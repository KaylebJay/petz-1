local modpath, S = ...

petz.wolf_to_puppy= function(self, player_name)
	self.wolf_to_puppy_count = self.wolf_to_puppy_count - 1	
	mobkit.remember(self, "wolf_to_puppy_count", self.wolf_to_puppy_count)
	if self.wolf_to_puppy_count <= 0 then
		local pos = self.object:get_pos()
		local puppy = minetest.add_entity(pos, "petz:puppy")
		local puppy_entity = puppy:get_luaentity()
		puppy_entity.tamed = true
		mobkit.remember(puppy_entity, "tamed", puppy_entity.tamed)
		puppy_entity.owner = player_name 
		mobkit.remember(puppy_entity, "owner", puppy_entity.owner)
		self.object:remove()	
		minetest.chat_send_player(player_name , S("The wolf turn into puppy."))
	end	
end
