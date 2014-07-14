local colormod = {}
colormod[ "$pp_colour_brightness" ] = 0
colormod[ "$pp_colour_colour" ] = 1
colormod[ "$pp_colour_mulr" ] = 0
colormod[ "$pp_colour_mulg" ] = 0
colormod[ "$pp_colour_mulb" ] = 0
colormod[ "$pp_colour_contrast" ] = 1.1
colormod[ "$pp_colour_addr" ] = 0
colormod[ "$pp_colour_addg" ] = 0.1
colormod[ "$pp_colour_addb" ] = 0

hook.Add("RenderScreenspaceEffects", "cl_nightvision_colors", function()
	if LocalPlayer():NightVisionIsOn() then
		-- Overlay
		render.UpdateScreenEffectTexture()
		mat_Overlay = Material("effects/combine_binocoverlay")
		mat_Overlay:SetFloat( "$envmap", 0 )
		mat_Overlay:SetFloat( "$envmaptint", 0 )
		mat_Overlay:SetFloat( "$refractamount", 1 )
		mat_Overlay:SetInt( "$ignorez", 1 )
		render.SetMaterial( mat_Overlay )
		render.DrawScreenQuad()

		-- Green color modification
		DrawColorModify(colormod)
	end
end)

hook.Add("Think", "cl_nightvision_think", function()
	if LocalPlayer():NightVisionIsOn() then
		local light = DynamicLight(LocalPlayer():EntIndex())
		if (light) then
			light.Pos = LocalPlayer():GetPos() + LocalPlayer():GetCurrentViewOffset()
			light.r = 80
			light.g = 255
			light.b = 80
			light.Brightness = 0.5
			light.Size = 500 -- This should change for the different classes
			light.Decay = 10000
			light.DieTime = CurTime() + 0.1
			light.Style = 0
		end
	end
end)