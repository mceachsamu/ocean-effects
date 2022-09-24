
float4 getDistortion(float4 position) {
    float4 wPosition = mul (unity_ObjectToWorld, position);
    float time = _T * _WaveSpeed;

    float z = 0.0;
    // These waves are much larger must use constants so that we can track them in the cpu
    z -= 1.0 * (sin(wPosition.x * _WaveFrequency/_wF1 + _T * _WaveSpeed*_wS1)) * _WaveHeight*_wH1;
    z -= 1.0 * (sin((wPosition.z/_wFZ2 - wPosition.x/_wFX2) * _WaveFrequency/_wF2 + _T * _WaveSpeed*_wS2)) * _WaveHeight* _wH2;
    z -= 1.0 * abs(sin(wPosition.z * _WaveFrequency/_wF3 + _T * _WaveSpeed*_wS3)) * _WaveHeight*_wH3;
    z -= 1.0 * abs(sin(wPosition.z * _WaveFrequency/_wF4 - _T * _WaveSpeed*_wS4)) * _WaveHeight*_wH4;
    
    // These waves are small and the cpu can ignore them
    z -= 1.0 * (sin((wPosition.z + wPosition.x/2.0) * _WaveFrequency/25.0 * _WaveFrequencySmall - _T * _WaveSpeed * 2.5)) * _WaveHeight2*100.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x) * _WaveFrequency/10.0 * _WaveFrequencySmall - _T * _WaveSpeed * 3.5)) * _WaveHeight2*140.0;
    z -= 1.0 * (sin((wPosition.z/3.0 + wPosition.x/8.0) * _WaveFrequency/30.0 * _WaveFrequencySmall - _T * _WaveSpeed * 2.1)) * _WaveHeight2*210.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x/2.0) * _WaveFrequency/20.0 * _WaveFrequencySmall - _T * _WaveSpeed * 2.2)) * _WaveHeight2*180.0;
    z -= 1.0 * abs(sin((wPosition.z/2.0) * _WaveFrequency/10.0 * _WaveFrequencySmall + _T * _WaveSpeed * 2.2)) * _WaveHeight2*120.0;
    
    z -= 1.0 * (sin((wPosition.z + wPosition.x/2.0) * _WaveFrequency/30.0 * _WaveFrequencySmall+ _T * _WaveSpeed * 2.3)) * _WaveHeight2*100.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x) * _WaveFrequency/21.0 * _WaveFrequencySmall + _T * _WaveSpeed * 3.1)) * _WaveHeight2*140.0;
    z -= 1.0 * (sin((wPosition.z/3.0 + wPosition.x/8.0) * _WaveFrequency/24.0 * _WaveFrequencySmall + _T * _WaveSpeed * 2.6)) * _WaveHeight2*210.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x/2.0) * _WaveFrequency/32.0 * _WaveFrequencySmall + _T * _WaveSpeed * 2.8)) * _WaveHeight2*180.0;
    z -= 1.0 * abs(sin((wPosition.z/2.0) * _WaveFrequency/18.0 * _WaveFrequencySmall - _T * _WaveSpeed * 1.5)) * _WaveHeight2*120.0;
    

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
