Shader "cy_shader/0.CYImageEffectShader"
{
    Properties
    {
        //主纹理
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        //关闭剔除操作
        Cull Off 
        //关闭深度写入操作
        ZWrite Off 
        //设置深度测试模式,渲染所有像素,等同关闭透明测试(AlphaTestOff)
        ZTest Always
        //唯一通道
        Pass
        {
            CGPROGRAM
            //编译指令 顶点编译着色函数 vert
            #pragma vertex vert
            //编译指令 片段着色函数 frag
            #pragma fragment frag
            //包含头文件
            #include "UnityCG.cginc"
            //顶点输入结构数据
            struct appdata
            {
                float4 vertex : POSITION;//顶点位置
                float2 uv : TEXCOORD0;//一级纹理坐标
            };
            //顶点输出结构数据
            struct v2f
            {
                float2 uv : TEXCOORD0;//一级纹理坐标
                float4 vertex : SV_POSITION;//像素位置
            };
            //顶点着色函数
            v2f vert (appdata v)
            {
                //实例化输入结构体o
                v2f o;
                //【2】填充此输出结构
                //输出的顶点位置（像素位置）为模型视图投影矩阵乘以顶点位置，也就是将三维空间中的坐标投影到了二维窗口
                o.vertex = UnityObjectToClipPos(v.vertex);
                //输入的UV纹理坐标为顶点输出的坐标
                o.uv = v.uv;
                //【3】返回此输出结构对象
                return o;
            }
            //声明主纹理
            sampler2D _MainTex;
            //片段着色函数
            fixed4 frag (v2f i) : SV_Target
            {
                //【1】采样主纹理在对应坐标下的颜色值
                fixed4 col = tex2D(_MainTex, i.uv);
                //【2】将颜色值反向
                col.rgb = 1 - col.rgb;
                //【3】返回最终的颜色值
                return col;
            }
            ENDCG
        }
    }
}
