Shader "cy_shader/GrabPassInvert"
{
    SubShader{
        Tags{
            "Queue" = "Transparent"
        }
        GrabPass{}
        pass{
            SetTexture [_GrabTexture] { combine one-texture }
        }
    }
}