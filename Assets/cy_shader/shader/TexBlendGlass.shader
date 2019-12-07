Shader "cy_shader/22.TexBlendGlass"
{
    Properties{
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Base (RGB) Transparency (A)", 2D) = "withe" {}
        _Reflections("Base (RGB) Gloss (A)", Cube) = "skybox" {TexGen CubeReflect }
    }

    SubShader{
        Tags{"Queue" = "Transparent"}
        pass{
            Blend One One 
            Material{
                DIFFUSE [_Color]
            }
            Lighting On 
            SetTexture [_Reflections]{
                Combine texture
                Matrix [_Reflections]
            }
        }
    }
}