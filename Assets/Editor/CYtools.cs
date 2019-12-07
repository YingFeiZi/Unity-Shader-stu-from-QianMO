using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using System.Text;
using System.Collections.Generic;
//using ExtendEditor;
using System;

public class CYtoolsobject : MonoBehaviour
{

    static int index = 0;
    static int samenum = 0;
    static int spacenum = 0;
    static int nullnum = 0;
    static int activenum = 0;
    static string str = null;
    enum UItype
    {
        UIsprite,//图片
        UIbutton,//按钮
        UItexture,//tex图片
        UItoggle,//toggle
        UIlabel, //文本
        UIpanel, //panel
        UIgrid,  //grid

    }
    enum SnapType
    {
        StAll,//所有
        StWidget,//挂件   
        StSprite,//图片
    }

    [MenuItem(" | CYtools | / *OutLabelLists")]
    static void OutLabelLists()
    {

        PutoutType("UI_Labellist.txt", UItype.UIlabel);
    }


    [MenuItem(" | CYtools | / *OutSpriteLists")]
    static void OutSpriteLists()
    {

        PutoutType("UI_Spritelist.txt", UItype.UIsprite);
    }

    [MenuItem(" | CYtools | / *OutTextureLists")]
    static void OutTextureLists()
    {

        PutoutType("UI_Texturelist.txt", UItype.UItexture);
    }


    [MenuItem(" | CYtools | / *OutButtonLists")]
    static void OutButtonLists()
    {

        PutoutType("UI_Buttonlist.txt", UItype.UIbutton);
    }

    [MenuItem(" | CYtools | / set Texture type  #%T")]
    static void SetTexture()
    {
        DoSetTexture();
    }

    [MenuItem(" | CYtools | / *CheckSameName  #c")]
    static void CheckActive()
    {
        CheckIsActive();
    }

    static void CheckSameName()
    {
        CheckSameNames();
    }

    //&%#s
    [MenuItem(" | CYtools | / *hideobjects  #a")]
    static void HideObj()
    {
        HideYou();
    }


    [MenuItem(" | CYtools | / *setTagNotrans")]
    static void SetTagNoTr()
    {
        SetTagNoTrans();
    }

    [MenuItem(" | CYtools | / *Snap / Snap all #s")]
    static void SnapObjAll()
    {
        SnapGameObject();
    }

    

    [MenuItem(" | CYtools | / *Snap / Snap widget #x")]
    static void SnapObjWidget()
    {
        SnapMe(SnapType.StWidget);
    }



    [MenuItem(" | CYtools | / 改变label数值 #D")]
    static void LabelColorChange()
    {
        ChangeLabelColor();
    }



    [MenuItem(" | CYtools | / 设置atlas  #q")]
    static void SetAtlas()
    {
        SetNomalAtlas();
    }

/*
    [MenuItem(" | CYtools | / *Prefabs Apply")]
    static void ApplySelected()
    {
        ApplySelectedPrefabs();
    }
*/

    [MenuItem(" | CYtools | / *ProcessToSprite")]
    static void DoProcessToSprite()
    {
        ProcessToSprite();
    }

    [MenuItem(" | CYtools | / 截图 / 屏幕截图")]
    static void CaptureScreentype1()
    {
        CaptureScreen();
    }

    /*
    static void ApplySelectedPrefabs()
    {
        //获取选中的gameobject对象  
        GameObject[] selectedsGameobject = Selection.gameObjects;

        GameObject prefab = PrefabUtility.FindPrefabRoot(selectedsGameobject[0]);

        for (int i = 0; i < selectedsGameobject.Length; i++)
        {
            GameObject obj = selectedsGameobject[i];

            UnityEngine.Object newsPref = PrefabUtility.GetPrefabParent(obj);

            //判断选择的物体，是否为预设  
            if (PrefabUtility.GetPrefabType(obj) == PrefabType.PrefabInstance)// && newsPref != null)
            {

                UnityEngine.Object parentObject = PrefabUtility.GetPrefabParent(obj);
                //获取路径  
                //string path = AssetDatabase.GetAssetPath(parentObject);  
                //Debug.Log("path:"+path);  
                //替换预设  
                PrefabUtility.ReplacePrefab(obj, parentObject, ReplacePrefabOptions.ConnectToPrefab);
                //刷新  
                AssetDatabase.Refresh();
            }


        }



    }
    */


