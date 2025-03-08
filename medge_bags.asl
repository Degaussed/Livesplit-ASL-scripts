//This is a Livesplit script to display and reset the Bag counter in Mirror's Edge. (Steam)
//This is NOT an Autosplitter
state("MirrorsEdge")
{
    ulong bags: 0x01BFBB54, 0x0, 0xC, 0x74, 0x3C, 0x5C, 0x4C, 0x7A4; //Seems to be a bitmask for bags
    string100 persLevel: 0x01BF8B20, 0x3CC, 0x0;
}

startup
{
    vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
    settings.Add("bag_count", true, "Bag Counter");
    settings.Add("bag_reset", false, "Reset Bags on New Game");
}

update
{
    //increase bag counter component for every bag collected
    var bagCount = 0;
    for (int i = 0; i < 30; i++)
    {
        if ((current.bags & (ulong)Math.Pow(2, i)) > 0)
			bagCount++;
    }
    vars.BagsToString = bagCount.ToString();
    if (settings["bag_count"]){vars.SetTextComponent("Bag Counter", (bagCount).ToString()); }


    //Write ulong (change bags value to 0 on new game)
    if (settings["bag_reset"] && current.persLevel == "tutorial_p" && old.persLevel == "TdMainMenu")
    {
        bool bSuccess;
        IntPtr hProcess = game.Handle;
        IntPtr lpPtrPath = IntPtr.Add(modules.First().BaseAddress, 0x01BFBB54);
        byte[] lpBuffer = BitConverter.GetBytes((ulong)0);
        UIntPtr nSize = (UIntPtr)lpBuffer.Length;
        UIntPtr lpNumberOfBytesWritten = UIntPtr.Zero;
        UIntPtr nReadSize = (UIntPtr)4;
        byte[] lpReadBuf = new byte[4];
        UIntPtr lpNumberOfBytesRead = UIntPtr.Zero;

        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x0);
        
        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0xC);

        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x74);
        
        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x3C);

        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x5C);

        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x4C);

        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        lpPtrPath = (IntPtr)BitConverter.ToInt32(lpReadBuf, 0);
        lpPtrPath = IntPtr.Add(lpPtrPath, 0x7A4);
        
        bSuccess = WinAPI.WriteProcessMemory(hProcess, lpPtrPath, lpBuffer, nSize, out lpNumberOfBytesWritten);
        bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
        ulong bagwatch = BitConverter.ToUInt32(lpReadBuf, 0);
    }
}