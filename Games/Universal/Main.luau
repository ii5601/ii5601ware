local Services = setmetatable({}, {
    __index = function(self, Name)
        if ii5601ware.Environment.cloneref then
            return ii5601ware.Environment.cloneref(game:GetService(Name))
        else
            return game:GetService(Name)
        end
    end
})

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function(Response)
    local Success, Result = pcall(function()
        toclipboard("PlaceId: " .. game.PlaceId .. "\nGameID: " .. game.GameId)
    end)
    if not Success then
        Services.LocalPlayer:Kick("Failed to copy PlaceId.\nPlaceId: " .. game.PlaceId .. "\nGameID: " .. game.GameId .. "\nError: " .. Result)
    end
end

Services.StarterGui:SetCore("SendNotification", {
    Title = "ii5601ware",
    Text = "Only DOORS, Piggy, and Work At Pizza Place, NDS and MM2 are supported right now, sorry :)",
    Duration = 10,
    Button1 = "Copy PlaceId",
    Callback = Bindable,
})
