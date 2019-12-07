Shader "cy_shader/36.LightHalfLambert"
{
    Properties
    {
        _Maintex("【主纹理】Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RanderType" = "Opaque"}
        CGPROGRAM
        #pragma surface mysur easyLambert
        half4 LightingeasyLambert (SurfaceOutput s, fixed3 lightDir, fixed atten) 
		{
			half NdotL =max(0, dot (s.Normal, lightDir));
            float hLambert = NdotL * 0.5 + 0.5;
			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
			color.a = s.Alpha;
			return color;
		}
        struct Input 
        {
            float2 uv_MainTex;
        };
        sampler2D _Maintex;
        void mysur(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_Maintex, IN.uv_MainTex).rgb;
        }
        ENDCG

    }
    Fallback "Diffuse"
}