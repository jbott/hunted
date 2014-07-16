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