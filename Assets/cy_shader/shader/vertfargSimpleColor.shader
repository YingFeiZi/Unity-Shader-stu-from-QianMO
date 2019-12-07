// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_verfar/2.SimpleColor"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            uniform float4 _Color;
            float4 vert(float4 vertexPos : POSITION) :SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            float4 frag(void) : COLOR
            {
                return _Color;
            }
            ENDCG
        }
    }
}