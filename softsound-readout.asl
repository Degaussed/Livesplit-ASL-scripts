state ("MirrorsEdge", "Steam") //Taken from Toyro's Chapter Autosplitter
{
    float IGT : 0x01C553D0, 0xCC, 0x1CC, 0x2F8, 0x9C, 0xCC4, 0x368, 0x114;
    string50 level : 0x01BF8B20, 0x3CC, 0x0;
    string50 progress : 0x01C553D0, 0xCC, 0x560, 0x0;
}

state ("MirrorsEdge", "Origin")
{
    float IGT: 0x01C6E50C, 0xCC, 0x1CC, 0x2F8, 0x9C, 0xCC4, 0x368, 0x114;
    string50 level : 0x01C11BE0, 0x330, 0x0;
}

state ("MirrorsEdge", "Reloaded")
{
    float IGT: 0x01C6E50C, 0xCC, 0x1CC, 0x2F8, 0x9C, 0xCC4, 0x368, 0x114;
    string50 level : 0x01C6EFE0, 0x170, 0x1DC, 0x1E8, 0x3C, 0x528, 0x3CC, 0x0;
}

state ("MirrorsEdge", "Origin (Asia)")
{
    float IGT: 0x01B8BE54, 0xCC, 0x1CC, 0x2F8, 0x9C, 0xCC4, 0x368, 0x114;
}

state ("MirrorsEdge", "Origin (DLC)")
{
    float IGT: 0x01C7561C, 0xE4, 0x1CC, 0x2F8, 0x9C, 0xCC4, 0x368, 0x114;
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 32976896:
        case 32632832:
        version = "Steam";
        break;
        
        case 42889216:
        version = "Origin";
        break;
        
        case 60298504:
        case 42876928:
        version = "Reloaded";
        break;
        
        case 42717184:
        version = "Origin (Asia)";
        break;
        
        case 43794432:
        version = "Origin (DLC)";
        break;
        
        default:
        MessageBox.Show("Memory Size: " + modules.First().ModuleMemorySize.ToString(), "Unknown Version Detected!");
        version = "Unknown";
        break;
    }
}

// Weighted so the splits will only split forward, consecutively
startup
{
    refreshRate = 62;
    vars.mm     = "TdMainMenu";
    vars.tut    = "tutorial_p";
    vars.levels = new Dictionary<string, int>()
    {
        {"TdMainMenu", 1},
        {"Edge_p", 2},
        {"Escape_p", 3},
        {"Stormdrain_p", 4},
        {"Cranes_p", 5},
        {"subway_p", 6},
        {"mall_p", 7},
        {"factory_p", 8},
        {"Boat_p", 9},
        {"Convoy_p", 10},
        {"Scraper_p", 11}
    };
    vars.end  = "Scraper_p";
    settings.Add("bag_reset", false, "Reset Bags on New Game. Steam only");
}

update
{
    //Reset the bag counter to 0 when starting a new game (steam only)
    if (settings["bag_reset"] && current.level == vars.tut && old.level == vars.mm)
    {
        IntPtr hProcess = game.Handle;
        IntPtr addr = IntPtr.Add(modules.First().BaseAddress, 0x01BFBB54);
        int[] offsets = { 0x0, 0xC, 0x74, 0x3C, 0x5C, 0x4C, 0x7A4 };
        byte[] buf = new byte[4];
        UIntPtr bytesRead, bytesWritten;
        
        foreach (int offset in offsets)
        if (!WinAPI.ReadProcessMemory(hProcess, addr, buf, (UIntPtr)4, out bytesRead)) return;
        else addr = IntPtr.Add((IntPtr)BitConverter.ToInt32(buf, 0), offset);
        
        WinAPI.WriteProcessMemory(hProcess, addr, BitConverter.GetBytes(0UL), (UIntPtr)8, out bytesWritten);
    }
}

split
{
    if (current.level == vars.mm || old.level == vars.mm) return false;
    if (
    vars.levels.ContainsKey(current.level) &&
    vars.levels.ContainsKey(old.level) &&
    vars.levels[current.level] == vars.levels[old.level] + 1) return true;
    
    //Condition for final split
    if (current.level == "Scraper_p" && current.progress == "AnyPercentCompleted" && old.progress != current.progress)
    return true;
}

start
{
    return current.level == vars.tut && old.level == vars.mm;
}

reset
{
    return current.level == vars.tut && old.level != vars.tut;
}

gameTime
{
    if (current.IGT != 0)
    return TimeSpan.FromSeconds(current.IGT);
}

isLoading
{
    return true;
}