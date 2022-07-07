using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using Unity.VisualScripting;
using UnityEngine;

public class MotionBlurWithDepthTexture : PostEffectsBase
{
    public Shader motionBlurShader;
    private Material motionBlurMaterial=null;

    public Material material
    {
        get
        {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader, motionBlurMaterial);
            return motionBlurMaterial;
        }
    }

    [Range(0.0f, 1.0f)] public float blurSize = 0.5f;
    private Camera myCamera;

    public Camera camera
    {
        get
        {
            myCamera = GetComponent<Camera>();
            return myCamera;
        }
    }

    private Matrix4x4 previousViewProjectionMatrix;
    //保存上一帧摄像机的视角*投影矩阵
    private void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;
        
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material!=null)
        {
            
            material.SetFloat("_BlurSize",blurSize);
            material.SetMatrix("_PreviousViewProjectionMatrix",previousViewProjectionMatrix);
            Matrix4x4 currentViewProMat = camera.projectionMatrix * camera.worldToCameraMatrix;
            Matrix4x4 currentViewInvMat = currentViewProMat.inverse;
            material.SetMatrix("_CurrentViewProjectionInverseMatrix",currentViewInvMat);
            previousViewProjectionMatrix = currentViewProMat;
            Graphics.Blit(src,dest,material);

        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
