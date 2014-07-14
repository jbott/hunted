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
		-- Bloom
		if ( render.SupportsPixelShaders_2_0() ) then
			DrawBloom( .35, --pp_bloom_darken
				2.0, --pp_bloom_multiply
				4.0, --pp_bloom_sizex
				4.0, --pp_bloom_sizey
				1, --pp_bloom_passes
				2.0, --pp_bloom_color
				1, --pp_bloom_color_r
				1, --pp_bloom_color_g
				1 --pp_bloom_color_b
			)
		end

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
			light.Pos = LocalPlayer():GetPos() + Vector(0,0,30) -- 30 units up
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

local mat_Downsample	= Material( "pp/downsample" )
local mat_Bloom			= Material( "pp/bloom" )
local mat_BlurX			= Material( "pp/blurx" )
local mat_BlurY			= Material( "pp/blury" )

local tex_Bloom0		= render.GetBloomTex0()
local tex_Bloom1		= render.GetBloomTex1()

mat_Downsample:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

function DrawBloom( darken, multiply, sizex, sizey, passes, color, colr, colg, colb )

	-- No bloom for crappy gpus
	if ( !render.SupportsPixelShaders_2_0() ) then return end

	-- Todo: Does this stop it working properly when rendered to a rect?
	local w = ScrW()
	local h = ScrH()

	-- Copy the backbuffer to the screen effect texture
	render.UpdateScreenEffectTexture()

	-- Store the render target so we can swap back at the end
	local OldRT = render.GetRenderTarget()

	-- The downsample material adjusts the contrast
	mat_Downsample:SetFloat( "$darken", darken )
	mat_Downsample:SetFloat( "$multiply", multiply )


	-- Downsample to BloomTexture0
	render.SetRenderTarget( tex_Bloom0 )

	render.SetMaterial( mat_Downsample )
	render.DrawScreenQuad()

	render.BlurRenderTarget( tex_Bloom0, sizex, sizey, passes )

	render.SetRenderTarget( OldRT )

	mat_Bloom:SetFloat( "$levelr", colr )
	mat_Bloom:SetFloat( "$levelg", colg )
	mat_Bloom:SetFloat( "$levelb", colb )
	mat_Bloom:SetFloat( "$colormul", color )
	mat_Bloom:SetTexture( "$basetexture", tex_Bloom0 )

	render.SetMaterial( mat_Bloom )
	render.DrawScreenQuad()

end