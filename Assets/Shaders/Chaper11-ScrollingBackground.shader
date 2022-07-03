
Shader "Unity Shader Books/Chapter 11/Scrolling Background"
{
    Properties
    {
        _MainTex ("Base Layer(RGB)", 2D) = "white" {}
        _DetailTex("2nd Layer(RGB)",2D)="white"{}
        _ScrollX("Base layer Scroll Speed",Float)=1.0
        _ScrollY("2nd layer Scroll Speed",Float)=1.0
        _Multiplier("Layer Multiplier",Float)=1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		
		Pass { 
			Tags { "LightMode"="ForwardBase" }
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _DetailTex;
			float4 _MainTex_ST;
			float4 _DetailTex_ST;
			float _ScrollX;
			float _Scroll2X;
			float _Multiplier;
			
			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};
			
			v2f vert (a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(float2(_ScrollX, 0.0) * _Time.y);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(float2(_Scroll2X, 0.0) * _Time.y);
				//利用 TRANSFORM_TEX 来得到初始的纹理坐标。
				//利用内置的 _Time.y 变量在水平方向上对纹理坐标进行偏移，以此达到滚动的效果。
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 firstLayer = tex2D(_MainTex, i.uv.xy);
				fixed4 secondLayer = tex2D(_DetailTex, i.uv.zw);
				
				fixed4 c = lerp(firstLayer, secondLayer, secondLayer.a);
				//使用第二层纹理的透明通道来混合两张纹理
				c.rgb *= _Multiplier;
				
				return c;
			}
			
			ENDCG
		}
    }
    FallBack "VertexLit"
}
