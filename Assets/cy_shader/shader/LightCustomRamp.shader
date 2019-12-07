Shader "cy_shader/37.LightCustomRamp"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
        _Ramp("【渐变纹理】Shading Ramp", 2D) = "gray" {}
    }
    SubShader
    {
        Tags { "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface mysur Ramp 
        sampler2D _Ramp;
        float4 LightingRamp(SurfaceOutput s, fixed  lightDir, fixed atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            float diff = NdotL * 0.5 +0.5;
            half3 ramp = tex2D(_Ramp, float2(diff, diff)).rgb;
            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
            color.a = s.Alpha;
            return color;
        }
        struct Input 
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        void mysur(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}