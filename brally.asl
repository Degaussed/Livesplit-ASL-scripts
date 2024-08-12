state("BRally", "Retail: Internet Archive") //57344

{
    bool isLoading: "BRD3D.dll", 0x6909F0;  // 1 in Menu
    byte inRace:    "BRD3D.dll", 0x6909E4;  // 1 in race
    int points:     "BRD3D.dll", 0xAA28C4;  // Total number of points for the race season.
    int carID:      "BRD3D.dll", 0x39EB10;  // Numeric value of selected car
    int SPACE:      "BRD3D.dll", 0x22AF14;  // 1 after pressing space to start race
}

startup
{
    vars.LD = 8; // Coastline-Lancia Delta
    vars.ES = 1; // Coastline-Escort Cosworth
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
	settings.Add("season_points", true, "Season Points"); // Taken from FAITHTheUnholyTrinity.asl
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 57344: 
            version = "Retail: Internet Archive";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
}

update
{
    vars.CurRoomToString = current.points.ToString();
		if (settings["season_points"])
        {
            vars.SetTextComponent("Season Points", (current.points).ToString());
        }
}

split
{
    if (current.points > old.points)
        return true;
}

start
{
    return (current.carID == vars.ES || current.carID == vars.LD) && current.inRace == 1 && current.SPACE == 0;
}

isLoading
{
    return current.isLoading;
}