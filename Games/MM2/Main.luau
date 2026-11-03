local LoadStart = tick()
ii5601ware.SavePath = "MM2"

local Library = ii5601ware.Interface.Library
local SaveManager = ii5601ware.Interface.SaveManager
local ThemeManager = ii5601ware.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
	if ii5601ware and ii5601ware.Environment.cloneref then
		return ii5601ware.Environment.cloneref(Object)
	end
	return Object
end

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return CloneReference(game:GetService(Name))
	end
})

local Globals = {}
local Connections = {}
local ESPConnections = {}
local Groupboxes = {}
local Functions = {}
local PartProperties = {}

Globals.IncompatibleMessage = "Your executor doesn't support this feature."

Functions.CheckCompatability = function(Array)
	for _, Name in Array do
		if not ii5601ware.Environment[Name] then
			return false
		end
	end
	return true
end

local LocalPlayer = Services.Players.LocalPlayer

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return ii5601ware.Environment.gethui()
	end
	return Services.CoreGui
end

local NotificationLibrary = {
	LiveNotifications = 0,
	Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = ii5601ware.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
	Library.Scheme = setmetatable({}, {
		__index = function(Self, Name)
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
        Container = ii5601ware.Environment.gethui()
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

local function getHRP()
	local char = LP.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
	local char = LP.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end
local function getEquippedTool()
	local char = LP.Character
	return char and char:FindFirstChildOfClass("Tool")
end
local function aimAt(targetPos)
	local cam = workspace.CurrentCamera
	if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos) end
end
local function tpTo(pos)
	local hrp = getHRP()
	if hrp then hrp.CFrame = CFrame.new(pos) end
end

local killingAll = false
local killingSheriff = false

local function knifeKill(target)
	local tool = getEquippedTool()
	if not tool then return end
	local tchar = target.Character
	if not tchar then return end
	local thrp = tchar:FindFirstChild("HumanoidRootPart")
	local thum = tchar:FindFirstChildOfClass("Humanoid")
	if not thrp or not thum or thum.Health <= 0 then return end
	tpTo(thrp.Position)
	task.wait(0.03)
	local hrp = getHRP()
	if hrp then hrp.CFrame = CFrame.new(thrp.Position, thrp.Position + thrp.CFrame.LookVector) end
	task.wait(0.03)
	pcall(function() tool:Activate() end)
	task.wait(killDelay)
end
local function gunKill(target)
	local tool = getEquippedTool()
	if not tool then return end
	local tchar = target.Character
	if not tchar then return end
	local thrp = tchar:FindFirstChild("HumanoidRootPart")
	local thum = tchar:FindFirstChildOfClass("Humanoid")
	if not thrp or not thum or thum.Health <= 0 then return end
	tpTo(thrp.Position)
	task.wait(0.05)
	local hrp = getHRP()
	local aimPos = thrp.Position + Vector3.new(0, 0.5, 0)
	if hrp then hrp.CFrame = CFrame.new(thrp.Position, aimPos) end
	aimAt(aimPos)
	task.wait(0.05)
	pcall(function() tool:Activate() end)
	task.wait(killDelay)
end

local function killAllLoop()
	while killingAll do
		local tool = getEquippedTool()
		if tool and tool.Name == "Knife" then
			for _, plr in ipairs(Players:GetPlayers()) do
				if not killingAll then break end
				if plr ~= LP and plr.Character then
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then knifeKill(plr) end
				end
			end
		end
		task.wait(0.05)
	end
end
local function killSheriffLoop()
	while killingSheriff do
		local tool = getEquippedTool()
		if tool and tool.Name == "Gun" then
			for _, plr in ipairs(Players:GetPlayers()) do
				if not killingSheriff then break end
				if plr ~= LP and plr.Character and isKnifeHolder(plr) then
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then gunKill(plr) end
				end
			end
		end
		task.wait(0.05)
	end
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

local Window = Library:CreateWindow({
    Title = "ii5601ware",
    Footer = "vBeta | [key type] | MM2",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
    CornerRadius = 2,
})

ii5601ware.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab("General", "house"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Exploits = Window:AddTab("Exploits", "sword"),
    Troll = Window:AddTab("Troll", "face-smile"),
    Teleport = Window:AddTab("Teleport", "map")
}

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

ii5601ware.ESPLibrary:SetRainbow(false)
ii5601ware.ESPLibrary:SetShowDistance(true)
ii5601ware.ESPLibrary:SetFillTransparency(0.75)
ii5601ware.ESPLibrary:SetOutlineTransparency(0)
ii5601ware.ESPLibrary:SetTextTransparency(0)
ii5601ware.ESPLibrary:SetTextOutlineTransparency(0)
ii5601ware.ESPLibrary:SetRenderLimit(240)
ii5601ware.ESPLibrary:SetFadeTime(0.25)
ii5601ware.ESPLibrary:SetTextSize(20)
ii5601ware.ESPLibrary:SetFont(Enum.Font.Highway)
ii5601ware.ESPLibrary:SetTracers(false)
ii5601ware.ESPLibrary:SetTracerSize(0.75)
ii5601ware.ESPLibrary:SetTracerOrigin("Bottom")
ii5601ware.ESPLibrary:SetArrows(false)
ii5601ware.ESPLibrary:SetArrowRadius(250)
ii5601ware.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(V)        ii5601ware.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   ii5601ware.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        ii5601ware.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     ii5601ware.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        ii5601ware.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) ii5601ware.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        ii5601ware.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     ii5601ware.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        ii5601ware.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        ii5601ware.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   ii5601ware.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   ii5601ware.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) ii5601ware.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    ii5601ware.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    ii5601ware.ESPLibrary:SetArrowRadius(V) end)

Groupboxes.Player = Tabs.General:AddGroupbox({
    Side = "Left",
    Name = "Player",
    Description = "Some player modification",
    IconName = "user-round-pen"
})

Groupboxes.Round = Tabs.General:AddGroupbox({
    Side = "Right",
    Name = "Round",
    Description = "Control the round",
    IconName = "user-round-pen"
})

Groupboxes.Round:AddButton("Kill All", function()
    task.spawn(function() killAllLoop() end)
end)

Groupboxes.Round:AddButton("Kill Murder", function()
    task.spawn(function() killSheriffLoop() end)
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("MurderESPToggle", {
    Text = "Murder",
    Default = false,
    Tooltip = "Highlights the Murder."
}):AddColorPicker("MurderESPColor", {
    Text = "Murder",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0
})

Groupboxes.Visuals_ESP_Toggles:AddToggle("SheriffESPToggle", {
    Text = "Sheriff",
    Default = false,
    Tooltip = "Highlights the Sheriff."
}):AddColorPicker("SheriffESPColor", {
    Text = "Sheriff",
    Default = Color3.fromRGB(0, 0, 255),
    Transparency = 0
})

Groupboxes.Visuals_ESP_Toggles:AddToggle("HeroESPToggle", {
    Text = "Hero",
    Default = false,
    Tooltip = "Highlights the Hero."
}):AddColorPicker("HeroESPColor", {
    Text = "Hero",
    Default = Color3.fromRGB(255, 255, 0),
    Transparency = 0
})

Groupboxes.Visuals_ESP_Toggles:AddToggle("InnocentsESPToggle", {
    Text = "Innocents",
    Default = false,
    Tooltip = "Highlights the Innocents."
}):AddColorPicker("InnocentsESPColor", {
    Text = "Innocents",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0
})

