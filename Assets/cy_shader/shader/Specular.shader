// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "cy_alpha/4.Specular"
{
    Properties
    {
        _Color("主颜色", Color) = (1,1,1,1)
        _SpecColor("镜面反射颜色", Color) = (1,1,1,1)
        _SpecShininess("镜面反射光泽度", Range(1.0, 100.0)) = 10
    }
    SubShader
    {
		//渲染类型设置：不透明
		Tags{ "RenderType" = "Opaque" }
        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            //struct
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float4 posWorld : TEXCOORD0;
            };
            //variables
            float4 _LightColor0;
            float4 _Color;
            float4 _SpecColor;
            float _SpecShininess;

            v2f vert(appdata IN)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(IN.vertex);
                o.posWorld = mul(unity_ObjectToWorld, IN.vertex);
                o.normal = mul(float4(IN.normal, 0.0), unity_ObjectToWorld).xyz;
                return o;
            }
            fixed4 frag(v2f IN) : COLOR
            {
                //准备法线方向、入射光线方向、视角方向
                float3 normalDirection = normalize(IN.normal);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDirection = normalize(_WorldSpaceCameraPos - IN.posWorld.xyz);
                //计算漫反射颜色值：diffuse = LightColor * MainColor * max（0， dot（N，L）
                float3 diffuse = _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
                //计算镜面反射颜色值：若法线方向和入射光方向大于180°，镜面反射值为0，否则：Specular =LightColor * SpecColor *pow(max(0,dot(R,V)),Shiness),R=reflect(-L,N)
                float3 specular;
                if(dot(normalDirection, lightDirection) <=0.0)
                {
                    specular = float3(0.0,0.0,0.0);
                }
                else
                {
                    float3 reflectDirection = reflect(-lightDirection, normalDirection);
                    specular = _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflectDirection, viewDirection)), _SpecShininess);
                }
                //合并漫反射、镜面反射、环境光
                float4 diffuseSpecularAmbient = float4(diffuse, 1.0) + float4(specular, 1.0) + UNITY_LIGHTMODEL_AMBIENT;
                //返回合并值
                return diffuseSpecularAmbient;
            }
            ENDCG
        }
    }
}