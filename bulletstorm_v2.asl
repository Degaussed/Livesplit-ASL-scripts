state("StormGame-Win64-Shipping", "Full Clip") //62898176
{
    string50 level: 0x03951AC0, 0x0;
    bool loading:   0x37CF5F0;
}

state("StormGame-Win64-Shipping", "Lite Edition") //62812160
{
    string50 level: 0x039581F0, 0x0;
    bool loading: 0x37D25F0;
}

startup
{
    vars.mm = "BSStart";
}

update
{
    //print("buh " + current.loading);
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 62898176:
            version = "Full Clip";
            break;

        case 62812160:
            version = "Lite Edition";
            break;

        default:
            MessageBox.Show("Memory Size: " + modules.First().ModuleMemorySize.ToString(), "Unknown Version Detected!");
            version = "Unknown";
            break;
    }

    vars.seenLevels = new List<string>();
}

split //temp until we have a full run so i can make a string dictionary
{
    if (current.level != vars.mm
        && old.level != vars.mm
        && current.level != old.level
        && !vars.seenLevels.Contains(current.level))
    {
        vars.seenLevels.Add(current.level);
        return true;
    }

    return false;
}

isLoading
{
    return !current.loading;
}

start
{
    return !current.loading && current.level == "SP_Crash_P" && old.level == "BSStart";
}

reset
{
    vars.seenLevels.Clear();
}