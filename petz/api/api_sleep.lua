local modpath, S = ...

petz.sleep = function(self, prty)	
	--minetest.chat_send_player("singleplayer", "ana")	
	if ((self.sleep_at_night and petz.is_night()) or (self.sleep_at_day and not(petz.is_night()))) then
		--minetest.chat_send_player("singleplayer", "lucas")			
		local timeofday = minetest.get_timeofday() * 24000
		--minetest.chat_send_player("singleplayer", tostring(timeofday))	
		--minetest.chat_send_player("singleplayer", "time of day="..tostring(timeofday).."/sleep_start_time="..tostring(self.sleep_start_time).."/sleep_end_time="..tostring(self.sleep_end_time))	
		if (self.status ~= "sleep") and (timeofday > self.sleep_start_time) and (timeofday < self.sleep_end_time) then	
			--minetest.chat_send_player("singleplayer", "prueba")	
			self.status = mobkit.remember(self, "status", "sleep")	
			mobkit.animate(self, 'sleep')
			mobkit.hq_sleep(self, prty)
		end		
	end
end

function mobkit.hq_sleep(self, prty)
	local timer = 2 --check each 2 seconds
	local func=function(self)	
		timer = timer - self.dtime
		local timeofday = minetest.get_timeofday() * 24000
		if (self.status == "sleep") and timer < 0 --check if status did not change
			and (self.sleep_at_night and not(petz.is_night())) or (self.sleep_at_day and petz.is_night())
			or (timeofday < self.sleep_start_time) or (timeofday > self.sleep_end_time) then			
				mobkit.clear_queue_high(self) --awake
				self.status = mobkit.remember(self, "status", "")
				return true
		end
		if timer < 0 then
			timer = 2
		end
	end
	mobkit.queue_high(self,func,prty)
end
