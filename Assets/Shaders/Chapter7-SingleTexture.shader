Shader "Unity Shader Books/Chapter 7/Single Texture"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            //使用纹理名_ST的方式来声明某个纹理的属性。其中，ST是缩放(scale)和平移(translation)的缩写。
            //_MainTex_ST可以让我们得到该纹理的缩放和平移 偏移）值，_MainTex_ST.xy 存储的是缩放值，
            //而_MainTex_ST.zw 存储的是偏移值 。这些值可以在材质面板的纹理属性中调节 
            fixed4 _Specular;
            float _Gloss;

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
                
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal=UnityObjectToWorldNormal(v.normal);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
                o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                //先缩放，再偏移
                return o;
            }
            fixed4 frag(v2f i):SV_Target
            {
                fixed3 worldNormal=normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
                //使用纹理对漫反射采样
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));

                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir+viewDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);
                return fixed4(ambient+diffuse+specular,1.0);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
