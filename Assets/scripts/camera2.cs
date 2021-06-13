using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class camera2 : MonoBehaviour
{
    public Shader shader;

    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Camera>().SetReplacementShader (shader, "RenderType");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
