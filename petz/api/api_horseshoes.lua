local modpath, S = ...

petz.put_horseshoe = function(self, clicker)
	if self.horseshoes >= 4 then
		minetest.chat_send_player(clicker:get_player_name(), S("This pony has already four horseshoes."))
		return
	end
	local wielded_item = clicker:get_wielded_item()
	wielded_item:take_item()
	petz.horseshoes_inc_speed(self)
	petz.do_sound_effect("object", self.object, "petz_put_sound")
	petz.do_sound_effect("object", self.object, "petz_"..self.type.."_moaning")
end

petz.speedup_change = function(self, speedup)
	self.max_speed_forward = self.max_speed_forward + speedup
	self.max_speed_reverse = self.max_speed_reverse + speedup
	self.accel= self.accel + speedup
end

petz.horseshoes_speedup = function(self)
	if self.horseshoes == 0 then
		return
	end
	local speedup = self.horseshoes * petz.settings.horseshoe_speedup
	petz.speedup_change(self, speedup)
end

petz.horseshoes_inc_speed = function(self)
	local speedup
	if self.horseshoes > 0 then  --first reset old speed up
		speedup = self.horseshoes * petz.settings.horseshoe_speedup
		petz.speedup_change(self, -speedup)
	end
	self.horseshoes = mobkit.remember(self, "horseshoes", (self.horseshoes+1)) --now inc the horseshoes
	speedup = self.horseshoes * petz.settings.horseshoe_speedup --new speedup
	petz.speedup_change(self, speedup)
end

petz.horseshoes_reset = function(self)
	if self.horseshoes == 0 then
		return
	end
	local speedup = self.horseshoes * petz.settings.horseshoe_speedup
	petz.speedup_change(self, -speedup)
	local obj
	local pos = self.object:get_pos()
	for i = 1, self.horseshoes do
		obj = minetest.add_item(pos, "petz:horseshoe")
		petz.drop_velocity(obj)
	end
	self.horseshoes = mobkit.remember(self, "horseshoes", 0)
	petz.do_sound_effect("object", self.object, "petz_pop_sound")
end

