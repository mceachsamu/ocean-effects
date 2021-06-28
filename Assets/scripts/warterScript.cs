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

    public float WaveFrequency = 210.0f;

    public float WaveSpeed = 24.7f;

    public float WaveHeight = 0.0005f;

    public float count = 0;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        count+= 0.0005f;

        this.GetComponent<Renderer>().material.SetFloat("_wF1", wF1);
        this.GetComponent<Renderer>().material.SetFloat("_wS1", wS1);
        this.GetComponent<Renderer>().material.SetFloat("_wH1", wH1);
        this.GetComponent<Renderer>().material.SetFloat("_wFX2", wFX2);
        this.GetComponent<Renderer>().material.SetFloat("_wFZ2", wFZ2);
        this.GetComponent<Renderer>().material.SetFloat("_wF2", wF2);
        this.GetComponent<Renderer>().material.SetFloat("_wS2", wS2);
        this.GetComponent<Renderer>().material.SetFloat("_wH2", wH2);
        this.GetComponent<Renderer>().material.SetFloat("_wF3", wF3);
        this.GetComponent<Renderer>().material.SetFloat("_wS3", wS3);
        this.GetComponent<Renderer>().material.SetFloat("_wH3", wH3);

        this.GetComponent<Renderer>().material.SetFloat("_WaveFrequency", WaveFrequency);
        this.GetComponent<Renderer>().material.SetFloat("_WaveSpeed", WaveSpeed);
        this.GetComponent<Renderer>().material.SetFloat("_WaveHeight", WaveHeight);

        this.GetComponent<Renderer>().material.SetFloat("_T", count);
    }

  public float getHeight(Vector3 pos) {
        float height = this.transform.position.y;
        float time = count;
        height -= 1.0f * (Mathf.Sin(pos.x * WaveFrequency/wF1 + time * WaveSpeed*wS1)) * WaveHeight*wH1;
        height -= 1.0f * (Mathf.Sin((pos.z/wFZ2 - pos.x/wFX2) * WaveFrequency/wF2 + time * WaveSpeed*wS2)) * WaveHeight * wH2;
        height -= 1.0f * (Mathf.Sin(pos.z * WaveFrequency/wF3 + time * WaveSpeed*wS3)) * WaveHeight*wH3;
        return height;
    }
}
