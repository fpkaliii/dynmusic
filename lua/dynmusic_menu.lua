if SERVER then
	// do stuff
else
	surface.CreateFont("Trebuchet20", {
		font = "Trebuchet",
		size = 20,
		weight = 650
	})

	if dynamicMusic.menu and dynamicMusic.menu.frame then
		dynamicMusic.menu.frame:Remove()
	end

	dynamicMusic.menu = {}
	dynamicMusic.menu.isReady = false
	dynamicMusic.menu.isOpen = false
	dynamicMusic.menu.frame = nil
	function dynamicMusic.menu.open()
		if dynamicMusic.menu["isOpen"] or dynamicMusic.menu.frame then
			dynamicMusic.menu.frame:Remove()
			dynamicMusic.menu.frame = nil
			dynamicMusic.menu.isOpen = false
			return
		end

		dynamicMusic.menu.isReady = false
		dynamicMusic.menu.isOpen = true
		dynamicMusic.menu.frame = vgui.Create("DFrame")
		dynamicMusic.menu.frame:ShowCloseButton(false)
		dynamicMusic.menu.frame:SetDraggable(false)
		dynamicMusic.menu.frame:SetSize(24, 24)
		dynamicMusic.menu.frame:SetText("")
		dynamicMusic.menu.frame:SetTitle("")
		dynamicMusic.menu.frame:MakePopup()
		dynamicMusic.menu.frame:Center()
		dynamicMusic.menu.frame.Paint = function(self, width, height)
			// background
			surface.SetDrawColor(Color(25, 0, 75, 215))
			surface.DrawRect(0, 0, width, height)

			// top/title
			local r = 90
			local b = r + 50
			for i = 1, 24 do
				r = r - 2
				b = b - 2
				surface.SetDrawColor(Color(r, 0, b))
				surface.DrawRect(0, i - 1, width, 1)
			end

			if width == 500 then
				draw.SimpleText("dynmusic", "Trebuchet20", width / 2, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local endWidth = 500
		local endHeight = 350
		for i = 1, endWidth - 24 do
			timer.Simple(i * 0.00075, function()
				local sizeX, sizeY = dynamicMusic.menu.frame:GetSize()
				dynamicMusic.menu.frame:SetSize(sizeX + 1, sizeY)
				dynamicMusic.menu.frame:Center()
				if i == endWidth - 24 then
					for i = 1, endHeight - 24 do
						timer.Simple(i * 0.001, function()
							local sizeX, sizeY = dynamicMusic.menu.frame:GetSize()
							dynamicMusic.menu.frame:SetSize(500, sizeY + 1)
							dynamicMusic.menu.frame:Center()
							if i == endHeight - 24 then
								dynamicMusic.menu.isReady = true
							end
						end)
					end
				end
			end)
		end


	end

	concommand.Add("dynmusic_menu", dynamicMusic.menu.open)
end