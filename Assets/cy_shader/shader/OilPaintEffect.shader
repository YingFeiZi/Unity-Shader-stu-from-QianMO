// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_shader/OilPaintEffect"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Distortion("_Distortion", Range(0.0,1.0)) = 0.3
        _ScreenResolution("_ScreenResolution", vector) = (0,0,0,0)
        _ResolutionValue("_ResolutionValue", Range(0.0, 5.0)) = 1.0
        _Radius("_Radius", Range(0.0, 5.)) = 2.0
    }
    SubShader
    {
        pass
        {
            ZTest Always
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc"
            //variables
            uniform sampler2D _MainTex;
            uniform float _Distortion;
            uniform float4 _ScreenResolution;
            uniform float _ResolutionValue;
            uniform int _Radius;

            //vertex input
            struct vertexInput
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            //vertex output
            struct vertexOutput
            {
                half2  texcoord : TEXCOORD;
                fixed4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            //function vert
            vertexOutput vert(vertexInput Input)
            {
                vertexOutput Output;
                Output.vertex = UnityObjectToClipPos(Input.vertex);
                Output.texcoord = Input.texcoord;
                Output.color = Input.color;
                return Output;
            }
            //function frag
            float4 frag(vertexOutput Input) : COLOR
            {
                //1.根据分辨率比值,计算图像尺寸
                float2 src_size = float2(_ResolutionValue /_ScreenResolution.x, _ResolutionValue / _ScreenResolution.y);
                //2.获取坐标值
                float2 uv = Input.texcoord.xy;
                //3.根据半径，计算n的值
                float n = float((_Radius +1) * (_Radius +1));
                //4.定义参数
                float3 m0 =0.0;float3 m1 =0.0;
                float3 s0 =0.0;float3 s1 =0.0;
                float3 c;
                //5.按半径radius的值，迭代计算m0和s0的值
                for(int j = -_Radius; j<= 0; ++j)
                {
                    for(int i = -_Radius; i<=0; ++i)
                    {
                        c = tex2D(_MainTex, uv + float2(i,j) * src_size).rgb;
                        m0 += c;
                        s0 += c*c;
                    }
                }
				//【6】按半径Radius的值，迭代计算m1和s1的值
				for (int j = 0; j <= _Radius; ++j)
                {
					for (int i = 0; i <= _Radius; ++i)
                    {
                        c = tex2D(_MainTex, uv + float2(i,j) * src_size).rgb;
                        m1 += c;
                        s1 += c*c;
                    }
                }
                //7.定义参数，准备计算最终的颜色值
                float4 finalFragColor = 0.;
                float min_sigma2 = 1e+2;
                //8.根据m0和s0， 第一次计算finalFragColor的值
                m0 /=n;
                s0 = abs(s0/n - m0*m0);
                float sigma2 = s0.r + s0.g + s0.b;
                if(sigma2 <min_sigma2)
                {
                    min_sigma2 = sigma2;
                    finalFragColor = float4(m0, 1.0);
                }
                //9.根据m1和s1， 第二计算finalFragColor的值
                m1 /=n;
                s1 = abs(s1/n - m1* m1);
                sigma2 = s1.r + s1.g +s1.b;
                if(sigma2 < min_sigma2)
                {
                    min_sigma2 = sigma2;
                    finalFragColor = float4(m1, 1.0);
                }
                //10.返回最终颜色
                return finalFragColor;
            }
            ENDCG

        }
    }
}