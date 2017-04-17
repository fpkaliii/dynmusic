AddCSLuaFile("dynmusic_config.lua")
util.AddNetworkString("dynmusic")
hook.Add("Think", "dynamicMusic", function()
	for playerIndex, playerEnt in next, player.GetAll() do
		if !playerEnt:IsValid() then 
			continue 
		end

		if playerEnt.dynMusicFighting == nil then 
			playerEnt.dynMusicFighting = false 
		end

		local isFighting = false
		for entityIndex, entity in next, ents.GetAll() do
			if entity:IsNPC() and entity:IsValid() and entity:GetEnemy() == playerEnt then
				isFighting = true
			end
		end

		if isFighting != playerEnt.dynMusicFighting then
			playerEnt.dynMusicFighting = isFighting
			net.Start("dynmusic")
			net.WriteBool(playerEnt.dynMusicFighting)
			net.Send(playerEnt)
		end
	end	
end)
