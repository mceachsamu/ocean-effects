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
uniform float _LightingOverall;

float4 getBaseLighting(float3 normC, float3 normal, float3 lightDir) {
    float NdotL = saturate(dot(normC , lightDir));
    float troughEmphisis = saturate((1.0 - (normalize(normal).z))) * _DepthMultiplier;

    return NdotL * _Color;
}

float4 getSpecularLighting(float3 lightDir, float3 normal, float3 viewDir) {
    float3 R = 2.0 * (normal) * dot((normal), normalize(lightDir)) - normalize(lightDir);
    float spec = pow(max(0, dot(R, normalize(viewDir))), _Glossiness);

    return spec * _SpecularColor;
}

float4 getRimLighting(float3 normal, float3 viewDir) {
    float rimDot = clamp((1.0 - dot(normalize(viewDir), normalize(normal))), -50.0, 50.0);
    float rim = pow(rimDot, _RimAmount);

    return rim * _RimColor;
}

float4 getBackLighting(float3 normal, float3 viewDir, float3 lightDir) {
    float backLightingDot = saturate(dot(viewDir, (-1.0 * (normalize(lightDir + normal * _BackLightNormalStrength)))));
    
    // float backLightingDot = 1.0 - clamp(dot(normal, (-1.0 * lightDir)), 0.0, 1.0);
    float backLighting = pow(backLightingDot, _BackLightPower) * _BackLightStrength;
    
    //we want backlighting to be strongest at the point where the wave is facing horizontally
    float fakeDensity = saturate((1.0 - normal.y)) * _FakeDensityMult;
    //we call it fake density because its supposed to estimate the density/thickness of a wave

    return _BacklightColor * fakeDensity * backLighting;
}

float4 getLighting(float3 normal, float3 normalMapNormal, float3 viewDir, float4 screenPos)
{
    // we want to combine the mesh normal and the normal map normal for specific lighting
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    float3 normC = normalize((normal + normalMapNormal)/2.0);
    float4 baseColor = getBaseLighting(normC, normal, lightDir);
    float4 specularColor = getSpecularLighting(lightDir, normC, viewDir);
    float4 rimColor = getRimLighting(normal, viewDir);
    float4 backLighting = getBackLighting(normC, viewDir, lightDir);

    float4 col = _AmbientColor;
    col += baseColor;
    col += specularColor;
    col += rimColor;
    col += backLighting;
    return col * _LightingOverall;
}
