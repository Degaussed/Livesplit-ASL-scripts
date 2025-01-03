state("bond", "elamigos repack") //17612800 
{
    bool load:        0x00F893D8, 0x24, 0x820; //Tracks loading
    bool csload:      0x102C2D0;               //Remains true through any cutscene that also loads a level
    bool stinky:      0x007469D8, 0xC;         //Returns true when an in game cutscene is playing
    int trainObj:     0x0102BFF8, 0x3B4, 0xC, 0x10, 0xC60;
    ushort pObj:      0x1010FC0;
    byte mObj:        0x1010FB8;
    string60 level:   0x00F75FA8, 0x0, 0x24;   //Tracks the last loaded level
    ushort bik:       "binkw32.dll", 0x220EC;  //Tracks the last loaded .bik fmv
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 17612800: 
            version = "elamigos repack";
            break;
        default:
        print("Unknown version detected");
        return false;
    }
}

startup
{
    vars.levels = new Dictionary<string, int>()
    {
        {"Pre_Credits_1\\artlevel", 0},
        {"Pre_Credits_2_New\\artlevel", 1},
        {"Pre_Credits_3\\artlevel", 2},
        {"Barbados\\artlevel", 2},
        {"Istanbul_0\\artlevel", 3},
        {"Istanbul_Driving\\artlevel", 4},
        {"Istanbul_2\\artlevel", 5},
        {"Monaco\\artlevel", 6},
        {"Monaco_Cut_Scene\\artlevel", 6},
        {"Refinery_01\\artlevel", 7},
        {"Refinery_02\\artlevel", 8},
        {"Refinery_Driving\\artlevel", 9},
        {"River_Battle_2\\artlevel", 10},
        {"River_Battle_2_Cut_Scene\\artlevel", 10},
        {"Bangkok_Aquarium\\artlevel", 11},
        {"Bangkok\\artlevel", 12},
        {"Bangkok_Driving\\artlevel", 13},
        {"bangkok_escape\\artlevel", 14},
        {"Bangkok_Escape_Silk_Cut_Scene\\artlevel", 15},
        {"Mercenary_Camp\\artlevel", 16},
        {"Dam_Works_1\\artlevel", 17},
        {"Dam_Works_2\\artlevel", 18},
        {"Monaco_Driving\\artlevel", 19},
    };
    vars.end  = "Monaco_Driving\\artlevel";
    
    
    vars.introCS          = 16384;
    vars.menu             = 2048;
    vars.intro            = "Pre_Credits_1\\artlevel";
    vars.train            = "Istanbul_0\\artlevel";

    //Yoinked this from FAITH, very cool
    vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
    settings.Add("show_level", false, "Show Level");
    settings.Add("show_load", false, "Show Loading");
    settings.Add("show_csload", false, "Show csloading");
    settings.Add("show_bink", false, "Show Bink");
    settings.Add("show_pObj", true, "Show pObj");
    settings.Add("show_mObj", false, "Show mObj");
    settings.Add("show_trainObj", false, "Show trainObj");
    settings.Add("train", false, "Extra split for the train in Instanbul_0");
}

update
{
    vars.deeznutzToString = (current.csload).ToString();
    if (settings["show_level"]){vars.SetTextComponent("Level", (current.level).ToString()); }
    if (settings["show_load"]){vars.SetTextComponent("Load", (current.load).ToString()); }
    if (settings["show_csload"]){vars.SetTextComponent("CSload", (current.csload).ToString()); }
    if (settings["show_bink"]){vars.SetTextComponent("Bink!", (current.bik).ToString()); }
    if (settings["show_pObj"]){vars.SetTextComponent("Primary Obj", (current.pObj).ToString()); }
    if (settings["show_mObj"]){vars.SetTextComponent("Mission Obj", (current.mObj).ToString()); }
    if (settings["show_trainObj"]){vars.SetTextComponent("trainObj", (current.trainObj).ToString()); }
    //print("pObj: " + current.trainObj);
    //print("Module size: " + modules.First().ModuleMemorySize);
}

split
{
    if (current.level != old.level && vars.levels[current.level] > vars.levels[old.level])
    return true;

    if
        (   
            settings["train"] &&
            current.level == vars.train &&
            current.pObj == 42491 &&
            current.trainObj == 7274563 &&
            current.trainObj != old.trainObj)
            return true;
}

isLoading
{
    return current.load || current.csload && current.bik != 1024;
}

//Starts timer when skipping first fmv
start
{
    return current.level == vars.intro && !current.csload && old.csload;
}