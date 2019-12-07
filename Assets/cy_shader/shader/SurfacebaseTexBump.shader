Shader "cy_shader/27.SurfacebaseTexBump"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _BumpMap("【凹凸纹理】Bumpamap", 2D) = "bump"
    }
    SubShader
    {
        Tags {"RanderType" = "Opaque"}
        //begin cg
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        }; 
        //variable _MainTex _BumpMap
        sampler2D _MainTex;
        sampler2D _BumpMap;
        //cg code
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }
    Fallback "Diffuse" 
}