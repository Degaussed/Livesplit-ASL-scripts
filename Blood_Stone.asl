state("bond", "elamigos repack") //17612800 
{
    bool load:        0x00F893D8, 0x24, 0x820; //Tracks loading
    bool csload:      0x102C2D0;               //Remains true through any cutscene that also loads a level
    bool cutscene:    0x007469D8, 0xC;         //Returns true when an in game cutscene is playing
    int trainObj:     0x00F33424, 0x0, 0x2DC, 0x34, 0xD90;
    ushort pObj:      0x1010FC0;
    byte mObj:        0x1010FB8;
    byte dead:        0x0102B410, 0x80, 0x14, 0x0, 0x0, 0xE10;
    float stamina:    0x00FAE574, 0xC, 0xC, 0xB94;
    string60 level:   0x00F75FA8, 0x0, 0x24;   //Tracks the last loaded level
    ushort bik:       "binkw32.dll", 0x220EC;  //Tracks the last loaded .bik fmv
    float stamina:    0x00FAE574, 0xC, 0xC, 0xB94;
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 17612800: 
            version = "elamigos repack";
            break;
        default:
        print("Unknown version detected, support may be limited.");
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
    vars.monaco           = "Monaco\\artlevel";
    vars.refinery         = "Refinery_02\\artlevel";
    vars.monoco2          = "Monaco_Driving\\artlevel";

    settings.Add("train", false, "Split when activating train in Istanbul");
    settings.Add("m_safe", false, "Split when hacking the safe in Monaco");
    settings.Add("ref_split", false, "Split on Refinery \"return to control room\"");
    settings.Add("runnerman", false, "Enable Unlimited Sprint");
}

update
{
    //Write value of 1 to Sprints float value, enabling Unlimited Sprint
    if (settings["runnerman"])
    {
    bool bSuccess;
    IntPtr hProcess = game.Handle;
    IntPtr lpPtrPath = IntPtr.Add(modules.First().BaseAddress, 0x00FAE574);
    byte[] lpBuffer = BitConverter.GetBytes((float)1);
    UIntPtr nSize = (UIntPtr)lpBuffer.Length;
    UIntPtr lpNumberOfBytesWritten = UIntPtr.Zero;
	
    UIntPtr nReadSize = (UIntPtr)4;
    byte[] lpReadBuf = new byte[4];
    UIntPtr lpNumberOfBytesRead = UIntPtr.Zero;
	
    bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
    lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
    lpPtrPath = IntPtr.Add(lpPtrPath, 0xC);
	
    bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
    lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
    lpPtrPath = IntPtr.Add(lpPtrPath, 0xC);
	
    bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
    lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
    lpPtrPath = IntPtr.Add(lpPtrPath, 0xB94);
	
    bSuccess = WinAPI.WriteProcessMemory(hProcess, lpPtrPath, lpBuffer, nSize, out lpNumberOfBytesWritten);
    bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
    float stamina = BitConverter.ToSingle(lpReadBuf, 0);
    //print(stamina.ToString());
}}

split
{
    //Standard mission splits
    if (current.level != old.level && vars.levels[current.level] > vars.levels[old.level])
    return true;

    //Optional Train split
    if
    (
        settings["train"] &&
        current.level == vars.train &&
        current.pObj == 42491 &&
        current.trainObj == 7274563 && current.trainObj != old.trainObj
    )
        return true;

    //Optional Monaco Safe split
    if
    (
        settings["m_safe"] &&
        current.level == vars.monaco &&
        old.mObj == 135 && current.mObj == 223
    )
    return true;

    //Optional Refinery Split
    if
    (
        settings["ref_split"] &&
        current.level == vars.refinery &&
        current.pObj == 48109 && old.pObj != current.pObj
    )
    return true;
}

isLoading
{
    return current.load || current.csload && current.dead != 1;
}

//Starts timer when skipping first fmv
start
{
    return current.level == vars.intro && !current.csload && old.csload;
}