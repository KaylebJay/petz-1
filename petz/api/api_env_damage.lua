local modpath, S = ...

petz.env_damage = function(self)
	local stand_pos= mobkit.get_stand_pos(self)
	local stand_node_pos = mobkit.get_node_pos(stand_pos)
	local stand_node = mobkit.nodeatpos(stand_node_pos)
	if stand_node and stand_node.groups.igniter then --if lava or fire
		mobkit.hurt(self, petz.settings.igniter_damage)
	end
end
