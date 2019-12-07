// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_verfar/1.SimpleShader"
{
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }

            float4 frag(void) : COLOR
            {
                return float4(1,0.5,0.8,1);
            }
            ENDCG
        }
    }
}