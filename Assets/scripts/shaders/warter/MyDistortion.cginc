
float4 getDistortion(float4 position) {
    float4 wPosition = mul (unity_ObjectToWorld, position);
    float time = _T * _WaveSpeed;


    float z = 0.0;
    // These waves are much larger must use constants so that we can track them in the cpu
    z -= 1.0 * (sin(wPosition.x * _WaveFrequency/_wF1 + _T * _WaveSpeed*_wS1)) * _WaveHeight*_wH1;
    z -= 1.0 * (sin((wPosition.z/_wFZ2 - wPosition.x/_wFX2) * _WaveFrequency/_wF2 + _T * _WaveSpeed*_wS2)) * _WaveHeight* _wH2;
    z -= 1.0 * abs(sin(wPosition.z * _WaveFrequency/_wF3 + _T * _WaveSpeed*_wS3)) * _WaveHeight*_wH3;
    
    // These waves are small and the cpu can ignore them
    z -= 1.0 * abs(sin((wPosition.z + wPosition.x/24.0) * _WaveFrequency/50.0 - _T * _WaveSpeed * 3.5)) * _WaveHeight*240.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x) * _WaveFrequency/100.0 - _T * _WaveSpeed * 1.5)) * _WaveHeight*240.0;
    z -= 1.0 * (sin((wPosition.z/3.0 + wPosition.x/8.0) * _WaveFrequency/10.0 - _T * _WaveSpeed * 2.1)) * _WaveHeight*350.0;
    z -= 1.0 * abs(sin((wPosition.z/8.0 + wPosition.x/2.0) * _WaveFrequency/15.0 - _T * _WaveSpeed * 4.2)) * _WaveHeight*400.0;
    z -= 1.0 * abs(sin((wPosition.z/2.0) * _WaveFrequency/10.0 + _T * _WaveSpeed * 1.2)) * _WaveHeight*500.0;
    

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
