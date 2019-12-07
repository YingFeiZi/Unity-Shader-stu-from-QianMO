Shader "cy_shader/28.SurfacebaseTexColor"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _ColorTint("【色泽】Tint", Color) = (0.4,0.4,0.6,1)
    }
    SubShader
    {
        Tags {"RanderType" = "Opaque"}
        CGPROGRAM
        //finalcolor for custom color
        #pragma surface surf Lambert finalcolor:chgcolor
        //struct
        struct Input
        {
            float2 uv_MainTex;
        };
        //variable _MainTex _ColorTint
        sampler2D _MainTex;
        float4 _ColorTint;
        void chgcolor(Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    Fallback "DIffuse"
}