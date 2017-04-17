AddCSLuaFile("dynmusic_config.lua")
include("dynmusic_config.lua")
util.AddNetworkString("dynmusic")
if dynamicMusic["fightPerformance"] then
	dynamicMusic["targetTable"] = {}
	hook.Add("EntityTakeDamage", "dynamicMusic", function(target, damageInfo)
		if target:IsPlayer() and damageInfo:GetAttacker():IsValid() and damageInfo:GetAttacker():IsNPC() then
			dynamicMusic["targetTable"][target] = dynamicMusic["targetTable"][target] or {}
			dynamicMusic["targetTable"][target][damageInfo:GetAttacker()] = true
		end
	end)

	function dynamicMusic.updateFightStatus(target, status)
		net.Start("dynmusic")
		net.WriteBool(status)
		net.Send(target)
	end

	hook.Add("Think", "dynamicMusic", function()
		for target, attackerTable in next, dynamicMusic.targetTable do
			if table.Count(attackerTable) >= 1 then
				for attacker, attacking in next, attackerTable do
					if !attacker:IsValid() or !attacker:GetEnemy() or attacker:GetEnemy() != target then
						dynamicMusic.targetTable[target][attacker] = nil
						continue
					end

					if !target.dynMusicFighting then
						target.dynMusicFighting = true
						dynamicMusic.updateFightStatus(target, target.dynMusicFighting)
					end
				end
			elseif target.dynMusicFighting then
				target.dynMusicFighting = false
				dynamicMusic.updateFightStatus(target, target.dynMusicFighting)
			end
		end
	end)
else
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
end
