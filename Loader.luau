if ii5601ware then
    return 
end
getgenv().ii5601ware = {
    Legit = true
}

local GameList = {
  [2440500124] = "Doors",
  [1516533665] = "Piggy",
  [47545] = "WorkAtPizzaPlace",
  [65241] = "NDS",
  [mm2idhere] = "MM2"
}

local BaseUrl = "https://raw.githubusercontent.com/ii5601/ii5601ware/refs/heads/main/"
getgenv().ii5601ware = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),

    Legit = true, -- pog
}

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

if ii5601ware.Environment.writefile and ii5601ware.Environment.readfile then
    if not ii5601ware.Environment.isfile("ii5601ware/UserData.json") then
        local Data = {
            TotalExecutions = 0
        }
        ii5601ware.Environment.writefile("ii5601ware/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = ii5601ware.Environment.readfile("ii5601ware/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    ii5601ware.TotalExecutions = Decoded.TotalExecutions

    ii5601ware.Environment.writefile("ii5601ware/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

ii5601ware.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()

print("Loading...")
local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
elseif CurrentGame == "WorkAtPizzaPlace" then
    loadstring(game:HttpGet(BaseUrl .. "Games/WorkAtPizzaPlace/Main.luau"))()
elseif CurrentGame == "NDS" then
    loadstring(game:HttpGet(BaseUrl .. "Games/NDS/Main.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
