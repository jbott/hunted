include("shared.lua")
include("cl_nightvision.lua")

function GM:Initialize()
	-- Don't do a whole ton yet
	print("Hunted Clientside Initialized...")
end

function ChangeTeamGUI(ply, cmd, args)
	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 300)
	frame:Center()
	frame:SetTitle("Select Team")
	frame:SetVisible(true)
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()

	local hunterPanel = vgui.Create("DPanel")
	hunterPanel:SetBackgroundColor(Color(0, 0, 0, 230))
	local huntedPanel = vgui.Create("DPanel")
	huntedPanel:SetBackgroundColor(Color(0, 0, 0, 230))

	local div = vgui.Create("DHorizontalDivider", frame)
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
	hunterButton:SetText("Hunter")
	hunterButton.DoClick = function()
		RunConsoleCommand("hunted_change_team", TEAM_HUNTER)
		frame:Close()
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
	huntedButton:SetText("Hunted")
	if (team.NumPlayers(TEAM_HUNTED) >= 1) then huntedButton:SetDisabled(true) end
	huntedButton.DoClick = function()
		RunConsoleCommand("hunted_change_team", TEAM_HUNTED)
		frame:Close()
	end

	local huntedModel = vgui.Create("DModelPanel", huntedPanel)
	huntedModel:SetModel("models/player/Group03/Male_02.mdl")
	huntedModel:Dock(FILL)
	huntedModel.LayoutEntity = function() end
end

concommand.Add("hunted_menu_team", ChangeTeamGUI)