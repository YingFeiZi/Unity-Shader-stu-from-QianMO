Shader "cy_shader/2.DiffauAndAmb"
{
    SubShader
    {
        pass{
            Material{
                Diffuse(0.9, 0.5, 0.4,1)
                Ambient(0.9, 0.5, 0.4, 1)
            }
            
            Lighting On
        }
    }
}
