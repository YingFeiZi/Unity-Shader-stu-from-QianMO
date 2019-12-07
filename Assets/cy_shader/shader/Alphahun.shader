Shader "cy_shader/7.Alphahun"
{
    Properties{
        _MainTex("基础纹理(RGB)",2D) = "withe"{}
        _BlendTex("混合纹理(RGBA)", 2D) = "withe"{}
    }
    SubShader{
        pass{
            SetTexture [_MainTex] {Combine texture}
            SetTexture [_BlendTex] {Combine  texture * previous}
        }
    }
}