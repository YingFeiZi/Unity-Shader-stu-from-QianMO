Shader "cy_shader/33.LightDiffuse"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface mysur Lambert
        struct Input
        {
            float2 uv_MainTex;
        };
        sampler2D _MainTex;
        void mysur(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    Fallback "Diffuse"
}