-- shared extensions to player table
local plymeta = FindMetaTable( "Player" )
if not plymeta then return end

if SERVER then
function plymeta:NightVision(on)
	self:SetNWBool("NightVision", on)
end
end

function plymeta:NightVisionIsOn()
	return self:GetNWBool("NightVision", false)
end