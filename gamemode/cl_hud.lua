function GM:HUDPaint()

	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )

	if (LocalPlayer():Alive() &&
		LocalPlayer():Team() != TEAM_SPEC &&
		LocalPlayer():Team() != TEAM_UNASSIGNED &&
		LocalPlayer():Class() != CLASS_UNASSIGNED) then
		surface.SetFont("DermaDefault")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(10, 10)
		surface.DrawText(CLASS.GetClassName(LocalPlayer():Class()))
	end

	for _,ply in pairs(player.GetAll()) do
		paintPlayerName(ply)
	end
end

function paintPlayerName(ply)
	if (!ply:Alive()) then return end
	if (ply:Team() == TEAM_UNASSIGNED ||
		ply:Team() == TEAM_SPEC) then return end
	if (ply == LocalPlayer()) then return end
	local dist = LocalPlayer():GetPos():Distance(ply:GetPos())
	if (dist > 255) then return end

	local text = ply:GetName()
	local font = "DermaLarge"
	surface.SetFont(font)

	local pos = (ply:GetPos() + Vector(0, 0, 70)):ToScreen()
	local w, h = surface.GetTextSize(text)

	if pos.visible then
		local x = pos.x
		local y = pos.y

		x = x - w / 2
		y = y - h

		-- The fonts internal drop shadow looks lousy with AA on
		draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
		draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
		draw.SimpleText( text, font, x, y, Color(255,255,255,255 - dist))
	end
end

function GM:HUDShouldDraw( name )
    if (name == "CHudDeathNotice") then
        return false
    end
    return true
end

-- Disable overlay
function GM:HUDDrawTargetID()
end