state("Speed", "1.4eu")
{
    bool split : "Speed.exe", 0x2EE568;
    string3 movie : "Speed.exe", 0x38EF73;
}

state("Speed", "1.4na")
{
    bool split : "Speed.exe", 0x2EE568;
    string3 movie : "Speed.exe", 0x38EF83;
}

init
{
    version = "";
    if (modules.First().ModuleMemorySize == 3752808) {
        version = "1.4na";
    }
}

split
{
    return !current.split && old.split && current.movie != "DAY";
}
