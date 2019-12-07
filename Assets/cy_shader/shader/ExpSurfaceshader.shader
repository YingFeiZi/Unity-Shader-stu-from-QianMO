Shader "cy_shader/ExpSurfaceShader"
{
    Properties{
        _MainTex("【纹理】Texture", 2D) = "withe" {}
        _BumpMap("【凹凸纹理】Bumpmap", 2D) = "bump" {}
        _RimColor("【边缘颜色】Rim Color", Color) = (0.17,0.36,0.81,0.0)
        _RimPower("【边缘颜色强度】Rim Power", Range(0.6, 9.0)) = 1.0
    }
    SubShader{
        Tags{ "RanderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert
        //输入结构
        struct Input{
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 viewDir;
        };
        
        /*
        struct SurfaceOutput
        {
            half3 Albedo; // 纹理颜色值（r, g, b)
            half3 Normal; // 法向量(x, y, z)
            half3 Emission; // 自发光颜色值(r, g, b)
            half Specular; // 镜面反射度
            half Gloss; // 光泽度
            half Alpha; // Alpha不透明度
        };
        */
        //变量声明
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;

        //表面着色函数的编写
        void surf(Input IN, inout SurfaceOutput o)
        {
            //表面反射颜色为纹理颜色
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            //表面发现为凹凸纹理的颜色
            o.Normal  = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            //边缘颜色
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal ));
            //边缘颜色强度
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG


    }
    Fallback "Diffuse"
}
