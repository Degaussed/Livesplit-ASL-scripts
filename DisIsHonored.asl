state("DisIsHonored-Win64-Shipping")
{
    string100 level : 0x04493CA0, 0xC38, 0x0, 0xF8, 0x28;
    bool load       : 0x3FDAED0;
    //byte templeObj  : 0x044804A0, 0x70, 0x35C;
    float temple    : 0x04497560, 0x258, 0x110, 0x560, 0x260, 0x54;
}

startup
{
    vars.MM = "MainMenu";
    vars.Intro = "Tutorial_Gameplay";
    vars.Temple = "Temple_Gameplay";
}

update
{
    //print("Level = " + current.level);
}

split
{
    if (current.level == vars.MM || old.level == vars.MM) return false;
    else if (old.level != current.level) return true;

    if (current.temple < 2.6 && old.temple > 2.6 && current.level == vars.Temple)
        return true; // janky end split using distance from the objective label
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
    return !current.load;
}