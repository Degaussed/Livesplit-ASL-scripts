state("Speed")
{
bool split : "Speed.exe", 0x334534;
}



split
{
return !current.split && old.split;
}
