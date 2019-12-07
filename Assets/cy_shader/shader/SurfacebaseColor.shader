Shader "cy_shader/25.SurfaceBaseColor"
{
    Properties{
        _Color("【主颜色】 Main Color", Color) = (0.1, 0.3, 0.9,1)
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surt Lambert
        //variable declaration
        float4 _Color;
        //struct 
        struct Input{
            float4 color : Color;
        };
        //surface code
        void surt (Input IN, inout SurfaceOutput o){
            //reflectivity
            o.Albedo = _Color.rgb;
            //Alpha
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    Fallback "Diffuse"
}