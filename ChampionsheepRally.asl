state("CSR") 
{
    string6 level   : 0x1B06BE;
    string10 script : 0x001AA3F0, 0x90;
    int lap         : 0x001AA444, 0x18, 0x10;
    bool isLoading  : 0x001AA3F0, 0xB0C, 0x18;
}

startup
{
    settings.Add("Full Game", true, "Full Game");
    settings.Add("IL Mode", false, "Individual Level");
}

update
{
    vars.intro = "RO RtcIntr";
    //print("Level = " + current.script);
}

split
{
    if (current.level == "Level0" || old.level == "Level0") return false;
    else if (old.level != current.level) return true;
}

isLoading
{
    return current.isLoading;
}

start
{
    if (settings["Full Game"] && old.script == vars.intro && current.isLoading)
    return true;
    if (settings["IL Mode"] && current.level != "Level0" && current.lap == 1 && old.lap == 0)
    return true;
}

reset
{
    if (settings["IL Mode"] && current.lap == 0 && old.lap > 0)
        return true;
    if (settings["Full Game"] && current.level == "Level1" && current.script == vars.intro)
        return true;
}