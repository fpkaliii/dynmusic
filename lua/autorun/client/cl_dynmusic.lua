include("dynmusic_config.lua")
dynamicMusic["darknessValue"] = 0.0003
dynamicMusic["enabledCvar"] = CreateClientConVar("dynamicmusic_enabled", 1)
dynamicMusic["volumeCvar"] = CreateClientConVar("dynamicmusic_volume", 100)
local me = LocalPlayer()
local darkChannel = nil
local lightChannel = nil
local fightChannel = nil
local darkFinished = true
local lightFinished = true
local fightFinished = true
local inFight = false
local darkHasStarted = false
local lightHasStarted = false
local fightHasStarted = false
local darkEnterTime = 0
local darkZones = {}
local darkType = 1
local fadeTime = engine.TickInterval() / 1.75
hook.Add("Tick", "dynamicMusic", function()
	if !me or !IsValid(me) then 
		me = LocalPlayer()
		return 
	end

	if !dynamicMusic.enabledCvar:GetBool() then
		if darkChannel then
			darkChannel:SetVolume(0)
			darkChannel:Stop()
			darkChannel = nil
		darkHasStarted = false
			darkFinished = false
		end

		if lightChannel then
			lightChannel:SetVolume(0)
			lightChannel:Stop()
			lightChannel = nil
			lightHasStarted = false
			lightFinished = false
		end

		if fightChannel then
			fightChannel:SetVolume(0)
			fightChannel:Stop()
			fightChannel = nil
			fightFinished = false
		end

		return
	end

	local darkness = 2.5
	if darkType == 1 then
		if me:GetMoveType() != MOVETYPE_NOCLIP then
			local traceData = {
				start = me:GetPos() + me:OBBCenter(),
				endpos = me:GetPos() - Vector(0, 0, 32768),
				filter = {me},
				mask = MASK_SOLID
			}

			local trace = util.TraceLine(traceData)
			darkness = render.ComputeLighting(trace.HitPos, trace.HitNormal):Length2D()
		end
	elseif darkType == 2 then
		for i = 1, #darkZones do
			local min = darkZones[i][1]
			local max = darkZones[i][2]
			local stuff = ents.FindInBox(min, max)
			if #stuff >= 1 then
				for _i = 1, #stuff do
					local ent = stuff[_i]
					if ent == me then
						darkness = 0
					end
				end
			end
		end
	end

	if inFight then
		if lightChannel and lightChannel != NULL then
			fightFinished = false
			if 0.05 >= lightChannel:GetVolume() then
				lightChannel:SetVolume(0)
				lightChannel:Pause()
			else
				lightChannel:SetVolume(Lerp(fadeTime, lightChannel:GetVolume(), 0.01))
			end
		end

		if darkChannel and darkChannel != NULL then
			fightFinished = false
			if 0.05 >= darkChannel:GetVolume() then
				darkChannel:SetVolume(0)
				if (CurTime() - darkEnterTime) >= dynamicMusic.darkResetTime then
					darkChannel:SetTime(0)
					darkChannel:Pause()
				else
					darkChannel:Pause()
				end
			else
				darkChannel:SetVolume(Lerp(fadeTime, darkChannel:GetVolume(), 0.01))
			end
		end

		if (!fightChannel or fightChannel == NULL) and !fightHasStarted then
			fightHasStarted = true
			sound.PlayURL(table.Random(dynamicMusic.fightMusic), "noblock", function(channel, errid, err)
				if errid or err then 
					print("fight music error", err) 
					ErrorNoHalt("BAD OR INVALID MUSIC LINK (FIGHT)") 
					hook.Remove("Tick", "dynamicMusic") 
					return 
				end

				fightFinished = true
				fightChannel = channel
				fightChannel:EnableLooping(false)
				fightChannel:SetVolume(Lerp(fadeTime, fightChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			end)
		elseif fightChannel and fightChannel != NULL then
			fightChannel:SetVolume(Lerp(fadeTime, fightChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			fightChannel:Play()
			fightFinished = true
			if fightChannel:GetTime() >= (fightChannel:GetLength() - 1) then
				fightChannel = NULL
				fightFinished = false
				fightHasStarted = false
			end
		end
	end

	if dynamicMusic.darknessValue >= darkness and lightFinished and fightFinished and !inFight then
		darkEnterTime = CurTime()
		if lightChannel then
			darkFinished = false
			if 0.05 >= lightChannel:GetVolume() then
				lightChannel:SetVolume(0)
				lightChannel:Pause()
			else
				lightChannel:SetVolume(Lerp(fadeTime, lightChannel:GetVolume(), 0.01))
			end
		end

		if fightChannel then
			darkFinished = false
			if 0.05 >= fightChannel:GetVolume() then
				fightChannel:SetVolume(0)
				fightChannel:SetTime(0)
				fightChannel:Pause()
			else
				fightChannel:SetVolume(Lerp(fadeTime, fightChannel:GetVolume(), 0.01))
			end
		end

		if (!darkChannel or darkChannel == NULL) and !darkHasStarted then
			darkHasStarted = true
			sound.PlayURL(table.Random(dynamicMusic.darkMusic), "noblock", function(channel, errid, err)
				if errid or err then 
					print("dark music error", err) 
					ErrorNoHalt("BAD OR INVALID MUSIC LINK (DARK)") 
					hook.Remove("Tick", "dynamicMusic") 
					return 
				end

				darkFinished = true
				darkChannel = channel
				darkChannel:EnableLooping(false)
				darkChannel:SetVolume(Lerp(fadeTime, darkChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			end)
		elseif darkChannel and darkChannel != NULL then
			darkChannel:SetVolume(Lerp(fadeTime, darkChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			darkChannel:Play()
			darkFinished = true
			if darkChannel:GetTime() >= (darkChannel:GetLength() - 1) then
				darkChannel = NULL
				darkFinished = false
				darkHasStarted = false
			end
		end
	elseif darkness >= dynamicMusic.darknessValue and darkFinished and fightFinished and !inFight then
		if darkChannel then
			lightFinished = false
			if 0.05 >= darkChannel:GetVolume() then
				darkChannel:SetVolume(0)
				if (CurTime() - darkEnterTime) >= dynamicMusic.darkResetTime then
					darkChannel:SetTime(0)
					darkChannel:Pause()
				else
					darkChannel:Pause()
				end
			else
				darkChannel:SetVolume(Lerp(fadeTime, darkChannel:GetVolume(), 0.01))
			end
		end

		if fightChannel then
			lightFinished = false
			if 0.05 >= fightChannel:GetVolume() then
				fightChannel:SetVolume(0)
				fightChannel:SetTime(0)
				fightChannel:Pause()
			else
				fightChannel:SetVolume(Lerp(fadeTime, fightChannel:GetVolume(), 0.01))
			end
		end

		if (!lightChannel or lightChannel == NULL) and !lightHasStarted then
			lightHasStarted = true
			sound.PlayURL(table.Random(dynamicMusic.ambientMusic), "noblock", function(channel, errid, err)
				if errid or err then 
					print("ambient music error", err) 
					ErrorNoHalt("BAD OR INVALID MUSIC LINK (AMBIENT)") 
					hook.Remove("Tick", "dynamicMusic") 
					return 
				end

				lightFinished = true
				lightChannel = channel
				lightChannel:EnableLooping(false)
				lightChannel:SetVolume(Lerp(fadeTime, lightChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			end)
		elseif lightChannel and lightChannel != NULL then
			lightChannel:SetVolume(Lerp(fadeTime, lightChannel:GetVolume(), dynamicMusic.volumeCvar:GetInt() / 100))
			lightChannel:Play()
			lightFinished = true
			if lightChannel:GetTime() >= (lightChannel:GetLength() - 1) then
				lightChannel = NULL
				lightFinished = false
				lightHasStarted = false
			end
		end
	end
end)

net.Receive("dynmusic", function()
	inFight = net.ReadBool()
end)
