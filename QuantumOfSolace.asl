state("JB_LiveEngine_s", "No-CD") //3575808
{
    byte cutsc:         "jb_sp_s.dll", 0x19D90DC; //always 1 when a loading cutscene is playing.
    byte isLoading:     "jb_sp_s.dll", 0x13ABC3C; //loading
    string22 map:       "jb_sp_s.dll", 0x11115D0; //Our current loaded level. ui=MainMenu
    string18 bink:      "jb_sp_s.dll", 0x13A6CE0; //current .bik movie
    float IGT:          "jb_sp_s.dll", 0x16694E8; //Tracks time spent in level, reverts on checkpoint loading
    float cY:           "jb_sp_s.dll", 0x20B101C;
    float cX:           "jb_sp_s.dll", 0x20B1018;
    float cZ:           "jb_sp_s.dll", 0x20B1020;
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 3575808: 
            version = "No-CD";
            break;
        default:
        print("Unknown version detected");
        return false;
    }
}

update
{
    //print("Module size: " + modules.First().ModuleMemorySize);
    //print("map " + current.map);
}

split
{
    if (current.map == "ui" || old.map == "ui") return false; //regular splits, excluding menu trnasitions
    else if (old.map != current.map)
        return true;

    if ((current.cY == 0 && current.cX == -4 && current.cZ == 1) && current.map == "eco_hotel" && current.IGT > 100) //Final split
        return true;
}

isLoading
{
    return current.isLoading == 1 || current.cutsc == 1;
}

start
{
    return current.bink == "whites_estate_load";
}

exit
{
    timer.IsGameTimePaused = true;
    print("Did we crash?");
}