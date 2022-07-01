Shader "Unity Shader Books/Chapter 9/Alpha Test With Shadow"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Main Tex", 2D) = "white" {}
        _Cutoff("Alpha Cutoff",Range(0,1))=0.5
        //用于决定调用clip进行透明度测试的判断条件，范围是[0,1]，因为纹理像素就是再此范围内
        
    }
    SubShader
    {
        Tags{"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        //使用了透明度测试的Shader都应该在SubShader里面设置这三个标签
        //把 Queue 标 签设置为 AlphaTest
        //RenderType常被用于着色器替换功能，把Shader归到提前定义的组，指明该Shader是用了透明度测试的Shader
        //把IgnoreProjector设置为True,这意味着这个Shader不会受到投影器 (Projectors) 的影响。
        
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Cutoff;

            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 texcoord:TEXCOORD0;
                
                 
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float2 uv:TEXCOORD2;
                SHADOW_COORDS(3)
            };
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
                o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
                TRANSFER_SHADOW(o);
                return o;
                
            }
            fixed4 frag(v2f i):SV_Target
            {
                fixed3 worldNormal=normalize(i.worldNormal);
                fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed4 texColor=tex2D(_MainTex,i.uv);
                clip(texColor.a-_Cutoff);
                fixed3 albedo = texColor.rgb*_Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
                fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
                UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
                return fixed4(ambient+diffuse*atten,1.0);
                
            }
            ENDCG
        }
    }
    FallBack "Transparent/Cutout/VertexLit"
}
