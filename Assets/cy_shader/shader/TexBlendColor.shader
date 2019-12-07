Shader "cy_shader/20.TexBlendColor"
{
    Properties{
        _MainTex("基础纹理", 2D) = "black" {}
        _Color("主颜色", Color) = (1,1,1,0)
    }
    SubShader{
        Tags{ "Queue" = "Transparent"}
        pass{
            Blend One OneMinusDstColor
            SetTexture [_MainTex] {
                ConstantColor [_Color]
                Combine constant lerp(texture) previous
            }
        }
    }
}