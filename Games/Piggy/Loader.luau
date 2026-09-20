local BaseUrl = "https://raw.githubusercontent.com/ii5601/ii5601ware/refs/heads/main/"

print("Piggy loader")
if game.PlaceId ~= 1516533665 then
    loadstring(game:HttpGet(BaseUrl .. "Games/Piggy/Main.luau"))()
end
