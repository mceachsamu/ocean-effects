using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class underwater : MonoBehaviour
{

    public GameObject warter;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float height = warter.GetComponent<warterScript>().getHeight(this.transform.position);
        this.GetComponent<Renderer>().material.SetFloat("_WaterLevel", height);
    }
}
