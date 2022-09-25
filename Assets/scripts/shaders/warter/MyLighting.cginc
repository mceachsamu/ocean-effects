float4 getBaseLighting(float3 normC, float3 normal, float3 lightDir) {
    float NdotL = pow(saturate(dot(normC , lightDir)), 0.4);
    float troughEmphisis = saturate((1.0 - (normalize(normal).z))) * _DepthMultiplier;

    return NdotL * _Color * troughEmphisis;
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
    float backLightingDot = dot(viewDir, (-1.0 * (lightDir + normal * _BackLightNormalStrength)));
    
    // float backLightingDot = 1.0 - clamp(dot(normal, (-1.0 * lightDir)), 0.0, 1.0);
    float backLighting = pow(saturate(backLightingDot), _BackLightPower) * _BackLightStrength;
    
    //we want backlighting to be strongest at the point where the wave is facing horizontally
    float fakeDensity = saturate((normal.z)) * _FakeDensityMult;
    //we call it fake density because its supposed to estimate the density/thickness of a wave

    return backLighting * _BacklightColor * fakeDensity;
}

float4 getFrontLighting(float3 normal, float3 viewDir, float3 lightDir){
    float frontDot = dot(normalize(viewDir), (lightDir - normal * _BackLightNormalStrength));
    float frontLighting = pow(saturate(frontDot), _BackLightPower) * _BackLightStrength;

    float fakeDensity = saturate(normal.z) * _FakeDensityMult;

    return frontLighting * _BacklightColor * _FrontLightingStrength * fakeDensity;
}

float4 getLighting(float3 normal, float3 normalMapNormal, float3 viewDir)
{
    // we want to combine the mesh normal and the normal map normal for specific lighting
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

    float3 normC = normalize(normal + normalMapNormal);

    float4 baseColor = getBaseLighting(normC, normal, lightDir);

    float4 specularColor = getSpecularLighting(lightDir, normC, viewDir);

    float4 rimColor = getRimLighting(normal, viewDir);

    float4 backLighting = getBackLighting(normC, viewDir, lightDir);

    // float frontLighting = pow(saturate(dot(normalize(viewDir), (1.0 * lightDir - s.Normal * _BackLightNormalStrength))), _BackLightPower) * _BackLightStrength * depth;

    float4 frontLighting = getFrontLighting(normal, viewDir, lightDir);



    float4 col = _AmbientColor;
    col += baseColor;
    col += specularColor;
    col += rimColor;
    col += backLighting;
    // col += frontLighting;
    return col * _LightingOverall;
}
