using System.Collections.Generic;
using UnityEngine;
using System.Collections;


[ExecuteInEditMode]
[AddComponentMenu("cy_shader/ScreenWaterDropEffect")]
public class ScreenWaterDropEffect : MonoBehaviour
{
    // Start is called before the first frame update
    #region Variable
    //着色器和材质
    public Shader CurShader;
    public Material CurMaterial;
    //时间变量和素材图的定义
    private float TimeX = 1.0f;//time var
    public Texture2D ScreenWaterDropTex;//滴水素材图
    //可以在编辑器中调整的参数值
    [Range(5, 64), Tooltip("溶解度")]
    public float Distortion = 64.0f;
    [Range(0, 7), Tooltip("水滴在X坐标上的尺寸")]
    public float SizeX = 1f;
    [Range(0, 7), Tooltip("水滴在Y坐标上的尺寸")]
    public float SizeY = 0.5f;
    [Range(0, 10), Tooltip("水滴的流动速度")]
    public float DropSpeed = 3.6f;
    [Range(0,100), Tooltip("出现时间频率")]
    public int Timeface = 100;
 
    //用于参数调节的中间变量
    public static float ChangeDistortion;
    public static float ChangeSizeX;
    public static float ChangeSizeY;
    public static float ChangeDropSpeed;
    #endregion

    #region MaterialGetAndSet
    Material material
    {
        get
        {
            if (CurMaterial == null)
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
        //一次赋值
        ChangeDistortion = Distortion;
        ChangeSizeX = SizeX;
        ChangeSizeY = SizeY;
        ChangeDropSpeed = DropSpeed;
        //add Texture
        ScreenWaterDropTex = Resources.Load("water") as Texture2D;
        //add shader
        CurShader = Shader.Find("cy_shader/AAA.ScreenWaterDropEffect2");
        if(!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) 
    {
        if(CurShader != null)
        {
            TimeX += Time.deltaTime;
            if(TimeX > Timeface) TimeX = 0;
            //设置shader的其他外部变量
            material.SetFloat("_CurTime", TimeX);
            material.SetFloat("_Distortion", Distortion);
            material.SetFloat("_SizeX", SizeX);
            material.SetFloat("_SizeY", SizeY);
            material.SetFloat("_DropSpeed", DropSpeed);

            material.SetTexture("_ScreenWaterDropTex", ScreenWaterDropTex);
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }
    void OnValidate()
    {
        ChangeDistortion = Distortion;
        ChangeSizeX  = SizeX;
        ChangeSizeY = SizeY;
        ChangeDropSpeed = DropSpeed;
    }
    // Update is called once per frame
    void Update()
    {
        if(Application.isPlaying)
        {
            Distortion = ChangeDistortion;
            SizeX = ChangeSizeX;
            SizeY = ChangeSizeY;
            DropSpeed = ChangeDropSpeed;
        }
        //找到对应的Shader文件，和纹理素材
#if UNITY_EDITOR
        if (Application.isPlaying != true)
        {
            CurShader = Shader.Find("cy_shader/AAA.ScreenWaterDropEffect2");
            ScreenWaterDropTex = Resources.Load("water") as Texture2D;
 
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
