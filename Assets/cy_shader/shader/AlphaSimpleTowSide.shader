Shader "cy_alpha/3.AlphaSimpleTowSide"
{
    Properties
    {
        _ColorWithAlpha_Front("ColorWithAlpha_Front", Color) = (0.9,.1,.1,.5)
        _ColorWithAlpha_Back("ColorWithAlpha_Back", Color) = (.1,.3,.9,.5)
    }
    SubShader
    {
        Tags {"Queue" =  "Transparent"}
        pass
        {
            Cull Back 
            ZWrite Off 
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            float4 _ColorWithAlpha_Front;
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            float4 frag(void) : COLOR
            {
                return _ColorWithAlpha_Front;
            }
            ENDCG
        }
        pass
        {
            Cull Front 
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            float4 _ColorWithAlpha_Back;
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            float4 frag(void) : COLOR
            {
                return _ColorWithAlpha_Back;
            }
            ENDCG
        }
    }
}