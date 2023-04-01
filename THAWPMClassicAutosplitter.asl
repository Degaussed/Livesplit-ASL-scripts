state("THAWPM")
{
    bool isLoading: 0x458FFC; // Movie is playing
    string10 z_level: 0x4A4570; // Current level
    string28 lastloadscrn: 0x003D9244, 0x0; // string name of previous load screen ex: "loadscrn_generic_1"
    byte goalcount: 0x003D0BA8, 0x9F8; // Counts total goals, resets to 0 on new game
    byte runcomplete: 0x004A8A20, 0x4, 0x8BC, 0xC; // returns true when player selects end run and spams through the goal cams / goal list
}

startup {
    refreshRate = 62;

    settings.Add("catClassic", true, "Classic");
    settings.SetToolTip("catClassic", "Classic Mode.");

    vars.levels = new Dictionary<string, int>()
    {
        {"z_mainmenu", 0},
        {"Z_DN", 1},
        {"Z_SZ", 2},
        {"Z_MA", 3},
        {"Z_CH", 4},
        {"Z_JA", 5},
        {"Z_SV2", 6}
    };
    vars.end  = "Z_SV2";
}

split
{
    if (current.z_level != old.z_level && vars.levels[current.z_level] > vars.levels[old.z_level])
    {
        return true;
    }
    else if (current.runcomplete == 1 && current.runcomplete != old.runcomplete && (current.z_level == vars.end && current.goalcount == 52 || current.goalcount == 60))
    {
        return true;
    }
}

isLoading
{
    return current.isLoading;
}

start
{
    return current.z_level == "Z_DN" && old.z_level == "z_mainmenu";
}

reset
{
    return current.z_level == "z_mainmenu" && old.z_level != "z_mainmenu";
}

//if something breaks join and complain about it https://thps.run/discord