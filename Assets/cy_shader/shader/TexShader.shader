Shader "cy_shader/18.TexShader"
{
    Properties{
        _MainTex("基础纹理", 2D) = "black" {}
    }
    SubShader{
        Tags{ "Queue" = "Geometry" }
        pass{
            SetTexture [_MainTex] {
                Combine texture
            }
        }
    }
}