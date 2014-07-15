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
end

function GM:HUDShouldDraw( name )
    if (name == "CHudDeathNotice") then
        return false
    end
    return true
end