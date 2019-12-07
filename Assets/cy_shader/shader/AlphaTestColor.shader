Shader "cy_shader/16.AlphaTestColor"
{
    Properties{
        _Color("主颜色", Color) = (1,1,1,0)
        _SpecColor("高光颜色", Color) = (1,1,1,1)
        _Emission("光泽颜色", Color) = (0,0,0,0)
        _Shininess("光泽度", Range(0.01, 1)) = 0.7
        _MainTex("基础纹理（RBG）-透明度（A）", 2D) = "withe" {}
        _Cutoff("Alpha透明度阈值", Range(0,1)) = 0.5
    }
    SubShader{
        pass{
            AlphaTest Greater [_Cutoff]
            Material{
                DIFFUSE [_Color]
                Ambient [_Color]
                SPECULAR [_SpecColor]
                Emission [_Emission]
                Shininess [_Shininess]
            }
            Lighting On 

            SetTexture [_MainTex] {
                Combine texture * primary
            }
        }
    }
}