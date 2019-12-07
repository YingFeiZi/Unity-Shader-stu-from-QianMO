Shader "cy_alpha/1.simpleAlpha"
{
    SubShader
    {
        Tags {"Queue" = "Transparent"}
        pass
        {
            ZWrite Off
            Blend SrcAlpha SrcAlpha
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            float4 frag(void) :COLOR
            {
                return float4(0.3,1,0.1,0.5);
            }
            ENDCG
        }
    }
    
}