Shader "Unlit/water-simple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 64)) = 4
		_TessellationEdgeLength ("Tessellation Edge Length", Range(0.0, 0.01)) = 0.01
        _TessDistPow("tess distance power", Range(0.0, 5.0)) = 1.0
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

            uniform float _WaveFrequency;
            uniform float _WaveFrequencySmall;
            uniform float _WaveSpeed;
            uniform float _SmallWaveSpeed;
            uniform float _WaveHeight;
            uniform float _WaveHeight2;
            uniform int _NumFunctions;

            uniform float4x4 _WaveFunctions[10];

            uniform float _NormalSearch;

            uniform float _T;

            uniform float _Tess;
            uniform float _TessellationEdgeLength;
            uniform float _TessDistPow;
            
            sampler2D _MainTex;
            float4 _MainTex_ST;

            #include "MyDistortion.cginc"

            sampler2D _NormalMap;
            sampler2D _CameraDepthTexture;
            sampler2D _UnderWaterTex;
            uniform fixed4 _Color;
            uniform fixed4 _AmbientColor;
            uniform fixed4 _SpecularColor;
            uniform fixed4 _RimColor;
            uniform float _RimAmount;
            uniform float _Glossiness;
            uniform float _ShadingIntensity;

            uniform float _NormalMapStrength;
            uniform float _NormalMapStrength2;

            uniform float _BackLightNormalStrength;
            uniform float _BackLightPower;
            uniform float _BackLightStrength;
            uniform fixed4 _BacklightColor;
            uniform float _DepthMultiplier;
            uniform float _FakeDensityMult;
            uniform float _FrontLightingStrength;

            uniform float _LightingOverall;

			#include "MyLighting.cginc"

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
                fixed4 col = getLighting(normalize(i.normal), normalize(i.normal), i.viewDir);
                return col;
            }
            ENDCG
        }
    }
}
