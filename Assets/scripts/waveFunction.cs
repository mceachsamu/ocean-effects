using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waveFunction : MonoBehaviour
{
    public float amplitude;
    public bool isAbs;
    public Modifier modifier;
    public float frequency;
    public float waveSpeed;

    public float propX;
    public float propZ;

    public enum Modifier {
        cos,
        sin
    }
    
    // interperated all our values as floats, and insert them into a matrix
    public Matrix4x4 ToMatrix() {
        Matrix4x4 waveData = new Matrix4x4();
        Vector4 firstRow = new Vector4();
        
        firstRow.x = amplitude;
        firstRow.y = boolToFloat(isAbs);
        firstRow.z = modifierToFloat(modifier);
        firstRow.w = frequency;

        
        Vector4 secondRow = new Vector4();
        secondRow.x = waveSpeed;
        secondRow.y = propX;
        secondRow.z = propZ;

        waveData.SetRow(0, firstRow);
        waveData.SetRow(1, secondRow);

        return waveData;
    }


    private float boolToFloat(bool b) {
        if (b) {
            return 1.0f;
        }

        return 0.0f;
    }

    private float modifierToFloat(Modifier modifier) {
        switch (modifier) {
            case Modifier.cos:
                return 0.0f;
            case Modifier.sin:
                return 1.0f;
            default:
                return -1.0f;
        }
    }
}
