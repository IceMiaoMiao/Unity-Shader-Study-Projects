// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Books/Chapter 6/Diffuse Vertex-Level"
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
                fixed3 color:COLOR;
                
            };

            v2f vert(a2v v) {
				v2f o;
				// Transform the vertex from object space to projection space
				o.pos = UnityObjectToClipPos(v.vertex);
				//顶点着色器最基本的任务
            	
				//得到环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				// Transform the normal from object space to world space
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

            	
				//得到光源方向（场景光源只有一个且是平行光时，才可以用_WorldSpaceLightPos0得到光源方向）
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				//
				//（法线与光源方向之间的点积）与光源的颜色和强度以及材质的漫反射的颜色相乘即可得到漫反射光照
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				
				o.color = ambient + diffuse;
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
			}
            
            ENDCG
        }
    } 
	Fallback "Diffuse"   
}
