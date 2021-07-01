using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class camera : MonoBehaviour
{
    
    public GameObject water;

    [Range(0.0f, 10.0f)]
    public float lift = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float height = water.GetComponent<warterScript>().getHeight(this.transform.position);
        Vector3 pos = this.transform.position;
        pos.y = height + lift;
        // pos.z -= 0.005f;
        this.transform.position = pos;

        water.GetComponent<warterScript>().setPos(this.transform.position);
    }
}
