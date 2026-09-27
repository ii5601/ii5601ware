local BaseUrl = "https://raw.githubusercontent.com/ii5601/ii5601ware/refs/heads/main/"

if game.PlaceId ~= 192800 then
    loadstring(game:HttpGet(BaseUrl .. "Games/WorkAtPizzaPlace/Main.luau"))()
end
