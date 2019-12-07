Shader "cy_shader/8.AlphaDiffuse"
{
    Properties{
        _MainTex("基础纹理(RGB)-自发光", 2D) = "withe"{}
    }
    SubShader{
        pass{
            Material{
                DIFFUSE (.1,.1,.1,1)
                Ambient (1,.1,.1,1)
            }
            Lighting On 
            SetTexture [_MainTex] {
                ConstantColor (.8,.8,.8,1)
                Combine constant lerp(texture) previous
            }
            SetTexture [_MainTex] {
                Combine previous * texture
            }
        }
    }
}