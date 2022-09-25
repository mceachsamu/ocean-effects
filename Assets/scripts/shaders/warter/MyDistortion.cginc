
float4 getDistortion(float4 position) {
    float4 wPosition = mul (unity_ObjectToWorld, position);

    float z = 0.0;
    for (int i = 0; i < _NumFunctions; i++) {
        // unwrap matrix into functions
        float amplitude = _WaveFunctions[i][0][0];
        float useAbs = _WaveFunctions[i][0][1];
        float modifier = _WaveFunctions[i][0][2];
        float frequency = _WaveFunctions[i][0][3];

        float speed = _WaveFunctions[i][1][0];
        float propX = _WaveFunctions[i][1][1];
        float propZ = _WaveFunctions[i][1][2];

        float input = (wPosition.x * propX + wPosition.z * propZ) * _WaveFrequency/frequency + _T * _WaveSpeed * speed;
    
        // use cosine
        if (modifier == 0.0) {
            input = cos(input);
        }
        // use sine
        if (modifier == 1.0) {
            input = sin(input);
        }

        // use absolute value
        if (useAbs == 1.0) {
            input = abs(input);
        }

        input = input * _WaveHeight * amplitude;
        z += input;
    }
    
    z -= 1.0 * (sin((wPosition.z + wPosition.x/2.0) * _WaveFrequency/30.0 * _WaveFrequencySmall+ _T * _SmallWaveSpeed * 2.3)) * _WaveHeight2*120.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x) * _WaveFrequency/21.0 * _WaveFrequencySmall + _T * _SmallWaveSpeed * 3.1)) * _WaveHeight2*50.0;
    z -= 1.0 * (sin((wPosition.z/3.0 + wPosition.x/8.0) * _WaveFrequency/24.0 * _WaveFrequencySmall + _T * _SmallWaveSpeed * 2.6)) * _WaveHeight2*145.0;
    z -= 1.0 * abs(sin((wPosition.z/3.0 + wPosition.x/2.0) * _WaveFrequency/32.0 * _WaveFrequencySmall + _T * _SmallWaveSpeed * 2.8)) * _WaveHeight2*70.0;
    z -= 1.0 * abs(sin((wPosition.z/2.0) * _WaveFrequency/48.0 * _WaveFrequencySmall - _T * _SmallWaveSpeed * 1.5)) * _WaveHeight2*120.0;
    
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
