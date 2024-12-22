state ("UO-Win64-Shipping", "v1.0.1") //81231872
{
    string100 level   : 0x04948798, 0x8B0, 0x14;        // Unicode String tracking the current loaded level
    byte      idol    : 0x049346D0, 0x30, 0x250, 0x768; // Byte value tracking the idols broken in LV_Stage_RGB
    bool      loading : 0x444B878;
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 81231872: 
            version = "v1.0.1";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
{
    vars.mm     = "LV_title";
    vars.boss   = "LV_Stage_RGB";
    vars.start  = "LV_Arena_Entrance";
    vars.hub    = "LV_Arena_concourse";
}

split
{
    if (current.level == vars.mm || old.level == vars.mm || old.level == vars.hub) return false;
    else if (old.level != current.level) return true;
    
    return current.level == vars.boss && old.idol == 5 && current.idol == 6; //end split
}

start
{
    return current.level == vars.start && old.level == vars.mm;
}

isLoading
{
    return !current.loading;
}