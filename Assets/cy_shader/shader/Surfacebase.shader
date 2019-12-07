Shader "cy_shader/24.SurfaceBase"
{
    SubShader{
        Tags { "RenderType" = "Opaque"}
        //cg begin
        CGPROGRAM
        //lambert light
        #pragma surface  surf  Lambert
        //struct putin
        struct Input{
            float4 color : COLOR;
        };
        //surface code 
        void surf(Input IN, inout  SurfaceOutput o){
            //Albedo
            o.Albedo = float3(0.5,0.8,0.3);
        }
        ENDCG

    }
    Fallback "Diffuse"
}