// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "cy_shader/AAA.vagueEffect2"
{
    Properties
    {
        _MainTex("主纹理 (RGB)", 2D) = "white" {}
        _IterationNumber("迭代次数", Int) = 16
    }
    SubShader
    {
        pass
        {
            //深度测试模式，渲染所有像素
            ZTest Always
            //cg code 
            CGPROGRAM
            //编译指令：指定目标版本
            #pragma target 3.0
            //编译指令：顶点和片段名称
            #pragma vertex vert
            #pragma fragment frag 
            //头文件
            #include "UnityCG.cginc"
            //外部变量声明
            uniform sampler2D _MainTex;
            uniform float _Value;
            uniform float _Value2;
            uniform float _Value3;
            uniform int _IterationNumber;

            //顶点输入结构
            struct vertexInput
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };
            //顶点输出结构
            struct vertexOutput
            {
                half2 texcoord : TEXCOORD0;
                float4 vertex : sv_POSITION;
                fixed4 color : COLOR;
            };
            //顶点着色函数vert
            vertexOutput vert(vertexInput Input)
            {
                //1.声明一个输出结构对象
                vertexOutput Output;
                //2.填充输出结构：
                //输出的顶点位置为模型视图投影矩阵乘以顶点位置，也就是将三维空间中的坐标投影到了二维窗口
                Output.vertex = UnityObjectToClipPos(Input.vertex);
                //输出的纹理坐标也就是输入的纹理坐标
                Output.texcoord = Input.texcoord;
                //输出的颜色就是输入的颜色
                Output.color = Input.color;		
                //3.返回输出结构对象
                return Output;		
            }

            //片段着色函数frag
            float4 frag(vertexOutput i) : COLOR
            {
                //1.设置中心坐标
                float2 center = float2(_Value2, _Value3);
                //2.获取纹理坐标（x，y）值
                float2 uv = i.texcoord.xy;
                //3.坐标纹理按照中心位置进行一个偏移
                uv -= center;
                //4.初始化一个颜色值
                float4 color = float4(0.0,0.0,0.0,0.0);
                //5.将Value乘以一个系数
                _Value *= 0.085;
                //6.设置坐标缩放比例的值
                float scale = 1;
                //7.进行纹理颜色的迭代
                for(int j=1;j<_IterationNumber; ++j)
                {
                    //将主纹理在不同坐标采样下的颜色进行迭代累加
                    color += tex2D(_MainTex, uv * scale  + center);
		    //坐标缩放比例依据循环参数的改变而变化
                    scale = 1 + (float(j*_Value));
                }
                //8.将最终的颜色值除以迭代次数，取平均值
                color /= (float)_IterationNumber;
                //9.返回最终的颜色值
                return color;
            }
            ENDCG

        }
    }
}