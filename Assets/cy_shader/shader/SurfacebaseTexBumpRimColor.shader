Shader "cy_shader/30.SurfacebaseTexBumpRimColor"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "withe" {}
        _BumpMap("【凹凸贴图】Bumpmap",2D) = "bump" {}
        _ColorTint("【光泽色】Tint", Color) = (1,1,1,1)
        _RimColor("【边缘颜色】Rim Color", Color) = (0.2,0.2,0.5,0)
        _RimPower("【边缘颜色强度】Rim Power", Range(0.5,8)) = 3
    }
    SubShader
    {
        Tags { "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surf Lambert finalcolor:setcolor
        //struct 
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float viewDir;
        };
        //varialbe 
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _ColorTint;
        float4 _RimColor;
        float _RimPower;

        //setcolor
        void setcolor(Input IN, SurfaceOutput o, inout fixed4  color)
        {
            color *= _ColorTint;
        }

        void surf(Input IN, inout SurfaceOutput o)
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