Shader "cy_shader/19.TexShaderBlend"
{
    Properties{
        _MainTex("基础纹理", 2D) = "black" {}
    }
    SubShader{
        Tags{ "Queue" = "Geometry" }
        pass{
            Blend DstColor Zero
            SetTexture [_MainTex] {
                Combine texture
            }
        }
    }
}