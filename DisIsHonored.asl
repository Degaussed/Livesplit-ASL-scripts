state("DisIsHonored-Win64-Shipping")
{
    string100 level : 0x04493CA0, 0xC38, 0x0, 0xF8, 0x28;
    bool load       : 0x3FDAED0;
    float temple    : 0x04497560, 0x258, 0x110, 0x560, 0x260, 0x54;
    byte screen     : 0x044804A0, 0x70, 0x35C; // Menu = 3, Stats, Death & Pause = 0
}

startup
{
    settings.Add("PoC", false, "(Testing only) Pause timer on Stats, Death and Pause screen.");
    vars.MM = "MainMenu";
    vars.Intro = "Tutorial_Gameplay";
    vars.Temple = "Temple_Gameplay";
    vars.levels = new Dictionary<string, int>()
    {
        {"MainMenu", 0},
        {"Tutorial_Gameplay", 1},
        {"BarracksInterior_Gameplay", 2},
        {"BarracksExterior_Gameplay", 3},
        {"CivilianMarketplace_Gameplay_Level", 4},
        {"City_Gameplay", 5},
        {"DockYard_Gameplay", 6},
        {"RatTunnel_Gameplay_Level", 7},
        {"DropAttack_Gameplay", 8},
        {"Temple_Gameplay", 9}
    };
    vars.end  = "Temple_Gameplay";
}

update
{
    //print("Debug = " + current.screen);
}

split
{
    if (current.level != old.level && vars.levels[current.level] > vars.levels[old.level])
        return true;

    // janky end split using distance from the objective label
    return (current.temple < 3.0 && old.temple > 3.0) && current.level == vars.Temple;
}

reset
{
    return (current.level == vars.Intro && old.level == vars.MM);
}

start
{
    return (old.level == vars.MM && current.level == vars.Intro);
}

isLoading
{
    return !current.load || settings["PoC"] && current.screen == 0;
}