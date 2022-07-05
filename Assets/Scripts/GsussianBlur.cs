using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GsussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial;

    public Material material
    {
        get
        {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
            
        }
    }

    [Range(0, 4)] public int iterations = 3;
    [Range(0.2f, 3f)] public float blurSpread = 0.6f;
    //_BlurSize 越大，模糊程度越高 ， 但采样数却不会受到影响。但过大的 _BlurSize 值会造成虚影 ， 
    [Range(1, 8)] public int downSample = 2;
    //而 downSample 越大 ， 需要 处 理的像素数越少，同时也能进一步提高模糊程度,但过大会导致图像像素化
    
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material!=null)
        {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;
            RenderTexture buffer0=RenderTexture.GetTemporary(rtW,rtH,0);
            //利用RenderTexture.GetTemporary函数分配了一块与屏幕图像大小相同的缓冲区。
            buffer0.filterMode = FilterMode.Bilinear;
            Graphics.Blit(src,buffer0);
            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize",1.0f+i*blurSpread);
                RenderTexture buffer1=RenderTexture.GetTemporary(rtW,rtH,0);
                Graphics.Blit(buffer0,buffer1,material,0);
                RenderTexture.ReleaseTemporary(buffer0);
                //调用 RenderTexture . ReleaseTemporary 来释放之前分 配 的缓存。
                buffer0 = buffer1;
                buffer1=RenderTexture.GetTemporary(rtW,rtH,0);
                Graphics.Blit(buffer0,buffer1,material,1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            Graphics.Blit(buffer0,dest);
            RenderTexture.ReleaseTemporary(buffer0);
            
        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
