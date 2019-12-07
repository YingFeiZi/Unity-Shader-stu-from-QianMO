// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_shader/PixelEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Params("PixelNumPerRow (X) Ratio (Y)", vector) = (80,1,1,1.5)
    }
    SubShader
    {
        Cull Off
        ZWrite Off 
        ZTest Always
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc"
            //Input
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            //Output
            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

	    //变量的声明
            sampler2D _MainTex;
            half4 _Params;
            half4 PixelateOperation(sampler2D tex, half2 uv, half scale, half ratio)
            {
                half PixelSize = 1.0 /scale;
                half coordx = PixelSize * ceil(uv.x / PixelSize);
                half coordy = (ratio * PixelSize) * ceil(uv.y / PixelSize);
                half2 coord = half2(coordx, coordy);
                return half4(tex2D(tex, coord).xyzw);
            }

            fixed4 frag(VertexOutput Input) : COLOR
            {
                return PixelateOperation(_MainTex, Input.uv, _Params.x, _Params.y);
            }
            ENDCG
        }
        
    }
}