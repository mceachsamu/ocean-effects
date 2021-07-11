struct vertOut
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
};

vertOut vertexProgram (appdata_tan v)
{
    vertOut o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.texcoord, _MainText);
    return o;
}