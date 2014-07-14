AddCSLuaFile()

function EFFECT:Init( data )
	if (CLIENT) then
      local light = DynamicLight(data:GetEntity():EntIndex())
      if (light) then
         light.Pos = data:GetOrigin()
         light.r = 255
         light.g = 191
         light.b = 39
         light.Brightness = 4
         light.Size = 250
         light.Decay = 0.01
         light.DieTime = CurTime() + 0.001
         light.Style = 0
      end
   end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end