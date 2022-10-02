Shader "Unlit/standard"
{
    Properties
    {
        [HDR]
        _Color("color", Color) = (0.0,0.0,0.0,0.0)
        _AmbientColor("ambient color", Color) = (0.0,0.0,0.0,0.0)
        _SpecularColor("specular", Color) = (0.0,0.0,0.0,0.0)
        _BacklightColor("backlight", Color) = (0.0,0.0,0.0,0.0)
        _RimColor("rim", Color) = (0.0,0.0,0.0,0.0)

        _RimAmount("rim amount", float) = 0.0
        _Glossiness("glossiness", float) = 0.0
        _ShadingIntensity("shading intensity", float) = 0.0
        _BackLightNormalStrength("backlight normal strength", float) = 0.0
        _BackLightPower("wback light power", float) = 0.0
        _BackLightStrength("back light strength", float) = 0.0
        _FakeDensityMult("fake density", float) = 0.0
        _LightingOverall("overall lighting", float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag

			#include "MyLighting.cginc"
            #include "UnityCG.cginc"

            struct vertOut
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD1;
            };

            vertOut vert (appdata_tan v)
            {
                vertOut o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            fixed4 frag (vertOut i) : SV_Target
            {
                // sample the texture
                fixed4 col = getLighting(normalize(i.normal), normalize(i.viewDir));
                return col;
            }
            ENDCG
        }
    }
}
