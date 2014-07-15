-- shared extensions to player table
local plymeta = FindMetaTable("Player")
if not plymeta then return end

if SERVER then
	function plymeta:NightVision(on)
		self:SetNWBool("NightVision", on)
	end

	function plymeta:SetNightVisionSize(size)
		self:SetNWInt("NightVisionSize", size)
	end

	function plymeta:SetClass(class)
		self:SetNWString("Class", class)
	end
end

function plymeta:NightVisionIsOn()
	return self:GetNWBool("NightVision", false)
end

function plymeta:NightVisionSize()
	return self:GetNWInt("NightVisionSize", 500)
end

function plymeta:SlowWalk(on)
	if on then
		player_manager.RunClass(self, "SpeedMultiplier", 0.5)
	else
		player_manager.RunClass(self, "SpeedMultiplier", 1)
	end
end

function plymeta:Class()
	return self:GetNWString("Class", CLASS_UNASSIGNED)
end