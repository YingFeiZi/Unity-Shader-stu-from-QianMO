Shader "cy_shader/5.2DTexLoad"
{
    Properties{
        _MainTex("基本纹理",2D)="White"{TexGen SphereMap}
    }
    SubShader{
        pass{
            SetTexture[_MainTex]{Combine texture}
        }
    }
    Fallback "Diffuse"
}