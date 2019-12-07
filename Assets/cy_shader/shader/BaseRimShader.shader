// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "cy_alpha/BaseRimShader"
{
    Properties
	{
		//主颜色 || Main Color
		_MainColor("【主颜色】Main Color", Color) = (0.5,0.5,0.5,1)
		//漫反射纹理 || Diffuse Texture
		_TextureDiffuse("【漫反射纹理】Texture Diffuse", 2D) = "white" {}	
		//边缘发光颜色 || Rim Color
		_RimColor("【边缘发光颜色】Rim Color", Color) = (0.5,0.5,0.5,1)
		//边缘发光强度 ||Rim Power
		_RimPower("【边缘发光强度】Rim Power", Range(0.0, 36)) = 0.1
		//边缘发光强度系数 || Rim Intensity Factor
		_RimIntensity("【边缘发光强度系数】Rim Intensity", Range(0.0, 100)) = 3
	}
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        pass
        {
            Name "ForwardBase"
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma target 3.0

            float4 _LightColor0;
            float4 _MainColor;
            sampler2D _TextureDiffuse;
            float4 _TextureDiffuse_ST;
            float4 _RimColor;
            float _RimPower;
            float _RimIntensity;
            
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 posWorld : TEXCOORD1;
                LIGHTING_COORDS(3,4)
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                o.normal = mul(float4(v.normal, 1.0), unity_WorldToObject).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDir = normalize(i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float Attenuation = LIGHT_ATTENUATION(I);
                float3 AttenColor = Attenuation * _LightColor0.xyz;
                float NdotL = dot(normalDir, lightDir);
                float3 Diffuse = max(0.0, NdotL) * AttenColor +UNITY_LIGHTMODEL_AMBIENT.xyz;

                half Rim = 1.0 - max(0, dot(i.normal, viewDir));
                float3 Emissive = _RimColor.rgb * pow(Rim, _RimPower) * _RimIntensity;
                //最终颜色 = （漫反射系数 x 纹理颜色 x rgb颜色）+自发光颜色 || Final Color=(Diffuse x Texture x rgbColor)+Emissive
                float3 finalColor = Diffuse * (tex2D(_TextureDiffuse, TRANSFORM_TEX(i.texcoord.rg, _TextureDiffuse)).rgb * _MainColor.rgb) + Emissive;
                return float4(finalColor, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}