    static void PutoutType(string savepath, UItype utype)
    {
        index = 0;
        string writePath = Directory.GetCurrentDirectory() + "/" + savepath;
        if (File.Exists(writePath))
            File.Delete(writePath);
        FileInfo file = new FileInfo(writePath);
        StreamWriter sw = file.AppendText();
        foreach (UnityEngine.Object tmp in Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets))
        {
            if (!(tmp is GameObject))
                continue;
            string tempShowPath = AssetDatabase.GetAssetPath(tmp);
            if (!tempShowPath.Contains(".prefab"))
                continue;

            sw.Write(tempShowPath);
            sw.Write(sw.NewLine);
            if (utype == UItype.UIsprite)
            {
                FindScript(tmp as GameObject, tempShowPath, sw);
            }
            else if (utype == UItype.UIbutton)
            {
                FindButtons(tmp as GameObject, tempShowPath, sw);
            }
            else if (utype == UItype.UItexture)
            {
                FindTexture(tmp as GameObject, tempShowPath, sw);
            }
            else if (utype == UItype.UIlabel)
            {
                FindLabel(tmp as GameObject, tempShowPath, sw);
            }

            sw.Write(sw.NewLine);
            sw.Write(sw.NewLine);
        }
        sw.Flush();
        sw.Dispose();
        sw.Close();
        System.Diagnostics.Process.Start(writePath);
        //EditorUtility.DisplayDialog("提示", "成功！输出路径 ： " + writePath, "OK");
    }




    static void FindScript(GameObject go, string tempShowPath, StreamWriter sw)
    {
        //Transform[] scripts = go.GetComponentsInChildren<Transform>(true);
        //         switch (type)
        //         {
        //             case UItype.UISprite:
        //                 UISprite[] scripts = go.GetComponentsInChildren<UISprite>(true);
        //                 break;
        //             case UItype.UIButton:
        //                 UIButton[] scripts = go.GetComponentsInChildren<UIButton>(true);
        //                 break;
        // 
        //         }
        UISprite[] scripts = go.GetComponentsInChildren<UISprite>(true);
        //        UISprite atlasname;

        if (scripts.Length > 0)
        {
            index++;
            for (int i = 0; i < scripts.Length; i++)
            {
                StringBuilder sb = new StringBuilder();
                //sb.Append(tempShowPath);
                //sb.Append("\t\t");

                if (scripts[i].GetAtlasSprite() != null)//if (scripts[i] != null) //&& scripts[i].gameObject.name.Contains("(") )//& scripts[i].gameObject.name.Contains("tishi"))
                {
                    //sb.Append("\t" + scripts[i].gameObject.transform.parent.gameObject.name);
                    sb.Append("\t" + scripts[i].transform.parent.name);
                    sb.Append("\n\t");
                    sb.Append("\t\t" + scripts[i].gameObject.name);
                    sb.Append("\t");
                    if (scripts[i].GetAtlasSprite() == null)
                    {
                        sb.Append("Null");
                        sb.Append("\t" + "Null");
                    }
                    else
                    {
                        sb.Append(scripts[i].atlas.name);
                        sb.Append("\t" + scripts[i].GetAtlasSprite().name);
                    }

                    sb.Append(sw.NewLine);
                }

                //                 sb.Append(sw.NewLine); 
                //                 sb.Append(sw.NewLine);

                sw.Write(sb.ToString());
            }
        }

    }

    static void FindTexture(GameObject go, string tempShowPath, StreamWriter sw)
    {
        UITexture[] scripts = go.GetComponentsInChildren<UITexture>(true);

        if (scripts.Length > 0)
        {
            index++;
            for (int i = 0; i < scripts.Length; i++)
            {
                StringBuilder sb = new StringBuilder();
                {
                    //                     sb.Append("\t" + scripts[i].gameObject.transform.parent.gameObject.name);
                    //                     sb.Append("\n\t");
                    //                     sb.Append("\t\t" + scripts[i].gameObject.name);
                    //                     sb.Append("\t");
                    if (scripts[i].mainTexture != null)
                    {
                        sb.Append("\t" + scripts[i].gameObject.transform.parent.gameObject.name);
                        sb.Append("\t" + scripts[i].gameObject.name);
                        sb.Append("\t" + scripts[i].mainTexture.name);
                        sb.Append(sw.NewLine);
                    }


                }
                sw.Write(sb.ToString());
            }
        }

    }

    static void FindLabel(GameObject go, string tempShowPath, StreamWriter sw)
    {
        UILabel[] scripts = go.GetComponentsInChildren<UILabel>(true);

        if (scripts.Length > 0)
        {
            index++;
            for (int i = 0; i < scripts.Length; i++)
            {
                StringBuilder sb = new StringBuilder();
                {
                    if (scripts[i].bitmapFont != null)
                    {
                        sb.Append("\t" + scripts[i].gameObject.transform.parent.gameObject.name);
                        sb.Append("\t" + scripts[i].gameObject.name);
                        sb.Append("\t" + scripts[i].bitmapFont.name);
                        sb.Append(sw.NewLine);
                    }


                }
                sw.Write(sb.ToString());
            }
        }

    }

    static void FindButtons(GameObject go, string tempShowPath, StreamWriter sw)
    {

        UIButton[] scripts = go.GetComponentsInChildren<UIButton>(true);

        if (scripts.Length > 0)
        {
            index++;
            for (int i = 0; i < scripts.Length; i++)
            {
                StringBuilder sb = new StringBuilder();

                if (scripts[i] != null && scripts[i].gameObject.name.Contains("("))//& scripts[i].gameObject.name.Contains("tishi"))
                {
                    sb.Append("\t" + scripts[i].gameObject.transform.parent.gameObject.name);
                    sb.Append("\t");
                    sb.Append("\t" + scripts[i].gameObject.name);
                    sb.Append("\t");
                    sb.Append(sw.NewLine);
                }

                sw.Write(sb.ToString());
            }
        }


        UIToggle[] scripts2 = go.GetComponentsInChildren<UIToggle>(true);

        if (scripts2.Length > 0)
        {
            index++;
            for (int i = 0; i < scripts2.Length; i++)
            {
                StringBuilder sb = new StringBuilder();

                if (scripts2[i] != null && scripts2[i].gameObject.name.Contains("("))//& scripts[i].gameObject.name.Contains("tishi"))
                {
                    sb.Append("\t" + scripts2[i].gameObject.transform.parent.gameObject.name);
                    sb.Append("\t");
                    sb.Append("\t" + scripts2[i].gameObject.name);
                    sb.Append("\t");
                    sb.Append(sw.NewLine);
                }

                sw.Write(sb.ToString());
            }
        }
    }

    static void CheckSameNames()
    {
        GameObject[] objects = Selection.gameObjects;
        List<string> list = new List<string>();
        samenum = 0;
        spacenum = 0;
        nullnum = 0;
        string names;

        foreach (GameObject o in objects)
        {
            Transform[] traf = o.transform.GetComponentsInChildren<Transform>(true);

            for (int i = 0; i < traf.Length; ++i)
            {
                names = traf[i].gameObject.name.ToString();
                if (names.Contains("("))
                {
                    string[] sArray = names.Split(')');

                    //if (names.Substring(names.Length -1, 1) == " ")
                    if (sArray[1].Length < 1)
                    {
                        UnityEngine.Debug.LogError("null name:" + names);
                        nullnum++;
                        continue;
                    }
                    //if (names.Substring(names.Length - 1, 1) == " ")
                    if (sArray[1].Contains(" "))
                    {
                        UnityEngine.Debug.LogError("name space:" + names);
                        spacenum++;
                        continue;
                    }
                    //if (traf[i].gameObject.name.Contains("("))

                    if (!list.Contains(names))
                    {
                        list.Add(names);
                    }
                    else
                    {
                        samenum++;
                        UnityEngine.Debug.LogError("name same:" + names);
                        continue;
                    }
                }

            }
            list.Clear();
        }
        EditorUtility.DisplayDialog("提示", "检查完成，共有同名： " + samenum + "个，空名称：" + nullnum + "个，空格名称：" + spacenum + "个", "OK");

    }
    static void CheckIsActive()
    {
        GameObject[] objects = Selection.gameObjects;
        activenum = 0;
        str = null;
        foreach (GameObject o in objects)
        {
            if (o.activeSelf == false)
            {
                activenum++;
                str += o.gameObject.name.ToString();
                str += ",";
            }
        }
        EditorUtility.DisplayDialog("提示", "检查完成，共有未激活panel： " + activenum + "个，分别是：" + str, "OK");

    }

    static void HideYou()
    {
        GameObject[] objects = Selection.gameObjects;
        foreach (GameObject o in objects)
        {
            if (o.activeSelf == true)
            {
                o.SetActive(false);
            }
            else
            {
                o.SetActive(true);
            }

        }

    }

    static void SnapMe(SnapType st)
    {

        GameObject[] objects = Selection.gameObjects;

        switch (st)
        {
            case SnapType.StWidget:
                foreach (GameObject go in objects)
                {
                    UIWidget pw = go.GetComponent<UIWidget>();

                    if (pw != null)
                    {
                        NGUIEditorTools.RegisterUndo("Snap Dimensions", pw);
                        NGUIEditorTools.RegisterUndo("Snap Dimensions", pw.transform);
                        pw.MakePixelPerfect();
                    }
                }
                break;
            case SnapType.StAll:
                foreach (GameObject go in objects)
                {

                    Transform[] traf = go.GetComponentsInChildren<Transform>(true);
                    if (traf.Length < 1)
                        return;
                    foreach (Transform tr in traf)
                    {
                        Vector3 pos = tr.localPosition;
                        pos.z = Mathf.Round(pos.z);
                        pos.x = Mathf.Round(pos.x);
                        pos.y = Mathf.Round(pos.y);
                        tr.localPosition = pos;

                        Vector3 ls = tr.localScale;
                        ls.z = Mathf.Round(ls.z);
                        ls.x = Mathf.Round(ls.x);
                        ls.y = Mathf.Round(ls.y);
                        tr.localScale = ls;
                    }
                }
                break;
            case SnapType.StSprite:
                foreach (GameObject go in objects)
                {
                    UISprite ps = go.GetComponent<UISprite>();

                    if (ps != null)
                    {
                        NGUIEditorTools.RegisterUndo("Snap Dimensions", ps);
                        NGUIEditorTools.RegisterUndo("Snap Dimensions", ps.transform);
                        ps.MakePixelPerfect();
                    }
                }
                break;

        }
        //AssetDatabase.SaveAssets();
    }


    static string lbcolorf1 = "044217";
    static string lbcolort1 = "B5D8CD";

    static string lbcolorf2 = "492A07";
    static string lbcolort2 = "D7CBB4";

    static string lbcolorf3 = "AC9873";
    static string lbcolort3 = "959270";

    static void ChangeLabelColor()
    {
        int i = 1;
        UnityEngine.Object[] objects = Selection.GetFiltered((typeof(UnityEngine.Object)), SelectionMode.DeepAssets);

        foreach (UnityEngine.Object o in objects)
        {            
            string assetPath = AssetDatabase.GetAssetPath(o);            
            if(!assetPath.Contains(".prefab"))
            {
                //Debug.Log(prefabo.name + " is not Prefab");
                continue;
            }
            GameObject prefabo = AssetDatabase.LoadAssetAtPath(assetPath, typeof(GameObject)) as GameObject;
            UILabel[] labels = prefabo.GetComponentsInChildren<UILabel>(true);
            if (labels.Length < 1)
            {
                Debug.Log(prefabo.name + " is not have label");
                continue;
            }
            //UISprite[] sps = prefabo.GetComponentsInChildren<UISprite>(true);
            string text = string.Format("进度: {0}/{1}", i, objects.Length);
            EditorUtility.DisplayProgressBar("设置" + prefabo.name + "按钮文本颜色", text, 1f * i / (objects.Length));
            i++;
            foreach (UILabel l in labels)
            {
                if (l == null) return;                
                //BoxCollider box = l.GetComponentInParent(typeof(BoxCollider)) as BoxCollider;
                //if (box != null)
                //Debug.Log("btn:" + box.name + "  label:" + l.name);
                string hexc = ColorUtility.ToHtmlStringRGB(l.color);
                //Debug.Log(l.name + " : " + hexc);
                l.text = l.text.Replace("       ", "    ");
                if (hexc.Equals(lbcolorf1))
                {
                    Color newcolor;
                    ColorUtility.TryParseHtmlString("#" + lbcolort1, out newcolor);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.color = newcolor;
                    Debug.Log(l.name + ":" + lbcolorf1 + "改为" + lbcolort1);
                }
                else if (hexc.Equals(lbcolorf2))
                {
                    Color newcolor;
                    ColorUtility.TryParseHtmlString("#" + lbcolort2, out newcolor);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.color = newcolor;
                    Debug.Log(l.name + ":" + lbcolorf2 + "改为" + lbcolort2);
                }
                else if (hexc.Equals(lbcolorf3))
                {
                    Color newcolor;
                    ColorUtility.TryParseHtmlString("#" + lbcolort3, out newcolor);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.color = newcolor;
                    Debug.Log(l.name + ":" + lbcolorf2 + "改为" + lbcolort2);
                }
                else if (l.text.Contains(lbcolorf1))
                {
                    string temp = l.text.Replace(lbcolorf1, lbcolort1);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.text = temp;
                    Debug.Log(l.name + ":" + lbcolorf1 + "改为" + lbcolort1);
                }
                else if (l.text.Contains(lbcolorf2))
                {
                    string temp2 = l.text.Replace(lbcolorf2, lbcolort2);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.text = temp2;
                    Debug.Log(l.name + ":" + lbcolorf2 + "改为" + lbcolort2);
                }
                else if (l.text.Contains(lbcolorf3))
                {
                    string temp2 = l.text.Replace(lbcolorf3, lbcolort2);
                    if (l.GetComponent<BoxCollider>() == null)
                    {
                        l.transform.localPosition = Vector3.zero;
                    }
                    l.text = temp2;
                    Debug.Log(l.name + ":" + lbcolorf3 + "改为" + lbcolort2);
                }

            }
            EditorUtility.SetDirty(prefabo);
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    static void ChangeLabelColor2()
    {
        GameObject[] objects = Selection.gameObjects;
        foreach (GameObject o in objects)
        {
            UILabel[] labels = o.GetComponentsInChildren<UILabel>(true);
            UISprite[] sps = o.GetComponentsInChildren<UISprite>(true);
            foreach (UILabel l in labels)
            {
                if (l == null) return;
                //BoxCollider box = l.GetComponentInParent(typeof(BoxCollider)) as BoxCollider;
                //if (box != null)
                l.text = l.text.Replace("       ", "    ");
                {
                    //Debug.Log("btn:" + box.name + "  label:" + l.name);
                    string hexc = ColorUtility.ToHtmlStringRGB(l.color);
                    if (hexc.Equals(lbcolorf1))
                    {
                        Color newcolor;
                        ColorUtility.TryParseHtmlString("#" + lbcolort1, out newcolor);
                        if (l.GetComponent<BoxCollider>() == null)
                        {
                            l.transform.localPosition = Vector3.zero;
                        }
                        l.color = newcolor;
                    }
                    else if (hexc.Equals(lbcolorf2))
                    {
                        Color newcolor;
                        ColorUtility.TryParseHtmlString("#" + lbcolort2, out newcolor);
                        if (l.GetComponent<BoxCollider>() == null)
                        {
                            l.transform.localPosition = Vector3.zero;
                        }
                        l.color = newcolor;
                    }
                    else if (l.text.Contains(lbcolorf1))
                    {
                        string temp = l.text.Replace(lbcolorf1, lbcolort1);
                        if (l.GetComponent<BoxCollider>() == null)
                        {
                            l.transform.localPosition = Vector3.zero;
                        }
                        l.text = temp;
                    }
                    else if (l.text.Contains(lbcolorf2))
                    {
                        string temp2 = l.text.Replace(lbcolorf2, lbcolort2);
                        if (l.GetComponent<BoxCollider>() == null)
                        {
                            l.transform.localPosition = Vector3.zero;
                        }
                        l.text = temp2;
                    }
                }
            }
            //             foreach (UISprite sp in sps)
            //             {
            //                 if (sp == null) continue;
            //                 if (sp.spriteName.Equals("btn_introduce") || sp.spriteName.Equals("btn_setting") || sp.spriteName.Equals("edit"))
            //                 {
            //                     NGUIEditorTools.RegisterUndo("Snap Dimensions", sp);
            //                     NGUIEditorTools.RegisterUndo("Snap Dimensions", sp.transform);
            //                     sp.MakePixelPerfect();
            //                 }
            //             }
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    static void SetTagNoTrans()
    {
        GameObject[] objects = Selection.gameObjects;
        foreach (GameObject o in objects)
        {
            UILabel l = o.GetComponent(typeof(UILabel)) as UILabel;
            if (l != null)
            {
                if (o.tag != "DoNotTranslate")
                {
                    o.tag = "DoNotTranslate";
                }
            }


        }

    }

    static void DoSetTexture()
    {
        UnityEngine.Object[] textures = Selection.GetFiltered(typeof(Texture2D), SelectionMode.DeepAssets);
        int i = 0;

        foreach (Texture2D texture in textures)
        {
            
            string text = string.Format("进度: {0}/{1}", i, textures.Length);
            EditorUtility.DisplayProgressBar("设置" + texture.name + "属性格式", text, 1f * i / (textures.Length));
            i++;
            string path = AssetDatabase.GetAssetPath(texture);
            TextureImporter temp = AssetImporter.GetAtPath(path) as TextureImporter;
            /*
            if (temp.mipmapEnabled == false)
                continue;
            if (temp.npotScale == TextureImporterNPOTScale.None)
                continue;
             */
            temp.textureType = TextureImporterType.Default;
            temp.npotScale = TextureImporterNPOTScale.None;
            temp.mipmapEnabled = false;
            temp.alphaIsTransparency = false;
            temp.alphaSource = TextureImporterAlphaSource.None;
            temp.wrapMode = TextureWrapMode.Clamp;
            temp.filterMode = FilterMode.Trilinear;
            temp.anisoLevel = 4;
            TextureImporterPlatformSettings texSetting_Android = new TextureImporterPlatformSettings();
            TextureImporterPlatformSettings texSetting_IOS = new TextureImporterPlatformSettings();

            texSetting_Android.name = "Android";
            texSetting_Android.maxTextureSize = 2048;
            texSetting_Android.format = TextureImporterFormat.RGBA32;
            texSetting_Android.allowsAlphaSplitting = true;
            texSetting_Android.overridden = true;
            temp.SetPlatformTextureSettings(texSetting_Android);

            texSetting_IOS.name = "iPhone";
            texSetting_IOS.maxTextureSize = 2048;
            texSetting_IOS.format = TextureImporterFormat.RGBA32;
            texSetting_IOS.allowsAlphaSplitting = true;
            texSetting_IOS.overridden = true;
            temp.SetPlatformTextureSettings(texSetting_IOS);

            TextureImporterPlatformSettings tps = new TextureImporterPlatformSettings();
            tps.format = TextureImporterFormat.RGBA32;
            //tps.textureCompression = TextureImporterCompression.Uncompressed;
            temp.SetPlatformTextureSettings(tps);

            TextureImporterSettings tis = new TextureImporterSettings();
            temp.ReadTextureSettings(tis);
            temp.SetTextureSettings(tis);
            AssetDatabase.ImportAsset(path);
        }
        EditorUtility.ClearProgressBar();
    }

    static void ProcessToSprite()
    {
        Texture2D image = Selection.activeObject as Texture2D;//获取旋转的对象
        if (image == null)
        {
            Debug.LogError("Select is not Image");
            return;
        }
        string rootPath = Path.GetDirectoryName(AssetDatabase.GetAssetPath(image));//获取路径名称
        string path = rootPath + "/" + image.name + ".PNG";//图片路径名称

        TextureImporter texImp = AssetImporter.GetAtPath(path) as TextureImporter;//获取图片入口


        AssetDatabase.CreateFolder(rootPath, image.name);//创建文件夹
        if (texImp.spritesheet.Length < 1)
        {
            Debug.LogError("Image not slice");
            return;
        }

        foreach (SpriteMetaData metaData in texImp.spritesheet)//遍历小图集
        {
            Texture2D myimage = new Texture2D((int)metaData.rect.width, (int)metaData.rect.height);

            //abc_0:(x:2.00, y:400.00, width:103.00, height:112.00)
            for (int y = (int)metaData.rect.y; y < metaData.rect.y + metaData.rect.height; y++)//Y轴像素
            {
                for (int x = (int)metaData.rect.x; x < metaData.rect.x + metaData.rect.width; x++)
                    myimage.SetPixel(x - (int)metaData.rect.x, y - (int)metaData.rect.y, image.GetPixel(x, y));
            }


            //转换纹理到EncodeToPNG兼容格式
            if (myimage.format != TextureFormat.ARGB32 && myimage.format != TextureFormat.RGB24)
            {
                Texture2D newTexture = new Texture2D(myimage.width, myimage.height);
                newTexture.SetPixels(myimage.GetPixels(0), 0);
                myimage = newTexture;
            }
            var pngData = myimage.EncodeToPNG();


            //AssetDatabase.CreateAsset(myimage, rootPath + "/" + image.name + "/" + metaData.name + ".PNG");
            File.WriteAllBytes(rootPath + "/" + image.name + "/" + metaData.name + ".PNG", pngData);
        }
        // 刷新资源窗口界面
        AssetDatabase.Refresh();
    }

    static void SetNomalAtlas()
    {
        GameObject sel = Selection.activeGameObject;
        UISprite atl = sel.GetComponent<UISprite>();
        if (atl != null)
        {
            atl.atlas = NGUISettings.atlas;
        }
    }

    private static void SnapGameObject()
    {
        GameObject[] objects = Selection.gameObjects;
        foreach (GameObject o in objects)
        {
            // Transform[] tran = o.GetComponentsInChildren<Transform>();
            // Debug.Log(tran.Length);
            // foreach (Transform tr in tran)
            // {
            //     tr.localPosition = SnapVector3(tr.localPosition);
            //     tr.localScale = SnapVector3(tr.localScale);
            //     string str = "name:" + tr.name + "P:" + tr.localPosition + "R:" + tr.localRotation + "S:" + tr.localScale;
            //     Debug.Log(str);
            // }
            o.transform.localPosition = SnapVector3(o.transform.localPosition);
            o.transform.localScale = SnapVector3(o.transform.localScale);
            transfromSnap(o.transform);
        }
    }

    private static void transfromSnap(Transform root)
    {
        foreach (Transform chind in root)
        {
            chind.localPosition = SnapVector3(chind.localPosition);
            chind.localScale = SnapVector3(chind.localScale);
            string str = "name:" + chind.name + "P:" + chind.localPosition + "R:" + chind.localRotation + "S:" + chind.localScale;
            Debug.Log(str);
            if (chind.childCount > 0)
            {
                transfromSnap(chind);
            }            
        }
    }
    private static Vector3 SnapVector3(Vector3 vt3)
    {
        Vector3 v3 = Vector3.zero;
        v3.x = Mathf.RoundToInt(vt3.x);
        v3.y = Mathf.RoundToInt(vt3.y);
        v3.z = Mathf.RoundToInt(vt3.z);
        return v3;
    }

    private static void CaptureScreen()
    {
        string tname = Application.dataPath.Replace("Assets","")+"Screen"+DateTime.Now.ToString("yyyyMMddHHmm")+".png";
        Debug.Log(tname);
        ScreenCapture.CaptureScreenshot(tname, 0);
    }

    /// <summary>
    /// 自定义截图大小其中包含UI
    /// </summary>
    public Texture2D CaptureScreen(Rect rect)
    {
        Texture2D screenShot = new Texture2D((int)rect.width, (int)rect.height, TextureFormat.RGB24, false);

        screenShot.ReadPixels(rect, 0, 0);

        screenShot.Apply();

        byte[] bytes = screenShot.EncodeToPNG();
        string filename = Application.dataPath + "/ScreenShot.png";
        System.IO.File.WriteAllBytes(filename, bytes);

        return screenShot;
    }

    /// <summary>
    /// 对相机截图。 
    /// </summary>
    /// <returns>The screenshot2.</returns>
    /// <param name="camera">Camera.要被截屏的相机</param>
    /// <param name="rect">Rect.截屏的区域</param>
    Texture2D CaptureCamera(Camera camera, Rect rect)
    {
        // 创建一个RenderTexture对象
        RenderTexture rt = new RenderTexture((int)rect.width, (int)rect.height, 0);
        // 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机
        camera.targetTexture = rt;
        camera.Render();
        //ps: --- 如果这样加上第二个相机，可以实现只截图某几个指定的相机一起看到的图像。
        //ps: camera2.targetTexture = rt;
        //ps: camera2.Render();
        //ps: -------------------------------------------------------------------

        // 激活这个rt, 并从中中读取像素。
        RenderTexture.active = rt;
        Texture2D screenShot = new Texture2D((int)rect.width, (int)rect.height, TextureFormat.RGB24, false);
        screenShot.ReadPixels(rect, 0, 0);// 注：这个时候，它是从RenderTexture.active中读取像素
        screenShot.Apply();

        // 重置相关参数，以使用camera继续在屏幕上显示
        camera.targetTexture = null;
        //ps: camera2.targetTexture = null;
        RenderTexture.active = null; // JC: added to avoid errors
        GameObject.Destroy(rt);
        // 最后将这些纹理数据，成一个png图片文件
        byte[] bytes = screenShot.EncodeToPNG();
        string filename = Application.dataPath + "/Screenshot.png";
        System.IO.File.WriteAllBytes(filename, bytes);
        Debug.Log(string.Format("截屏了一张照片: {0}", filename));

        return screenShot;
    }
    
}

public class UIPrefabLayer : AssetPostprocessor
{
    void OnPreProcessTexture()
    {
        Debug.LogError(assetPath);
        if (assetPath.Contains("UIAsset/"))
        {
            //由于UI的存放没有规则,需要找到该图片所使用的UIAtlas
            // List<string> list = new List<string>();
            // FileUtility.GetDeepAssetPaths(Application.dataPath + "/UIAsset/chart/", list, ".prefab");
            // FileUtility.GetDeepAssetPaths(Application.dataPath + "/UIAsset/Font/", list, ".prefab");
            // FileUtility.GetDeepAssetPaths(Application.dataPath + "/UIAsset/Prefabs/", list, ".prefab");
            // for (int i = 0; i < list.Count; i++)
            // {
            //     if (i < list.Count && list[i] != null)
            //     {
            //         Debug.LogError(list[i]);
            //     }
            // }

        }


    }
}

public class Measure_Tool : MonoBehaviour
{
    LineRenderer line;
    Ray ray;
    RaycastHit hit;
    public UILabel tex;
    Vector3 startPos;

    private void Start()
    {
        line = GetComponent<LineRenderer>();
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            line.SetPosition(0, hit.point);
            startPos = hit.point;
        }

        ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 1000) && Input.GetMouseButton(0))
        {
            line.SetPosition(1, hit.point);
        }
        tex.text = Vector3.Distance(startPos, hit.point).ToString();
        tex.transform.position = Camera.main.WorldToScreenPoint(hit.point);
    }
    
}