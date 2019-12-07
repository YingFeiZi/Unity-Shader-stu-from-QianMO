Shader "cy_shader/17.AlphaTestAll"
{
    Properties{
        _Color("主颜色", Color) = (1,1,1,0)
        _MainTex("基础纹理（RGB）-透明度（A）", 2D) = "withe" {}
        _Cutoff("Alpha透明度阈值", Range(0,1)) = 0.5
    }
    SubShader{
        Material{
            DIFFUSE [_Color]
            Ambient [_Color]
        }
        Lighting On 
        Cull off 
        pass{
            AlphaTest Greater [_Cutoff]
            SetTexture [_MainTex] {
                Combine  texture * primary, texture
            }
        }
        pass{
            ZWrite off 
            ZTest Less
            AlphaTest LEqual [_Cutoff]
            Blend SrcAlpha OneMinusSrcAlpha
            SetTexture [_MainTex] {
                Combine texture * primary, texture
            }
        }
    }
}