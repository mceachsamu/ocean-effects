Shader "Custom/water"
{
    Properties {
        _Tess ("Tessellation", Range(1,32)) = 4
        _Phong ("phong", Range(0,1)) = 0.5
        _MaxDistanceTess("mex tes distance", Range(0, 2000)) = 100
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTexture ("Noise map", 2D) = "white" {}
        _NoiseTexture2 ("Noise map 2", 2D) = "white" {}
        _DispTex ("Disp Texture", 2D) = "gray" {}
        _NormalMap ("Normalmap", 2D) = "bump" {}
        _Displacement ("Displacement", Range(0.0005, 0.00001)) = 0.001
        _Color ("Color", color) = (1,1,1,0)
        _SpecColor ("Spec color", color) = (0.5,0.5,0.5,0.5)
        _SpecularColor ("Specular color", color) = (0.5,0.5,0.5,0.5)
        _AmbientColor("Ambient Color", Color) = (0.0,0.0,0.0,0.0)
        _RimColor("Rim Color", Color) = (0.0,0.0,0.0,0.0)
        _RimAmount("rim amount", Range(0, 5)) = 1
        _Glossiness("Glossiness", Range(0, 50)) = 1
        _ShadingIntensity("shading intensity", Range(0.0, 30.0)) = 1.0

        _NormalMapStrength("normal map strength", Range(0.0,30.0)) = 1.0
        _NormalMapStrength2("normal map strength 2", Range(0.0,1.0)) = 1.0
        _NormalMapDisplacement("normal map displacement", Range(0.0,1.0)) = 1.0
        _NormalScrollSpeed("normal scroll speed", Range(0.0,1.0)) = 1.0
        _TextureFrequency("texture frequency", Range(0.0,40.0)) = 1.0

        _BackLightNormalStrength("backlighting normal strength",  Range(0.0,1.0)) = 0.5
        _BackLightPower("backlighting power",  Range(0.0,10.0)) = 1.0
        _BackLightStrength("backlighting strength",  Range(0.0,10.0)) = 1.0
        _BacklightColor("backlight Color", Color) = (0.0,0.0,0.0,0.0)
        _DepthMultiplier("depth multiplier",  Range(0.0,5.0)) = 1.0
        _FakeDensityMult("density multiplier", Range(0.0,5.0)) = 1.0
        _FrontLightingStrength("front lighting strength", Range(0.0, 1.0)) = 0.5

        _WaveFrequency("wave frequency",  Range(0.0, 1.0)) = 1.0
        _WaveSpeed("wave speed",  Range(0.0,100.0)) = 1
        _WaveHeight("wave height", Range(0.0,0.05)) = 0.01

        _NormalSearch("normal search", Range(0.0,0.1)) = 0.01
        _TextureSize("texture size", float) = 100.0

    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 300
        
        CGPROGRAM
        
        #pragma surface surf Water addshadow fullforwardshadows vertex:disp tessellate:tessDistance tessphong:_Phong nolightmap
        #pragma target 4.6
        #include "Tessellation.cginc"

        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        float _Tess;
        float _Phong;
        uniform float _MaxDistanceTess;

        float4 tessDistance (appdata v0, appdata v1, appdata v2) {
            float minDist = 15.0;
            float maxDist = _MaxDistanceTess;
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
        }

        sampler2D _DispTex;
        float _Displacement;

        float3 getNormal(float4 step, float2 uv, sampler2D heightMap, float size)
        {
            float this = tex2Dlod (heightMap, float4(float2(uv.x, uv.y),0,0)).r * size;
            float botLeft = tex2Dlod (heightMap, float4(float2(uv.x - step.x, uv.y - step.z),0,0)).r * size;
            float botRight = tex2Dlod (heightMap, float4(float2(uv.x + step.x, uv.y - step.z),0,0)).r * size;
            float topRight = tex2Dlod (heightMap, float4(float2(uv.x + step.x, uv.y + step.z),0,0)).r * size;
            float topLeft = tex2Dlod (heightMap, float4(float2(uv.x - step.x, uv.y + step.z),0,0)).r * size;

            float4 vec1 =  (float4(0, this,0,0) - float4(step.x, topRight, step.z,0));
            float4 vec2 =  (float4(0, this,0,0) - float4(step.x, botRight, -step.z,0));

            float4 vec3 =  (float4(0, this.r, 0,0) - float4(-step.x, topLeft, step.z,0));
            float4 vec4 =  (float4(0, this.r, 0,0) - float4(-step.x, botLeft, -step.z,0));

            float4 vec5 =  (float4(0, this.r, 0,0) - float4(step.x, topRight, step.z,0));
            float4 vec6 =  (float4(0, this.r, 0,0) - float4(step.x, topLeft, -step.z,0));

            float4 vec7 =  (float4(0, this.r, 0,0) - float4(-step.x, botLeft, -step.z,0));
            float4 vec8 =  (float4(0, this.r, 0,0) - float4(-step.x, botRight, step.z,0));

            float3 norm1 = normalize(cross(normalize(vec1),normalize(vec2)));
            float3 norm2 = normalize(cross(normalize(vec3),normalize(vec4)));
            float3 norm3 = normalize(cross(normalize(vec5),normalize(vec6)));
            float3 norm4 = normalize(cross(normalize(vec7),normalize(vec8)));
            return ((norm1 + norm2 + norm3 + norm4) / 4.0);
        }

        uniform sampler2D _NoiseTexture;
        uniform sampler2D _NoiseTexture2;
        uniform float _WaveFrequency;
        uniform float _WaveSpeed;
        uniform float _WaveHeight;
        uniform float _NormalSearch;
        uniform float _TextureSize;
        uniform float _NormalMapDisplacement;
        uniform float _TextureFrequency;
        uniform float _NormalScrollSpeed;

        float4 getDistortion(float4 position) {
            float4 wPosition = mul (unity_ObjectToWorld, position);
            float time = _Time * _WaveSpeed;


            float z = 0.0;
            // z -= 1.0 * (sin(wPosition.x * _WaveFrequency*10 + _Time * _WaveSpeed)) * _WaveHeight*2.0;
            // z -= 1.0 * abs(sin(wPosition.x * _WaveFrequency*20 + _Time * _WaveSpeed)) * _WaveHeight*1.6;
            z -= 1.0 * (sin((wPosition.z + wPosition.x) * _WaveFrequency/20.0 + _Time * _WaveSpeed*0.5)) * _WaveHeight*100.1;
            z -= 1.0 * (sin(wPosition.x * _WaveFrequency/600.0 + _Time * _WaveSpeed*0.99)) * _WaveHeight*1600;
            z -= 1.0 * (sin(wPosition.z * _WaveFrequency/100.0 + _Time * _WaveSpeed*0.6)) * _WaveHeight*2000.0;
            
            // wPosition.z -= 1.0 * abs(sin(wPosition.x * _WaveFrequency*1000 + _Time * _WaveSpeed * 2.0)) * _WaveHeight * 0.32;
            z -= 1.0 * abs(sin(wPosition.z * _WaveFrequency/30.0 - _Time * _WaveSpeed * 5.5)) * _WaveHeight*150.0;
            // z -= 1.0 * (sin((wPosition.y + wPosition.x) * _WaveFrequency*70 + _Time * _WaveSpeed*3.5)) * _WaveHeight*1.53;
            // z -= 1.0 * (sin((wPosition.y + wPosition.x/4.0) * _WaveFrequency*650 + _Time * _WaveSpeed*5.0)) * _WaveHeight*0.22;
            // z -= 1.0 * (sin((wPosition.y + wPosition.x) * _WaveFrequency*300 + _Time * _WaveSpeed*3.0)) * _WaveHeight*0.31;

            z += _WaveHeight;
            wPosition.y += z;
            position = mul(unity_WorldToObject, wPosition);
            return position;
        }

        float3 getDistortedNormal(float4 position, float3 normal, float step) {
            float4 pos1 = getDistortion(position) - getDistortion(float4(position.x + step, position.y + step, position.z, position.w));
            float4 pos2 = getDistortion(position) - getDistortion(float4(position.x - step, position.y + step, position.z, position.w));
            float4 pos3 = getDistortion(position) - getDistortion(float4(position.x + step, position.y - step, position.z, position.w));
            float4 pos4 = getDistortion(position) - getDistortion(float4(position.x - step, position.y - step, position.z, position.w));

            float3 norm1 = cross(pos1.xyz, pos2.xyz);
            float3 norm2 = cross(pos4.xyz, pos3.xyz);

            return normalize(norm2);//(normalize(normal) + normalize(norm1) + normalize(norm2))/3.0;
        }

        float2 GetNormUVPositive(float2 uv) {
            return uv * _TextureFrequency + _Time * _NormalScrollSpeed;
        }
        
        float2 GetNormUVNegative(float2 uv) {
            return uv * _TextureFrequency - _Time * _NormalScrollSpeed;
        }

        void disp (inout appdata v)
        {
            float4 col = tex2Dlod (_NoiseTexture, float4(v.texcoord.xy,0,0));//tex2D(_NoiseTexture, v.texcoord);
            float4 distortion = getDistortion(v.vertex);
            v.vertex.z += distortion.z;
            v.normal = getDistortedNormal(v.vertex, v.normal, _NormalSearch);
        }

        struct Input {
            float2 uv_MainTex;
            float3 worldNormal; INTERNAL_DATA
            float3 worldPos;
            float4 screenPos;
        };

        struct SurfaceOutputT
        {
            fixed4 Albedo;  // diffuse color
            fixed4 Depth;  // diffuse color
            fixed3 Normal;  // world normal, if written
            fixed3 NormalM; //normal map normal
            fixed3 Position;  // world position, if written
            fixed3 Emission;
            fixed3 Ambience;
            half Specular;  // specular power in 0..1 range
            fixed Gloss;    // specular intensity
            fixed Alpha;    // alpha for transparencies
        };
        
        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _CameraDepthTexture;
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

        inline half4 LightingWater (SurfaceOutputT s, half3 viewDir, UnityGI gi) {

            float3 normC = normalize(normalize(s.Normal) + s.NormalM);

            float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
            float NdotL = pow(saturate(dot(normalize(normC) , lightDir)), _ShadingIntensity);

            float3 H = normalize(lightDir + normalize(viewDir));
            float P = dot(normalize(viewDir), normalize(s.Normal));
            float NdotH = dot(normC, H);
            float specIntensity = 1.0 - saturate(pow(NdotH, s.Gloss));

            float3 R = 2.0 * (normC) * dot((normC), normalize(lightDir)) - normalize(lightDir);
            float spec2 = _SpecColor * pow(max(0, dot(R, normalize(viewDir))), _Glossiness);
            specIntensity = spec2;

            float rimDot = clamp((1.0 - dot(normalize(viewDir), normalize(s.Normal))), -50.0, 50.0);
            float rim = pow(rimDot, _RimAmount);

            float depth = s.Depth * _DepthMultiplier;

            float backLighting = pow(saturate(dot(normalize(viewDir), (-1.0 * lightDir - s.Normal * _BackLightNormalStrength))), _BackLightPower) * _BackLightStrength;
            float frontLighting = pow(saturate(dot(normalize(viewDir), (1.0 * lightDir - s.Normal * _BackLightNormalStrength))), _BackLightPower) * _BackLightStrength * depth;

            // float fakeDensity = saturate((dot(float3(0.0, 0.0, 1.0), s.Normal)) + (dot(float3(1.0, 0.0, 0.0), s.Normal))) * _FakeDensityMult;
            // float fakeDensity = 1.0 - saturate((dot(float3(0.0, 1.0, 0.0), s.Normal))) * _FakeDensityMult;
            float fakeDensity = saturate((0.0 + (normalize(s.Normal).z))) * _FakeDensityMult;
            float fakeDensity2 = saturate((1.0 - (normalize(s.Normal).z))) * _DepthMultiplier;
            backLighting *= fakeDensity;
            // frontLighting *= fakeDensity;

            float4 col = _AmbientColor;
            col += rim * _RimColor;
            col += specIntensity * _SpecularColor;
            col += NdotL * _Color * fakeDensity2;
            col += backLighting * _BacklightColor;
            col += frontLighting * _BacklightColor * _FrontLightingStrength;
            // col += spec2;
            return col;
        }

        inline void LightingWater_GI (SurfaceOutputT s, UnityGIInput data, inout UnityGI gi){
            
        }

        void surf (Input IN, inout SurfaceOutputT o) {
            // float refraction = getDistortion(IN.worldPos.y, IN.) * 1.0;

            float2 tex = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
            half4 c = tex2D (_NoiseTexture, IN.uv_MainTex);
            half4 depth = tex2D (_CameraDepthTexture, tex);

            o.Depth = depth;
            o.Albedo = c;
            o.Gloss = _Glossiness;
            o.Ambience = float3(_AmbientColor.r, _AmbientColor.g, _AmbientColor.b);

            float4 norm1 = tex2D(_NormalMap, GetNormUVPositive(IN.uv_MainTex));
            float4 norm2 = tex2D(_NormalMap, GetNormUVNegative(IN.uv_MainTex));
            float4 norm3 = (norm1 + norm2) * _NormalMapStrength2;
            float3 nmNormal = UnpackNormal(norm3) * _NormalMapStrength;
            WorldNormalVector (IN, o.Normal);
            o.NormalM = nmNormal;
            o.Position = IN.worldPos;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
