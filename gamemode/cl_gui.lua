function ChangeTeamGUI(ply, cmd, args)
	local teamGUI = vgui.Create("DFrame")
	teamGUI:SetSize(500, 300)
	teamGUI:Center()
	teamGUI:SetTitle("Select Team")
	teamGUI:SetVisible(true)
	teamGUI:SetDraggable(false)
	teamGUI:ShowCloseButton(true)
	teamGUI:MakePopup()

	local hunterPanel = vgui.Create("DPanel")
	hunterPanel:SetBackgroundColor(Color(0, 0, 0, 230))
	local huntedPanel = vgui.Create("DPanel")
	huntedPanel:SetBackgroundColor(Color(0, 0, 0, 230))

	local div = vgui.Create("DHorizontalDivider", teamGUI)
	div:Dock(FILL)
	div:SetLeft(hunterPanel)
	div:SetRight(huntedPanel)
	div:SetLeftWidth(242)
	div:SetDividerWidth(4)
	-- Disable mouse movement of divider
	div.m_DragBar.OnMousePressed = nil
	div.m_DragBar:SetCursor("arrow")

	-- Hunter
	local hunterButton = vgui.Create("DButton", hunterPanel)
	hunterButton:Dock(BOTTOM)
	hunterButton:SetTall(60)
	hunterButton:SetText("Hunter (" .. team.NumPlayers(TEAM_HUNTER) .. ")")
	hunterButton.DoClick = function()
		RunConsoleCommand("hunted_change_team", TEAM_HUNTER)
		teamGUI:Close()
	end

	local hunterModel = vgui.Create("DModelPanel", hunterPanel)
	hunterModel:SetModel("models/player/Combine_Soldier.mdl")
	function hunterModel.Entity:GetPlayerColor() return Vector ( 0, 1, 0 ) end -- GREEN
	hunterModel:Dock(FILL)
	hunterModel.LayoutEntity = function() end

	-- Hunted
	local huntedButton = vgui.Create("DButton", huntedPanel)
	huntedButton:Dock(BOTTOM)
	huntedButton:SetTall(60)
	huntedButton:SetText("Hunted (" .. team.NumPlayers(TEAM_HUNTED) .. ")")
	if (team.NumPlayers(TEAM_HUNTED) >= 1 && LocalPlayer():Team() != TEAM_HUNTED) then huntedButton:SetDisabled(true) end
	huntedButton.DoClick = function()
		RunConsoleCommand("hunted_change_team", TEAM_HUNTED)
		teamGUI:Close()
	end

	local huntedModel = vgui.Create("DModelPanel", huntedPanel)
	huntedModel:SetModel("models/player/Group03/Male_02.mdl")
	huntedModel:Dock(FILL)
	huntedModel.LayoutEntity = function() end
end
concommand.Add("hunted_menu_team", ChangeTeamGUI)

function ChangeClassGUI(ply, cmd, args)
	if (LocalPlayer():Team() == TEAM_SPECTATOR || LocalPlayer():Team() == TEAM_UNASSIGNED) then return end

	local classGUI = vgui.Create("DFrame")
	classGUI:SetSize(500, 500)
	classGUI:Center()
	classGUI:SetTitle("Select Class: " .. team.GetName(LocalPlayer():Team()))
	classGUI:SetVisible(true)
	classGUI:SetDraggable(false)
	classGUI:ShowCloseButton(true)
	classGUI:MakePopup()

	local scrollPanel = vgui.Create("DScrollPanel", classGUI)
	scrollPanel:Dock(FILL)

	local listLayout = vgui.Create("DListLayout", scrollPanel)
	listLayout:Dock(FILL)

	for k,v in pairs(CLASS.GetTeamClasses(LocalPlayer():Team())) do
		local panel = listLayout:Add("DPanel")
		panel:DockMargin(0, 0, 0, 5) -- Pad on the bottom
		panel:SetBackgroundColor(Color(0, 0, 0, 230))
		panel:SetTall(100)

		local className = vgui.Create("DLabel", panel)
		className:SetTextColor(Color(255, 255, 255, 255))
		className:SetPos(10, 10)
		className:SetText(CLASS.GetClassName(v))
		className:SetFont("DermaLarge")
		className:SizeToContents()

		local classDesc = vgui.Create("DLabel", panel)
		classDesc:SetTextColor(Color(255, 255, 255, 255))
		classDesc:SetPos(10, 12 + className:GetTall())
		classDesc:SetText(CLASS.GetClassDesc(v))
		classDesc:SizeToContents()

		local classSelect = vgui.Create("DButton", panel)
		classSelect:Dock(RIGHT)
		classSelect:DockMargin(4, 4, 4, 4)
		classSelect:SetText("Select")
		classSelect:SetFont("DermaLarge")
		classSelect:SetWide(140)
		classSelect.DoClick = function()
			RunConsoleCommand("hunted_change_class", tostring(v))
			classGUI:Close()
		end
	end
end
concommand.Add("hunted_menu_class", ChangeClassGUI)