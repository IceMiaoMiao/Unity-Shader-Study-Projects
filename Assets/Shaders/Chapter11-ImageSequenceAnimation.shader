Shader "Unity Shader Books/Chapter 11/Image Sequence Animation"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Image Sequence", 2D) = "white" {}
        _HorizontalAmount("Horizontal Amount",Float)=4
        _VerticalAmount("Vertical Amount",Float)=4
        //水平方向和竖直方向包含关键帧的个数
        _Speed("Speed",Range(1,100))=30
        
    }
    SubShader
    {
        Tags{"Queue"="Transparent" "IgnoreProjects"="True" "RenderType"="Transparent"}
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            //使用半透明的标配来设置Tags
            CGPROGRAM
            #pragma vertex vert  
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _HorizontalAmount;
			float _VerticalAmount;
			float _Speed;
			  
			struct a2v {  
			    float4 vertex : POSITION; 
			    float2 texcoord : TEXCOORD0;
			};  
			
			struct v2f {  
			    float4 pos : SV_POSITION;
			    float2 uv : TEXCOORD0;
			};
            v2f vert(a2v v)
            {
	            v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);
            	o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
            	return o;
            	
            }
            fixed4 frag(v2f i):SV_Target
            {
            	float time=floor(_Time.y*_Speed);
            	//_Time.y 就是自该场景加载后所经过的时间,与speed相乘得到模拟的时间
            	float row=floor(time/_HorizontalAmount);
            	//行索引
            	float column=time-row*_HorizontalAmount;
            	//列索引
            	half2 uv=i.uv+half2(column,-row);
            	//把原纹理坐标 i.uv按行数和列数进行等分， 得到每个子图像的纹理坐标范围。、
            	//竖直偏移要用减法
            	uv.x/=_HorizontalAmount;
            	uv.y/=_VerticalAmount;
            	//用当前的行列数对结果进行偏移
            	float4 c=tex2D(_MainTex,uv);
            	c.rgb*=_Color;
            	return c;
            }
            ENDCG
        }
    }
        
    FallBack "Transparent/VertexLit"
}
