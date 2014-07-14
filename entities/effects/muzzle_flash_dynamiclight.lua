AddCSLuaFile()

function EFFECT:Init( data )
	if (CLIENT) then
      local light = DynamicLight(data:GetEntity():EntIndex())
      if (light) then
         light.Pos = data:GetOrigin()
         light.r = 255
         light.g = 255
         light.b = 255
         light.Brightness = 4
         light.Size = 250
         light.Decay = 0.1
         light.DieTime = CurTime() + 0.01
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