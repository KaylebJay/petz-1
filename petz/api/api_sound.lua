local modpath, S = ...

--
--Sound System
--

petz.random_mob_sound = function(self)
	if self.muted == true then
		return
	end
	local random_number = math.random(1, petz.settings.misc_sound_chance)
	if random_number == 1 then
		if self.sounds and self.sounds['misc'] then
			local misc_sound
			if (type(self.sounds['misc']) == "table") then
				misc_sound = self.sounds['misc'][math.random(1, #self.sounds['misc'])]
			else
				misc_sound = self.sounds['misc']
			end
			petz.do_sound_effect("object", self.object, misc_sound)
		end
	end
end

petz.do_sound_effect = function(dest_type, dest, soundfile)
	if dest_type == "object" then
		minetest.sound_play(soundfile, {object = dest, gain = 0.5, max_hear_distance = petz.settings.max_hear_distance,})
	 elseif dest_type == "player" then
		local player_name = dest:get_player_name()
		minetest.sound_play(soundfile, {to_player = player_name, gain = 0.5, max_hear_distance = petz.settings.max_hear_distance,})
	 elseif dest_type == "pos" then
		minetest.sound_play(soundfile, {pos = dest, gain = 0.5, max_hear_distance = petz.settings.max_hear_distance,})
	end
end
