local modpath, S = ...

petz.on_step = function(self, dtime)
	if self.init_tamagochi_timer == true then
		petz.init_tamagochi_timer(self)
	end
	if self.is_pregnant == true then
		petz.pregnant_timer(self, dtime)
	end
end
