using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
public class vagueEffect : MonoBehaviour
{
    // Start is called before the first frame update
    #region Variables
    public Shader CurShader;//着色器实例
    private Vector4 ScreenResolution;//屏幕分辨率
    private Material CurMaterial;//当前材质
    [Range(5,50)]
    public float IterationNumber = 15;
    [Range(-0.5f,0.5f)]
    public float Intensity = 0.125f;
    [Range(-2f, 2f)]
    public float OffsetX = 0.5f;
    [Range(-2f, 2f)]
    public float OffsetY = 0.5f;
    public static float ChangeValue;
    public static float ChangeValue2;
    public static float ChangeValue3;
    public static float ChangeValue4;
    #endregion

    #region MaterialGetAndSet
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
    #endregion

    void Start()
    {
        ChangeValue = Intensity;
        ChangeValue2 = OffsetX;
        ChangeValue3 = OffsetY;
        ChangeValue4 = IterationNumber;
        //find shader
        CurShader = Shader.Find("cy_shader/AAA.vagueEffect2");
        if(!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
    }

    //onRenderImage() function
    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) 
    {
        // uniform sampler2D _MainTex;
        //     uniform float _Value;
        //     uniform float _Value2;
        //     uniform float _Value3;
        //     uniform int _InterationNumber;
        //着色器不为空，进行参数设置
        if (CurShader != null)
        {
            material.SetFloat("_IterationNumber", IterationNumber);
            material.SetFloat("_Value", Intensity);
            material.SetFloat("_Value2", OffsetX);
            material.SetFloat("_Value3", OffsetY);
            material.SetVector("_ScreenResolution", new Vector4(sourceTexture.width, sourceTexture.height, 0.0f, 0.0f));
            //拷贝源纹理到目标渲染纹理,加上我们的材质效果
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else //着色器为空，直接拷贝屏幕上的效果
        {
            //直接拷贝纹理到目标渲染纹理
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void OnValidate() 
    {
        //编辑器中的值赋值回来
        ChangeValue4 = IterationNumber;
        ChangeValue = Intensity;
        ChangeValue2 = OffsetX;
        ChangeValue3 = OffsetY;
    }

    
    // Update is called once per frame
    void Update()
    {
        if(Application.isPlaying)
        {
            IterationNumber = ChangeValue4;
            Intensity = ChangeValue;
            OffsetX = ChangeValue2;
            OffsetY = ChangeValue3;
        }
#if UNITY_EDITOR
        if(Application.isPlaying != true)
        {
            CurShader = Shader.Find("cy_shader/AAA.vagueEffect2");
        }
#endif
    }
	void OnDisable()
    {
        if(CurMaterial)
        {
            DestroyImmediate(CurMaterial);
        }
    }
}
