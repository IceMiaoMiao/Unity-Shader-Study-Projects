using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class Translating : MonoBehaviour
{
    public float speed=0.5f;
    private void Update()
    {
        this.transform.position += new Vector3(speed * Time.deltaTime, 0, 0);
    }
}
