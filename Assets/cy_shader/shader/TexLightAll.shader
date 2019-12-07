Shader "cy_shader/6.TexLightAll"
{
    Properties{
        _Color("主颜色",Color)=(1,1,1,0)
        _SpecColor ("高光颜色", Color) = (1,1,1,1) 
        _Emission ("自发光颜色", Color) = (0,0,0,0) 
        _Shininess ("光泽度", Range (0.01, 1)) = 0.7 
        _MainTex ("基本纹理", 2D) = "white" {}
    }
    SubShader{
        pass{
            Material{
                Diffuse [_Color] 
                Ambient [_Color] 
                //光泽度 
                Shininess [_Shininess] 
                //高光颜色 
                Specular [_SpecColor] 
                //自发光颜色 
                Emission [_Emission]
            }
            Lighting On
            SeparateSpecular On
            //SetTexture[_MainTex] {Combine texture * primary double, texture * primary}
            SetTexture[_MainTex] {Combine texture * primary double , texture * primary}
        }
    }
}