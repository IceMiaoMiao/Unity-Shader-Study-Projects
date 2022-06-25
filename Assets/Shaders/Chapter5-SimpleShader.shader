// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Books/Chapter5/Simple Shader"//定义shader的名字和位置
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            //包含CG代码片段
            #pragma vertex vert
            #pragma fragment frag
            //编译指令，告诉unity哪个函数包含了顶点着色器或者片元着色器的代码

            struct a2v//使用结构体定义顶点着色器的输入
            {
                float4 veretx:POSITION;
                //使用POSITION语义，意为用模型空间的顶点坐标填充vertex变量
                float3 normal:NORMAL;
                //使用NORMAL语义，意为用模型空间的法线方向填充normal变量
                float4 texcoord : TEXCOORD0;
                //使用TEXCOORD0语义，意为用模型的第一套纹理坐标填充texcoord变量
            };
            
            float4 vert(float4 v:POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(v);
                
            }
            fixed4 frag():SV_Target
            {
                return fixed4(1.0,1.0,1.0,1.0);
            }
            
            ENDCG   
        }
    }
}
