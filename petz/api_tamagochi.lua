local modpath, S = ...

--
--The Tamagochi Mode
--

-- Increase/Descrease the pet affinity

petz.set_affinity = function(self, increase, amount)
    local new_affinity    
    if increase == true then
        new_affinity = self.affinity +  amount
    else
        new_affinity = self.affinity - amount
    end
    if new_affinity > 100 then
        new_affinity = 100
    elseif new_affinity < 0 then     
        new_affinity = 0
    end
    self.affinity = new_affinity
    mobkit.remember(self, "affinity", self.affinity)
end

--The Tamagochi Timer

petz.init_tamagochi_timer = function(self)	
    if (petz.settings.tamagochi_mode == true) and (self.tamed == true) and (self.init_tamagochi_timer == true) then
        petz.timer(self)
        return true
    else
        return false
    end
end

--
--Tamagochi Mode Timer
--

petz.timer = function(self)
    minetest.after(petz.settings.tamagochi_check_time, function(self)         
        if not(self.object== nil) then
			if (not(minetest.is_singleplayer())) and (petz.settings.tamagochi_check_if_player_online == true) then
				if minetest.player_exists(self.owner) == false then --if pet owner is not online
					return
				end
			end       
            local pos = self.object:get_pos()
            if not(pos == nil) then --important for if the pet dies
                local pos_below = {
                    x = pos.x,
                    y = pos.y - 1.5,
                    z = pos.z,
                }
                local node = minetest.get_node_or_nil(pos_below)
                --minetest.chat_send_player(self.owner, petz.settings.tamagochi_safe_node)
                for i = 1, #petz.settings.tamagochi_safe_nodes do --loop  thru all safe nodes
                    if node and (node.name == petz.settings.tamagochi_safe_nodes[i]) then
						self.init_tamagochi_timer = true
						mobkit.remember(self, "init_tamagochi_timer", self.init_tamagochi_timer)    
                        return
                    end    
                end                
            else  --if the pos is nil, it means that the pet died before 'minetest.after_effect'
                self.init_tamagochi_timer = false
                mobkit.remember(self, "init_tamagochi_timer", self.init_tamagochi_timer)   --so no more timer
                return
            end
            --Decrease affinitty always a bit amount because the pet lost some affinitty	
            if self.has_affinity == true then
				petz.set_affinity(self, false, 10)
			end
            --Decrease health if pet has not fed
            if self.fed == false then				
				local damage_amount = - petz.settings.tamagochi_hunger_damage
				mobkit.hurt(self, damage_amount)
				petz.update_nametag(self)
                if (self.hp > 0)  and (self.has_affinity == true) then
					petz.set_affinity(self, false, 33)
				end                
            else
                self.fed = false
                mobkit.remember(self, "fed", self.fed) --Reset the variable
            end
            --If the pet has not brushed            
            if self.can_be_brushed == true then				
				if self.brushed == false then
					if self.has_affinity == true then
						petz.set_affinity(self, false, 20)
					end
				else
					self.brushed = false
					mobkit.remember(self, "brushed", self.brushed) --Reset the variable
				end
			end
            --If the petz is a lion had to been lashed
            if self.type== "lion" then				
                if self.lashed == false then
                    petz.set_affinity(self, false, 25)                
                else
                    self.lashed = false
                    mobkit.remember(self, "lashed", self.lashed)
                end
            end            
            --If the pet starves to death            
            if self.hp <= 0 then
                minetest.chat_send_player(self.owner, S("Your").. " "..self.type.." "..S("has starved to death!!!"))
                self.init_tamagochi_timer  = false -- no more timing
            --I the pet get bored of you
            elseif (self.has_affinity == true) and (self.affinity == 0) then
                minetest.chat_send_player(self.owner, S("Your").." "..self.type.." "..S("has abandoned you!!!"))
                petz.delete_nametag(self)
				petz.remove_owner(self) --the pet abandon you               
                petz.drop_dreamcatcher(self)
                self.init_tamagochi_timer  = false -- no more timing				
            --Else reinit the timer, to check again in the future
            else
                self.init_tamagochi_timer  = true
            end
        end
    end, self)
    self.init_tamagochi_timer = false --the timer is reinited in the minetest.after function
end
