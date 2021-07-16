struct vertOut
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 normal : NORMAL;
    float3 viewDir : TEXCOORD1;
};

vertOut vertexProgram (appdata_tan v)
{
    vertOut o;

    v.vertex = getDistortion(v.vertex);
    o.vertex = UnityObjectToClipPos(v.vertex);
    
    float3 normal = getDistortedNormal(v.vertex, v.normal, _NormalSearch);
    o.normal = UnityObjectToWorldNormal(normal);

    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    
    o.viewDir = WorldSpaceViewDir(v.vertex);

    return o;
}