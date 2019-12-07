Shader "cy_alpha/2.AlphaSimpleColor"
{
    Properties
    {
        _ColorAndAlpha("ColorAndAlpha", Color) = (1,.1,.1,1)
    }
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
            float4 _ColorAndAlpha;
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            float4 frag(void) : COLOR
            {
                return _ColorAndAlpha;
            }
            ENDCG
        }
    }
}