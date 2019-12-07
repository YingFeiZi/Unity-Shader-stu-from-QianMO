// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cy_verfar/4.vertfargRGBCubeColor"
{
    Properties
    {
        _ColorValue("Color", Range(0.0,1.0)) = 0.6
    }
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment farg 
            struct vertexOutput
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };
            uniform float _ColorValue;
            vertexOutput vert(float4 vertexPos : POSITION)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(vertexPos);
                o.color = vertexPos + float4(_ColorValue, _ColorValue, _ColorValue,0.0); 
                return o;
            }
            float4 farg(vertexOutput Input) : COLOR
            {
                return Input.color;
            }
            ENDCG
        }
    }
}