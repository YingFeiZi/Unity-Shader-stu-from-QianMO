Shader "cy_shader/34.LightCustom"
{
    Properties
    {
        _MainTex("【主纹理】Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface mysur SimpleSpecular
        half4 LightingSimpleSpecular(SurfaceOutput s, fixed3   lightDir, half3 viewDir, fixed3  atten)
        {
            half3 h = normalize(lightDir + viewDir);
            half diff = max(0, dot(s.Normal, lightDir));
            float nh = max(0, dot(s.Normal, h));
            float spec = pow(nh, 48.0);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb + _LightColor0.rgb * spec) * (atten *2);
            c.a = s.Alpha;
            return c;
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