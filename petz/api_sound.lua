local modpath, S = ...

--
--Sound System
--

petz.random_mob_sound = function(self)
	local random_number = math.random(1, petz.settings.misc_sound_chance)
	if random_number == 1 then
		if self.sounds and self.sounds['misc'] then 
			petz.mob_sound(self, self.sounds['misc'], 1.0, 10)
		end
	end
end

-- play sound
petz.mob_sound = function(self, sound, _gain, _max_hear_distance)
	if sound then
		minetest.sound_play(sound, {object = self.object, gain = _gain, max_hear_distance = _max_hear_distance})
	end
end

petz.do_sound_effect = function(dest, dest_name, soundfile)
    minetest.sound_play(soundfile, {dest = dest_name, gain = 0.4, max_hear_distance = 10,})
end

petz.set_properties = function(self, properties)
	self.object:set_properties(properties) 			
end
