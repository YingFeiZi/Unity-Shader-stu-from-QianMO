// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_shader/AAA.ScreenWaterDropEffect"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _ScreenWaterDropTex("Base (RGB)", 2D) = "white" {}
        //当前时间
        _CurTime("Time", Range(0.0,1.0)) = 1.0
        //x坐标水滴尺寸
        _SizeX("SizeX", Range(0.0, 1.0)) = 1.0
        //y坐标水滴尺寸
        _SizeY("SizeY", Range(0.0, 1.0)) = 1.0
        //水滴的流动速度
        _DropSpeed("Speed", Range(0.0,10)) = 1.0
        //溶解度
        _Distortion("Distortion", Range(0.0, 1.0)) = 0.87
    }
    SubShader
    {
        pass
        {
            //深度测试  Always
            ZTest Always
            //cgcode
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma target 3.0

            //include cginc
            #include "UnityCG.cginc"
            //variables
            uniform sampler2D _MainTex;
            uniform sampler2D _ScreenWaterDropTex;
            uniform float _CurTime;
            uniform float _DropSpeed;
            uniform float _SizeX;
            uniform float _SizeY;
            
            uniform float _Distortion;
            uniform float2 _MainTex_TexelSize;

            //Input vertex struct
            struct vertexInput
            {
                float4 vertex : POSITION;//vertex position
                float4 color : COLOR;//color
                float2 texcoord : TEXCOORD;//tex coord
            };
            //Output vertex struct
            struct vertexOutput 
            {
                half2 texcoord : TEXCOORD;//tex coord
                float4 vertex : SV_POSITION;//pinex position
                fixed4 color : COLOR;//color

            };

            //vertex function vert
            vertexOutput vert(vertexInput Input)
            {
                //inteface
                vertexOutput Output;
                Output.vertex = UnityObjectToClipPos(Input.vertex);

                Output.texcoord = Input.texcoord;
                Output.color = Input.color;
                return Output;
            }
            //fargment function farg
            fixed4 frag(vertexOutput Input) : COLOR
            {
                //1.获取顶点的坐标
                float2 uv = Input.texcoord.xy;
                //2.解决平台差异的问题
                #if UNITY_UV_STARTS_AT_TOP
                if(_MainTex_TexelSize.y < 0)
                    _DropSpeed = 1- _DropSpeed;
                #endif
                //3.设置三层水流效果，按一定规律在水滴纹理上分别进行取样
                float3 rainTex1 = tex2D(_ScreenWaterDropTex, float2(uv.x * 1.15 * _SizeX, (uv.y * _SizeY * 1.1) + _CurTime * _DropSpeed * 0.15)).rgb / _Distortion;
                float3 rainTex2 = tex2D(_ScreenWaterDropTex, float2(uv.x * 1.25 * _SizeX - 0.1, (uv.y * _SizeY * 1.20) + _CurTime * _DropSpeed * 0.2)).rgb / _Distortion;
                float3 rainTex3 = tex2D(_ScreenWaterDropTex, float2(uv.x * _SizeX * 0.9, (uv.y * _SizeY * 1.25) + _CurTime * _DropSpeed * 0.032)).rgb / _Distortion;
                //4.整合三层水流效果
                float2 finalRainTex = uv.xy - (rainTex1.xy - rainTex2.xy -rainTex3.xy) / 3;
                //5.按照finalRainTex的坐标信息，在主纹理上进行采样
                float3 finalColor = tex2D(_MainTex, float2(finalRainTex.x, finalRainTex.y)).rgb;
                //6.返回加上Alpha值
                return fixed4(finalColor, 1.0);
            }
            ENDCG

        }
    }
}