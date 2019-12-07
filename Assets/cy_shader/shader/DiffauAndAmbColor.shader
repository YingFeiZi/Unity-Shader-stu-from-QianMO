Shader "cy_shader/3.DiffauAndAmb2"
{
    Properties{
        _MainColor("MainColor",Color)=(1,.1,5,1)
    }
    SubShader{
        pass{
            Material{
                DIFFUSE[_MainColor]
                Ambient[_MainColor]
            }

            Lighting On
        }
    }
}