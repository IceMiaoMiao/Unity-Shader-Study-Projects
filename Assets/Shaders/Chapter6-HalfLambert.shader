// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Books/Chapter 6/Half Lambert"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        //为了得到并且控制材质的漫反射颜色
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            //LightMode标签是Pass标签中的一种，它用于定义该Pass在Unity的光照流水线中的角色
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            fixed4 _Diffuse;
            //定义与属性类型相匹配的变量，得到材质的漫反射属性

            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;
                
            };

            v2f vert(a2v v)
            {
				v2f o;
				// Transform the vertex from object space to projection space
                o . pos = UnityObjectToClipPos(v.vertex);
                // Transform the normal from object space to world space
                o . worldNormal = mul(v . normal, (float3x3)unity_WorldToObject);
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			    //得到环境光

				fixed3 worldNormal = normalize(i.worldNormal);
				//把法线归一化

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//得到光线在世界坐标下的方向

				fixed halfLambert = dot(worldNormal,worldLightDir)*0.5+0.5;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
				//计算漫反射

				fixed3 color = ambient + diffuse;

				return fixed4(color,1.0);
			}
            
            ENDCG
        	
        }
    } 
	Fallback "Diffuse"   
}
