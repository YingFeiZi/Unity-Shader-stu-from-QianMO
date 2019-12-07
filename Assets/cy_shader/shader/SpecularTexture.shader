// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "cy_alpha/5.SpecularTexture"
{
    Properties
    {
        _MainTex("纹理", 2D) = "white" {}
        _COlor("主颜色", Color) = (1,1,1,1)
        _SpecColor("镜面反射颜色", Color) = (1,1,1,1)
        _SpecShininess("镜面反射光泽度", Range(1, 100)) = 10
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 
            //stuect
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
            };
            //variables
            float4 _LightColor0;
            float4 _COlor;
            float4 _SpecColor;
            float _SpecShininess;
            sampler2D _MainTex;
            
            v2f vert(appdata IN)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(IN.vertex);
                o.posWorld = mul(unity_ObjectToWorld, IN.vertex);
                o.normal = mul(float4(IN.normal, 0.0), unity_WorldToObject).xyz;
                o.texcoord = IN.texcoord;
                return o;
            }
            float4 frag(v2f IN) : COLOR
            {
                float4 texColor = tex2D(_MainTex, IN.texcoord);
                float3 normalDir = normalize(IN.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos  - IN.posWorld);
                //计算漫反射颜色值：diffuse = LightColor * MainColor * max（0， dot（N，L）
                float3 diffuse = _LightColor0.rgb * _COlor.rgb * max(0, dot(normalDir, lightDir));
                //计算镜面反射颜色值：若法线方向和入射光方向大于180°，镜面反射值为0，否则：Specular =LightColor * SpecColor *pow(max(0,dot(R,V)),Shiness),R=reflect(-L,N)
                float3 specular;
                if(dot(normalDir, lightDir) <= 0.0)
                {
                    specular = float3(0,0,0);
                }
                else
                {
                    float3 reflectDir = reflect(-lightDir, normalDir);
                    specular = _LightColor0.rgb * _SpecColor.rgb * pow(max(0, dot(reflectDir, viewDir)), _SpecShininess);
                }
                float4 diffuseSpecularAmbient = float4(diffuse, 1.0) + float4(specular, 1.0) + UNITY_LIGHTMODEL_AMBIENT;
                return diffuseSpecularAmbient * texColor;
            }
            ENDCG
        }
    }
}