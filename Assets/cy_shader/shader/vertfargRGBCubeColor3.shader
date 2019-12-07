Shader "cy_verfar/5.vertfargRGBCubeColor"
{
    Properties
    {
        _ColorValueRed("ColorRed", Range(0.0,1.0)) = 0.3
        _ColorValueGreen("ColorGreen", Range(0.0,1.0)) = 0.4
        _ColorValueBlue("ColorBlue", Range(0.0,1.0)) = 0.5
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

            uniform float _ColorValueBlue;
            uniform float _ColorValueGreen;
            uniform float _ColorValueRed;

            vertexOutput vert(float4 vertexPos : POSITION)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(vertexPos);
                o.color = vertexPos + float4(_ColorValueRed, _ColorValueGreen, _ColorValueBlue,0);
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