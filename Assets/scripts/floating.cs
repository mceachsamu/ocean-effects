using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class floating : MonoBehaviour
{

    public GameObject warter;

    private Rigidbody rigidBody;

    // Start is called before the first frame update
    void Start()
    {
        this.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        float height = warter.GetComponent<warterScript>().getHeight(this.transform.position);
        Vector3 pos = this.transform.position;

        if (pos.y < height) {
            this.GetComponent<Rigidbody>().AddForce(new Vector3(0.0f,4.0f,0.0f));
        }
        // pos.y = height;
        // this.transform.position = pos;
    }
}
