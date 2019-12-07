using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("cy_shader/ScreenOilPaintEffect")]
public class ScreenOilPaintEffect : MonoBehaviour
{
    // Start is called before the first frame update
    #region  variables
    public Shader CurShader;
	private Material CurMaterial;
    [Range(0,5), Tooltip("分辨率比例值")]
    public float ResolutionValue = 0.9f;
    [Range(1, 30),Tooltip("半径的值，决定了迭代的次数")]
    public int RadiusValue = 5;
    //change variable
    public static float ChangeValue;
    public static int ChangeValue2;

    #endregion

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
    void Start()
    {
        //fuzhi
        ChangeValue = ResolutionValue;
        ChangeValue2 = RadiusValue;

        //find shader file
        CurShader = Shader.Find("cy_shader/OilPaintEffect");
        if(!SystemInfo.supportsImageEffects)
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
            material.SetFloat("_ResolutionValue", ResolutionValue);
            material.SetInt("_Radius", RadiusValue);
            material.SetVector("_ScreenResolution", new Vector4(sourceTexture.width, sourceTexture.height, 0.0f, 0.0f));
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }
    /// <summary>
    /// Called when the script is loaded or a value is changed in the
    /// inspector (Called in the editor only).
    /// </summary>
    void OnValidate()
    {
        ChangeValue = ResolutionValue;
        ChangeValue2 = RadiusValue;
    }
    // Update is called once per frame
    void Update()
    {
        if (Application.isPlaying)
		{
            //赋值
            ResolutionValue = ChangeValue;
            RadiusValue=ChangeValue2;
		}
        //若程序没有在运行，去寻找对应的Shader文件
		#if UNITY_EDITOR
		if (Application.isPlaying!=true)
		{
            CurShader = Shader.Find("cy_shader/OilPaintEffect");
		}
        #endif
    }
    /// <summary>
    /// This function is called when the behaviour becomes disabled or inactive.
    /// </summary>
    void OnDisable()
    {
        if(CurMaterial)
        {
            DestroyImmediate(CurMaterial);
        }
    }
}