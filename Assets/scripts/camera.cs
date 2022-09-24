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
        this.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
        Application.targetFrameRate = 60;
    }

    // Update is called once per frame
    void Update()
    {    }
}
