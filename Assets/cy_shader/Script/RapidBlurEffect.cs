using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//设置在编辑模式下也执行该脚本
[ExecuteInEditMode]
//添加选项到菜单中
[AddComponentMenu("cy_alpha/RapidBlurEffect")]
public class RapidBlurEffect : MonoBehaviour
{
    private string ShaderName = "cy_alpha/RapidBlurEffect";
 
    //着色器和材质实例
    public Shader CurShader;
    private Material CurMaterial;
 
    //几个用于调节参数的中间变量
    public static int ChangeValue;
    public static float ChangeValue2;
    public static int ChangeValue3;
 
    //降采样次数
    [Range(0, 6), Tooltip("[降采样次数]向下采样的次数。此值越大,则采样间隔越大,需要处理的像素点越少,运行速度越快。")]
    public int DownSampleNum = 2;
    //模糊扩散度
    [Range(0.0f, 20.0f), Tooltip("[模糊扩散度]进行高斯模糊时，相邻像素点的间隔。此值越大相邻像素间隔越远，图像越模糊。但过大的值会导致失真。")]
    public float BlurSpreadSize = 3.0f;
    //迭代次数
    [Range(0, 8), Tooltip("[迭代次数]此值越大,则模糊操作的迭代次数越多，模糊效果越好，但消耗越大。")]
    public int BlurIterations = 3;

    Material material
    {
        get
        {
            if(CurMaterial == null)
            {
                CurMaterial = new Material(CurShader);
                CurMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return CurMaterial;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        ChangeValue = DownSampleNum;
        ChangeValue2 = BlurSpreadSize;
        ChangeValue3 = BlurIterations;
        CurShader = Shader.Find(ShaderName);
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
    }
    /// <summary>
    /// OnRenderImage is called after all rendering is complete to render image.
    /// </summary>
    /// <param name="src">The source RenderTexture.</param>
    /// <param name="dest">The destination RenderTexture.</param>
    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if(CurShader != null)
        {
            float widthMod = 1.0f / (1.0f * (1<<DownSampleNum));
            material.SetFloat("_DownSampleValue", BlurSpreadSize * widthMod);
            sourceTexture.filterMode = FilterMode.Bilinear;
            int renderWidth = sourceTexture.width >> DownSampleNum;
            int renderHeight = sourceTexture.height >> DownSampleNum;

            RenderTexture renderBuffer = RenderTexture.GetTemporary(renderWidth, renderHeight, 0, sourceTexture.format);
            renderBuffer.filterMode = FilterMode.Bilinear;
            Graphics.Blit(sourceTexture, renderBuffer, material, 0);

            for (int i = 0; i < BlurIterations; i++)
            {
                float iterationOffs = (i * 1.0f);
                material.SetFloat("_DownSampleValue", BlurSpreadSize * widthMod + iterationOffs);
 
                // 【2.2】处理Shader的通道1，垂直方向模糊处理 || Pass1,for vertical blur
                // 定义一个临时渲染的缓存tempBuffer
                RenderTexture tempBuffer = RenderTexture.GetTemporary(renderWidth, renderHeight, 0, sourceTexture.format);
                // 拷贝renderBuffer中的渲染数据到tempBuffer,并仅绘制指定的pass1的纹理数据
                Graphics.Blit(renderBuffer, tempBuffer, material, 1);
                //  清空renderBuffer
                RenderTexture.ReleaseTemporary(renderBuffer);
                // 将tempBuffer赋给renderBuffer，此时renderBuffer里面pass0和pass1的数据已经准备好
                 renderBuffer = tempBuffer;
 
                // 【2.3】处理Shader的通道2，竖直方向模糊处理 || Pass2,for horizontal blur
                // 获取临时渲染纹理
                tempBuffer = RenderTexture.GetTemporary(renderWidth, renderHeight, 0, sourceTexture.format);
                // 拷贝renderBuffer中的渲染数据到tempBuffer,并仅绘制指定的pass2的纹理数据
                Graphics.Blit(renderBuffer, tempBuffer, CurMaterial, 2);
 
                //【2.4】得到pass0、pass1和pass2的数据都已经准备好的renderBuffer
                // 再次清空renderBuffer
                RenderTexture.ReleaseTemporary(renderBuffer);
                // 再次将tempBuffer赋给renderBuffer，此时renderBuffer里面pass0、pass1和pass2的数据都已经准备好
                renderBuffer = tempBuffer;
            }
            Graphics.Blit(renderBuffer, destTexture);
            RenderTexture.ReleaseTemporary(renderBuffer);
        }
        else
        {
            //直接拷贝源纹理到目标渲染纹理
            Graphics.Blit(sourceTexture, destTexture);
        }
    }
    void OnValidate()
    {
        //将编辑器中的值赋值回来，确保在编辑器中值的改变立刻让结果生效
        ChangeValue = DownSampleNum;
        ChangeValue2 = BlurSpreadSize;
        ChangeValue3 = BlurIterations;
    }

    // Update is called once per frame
    void Update()
    {
        //若程序在运行，进行赋值
        if (Application.isPlaying)
        {
            //赋值
            DownSampleNum = ChangeValue;
            BlurSpreadSize = ChangeValue2;
            BlurIterations = ChangeValue3;
        }
        //若程序没有在运行，去寻找对应的Shader文件
#if UNITY_EDITOR
        if (Application.isPlaying != true)
        {
            CurShader = Shader.Find(ShaderName);
        }
#endif
    }
    void OnDisable()
    {
        if (CurMaterial)
        {
            //立即销毁材质实例
            DestroyImmediate(CurMaterial);
        }
 
    }
}
