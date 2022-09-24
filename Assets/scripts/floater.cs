using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class floater : MonoBehaviour
{
    public GameObject warter;
    private Rigidbody rb;
    public float buoyancey;
    // Start is called before the first frame update
    void Start()
    {
        this.rb = this.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        float height = warter.GetComponent<warterScript>().getHeight(this.transform.position);

        Vector3 pos = this.transform.position;
        if (pos.y < height) {
            rb.AddForce(new Vector3(0.0f, 1.0f, 0.0f) * buoyancey);
        }
    }
}
