// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Books/Chapter 6/BlinnPhong"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256)) = 200
        //声明属性，方便控制参数
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            //由于颜色属性的范围在 0 到 1 之间，因此对于_Diffuse和_Specular属性我们可以使用fixed精度的变量来存储
            //而 _Gloss的范围很大，因此我们使用float精度来存储。
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                
            };
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));\           

                return o;
                
            }
            fixed4 frag(v2f i):SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal,worldLightDir));

                fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir+viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

                return fixed4(ambient+diffuse+specular,1.0);
                
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
