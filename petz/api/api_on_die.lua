local modpath, S = ...

--
--on_die event for all the mobs
--

petz.on_die = function(self)
	--Specific of each mob-->
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
		 --Drop horseshoes-->
		if self.horseshoes and self.horseshoes > 0 then
			mokapi.drop_item(self, "petz:horseshoe", self.horseshoes)
		end
	elseif self.type == "puppy" then
		if self.square_ball_attached == true and self.attached_squared_ball then
			self.attached_squared_ball.object:set_detach()
		end
	end
	--Make it not pointable-->
	self.object:set_properties({
		pointable = false,
	})
	--Check if Dreamctacher to drop it-->
	petz.drop_dreamcatcher(self)
	--Flying mobs fall down-->
	if self.can_fly then
		self.can_fly = false
	end
	--For all the mobs-->
    local props = self.object:get_properties()
    props.collisionbox[2] = props.collisionbox[1] - 0.0625
    self.object:set_properties({collisionbox=props.collisionbox})
    --Drop Items-->
	mokapi.drop_items(self, self.was_killed_by_player or nil)
	mobkit.clear_queue_high(self)
	--Remove the owner entry for right_click formspec-->
	if petz.pet[self.owner] then
		petz.pet[self.owner]= nil
	end
	--Remove this petz from the list of the player pets-->
	if self.tamed == true then
		petz.remove_tamed_by_owner(self, false)
	end
	--Make Sound-->
	mobkit.make_sound(self, 'die')
	--To finish, the Mobkit Die Function-->
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
