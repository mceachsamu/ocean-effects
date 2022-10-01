using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class warterScript : MonoBehaviour
{
    public GameObject[] waveFunctionObjects;

    public float WaveFrequency = 210.0f;
    public float WaveFrequencySmall = 210.0f;

    public float WaveSpeed = 24.7f;
    
    public float SmallWaveSpeed = 24.7f;

    public float WaveHeight = 0.0005f;
    public float WaveHeight2 = 0.0005f;
    public Color Color = new Color(1.0f * 255.0f,1.0f * 255.0f,1.0f * 255.0f,0.0f * 255.0f);
    public Color SpecColor = new Color(0.5f * 255.0f,0.5f * 255.0f,0.5f * 255.0f,0.5f * 255.0f);
    public Color SpecularColor = new Color(0.5f * 255.0f,0.5f * 255.0f,0.5f * 255.0f,0.5f * 255.0f);
    public Color AmbientColor = new Color(0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f);
    public Color RimColor = new Color(0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f);
    public Color BacklightColor = new Color(0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f,0.0f * 255.0f);
    public float count = 0;
    
    [Range(0.0f, 5.0f)]
    public float RimAmount = 1.0f;

    [Range(0.0f, 50.0f)]
    public float Glossiness = 1.0f;

    [Range(0.0f, 30.0f)]
    public float ShadingIntensity = 1.0f;

    [Range(0.0f, 30.0f)]
    public float NormalMapStrength = 1.0f;

    [Range(0.0f, 1.0f)]
    public float NormalMapStrength2 = 1.0f;

    [Range(0.0f, 1.0f)]
    public float NormalMapDisplacement = 1.0f;

    [Range(0.0f, 1.0f)]
    public float NormalScrollSpeed = 1.0f;

    [Range(0.0f, 40.0f)]
    public float TextureFrequency = 1.0f;

    [Range(0.0f, 1.0f)]
    public float BackLightNormalStrength = 0.5f;
    [Range(0.0f, 10.0f)]
    public float BackLightPower = 1.0f;

    [Range(0.0f, 10.0f)]
    public float BackLightStrength = 1.0f;

    [Range(0.0f, 5.0f)]
    public float DepthMultiplier = 1.0f;

    [Range(0.0f, 5.0f)]
    public float FakeDensityMult = 1.0f;

    [Range(0.0f, 1.0f)]
    public float FrontLightingStrength = 0.5f;

    [Range(0.0f, 1.0f)]
    public float LightingOverall = 1.0f;

    [Range(0.0f, 1.0f)]
    public float UnderWaterIntensity = 1.0f;

    [Range(0.0f, 1.0f)]
    public float UnderWaterDistortion = 1.0f;

    public float NormalSearch = 0.01f;

    public GameObject water1;

    private Matrix4x4[] waveData = new Matrix4x4[1];

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        count+= 0.0005f;
        waveData = WaveFunctionsToMatrixArray(waveFunctionObjects);
        setShaderProperties(water1);
    }

    private Matrix4x4[] WaveFunctionsToMatrixArray(GameObject[] waveFunctions) {
        Matrix4x4[] waveData = new Matrix4x4[waveFunctions.Length];
        for (int i = 0 ; i < waveFunctions.Length; i++) {
            waveData[i] = waveFunctions[i].GetComponent<waveFunction>().ToMatrix();
        }

        return waveData;
    }

    private void setShaderProperties(GameObject g) {

        SetWaveDistortionProperties(g);

        g.GetComponent<Renderer>().material.SetFloat("_RimAmount", RimAmount);
        g.GetComponent<Renderer>().material.SetFloat("_Glossiness", Glossiness);
        g.GetComponent<Renderer>().material.SetFloat("_ShadingIntensity", ShadingIntensity);
        g.GetComponent<Renderer>().material.SetFloat("_NormalMapStrength", NormalMapStrength);
        g.GetComponent<Renderer>().material.SetFloat("_NormalMapStrength2", NormalMapStrength2);
        g.GetComponent<Renderer>().material.SetFloat("_NormalMapDisplacement", NormalMapDisplacement);
        g.GetComponent<Renderer>().material.SetFloat("_NormalScrollSpeed", NormalScrollSpeed);
        g.GetComponent<Renderer>().material.SetFloat("_TextureFrequency", TextureFrequency);
        g.GetComponent<Renderer>().material.SetFloat("_BackLightNormalStrength", BackLightNormalStrength);
        g.GetComponent<Renderer>().material.SetFloat("_BackLightPower", BackLightPower);
        g.GetComponent<Renderer>().material.SetFloat("_BackLightStrength", BackLightStrength);
        g.GetComponent<Renderer>().material.SetFloat("_DepthMultiplier", DepthMultiplier);
        g.GetComponent<Renderer>().material.SetFloat("_FakeDensityMult", FakeDensityMult);
        g.GetComponent<Renderer>().material.SetFloat("_FrontLightingStrength", FrontLightingStrength);
        g.GetComponent<Renderer>().material.SetFloat("_NormalSearch", NormalSearch);
        g.GetComponent<Renderer>().material.SetFloat("_LightingOverall", LightingOverall);
        g.GetComponent<Renderer>().material.SetFloat("_UnderWaterIntensity", UnderWaterIntensity);
        g.GetComponent<Renderer>().material.SetFloat("_UnderWaterDistortion", UnderWaterDistortion);

        g.GetComponent<Renderer>().material.SetVector("_Color", Color);
        g.GetComponent<Renderer>().material.SetVector("_SpecColor", SpecColor);
        g.GetComponent<Renderer>().material.SetVector("_SpecularColor", SpecularColor);
        g.GetComponent<Renderer>().material.SetVector("_AmbientColor", AmbientColor);
        g.GetComponent<Renderer>().material.SetVector("_RimColor", RimColor);
        g.GetComponent<Renderer>().material.SetVector("_BacklightColor", BacklightColor);
    }

    public void SetWaveDistortionProperties(GameObject g) {
        Material material = g.GetComponent<Renderer>().material;
        material.SetMatrixArray("_WaveFunctions", waveData);
        material.SetInt("_NumFunctions", waveData.Length);

        material.SetFloat("_WaveFrequency", WaveFrequency);
        material.SetFloat("_WaveFrequencySmall", WaveFrequencySmall);
        material.SetFloat("_WaveSpeed", WaveSpeed);
        material.SetFloat("_SmallWaveSpeed", SmallWaveSpeed);
        material.SetFloat("_WaveHeight", WaveHeight);
        material.SetFloat("_WaveHeight2", WaveHeight2);

        material.SetFloat("_T", count);
    }

    public float getHeight(Vector3 pos) {
        float height = this.transform.position.y;
        for (int i = 0; i < waveFunctionObjects.Length; i++) {
            height += executeWaveFunction(pos, waveFunctionObjects[i].GetComponent<waveFunction>());
        }
        return height;
    }

    private float executeWaveFunction(Vector3 pos, waveFunction wave) {        
        float time = count;
        float output = (pos.x * wave.propX + pos.z * wave.propZ) * WaveFrequency/wave.frequency + time * WaveSpeed * wave.waveSpeed;

        if (wave.modifier == waveFunction.Modifier.cos) {
            output = Mathf.Cos(output);
        }
        if (wave.modifier == waveFunction.Modifier.sin) {
            output = Mathf.Sin(output);
        }

        if (wave.isAbs) {
            output = Mathf.Abs(output);
        }

        return output * WaveHeight * wave.amplitude;
    }

}
