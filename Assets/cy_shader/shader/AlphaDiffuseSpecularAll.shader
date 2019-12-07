Shader "cy_shader/11.AlphaDiffuseSpecular"
{
    Properties{
        _IlluminCol("自发光色", Color) = (1,1,1,1)
        _Color("主颜色", Color) = (1,1,1,0)
        _SpecColor("高光颜色", Color) = (1,1,1,1)
        _Emission("光泽颜色", Color) = (0,0,0,0)
        _Shininess("色泽度", Range(0.01, 1)) = 0.7
        _MainTex("基础纹理（RGB）-自放光（A）", 2D) = "withe" {}
        _BlendTex("混合纹理（RGBA）", 2D) = "withe" {}
    }
    SubShader{
        pass{
            Material{
                DIFFUSE [_Color]
                Ambient [_Color]
                SPECULAR [_SpecColor]
                Emission [_Emission]
                Shininess [_Shininess]
            }
            Lighting On 
            SeparateSpecular On 

            SetTexture [_MainTex] {
                ConstantColor [_IlluminCol]
                Combine constant lerp(texture) previous
            }
            SetTexture [_MainTex] {
                Combine previous * texture
            }
            SetTexture [_BlendTex] {
                Combine previous * texture
            }
            SetTexture [_MainTex] {
                Combine previous * primary double, previous * primary
            }
        }
    }
}