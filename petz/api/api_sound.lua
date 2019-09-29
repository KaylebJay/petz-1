local modpath, S = ...

--
--Sound System
--

petz.random_mob_sound = function(self)
	local random_number = math.random(1, petz.settings.misc_sound_chance)
	if random_number == 1 then
		if self.sounds and self.sounds['misc'] then 
			petz.do_sound_effect("object", self.object, self.sounds['misc'])
		end
	end
end

petz.do_sound_effect = function(dest, dest_object, soundfile)
    minetest.sound_play(soundfile, {object = dest_object, gain = 0.5, max_hear_distance = petz.settings.max_hear_distance,})
end

petz.set_properties = function(self, properties)
	self.object:set_properties(properties) 			
end
