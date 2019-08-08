local modpath, S = ...

--
--on_die event for all the mobs
--

petz.on_die = function(self)	
	--Specific of each mob
	if self.is_mountable == true then
		if self.saddle then -- drop saddle when petz is killed while riding
			minetest.add_item(self.object:get_pos(), "petz:saddle")
		end
		if self.saddlebag then -- drop saddlebag
			minetest.add_item(self.object:get_pos(), "petz:saddlebag")
		end
		-- Drop the items from petz inventory
		local inv = minetest.get_inventory({ type="detached", name="saddlebag_inventory" })
		inv:set_list("saddlebag", {})
		if self.saddlebag_inventory then
			for key, value in pairs(self.saddlebag_inventory) do
				inv:set_stack("saddlebag", key, value)
			end						
			for i = 1, inv:get_size("saddlebag") do
				local stack = inv:get_stack("saddlebag", i)
				if stack:get_count() > 0 then
					minetest.item_drop(stack, self.object, self.object:get_pos())
				end
			end
		end				
	elseif self.type == "puppy" then
		if self.square_ball_attached == true and self.attached_squared_ball then
			self.attached_squared_ball.object:set_detach()
		end
	end
	petz.drop_dreamcatcher(self)
	if self.can_fly then
		self.can_fly = false
	end
	--For all the mobs
    local props = self.object:get_properties()
    props.collisionbox[2] = props.collisionbox[1]
	petz.set_properties(self, {collisionbox=props.collisionbox})
	petz.drop_items(self)
	mobkit.clear_queue_high(self)
	if petz.pet[self.owner] then
		petz.pet[self.owner]= nil --remove owner entry for right_click formspec
	end
	if self.tamed == true then
		petz.remove_petz_list_by_owner(self) --remove this petz from the list of the player pets
	end
	mobkit.hq_die(self)
end

petz.was_killed_by_player = function(self, puncher)	
	if self.hp <= 0 then
		if puncher:is_player() then
			return true
		else
			return false
		end
	else
		return false
	end
end
