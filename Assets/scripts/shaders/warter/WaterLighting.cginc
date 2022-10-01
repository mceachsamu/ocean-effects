
uniform float _UnderWaterIntensity;
uniform float _UnderWaterDistortion;

sampler2D _UnderWaterTexture;
float4 _UnderWaterTexture_ST;

float4 getUnderWater(float4 screenPos, float3 normal){
    float2 renderTexUV = float2(screenPos.x + _UnderWaterDistortion * normal.y - _UnderWaterDistortion, screenPos.y + _UnderWaterDistortion * normal.y - _UnderWaterDistortion) / screenPos.w;
    float4 underwater = tex2D(_UnderWaterTexture, renderTexUV);

    // the alpha channel is the strength of the water color
    return underwater * underwater.a;
}

float4 getWaterLighting(float3 normal, float3 normalMapNormal, float3 viewDir, float4 screenPos)
{
    // we want to combine the mesh normal and the normal map normal for specific lighting
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    float3 normC = normalize((normal + normalMapNormal)/2.0);
    float4 baseColor = getBaseLighting(normC, normal, lightDir);
    float4 specularColor = getSpecularLighting(lightDir, normC, viewDir);
    float4 rimColor = getRimLighting(normal, viewDir);
    float4 underWater = getUnderWater(screenPos, normal);
    float4 backLighting = getBackLighting(normC, viewDir, lightDir);

    float4 col = _AmbientColor;
    col += baseColor;
    col += specularColor;
    col += rimColor;
    col += backLighting;
    col += underWater;
    return col * _LightingOverall;
}
