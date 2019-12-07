Shader "cy_shader/29.SurfacebaseTexBumpRim"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _BumpMap("【凹凸贴图】Bumpmap", 2D) = "bump" {}
        _RimColor("【边缘颜色】Rim Color",Color) = (0.26, 0.19, 0.16, 0)
        _RimPower("【边缘颜色强度】Rim Power", Range(0.5, 8)) = 3.0
    }
    SubShader
    {
        Tags {"RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };
        //variable 
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir),o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    Fallback "Diffuse"
}