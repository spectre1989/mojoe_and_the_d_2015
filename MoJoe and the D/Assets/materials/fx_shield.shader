﻿// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position
// Upgrade NOTE: replaced 'V2F_POS_FOG' with 'float4 pos : SV_POSITION'

Shader "Custom/fx_shield" 
{

	Properties{
		_Colour("Colour1", Color) = (1,1,1,1)
		_Colour2("Colour2", Color) = (1,1,1,1)
		_Rate("Oscillation Rate", Range(5, 200)) = 50
		_Scale("Scale", Range(0.02, 0.5)) = 0.25
		_Distortion("Distortion", Range(0.1, 20)) = 1
	}

		SubShader{

		ZWrite Off
		Tags{ "Queue" = "Transparent" }
		Blend One One


		Pass{

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_fog_exp2
#include "UnityCG.cginc"

	float4 _Colour;
	float4 _Colour2;
	float _Rate;
	float _Scale;
	float _Distortion;

	struct v2f {
		float4 pos : SV_POSITION;
		float3 uv : TEXCOORD0;
		float3 vert : TEXCOORD1;
	};

	v2f vert(appdata_base v)
	{
		v2f o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		float s = 1 / _Scale;
		float t = _Time[0] * _Rate*_Scale;
		o.vert = sin((v.vertex.xyz + t) * s);
		o.uv = sin((v.texcoord.xyz + t) * s) * _Distortion;

		return o;
	}

	half4 frag(v2f i) : COLOR
	{
		float3 vert = i.vert;
		float3 uv = i.uv;
		float mix = 1 + sin((vert.x - uv.x) + (vert.y - uv.y) + (vert.z - uv.z));
		float mix2 = 1 + sin((vert.x + uv.x) - (vert.y + uv.y) - (vert.z + uv.z)) / _Distortion;

		return half4((_Colour * mix * 0.1) + (_Colour2 * mix2 * 0.1));
	}
		ENDCG

	}
	}
		Fallback "Transparent/Diffuse"
}


