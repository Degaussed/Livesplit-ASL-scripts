state("Alone")
{
bool isLoading : "Alone.exe", 0xBD624C;
bool split : "Alone.exe", 0xBDA654;
}

isLoading
{
return current.isLoading || current.split;
}


split
{
return !old.split && current.split;
}
