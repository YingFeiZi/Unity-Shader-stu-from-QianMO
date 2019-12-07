using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("cy_shader/PixelEffect")]
public class PixelEffect : MonoBehaviour
{

    public Shader CurShader;
    private Material CurMaterial;

    [Range(1f, 1024f), Tooltip("屏幕每行将被均分为多少个像素块")]
    public float PixelNumPerRow = 580.0f;
 
    [Tooltip("自动计算平方像素所需的长宽比与否")]
    public bool AutoCalulateRatio = true;
 
    [Range(0f, 24f), Tooltip("此参数用于自定义长宽比")]
    public float Ratio = 1.0f;

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
        CurShader = Shader.Find("cy_shader/PixelEffect");
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
            float pixelNumPerRow  =PixelNumPerRow;
            material.SetVector("_Params", new Vector2(pixelNumPerRow, 
                AutoCalulateRatio ? ((float)sourceTexture.width / (float)sourceTexture.height) : Ratio ));
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }
    // Update is called once per frame
    void Update()
    {
        if(Application.isPlaying)
        {
            #if UNITY_EDITOR
                if(Application.isPlaying != true)
                {
                    CurShader = Shader.Find("cy_shader/PixelEffect");
                }
            #endif
        }
        
    }
    void OnDisable ()
	{
		if(CurMaterial)
		{
            //立即销毁材质实例
			DestroyImmediate(CurMaterial);	
		}
    }

}
