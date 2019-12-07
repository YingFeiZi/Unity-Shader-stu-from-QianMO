shader "cy_shader/12.CullFront"
{
    SubShader{
        pass{
            Material{
                Emission(.3,.3,.3,.3)
                DIFFUSE(1,1,1,1)
            }
            Lighting On 
            Cull Front
        }
    }
}