Shader "cy_shader/26.SurfaceBaseTex"
{
    Properties{
        _MainTex("【主纹理】Texture", 2D) = "withe" {}
    }
    SubShader
    {
        //tags
        Tags { "RenderType" = "Opaque"}
        //begin cgcode
        CGPROGRAM
        //lambert light
        #pragma surface surf Lambert
        //input struct 
        struct Input
        {
            //texture uv
            float2 uv_MainTex;
        };
        //Variable _MainTex
        sampler2D _MainTex;
        //surface code
        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}