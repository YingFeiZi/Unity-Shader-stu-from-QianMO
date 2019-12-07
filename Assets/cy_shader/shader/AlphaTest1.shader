Shader "cy_shader/15.AlphaTest1"
{
    Properties{
        _MainTex("基础纹理（RGB）-透明度（A）", 2D) = "withe" {}
        _AlphaValue("透明度", Range(0.01, 1)) = 0.6
    }
    SubShader{
        pass{
            AlphaTest Greater [_AlphaValue]
            SetTexture [_MainTex] {
                Combine texture
            }
        }
    }
}