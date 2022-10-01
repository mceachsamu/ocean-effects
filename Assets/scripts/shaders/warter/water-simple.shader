Shader "Unlit/water-simple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UnderWaterTexture ("underwater texture", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 64)) = 4
		_TessellationEdgeLength ("Tessellation Edge Length", Range(0.0, 0.0001)) = 0.01
        _TessDistPow ("tess distance power", Range(0.0, 5.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma target 5.0
            #pragma require geometry
            #pragma shader_feature _TESSELLATION_EDGE
            
            sampler2D _MainTex;
            float4 _MainTex_ST;

            #include "MyDistortion.cginc"

            sampler2D _NormalMap;
            sampler2D _CameraDepthTexture;

			#include "MyLighting.cginc"
			#include "WaterLighting.cginc"

            #include "UnityCG.cginc"
			#include "MyVertex.cginc"
			#include "MyTessalation.cginc"
			#include "MyGeometry.cginc"

            #pragma vertex MyTessellationVertexProgram
            #pragma fragment frag
            #pragma hull MyHullProgram
			#pragma domain MyDomainProgram
			#pragma geometry MyGeometryProgram

            fixed4 frag (vertOut i) : SV_Target
            {
                // sample the texture
                fixed4 col = getWaterLighting(normalize(i.normal), normalize(i.normal), normalize(i.viewDir), i.screenPos);
                return col;
            }
            ENDCG
        }
    }
}
