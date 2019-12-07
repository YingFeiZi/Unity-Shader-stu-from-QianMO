Shader "cy_shader/9.AlphaDiffuseHun"
{
    Properties{
        _IlluminCol("自发光(RGB)", Color) = (1,1,1,1)
        _MainTex("基础纹理(RGB)-自发光", 2D) = "withe" {}
    }
    SubShader{
        pass{
            Material{
            DIFFUSE(1,1,1,1)
            Ambient(1,1,1,1)
            }
            Lighting On

            SetTexture [_MainTex] {
                constantColor [_IlluminCol]
                Combine constant lerp(texture) previous
            }
        
            SetTexture [_MainTex] {
                Combine previous * texture
            }
        }
    }
}
