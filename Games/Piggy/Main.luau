local LoadStart = tick()
Abysall.SavePath = "Piggy"

local Library = Abysall.Interface.Library
local SaveManager = Abysall.Interface.SaveManager
local ThemeManager = Abysall.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

local Groupboxes = {}
local Globals = {}
local Connections = {}
local Functions = {}
local Objects = {}
local ObjectsPiggy = {}

local LocalPlayer = Services.Players.LocalPlayer

while not LocalPlayer.Character do
    task.wait()
end
task.wait(1)

local Window = Library:CreateWindow({
    Title = "ii5601ware",
    Footer = "vBeta | [key type]",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
    CornerRadius = 2,
})
print("Window loaded!")
Abysall.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab("General", "house"),
    Visuals = Window:AddTab("Visuals", "eye"),
}

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not Abysall.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return Abysall.Environment.gethui()
	else
		return Services.CoreGui
	end
end

local NotificationLibrary = {
	LiveNotifications = 0,
    Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = Abysall.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
    Library.Scheme = setmetatable({}, {
        __index = function(self, Name)
            return Library[Name]
        end
    })
end

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	task.spawn(function()
		local Notification = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Warning = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
        local UICorner2 = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")

		Notification.Name = "Notification"
		Notification.Parent = Container
		Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
		Notification.BackgroundTransparency = 0.4
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
		Notification.Size = UDim2.new(0, 420, 0, 50)
        Notification:SetAttribute("ID", NotificationLibrary.Notifications)
        Notification:SetAttribute("CurrentPosition", Notification.Position)

		Line.Name = "Line"
		Line.Parent = Notification
		Line.BackgroundColor3 = Library.Scheme.AccentColor
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 1, -3)
		Line.Size = UDim2.new(0, 0, 0, 3)

		Warning.Name = "Warning"
		Warning.Parent = Notification
		Warning.BackgroundTransparency = 1
		Warning.Position = UDim2.new(0, 10, 0, 5)
		Warning.Size = UDim2.new(0, 40, 0, 40)
		Warning.Image = "rbxassetid://3944668821"
		Warning.ImageColor3 = Library.Scheme.AccentColor
		Warning.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 20)
		UICorner.Parent = Warning

        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 60, 0.155, 0)
		Title.Size = UDim2.new(0, 205, 0, 15)
		Title.Text = TitleText or "..."
		Title.TextColor3 = Library.Scheme.FontColor
		Title.TextSize = 10
		Title.TextStrokeTransparency = 0.75
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Description.Name = "Description"
		Description.Parent = Notification
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1.000
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
        Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left
		
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications + 1
        NotificationLibrary.Notifications = NotificationLibrary.Notifications + 1
		Services.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset)}):Play()

		task.wait(0.25)
		Services.TweenService:Create(Line, TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 400, 0, 3)}):Play()
		task.wait(Delay - 0.25)

        Notification:SetAttribute("Destroying", true)
		Services.TweenService:Create(Notification, TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset)}):Play()
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications - 1
        
        for Index, Object in pairs(Container:GetChildren()) do
            if Object.Name == "Notification" and Object:GetAttribute("ID") and Object:GetAttribute("ID") > Notification:GetAttribute("ID") and Object:GetAttribute("Destroying") ~= true and Object.Position.Y.Offset ~= 60 then
                Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, Object:GetAttribute("CurrentPosition").Y.Offset - 60))
                Services.TweenService:Create(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = UDim2.new(1, -370, 0, Object:GetAttribute("CurrentPosition").Y.Offset)}):Play()
            end
        end
        task.wait(0.75)
		Notification:Destroy()
	end)
end

Functions.Notify = function(Settings)
    local Container
    if Functions.CheckCompatability({"gethui"}) then
        Container = Abysall.Environment.gethui()
    else
        Container = Services.CoreGui
    end

    local Sound = Instance.new("Sound", Container)
    Sound.SoundId = "rbxassetid://8784885431"
    Sound.Volume = 3
    Sound.PlayOnRemove = true
    Sound:Destroy()

    NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

