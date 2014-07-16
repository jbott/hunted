surface.CreateFont(
	"Roboto16",
	{
		font = "Roboto",
		size = 16,
	}
)

surface.CreateFont(
	"Roboto32",
	{
		font = "Roboto",
		size = 36,
	}
)
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

-------------------
---- Inventory ----
-------------------

-- Automatically open all net messages with the SteamID
local function netStart(message)
	net.Start(message)
	net.WriteString(LocalPlayer():SteamID())
end

function InventoryOpen()
	netStart("InventoryOpen")
	net.SendToServer()
end
concommand.Add("hunted_inv", InventoryOpen)

local function addLabel(parent, newdata)
	local data = {
		text = "No Text",
		font = "Roboto16",
		dock = FILL,
		marginLeft = 0,
		marginTop = 0,
		marginRight = 0,
		marginBottom = 0,
		forceWide = nil,
		color = Color(255, 255, 255, 255)
	}
	table.Merge(data, newdata)
	local label = vgui.Create("DLabel", parent)
	label:SetTextColor(data.color)
	label:Dock(data.dock)
	label:DockMargin(data.marginLeft, data.marginTop,
		data.marginRight, data.marginBottom)
	label:SetText(data.text)
	label:SetFont(data.font)
	label:SizeToContents()
	if (data.forceWide) then
		label:SetWide(data.forceWide)
	end
end

local function addItem(listLayout, item, action, actionFunc)
	local panel = listLayout:Add("DPanel")
	panel:DockMargin(5, 5, 5, 0)
	panel:SetBackgroundColor(Color(0, 0, 0, 230))
	panel:SetTall(60)

	addLabel(panel, {
		text = item.displayname,
		font = "Roboto32",
		dock = LEFT,
		marginLeft = 10
	})

	local classSelect = vgui.Create("DButton", panel)
	classSelect:Dock(RIGHT)
	classSelect:DockMargin(0, 6, 6, 6)
	classSelect:SetText(action)
	classSelect:SetFont("Roboto32")
	classSelect:SetWide(120)
	classSelect.DoClick = actionFunc

	addLabel(panel, {
		text = item.weight,
		font = "Roboto32",
		dock = RIGHT,
		marginRight = 20,
		forceWide = 40
	})

	addLabel(panel, {
		text = "weight",
		font = "Roboto16",
		dock = RIGHT,
		marginRight = 4,
	})
end

local playerScroll = nil
local playerList = nil
local otherScroll = nil
local otherList = nil
function InventoryGUI()
	local inventorytype = net.ReadInt(3)

	local frame = vgui.Create("DFrame")
	frame:SetSize(1024, 768)
	frame:Center()
	frame:SetTitle("Inventory")
	frame:SetVisible(true)
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()

	-- Create player panel
	local playerPanel = vgui.Create("DPanel")
	playerPanel:SetBackgroundColor(Color(0, 0, 0, 200))
	playerScroll = vgui.Create("DScrollPanel", playerPanel)
	playerScroll:Dock(FILL)
	playerScroll.OldPerformLayout = playerScroll.PerformLayout
	playerScroll.VBar.SetEnabled = function() playerScroll.VBar.Enabled = true end
	playerList = vgui.Create("DListLayout", playerScroll)
	playerList:Dock(FILL)

	if (inventorytype == INVENTORY_TYPE_PLAYER) then
		-- Single Panel
		playerPanel:SetParent(frame)
		playerPanel:Dock(FILL)

		-- Populate items
		netStart("InventoryPopulatePlayer")
		net.SendToServer()
	else
		-- Double Panel
		local otherPanel = vgui.Create("DPanel")
		otherPanel:SetBackgroundColor(Color(0, 0, 0, 200))
		otherScroll = vgui.Create("DScrollPanel", otherPanel)
		otherScroll:Dock(FILL)
		otherScroll.VBar.SetEnabled = function() otherScroll.VBar.Enabled = true end
		otherList = vgui.Create("DListLayout", otherScroll)
		otherList:Dock(FILL)

		local div = vgui.Create("DHorizontalDivider", frame)
		div:Dock(FILL)
		div:SetLeft(otherPanel)
		div:SetRight(playerPanel)
		div:SetLeftWidth(504)
		div:SetDividerWidth(4)
		-- Disable mouse movement of divider
		div.m_DragBar.OnMousePressed = nil
		div.m_DragBar:SetCursor("arrow")

		-- Populate items
		netStart("InventoryPopulatePlayer")
		net.SendToServer()

		netStart("InventoryPopulateOther")
		net.SendToServer()
		end

end
net.Receive("InventorySendClient", InventoryGUI)

function populatePlayerList()
	local inventory = net.ReadTable()

	-- Remove old
	for _,child in pairs(playerList:GetChildren()) do
		child:Remove()
	end

	-- Populate items
	for k,item in pairs(inventory) do
		addItem(playerList, INVENTORY.GetItemData(item), "Drop", function()
			netStart("InventoryDropItem")
				net.WriteString(tostring(k))
			net.SendToServer()
		end)
	end

	playerList:InvalidateLayout(true)
	playerScroll:InvalidateLayout(true)
end
net.Receive("InventoryPopulatePlayerClient", populatePlayerList)

function populateOtherList()
	local inventory = net.ReadTable()

	-- Remove old
	for _,child in pairs(otherList:GetChildren()) do
		child:Remove()
	end

	-- Populate items
	for k,item in pairs(inventory) do
		addItem(otherList, INVENTORY.GetItemData(item), "Take", function()
			netStart("InventoryTakeItem")
				net.WriteString(item)
			net.SendToServer()
		end)
	end

	otherList:InvalidateLayout(true)
	otherScroll:InvalidateLayout(true)
end
net.Receive("InventoryPopulateOtherClient", populateOtherList)