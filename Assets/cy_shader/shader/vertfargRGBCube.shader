// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_verfar/3.vertfargRGBCube"
{
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            struct vertexOutput
            {
                float4 vertex : POSITION;
                float4 color : TEXCOORD0;
            };
            vertexOutput vert(float4 vertPos : POSITION)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(vertPos);
                o.color = vertPos + float4(0.2,0.2,0.2,0);
                return o;
            }
            float4 frag(vertexOutput Input) : COLOR
            {
                return Input.color;
            }
            ENDCG
        }
    }
}