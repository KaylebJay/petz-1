local modpath, S = ...

petz.on_step = function(self, dtime)
	if self.init_tamagochi_timer == true then
		petz.init_tamagochi_timer(self)
	end
	if self.is_pregnant == true then
		petz.pregnant_timer(self, dtime)
	elseif self.is_baby == true then
		petz.growth_timer(self, dtime)
	end
	if self.gallop == true then
		petz.gallop(self, dtime)
	end
	if self.dreamcatcher then
		petz.dreamcatcher_save_metadata(self)
	end
end
