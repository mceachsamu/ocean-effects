using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class warterScript : MonoBehaviour
{
    
    public float wF1 = 600.0f;
    public float wS1 = 0.99f;
    public float wH1 = 1600.0f;

    public float wFX2 = 4.0f;
    public float wFZ2 = 3.0f;
    public float wF2 = 100.0f;
    public float wS2 = 0.6f;
    public float wH2 = 2000.0f;

    public float wF3 = 200.0f;
    public float wS3 = 0.6f;
    public float wH3 = 2000.0f;
    
    public float wF4 = 200.0f;
    public float wS4 = 0.6f;
    public float wH4 = 2000.0f;

    public float WaveFrequency = 210.0f;

    public float WaveSpeed = 24.7f;

    public float WaveHeight = 0.0005f;
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

    public float NormalSearch = 0.01f;

    public GameObject water1;
    // public GameObject water2;
    // public GameObject water3;
    // public GameObject water4;
    // public GameObject water5;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        count+= 0.0005f;
        setShaderProperties(water1);
    }

    public void setPos(Vector3 position) {
        Vector3 pos = this.transform.position;
        pos.z = position.z;
        this.transform.position = pos;
    }

    public void setShaderProperties(GameObject g) {
        g.GetComponent<Renderer>().material.SetFloat("_wF1", wF1);
        g.GetComponent<Renderer>().material.SetFloat("_wS1", wS1);
        g.GetComponent<Renderer>().material.SetFloat("_wH1", wH1);
        g.GetComponent<Renderer>().material.SetFloat("_wFX2", wFX2);
        g.GetComponent<Renderer>().material.SetFloat("_wFZ2", wFZ2);
        g.GetComponent<Renderer>().material.SetFloat("_wF2", wF2);
        g.GetComponent<Renderer>().material.SetFloat("_wS2", wS2);
        g.GetComponent<Renderer>().material.SetFloat("_wH2", wH2);
        g.GetComponent<Renderer>().material.SetFloat("_wF3", wF3);
        g.GetComponent<Renderer>().material.SetFloat("_wS3", wS3);
        g.GetComponent<Renderer>().material.SetFloat("_wH3", wH3);
        g.GetComponent<Renderer>().material.SetFloat("_wF4", wF4);
        g.GetComponent<Renderer>().material.SetFloat("_wS4", wS4);
        g.GetComponent<Renderer>().material.SetFloat("_wH4", wH4);

        g.GetComponent<Renderer>().material.SetFloat("_WaveFrequency", WaveFrequency);
        g.GetComponent<Renderer>().material.SetFloat("_WaveSpeed", WaveSpeed);
        g.GetComponent<Renderer>().material.SetFloat("_WaveHeight", WaveHeight);

        g.GetComponent<Renderer>().material.SetFloat("_T", count);

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

        g.GetComponent<Renderer>().material.SetVector("_Color", Color);
        g.GetComponent<Renderer>().material.SetVector("_SpecColor", SpecColor);
        g.GetComponent<Renderer>().material.SetVector("_SpecularColor", SpecularColor);
        g.GetComponent<Renderer>().material.SetVector("_AmbientColor", AmbientColor);
        g.GetComponent<Renderer>().material.SetVector("_RimColor", RimColor);
        g.GetComponent<Renderer>().material.SetVector("_BacklightColor", BacklightColor);
    }

    public float getHeight(Vector3 pos) {
        float height = this.transform.position.y;
        float time = count;
        height -= 1.0f * (Mathf.Sin(pos.x * WaveFrequency/wF1 + time * WaveSpeed*wS1)) * WaveHeight*wH1;
        height -= 1.0f * (Mathf.Sin((pos.z/wFZ2 - pos.x/wFX2) * WaveFrequency/wF2 + time * WaveSpeed*wS2)) * WaveHeight * wH2;
        height -= 1.0f * Mathf.Abs(Mathf.Sin(pos.z * WaveFrequency/wF3 + time * WaveSpeed*wS3)) * WaveHeight*wH3;
        height -= 1.0f * Mathf.Abs(Mathf.Sin(pos.z * WaveFrequency/wF4 + time * WaveSpeed*wS4)) * WaveHeight*wH4;
        return height;
    }
}
