using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class floating : MonoBehaviour
{

    public GameObject warter;

    public GameObject[] floaters;

    public float bouyancyForce = 0.4f;

    [Range(1.0f, 100.0f)]
    public float dampening = 10.0f;


    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
    }
}
