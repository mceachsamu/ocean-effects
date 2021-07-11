Shader "Unlit/underwater"
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            uniform float _WaterLevel;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv * 5.0);

                float fade = pow((_WaterLevel - i.worldPosition.y), 0.5)/1.5 + 0.2;
                float4 c = col * 0.3;
                return float4(0.0,0.0,0.0,1.0) + fade * float4(1.0,1.0,1.0,0.0) - c;
            }
            ENDCG
        }
    }
}
