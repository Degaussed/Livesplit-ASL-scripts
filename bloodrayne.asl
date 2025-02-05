state("rayne", "Legacy Version") // by ToxicTT
{
    float IGT : 0x2C3C0C;
    string12 map: 0x2C66DB;
}

state("rayne1", "GOG 1.03") // Terminal Cut Support by Heki
{
    float IGT : 0x18B5F00;
    string12 map: 0x1AA7798;
}

state("rayne1", "GOG 1.04")
{
    float IGT : 0x18B6F20;
    string12 map: 0x1B620D8;
}
    
state("rayne1", "GOG 1.05")
{
    float IGT : 0x18B7F20;
    string12 map: 0x1B630D8;
}

state("rayne1", "Steam / GOG 1.06")
{
    float IGT : 0x18BC2A8;
    string12 map: 0x1B67460;
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 28692480: 
            version = "GOG 1.03";
            break;
        case 29454336 : 
            version = "GOG 1.04";
            break;
        case 29458432 : 
            version = "GOG 1.05";
            break;
        case 29483008 : 
            version = "Steam / GOG 1.06";
            break;
        case 6029312 :
            version = "Legacy Version";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
		var response = MessageBox.Show 
        (
            "This game is timed using Game Time, \n"+
            "Livesplit is currently set to Real Time. \n"+
            " \n"+ 
            "Change comparison to Game Time?",
            "Livesplit | BloodRayne",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        if (response == DialogResult.Yes){
            timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
        }
        settings.Add("givecheats", false, "Enable BloodRayne Debug Menu");
}

update
{
    if (settings["givecheats"])
    {
    //Extra Debug options
    IntPtr hProcess = game.Handle;
    IntPtr lpBaseAddress = IntPtr.Add(modules.First().BaseAddress, 0x3302CC);
    byte[] lpBuffer = BitConverter.GetBytes((UInt32)4294967295);
    UIntPtr nSize = (UIntPtr)lpBuffer.Length;
    UIntPtr lpNumberOfBytesWritten = UIntPtr.Zero;
    bool bSuccess = WinAPI.WriteProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, out lpNumberOfBytesWritten);

    //Debug bool
    lpBaseAddress = IntPtr.Add(modules.First().BaseAddress, 0x2C3BD8);
    lpBuffer = new byte[] { 0 };
    lpNumberOfBytesWritten = UIntPtr.Zero;
    bSuccess = WinAPI.WriteProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, out lpNumberOfBytesWritten);
    }
}

start
{
	if (old.IGT == 0 & current.IGT > 0 && current.map == "church.msn")
        return true;
}

split
{	
    if (old.map != current.map)
    	return true;
}

reset
{
    if (current.IGT == 0 && current.map == "church.msn")
        return true;
}

gameTime
{
    return TimeSpan.FromSeconds(current.IGT);
}