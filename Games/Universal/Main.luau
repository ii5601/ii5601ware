local Services = setmetatable({}, {
    __index = function(self, Name)
        if Abysall.Environment.cloneref then
            return Abysall.Environment.cloneref(game:GetService(Name))
        else
            return game:GetService(Name)
        end
    end
})

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function(Response)
    local Success, Result = pcall(function()
        toclipboard(game.PlaceId)
    end)
    if not Success then
        Services.LocalPlayer:Kick("Failed to copy PlaceId.\nPlaceId: " .. game.PlaceId .. "\nError: " .. Result)
    end
end

Services.StarterGui:SetCore("SendNotification", {
    Title = "ii5601ware",
    Text = "Only DOORS, Piggy, and Work At Pizza Place are supported right now, sorry :)",
    Duration = 10,
    Button1 = "Copy PlaceId",
    Callback = Bindable,
})
