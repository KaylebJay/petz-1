local modpath, S = ...

--
-- Dreamcatcher (protector for Petz)
--
petz.put_dreamcatcher = function(self, clicker, wielded_item, wielded_item_name)
	if self.dreamcatcher == true then
		minetest.chat_send_player(clicker:get_player_name(), S("This pet already has a Dreamcatcher."))	
		return
	end
	wielded_item:take_item() --quit one from player's inventory
	clicker:set_wielded_item(wielded_item)
	self.dreamcatcher = true
	mobkit.remember(self, "dreamcatcher", self.dreamcatcher)
	petz.do_sound_effect("object", self.object, "petz_magical_chime")
	petz.do_particles_effect(self.object, self.object:get_pos(), "dreamcatcher")
end

petz.drop_dreamcatcher = function(self)
	if self.dreamcatcher == true then --drop the dreamcatcher
		minetest.add_item(self.object:get_pos(), "petz:dreamcatcher")
		self.dreamcatcher = false
		mobkit.remember(self, "dreamcatcher", self.dreamcatcher)
	end
end
