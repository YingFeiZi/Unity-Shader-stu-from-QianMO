Shader "cy_shader/32.SurfaceTexDetBumpRim"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _BumpMap("【凹凸贴图】Bumpmap", 2D) = "bump" {}
        _Detail("【细节纹理】Detail", 2D) = "detail" {}
        _ColorTint("【光泽色】Tint", Color) = (1,1,1,1)
        _RimColor("【边缘颜色】Rim Color", Color) = (0.1,0.1,0.1,0)
        _RimPower("【边缘颜色强度】Rim Powe", Range(0.05, 8)) = 3.0
    }
    SubShader
    {
        Tags{ "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surtme Lambert finalcolor:mycolor
        //struct
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_Detail;
            float viewDir;
        };
        //variable
        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Detail;
        float4 _ColorTint;
        float4 _RimColor;
        float _RimPower;
        /*
        //mycolor function
        void mycolor(Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }

        //function surtme
        void surtme(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * 2;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        */
        //【3】自定义颜色函数setcolor的编写
		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
		{
			color *= _ColorTint;
		}
 
		//【4】表面着色函数的编写
		void surtme (Input IN, inout SurfaceOutput o) 
		{
			//先从主纹理获取rgb颜色值
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;   
			//设置细节纹理
				o.Albedo *= tex2D (_Detail, IN.uv_Detail).rgb * 2; 
			//从凹凸纹理获取法线值
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			//从_RimColor参数获取自发光颜色
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow (rim, _RimPower);
		}
        ENDCG
    }
    Fallback "DIffuse"
}