Groupboxes.Visuals_ESP          = Tabs.Visuals:AddRightTabbox("ESP/Settings")
Groupboxes.Visuals_ESP_Toggles  = Groupboxes.Visuals_ESP:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_ESP:AddTab("Settings")

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow",     { Text = "Rainbow Effect", Default = false, Tooltip = "Makes the esp objects change colour like a rainbow." })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance",{ Text = "Show Distance",  Default = true,  Tooltip = "Shows how far away your character is from the object." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency",        { Text = "Fill Transparency",         Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency",     { Text = "Outline Transparency",      Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextTransparency",        { Text = "Text Transparency",         Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextOutlineTransparency", { Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime",                { Text = "Fade Time",                 Min = 0, Max = 1, Default = 0.25, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPRenderLimit",             { Text = "Render Limit",              Min = 30, Max = 240, Default = 240, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize",                { Text = "Text Size",                 Min = 12, Max = 24, Default = 20, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", {
	Text = "Text Font",
	Values = { "Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","SourceSansSemibold","Gotham","GothamMedium","GothamBold","GothamBlack","AmaticSC","Bangers","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu","BuilderSans","BuilderSansMedium","BuilderSansBold","BuilderSansExtraBold","Arimo","ArimoBold" },
	Default = 12
})
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin",  { Text = "Tracer Origin", Values = { "Bottom","Center","Top","Mouse" }, Default = 1 })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness",  { Text = "Tracer Thickness", Min = 0.5, Max = 2, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle",    { Text = "Enable Tracers", Default = false, Tooltip = "Draws a line to highlighted objects." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius",     { Text = "Arrow Radius", Min = 100, Max = 500, Default = 250, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle",     { Text = "Enable Arrows", Default = false, Tooltip = "Shows arrow that point to off-screen objects." })

Abysall.ESPLibrary:SetRainbow(false)
Abysall.ESPLibrary:SetShowDistance(true)
Abysall.ESPLibrary:SetFillTransparency(0.75)
Abysall.ESPLibrary:SetOutlineTransparency(0)
Abysall.ESPLibrary:SetTextTransparency(0)
Abysall.ESPLibrary:SetTextOutlineTransparency(0)
Abysall.ESPLibrary:SetRenderLimit(240)
Abysall.ESPLibrary:SetFadeTime(0.25)
Abysall.ESPLibrary:SetTextSize(20)
Abysall.ESPLibrary:SetFont(Enum.Font.Highway)
Abysall.ESPLibrary:SetTracers(false)
Abysall.ESPLibrary:SetTracerSize(0.75)
Abysall.ESPLibrary:SetTracerOrigin("Bottom")
Abysall.ESPLibrary:SetArrows(false)
Abysall.ESPLibrary:SetArrowRadius(250)
Abysall.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(V)        Abysall.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   Abysall.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     Abysall.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) Abysall.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        Abysall.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     Abysall.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        Abysall.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        Abysall.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   Abysall.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   Abysall.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) Abysall.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    Abysall.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    Abysall.ESPLibrary:SetArrowRadius(V) end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("PiggyESPToggle", {
    Text = "Piggy",
    Default = false,
    Tooltip = "Highlights the Piggy."
}):AddColorPicker("PiggyESPColor", {
    Text = "Piggy",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0
})

local function UpdatePiggyESP(Object)
	if Toggles.PiggyESPToggle.Value then
		Abysall.ESPLibrary:AddESP({
			Object = Object,
			Text = "Piggy",
			Color = Options.PiggyESPColor.Value
		})
	else
		Abysall.ESPLibrary:RemoveESP(Object)
	end
end

local function AddPiggy(Object)
	if Object.Name ~= "PiggyNPC" then
		return
	end

	if table.find(ObjectsPiggy, Object) then
		return
	end

	table.insert(ObjectsPiggy, Object)
	UpdatePiggyESP(Object)
end

local function RemovePiggy(Object)
	local Index = table.find(ObjectsPiggy, Object)
	if not Index then
		return
	end

	Abysall.ESPLibrary:RemoveESP(Object)
	table.remove(ObjectsPiggy, Index)
end

for _, Object in Workspace:GetDescendants() do
	AddPiggy(Object)
end

Workspace.DescendantAdded:Connect(function(Object)
	AddPiggy(Object)
end)

Workspace.DescendantRemoving:Connect(function(Object)
	RemovePiggy(Object)
end)

Toggles.PiggyESPToggle:OnChanged(function()
	for _, Object in ObjectsPiggy do
		UpdatePiggyESP(Object)
	end
end)

Options.PiggyESPColor:OnChanged(function(Value)
	for _, Object in ObjectsPiggy do
		Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
	end
end)