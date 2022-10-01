Shader "Unlit/under-water"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _WaterLevel("water level", float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldPosition : TEXCOORD1;
                float waveHeight : TEXCOORD2;
            };

            #include "MyDistortion.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            uniform float _WaterLevel;

            v2f vert (appdata_tan v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = float4(1.0, 0.0, 0.0, 1.0);//tex2D(_MainTex, i.uv * 5.0);

                float fade = pow((_WaterLevel - i.worldPosition.y), 0.5)/2.0;
                float4 c = col;

                // pu the fade strength onto the alpha channel
                c.a = (1.0 - fade);
                return c;
            }

            ENDCG
        }
    }
}
