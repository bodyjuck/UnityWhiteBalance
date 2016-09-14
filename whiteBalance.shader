﻿Shader "Hidden/WhiteBalance"{
	Properties	{
		_MainTex ("Base (RGB)", 2D) = "" {}
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	sampler2D _MainTex;
	half4 _MainTex_ST;

	float4x4 ChromaticAdaptation;

	v2f vert(appdata_img v) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = UnityStereoScreenSpaceUVAdjust(v.texcoord.xy, _MainTex_ST);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target{
		fixed4 color = tex2D(_MainTex, i.uv);

		return  mul(ChromaticAdaptation, color);
	}

	ENDCG

	SubShader	{
		Pass{
			ZTest Always Cull off ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}
	}

	Fallback off
}
