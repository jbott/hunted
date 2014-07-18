surface.CreateFont(
	"Roboto16",
	{
		font = "Roboto",
		size = 16,
	}
)

surface.CreateFont(
	"Roboto24",
	{
		font = "Roboto",
		size = 24,
	}
)

surface.CreateFont(
	"Roboto28",
	{
		font = "Roboto",
		size = 28,
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

function InventoryOpen()
	net.Start("InventoryOpen")
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

	return label
end

local function addItem(listLayout, item, action, actionFunc, enabled)
	if (item.name == "spacer_label") then
		local panel = listLayout:Add("DPanel")
		panel:DockMargin(5, 5, 5, 0)
		panel:SetBackgroundColor(Color(0, 0, 0, 0))
		panel:SetTall(5)
		return
	end
	if (item.name == "category_label") then
		local panel = listLayout:Add("DPanel")
		panel:DockMargin(5, 5, 5, 0)
		panel:SetBackgroundColor(Color(0, 0, 0, 200))
		panel:SetTall(40)

		addLabel(panel, {
			text = item.displayname,
			font = "Roboto24",
			dock = LEFT,
			marginLeft = 40
		})
		return
	end

	local panel = listLayout:Add("DPanel")
	panel:DockMargin(5, 5, 5, 0)
	panel:SetBackgroundColor(Color(0, 0, 0, 230))
	panel:SetTall(60)

	addLabel(panel, {
		text = item.displayname,
		font = "Roboto28",
		dock = LEFT,
		marginLeft = 10
	})
	if (item.ammoquantity) then item.clip1 = item.ammoquantity end
	if (item.clip1 and item.clip1max and item.clip1max != -1) then
		local ammoLabel = addLabel(panel, {
			text = tostring(item.clip1) .. "/" .. tostring(item.clip1max),
			font = "Roboto16",
			dock = LEFT,
			marginLeft = 10
		})
	end

	local button = vgui.Create("DButton", panel)
	button:Dock(RIGHT)
	button:DockMargin(0, 6, 6, 6)
	button:SetText(action)
	button:SetFont("Roboto28")
	button:SetWide(120)
	if (enabled) then
		button.DoClick = actionFunc
	end
	button:SetEnabled(enabled)

	addLabel(panel, {
		text = item.weight,
		font = "Roboto28",
		dock = RIGHT,
		marginRight = 10,
		forceWide = 30
	})

	addLabel(panel, {
		text = "weight",
		font = "Roboto16",
		dock = RIGHT,
		marginRight = 4,
	})
end

local inventoryPanel = {}

function createInventory(id)
	inventoryPanel[id] = {}
	local invPanel = inventoryPanel[id]

	local panel = vgui.Create("DPanel")
	panel:SetBackgroundColor(Color(0, 0, 0, 200))

	-- Top - Weight Pane
	local weightPanel = vgui.Create("DPanel", panel)
	weightPanel:Dock(TOP)
	weightPanel:SetBackgroundColor(Color(0, 0, 0, 150))
	weightPanel:SetTall(35)
	invPanel.weightLabel = addLabel(weightPanel, {
		text = "0/0",
		font = "Roboto16",
		dock = RIGHT,
		marginRight = 10
	})
	invPanel.weightStringLabel = addLabel(weightPanel, {
		text = "Weight:",
		font = "Roboto16",
		dock = RIGHT,
		marginRight = 5
	})

	invPanel.nameLabel = addLabel(weightPanel, {
		text = "",
		font = "Roboto16",
		dock = LEFT,
		marginLeft = 10
	})

	-- Bottom - Inventory
	invPanel.scrollLayout = vgui.Create("DScrollPanel", panel)
	invPanel.scrollLayout:Dock(FILL)
	invPanel.scrollLayout.OldPerformLayout = invPanel.scrollLayout.PerformLayout
	invPanel.scrollLayout.VBar.SetEnabled = function() invPanel.scrollLayout.VBar.Enabled = true end
	invPanel.listLayout = vgui.Create("DListLayout", invPanel.scrollLayout)
	invPanel.listLayout:Dock(FILL)

	return panel
end

function InventoryGUI()
	if (table.Count(inventoryPanel) != 0) then return end

	local inventorytype = net.ReadInt(3)

	local frame = vgui.Create("DFrame")
	frame:SetSize(1024, 768)
	frame:Center()
	frame:SetTitle("Inventory")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:MakePopup()
	frame.OnClose = function()
		-- Reset
		inventoryPanel = {}
		net.Start("InventoryClosed")
		net.SendToServer()
	end
	frame.OnKeyCodePressed = function(self, keyCode)
		print(keyCode)
		if (keyCode == KEY_F1 or
			keyCode == KEY_E) then
			self:Close()
		end
	end
	inventoryPanel.frame = frame

	-- Create player panel
	local rightPanel = createInventory(INVENTORY_SIDE_RIGHT)

	if (inventorytype == INVENTORY_TYPE_PLAYER) then
		-- Single Panel
		rightPanel:SetParent(frame)
		rightPanel:Dock(FILL)

		-- Populate items
		net.Start("InventoryPopulateList")
			net.WriteInt(INVENTORY_SIDE_RIGHT, 3)
		net.SendToServer()
	else
		-- Double Panel
		local leftPanel = createInventory(INVENTORY_SIDE_LEFT)

		local div = vgui.Create("DHorizontalDivider", frame)
		div:Dock(FILL)
		div:SetLeft(leftPanel)
		div:SetRight(rightPanel)
		div:SetLeftWidth(504)
		div:SetDividerWidth(4)
		-- Disable mouse movement of divider
		div.m_DragBar.OnMousePressed = nil
		div.m_DragBar:SetCursor("arrow")

		-- Populate items
		net.Start("InventoryPopulateList")
			net.WriteInt(INVENTORY_SIDE_LEFT, 3)
		net.SendToServer()

		net.Start("InventoryPopulateList")
			net.WriteInt(INVENTORY_SIDE_RIGHT, 3)
		net.SendToServer()
	end
end
net.Receive("InventoryOpenResponse", InventoryGUI)

function InventoryForceClose()
	if inventoryPanel and inventoryPanel.frame then
		inventoryPanel.frame:Close()
	end
end
net.Receive("InventoryForceClose", InventoryForceClose)

function populateList()
	local id = net.ReadInt(3)
	local invPanel = inventoryPanel[id]

	local inv = net.ReadTable()

	invPanel.nameLabel:SetText(inv.name)
	invPanel.nameLabel:SizeToContents()

	-- Remove old
	for _,child in pairs(invPanel.listLayout:GetChildren()) do
		child:Remove()
	end

	-- Populate items
	for k,item in pairs(inv.data) do
		local enabled = true
		if ((inv.filterType != 0) and (INVENTORY.GetItemData(item.name).category != inv.filterType)) then
			enabled = false
		end
		local itemData = INVENTORY.GetItemData(item.name)
		table.Merge(itemData, item) -- Merge this way to keep item specific data
		addItem(invPanel.listLayout, itemData, inv.action, function()
			net.Start(inv.actionMessage)
				net.WriteInt(k, 16)
				net.WriteString(item.name)
			net.SendToServer()
		end, enabled)
	end

	if (inv.max != 0) then
		invPanel.weightLabel:SetText(inv.weight .. "/" .. inv.max)
		invPanel.weightLabel:SizeToContents()

		-- Set Color to show level of fullness
		local weightRation = inv.weight / inv.max
		local color = nil
		if (weightRation == 1) then
			color = Color(255, 0, 0, 255)
		elseif (weightRation > 0.8) then
			color = Color(255, 255, 0, 255)
		else
			color = Color(0, 255, 0, 255)
		end
		invPanel.weightLabel:SetTextColor(color)
	else
		invPanel.weightLabel:Hide()
		invPanel.weightStringLabel:Hide()
	end

	invPanel.listLayout:InvalidateLayout(true)
	invPanel.scrollLayout:InvalidateLayout(true)
end
net.Receive("InventoryPopulateListResponse", populateList)

function GM:PlayerBindPress( ply, bind, pressed )
	if (table.Count(inventoryPanel) != 0) then
		return true
	end
end