return function(Window)
	local function CloneReference(Object)
		if ii5601ware and ii5601ware.Environment.cloneref then
			return ii5601ware.Environment.cloneref(Object)
		else
			return Object
		end
	end
	
	local Services = setmetatable({}, {
		__index = function(self, Name)
			return CloneReference(game:GetService(Name))
		end
	})

	local Library = ii5601ware.Interface.Library
	local SaveManager = ii5601ware.Interface.SaveManager
	local ThemeManager = ii5601ware.Interface.ThemeManager
	
	local Toggles = Library.Toggles
	local Options = Library.Options
	
	local SettingsTab = Window:AddTab("Settings", "settings")
	local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")
	
	MenuGroup:AddToggle("KeybindMenuOpen", {
		Default = Library.KeybindFrame.Visible,
		Text = "Open Keybind Menu",
		Callback = function(value)
			Library.KeybindFrame.Visible = value
		end,
	})
	MenuGroup:AddToggle("ShowCustomCursor", {
		Text = "Custom Cursor",
		Default = false,
		Callback = function(Value)
			Library.ShowCustomCursor = Value
		end,
	})
	
	MenuGroup:AddDropdown("DPIDropdown", {
		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
		Default = "100%",
	
		Text = "DPI Scale",
	
		Callback = function(Value)
			Value = Value:gsub("%%", "")
			local DPI = tonumber(Value)
	
			Library:SetDPIScale(DPI)
		end,
	})
	MenuGroup:AddDivider()
	MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
	
	MenuGroup:AddButton("Rejoin Server", function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
	end)
	
	MenuGroup:AddButton("Copy Discord Link", function()
		setclipboard("https://discord.gg/WBdRuUmkmr")
	end)

	MenuGroup:AddButton("Unload", function()
		Library:Unload()
	end)
	
	Library.ToggleKeybind = Options.MenuKeybind
	
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({"UILibrary"})
	ThemeManager:SetFolder("ii5601ware")
	SaveManager:SetFolder("ii5601ware/" .. ii5601ware.SavePath)
	SaveManager:BuildConfigSection(SettingsTab)
	ThemeManager:ApplyToTab(SettingsTab)
	SaveManager:LoadAutoloadConfig()
end
