Shader "cy_shader/31.SurfaceTexDet"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _Detail("【细节纹理】Detail", 2D) = "detail" {}
    }
    SubShader
    {
        Tags {"RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surt Lambert
        //struct 
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Detail;
        };
        //variable
        sampler2D _MainTex;
        sampler2D _Detail;
        //cgcode
        void surt(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb *2;
        }
        ENDCG
    }
    Fallback "Diffuse"
}