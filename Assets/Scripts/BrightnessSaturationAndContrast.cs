
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrightnessSaturationAndContrast : PostEffectsBase
{
    public Shader briSatConShader;
    private Material briSatMaterial;

    public Material material
    {
        get
        {
            briSatMaterial = CheckShaderAndCreateMaterial(briSatConShader, briSatMaterial);
            return briSatMaterial;
        }

    }

    [Range(0.0f, 3.0f)] public float brightness = 1.0f;
    [Range(0, 3)] public float saturation = 1.0f;
    [Range(0f, 3f)] public float contrast = 1.0f;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material!=null)
        {
            material.SetFloat("_Brigthness",brightness);
            material.SetFloat("_Stauration",saturation);
            material.SetFloat("_Contrast",contrast);
            Graphics.Blit(src,dest,material);
            
        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
