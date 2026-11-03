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

    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "user")

    local User = InfoTab:AddLeftGroupbox("User Info")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("Welcome: " .. LocalPlayer.Name, true)
    User:AddLabel("ID: " .. LocalPlayer.UserId, true)
    User:AddLabel("Total Executions: " .. (ii5601ware.TotalExecutions and ii5601ware.TotalExecutions or "N/A"), true)
end
