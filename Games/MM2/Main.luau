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

local TradeValues = {}
TradeValues.categories = {"godlies", "chromas", "ancients", "legendaries", "rares", "uncommons", "commons", "vintages", "misc", "pets"}
TradeValues.minimum = {godlies = 80, chromas = 30, commons = 150, uncommons = 100, rares = 80, legendaries = 40, ancients = 8, pets = 40}
TradeValues.rarities = {godlies = "Godly", ancients = "Ancient", legendaries = "Legendary", rares = "Rare", uncommons = "Uncommon", commons = "Common", vintages = "Classic"}
local Globals = {}
local Connections = {}
local ESPConnections = {}
local Groupboxes = {}
local Functions = {}
local PartProperties = {}

local killingAll = false
local killingSheriff = false

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

function TradeValues.normalize(value)
	return (string.lower(tostring(value or "")):gsub("[^%w]", ""))
end
function TradeValues.assetId(value)
	local id
	for match in tostring(value or ""):gmatch("%d%d%d%d%d+") do id = match end
	return id
end
function TradeValues.text(value)
	local text = tostring(value or "")
	local function codepoint(value, base)
		local number = tonumber(value, base)
		if not number or number >= 1114112 or number >= 0xD800 and number <= 0xDFFF then return "" end
		return utf8.char(number)
	end
	return (text:gsub("<[^>]+>", " "):gsub("&#(%d+);", function(value) return codepoint(value, 10) end)
		:gsub("&#[xX](%x+);", function(value) return codepoint(value, 16) end):gsub("&amp;", "&"):gsub("&quot;", '"')
		:gsub("&apos;", "'"):gsub("&nbsp;", " "):gsub("&lt;", "<"):gsub("&gt;", ">")
		:gsub("%s+", " "):match("^%s*(.-)%s*$"))
end
function TradeValues.parse(category, html, yieldTask)
	local result, cursor, scanned = {}, 1, 0
	while true do
		local first = html:find('<div class="itemcolumn"', cursor, true)
		if not first then break end
		local nextItem = html:find('<div class="itemcolumn"', first + 23, true)
		local item = html:sub(first, (nextItem or #html + 1) - 1)
		cursor = nextItem or #html + 1
		scanned += 1
		if yieldTask and scanned % 60 == 0 then yieldTask() end
		local value = tonumber(item:match('data%-value="([%d%.]+)"') or "")
		local name = item:match('<div class="itemhead">(.-)</div>')
		local origin = TradeValues.text(item:match('class="itemorigin">([^<]*)<') or "")
		if value and value < 500000 and name and not origin:find("Deletion", 1, true) then
			table.insert(result, {c = category, n = TradeValues.text(name), v = value, y = item:match('data%-year="(%d%d%d%d)"'),
				e = item:match('data%-event="([^"]+)"'), o = origin ~= "" and origin or nil,
				cl = item:match("Class %- <b>([^<]+)</b>"), dm = item:match('data%-demand="(%d+)"')})
		end
	end
	return result
end
function TradeValues.candidates(index, name, category, chroma)
	local result = {}
	local function eligible(entry)
		local item = entry.item
		if entry.kind == "p" then return (item.Chroma == true) == chroma and (category == "pets" or category == "chromas") end
		if category == "pets" then return false end
		if chroma then return item.Chroma == true end
		if item.Chroma then return false end
		if category == "misc" then return item.ItemType == "Misc" or item.Rarity == "Christmas" or item.Rarity == "Halloween" end
		return item.Rarity == TradeValues.rarities[category]
	end
	local prefix = category == "pets" and "pet:" or ""
	for _, entry in ipairs(index[prefix .. TradeValues.normalize(name)] or {}) do if eligible(entry) then table.insert(result, entry) end end
	if chroma and #result == 0 then
		for _, entry in ipairs(index["pet:" .. TradeValues.normalize(name)] or {}) do if eligible(entry) then table.insert(result, entry) end end
	end
	return result
end
function TradeValues.filter(entries, predicate)
	local filtered = {}
	for _, entry in ipairs(entries) do if predicate(entry.item) then table.insert(filtered, entry) end end
	return #filtered > 0 and filtered or entries
end
function TradeValues.build(items, database, yieldTask)
	if type(database) ~= "table" or type(database.Item) ~= "table" then return nil end
	local weapons, pets = database.Item, type(database.Pets) == "table" and database.Pets or {}
	local index, petEntries = {}, {}
	local function addIndex(name, entry)
		index[name] = index[name] or {}
		table.insert(index[name], entry)
	end
	for id, item in pairs(weapons) do
		if type(item) ~= "table" then continue end
		local name = tostring(item.ItemName or item.Name or "")
		local entry = {kind = "i", id = tostring(id), item = item}
		addIndex(TradeValues.normalize(name), entry)
		local withoutYear = name:gsub("%s*%d%d%d%d%s*$", "")
		if withoutYear ~= name then addIndex(TradeValues.normalize(withoutYear), entry) end
	end
	for id, item in pairs(pets) do
		if type(item) ~= "table" then continue end
		local entry = {kind = "p", id = tostring(id), item = item}
		addIndex("pet:" .. TradeValues.normalize(item.Name), entry)
		table.insert(petEntries, entry)
	end
	local byKey, count = {}, 0
	for itemIndex, value in ipairs(items) do
		if yieldTask and itemIndex % 150 == 0 then yieldTask() end
		local category, amount = value.c, tonumber(value.v)
		if type(category) ~= "string" or not amount then continue end
		local name, kind = tostring(value.n or ""), nil
		local base, suffix = name:match("^(.-)%s*%((%a+)%)%s*$")
		if base and (suffix == "Knife" or suffix == "Gun") then name, kind = base, suffix end
		local year = value.y
		base, suffix = name:match("^(.-)%s*%((%d%d%d%d)%)%s*$")
		if base then name, year = base, suffix end
		if not year and value.o then year = tostring(value.o):match("(20%d%d)") end
		local chroma = category == "chromas"
		if chroma then name = name:gsub("^Chroma%s+", ""):gsub("^C%.%s+", "") end
		local aliases = {name}
		local wrapping = name:match("^(%a+) Papers$")
		if wrapping then table.insert(aliases, "Box of " .. wrapping .. " Wrapping Paper") end
		if name == "Ultra Wrap" then table.insert(aliases, "Box of Ultra Wrapping Paper") end
		if name:sub(-1) == "s" then table.insert(aliases, name:sub(1, -2)) end
		if category == "legendaries" then
			local short = name:match("^%S+%s+(.+)$")
			if short then table.insert(aliases, short) end
		end
		local matches = {}
		for _, alias in ipairs(aliases) do
			matches = TradeValues.candidates(index, alias, category, chroma)
			if #matches > 0 then break end
		end
		if category == "pets" and year then
			local correct = {}
			for _, entry in ipairs(matches) do if tostring(entry.item.Year or "") == tostring(year) then table.insert(correct, entry) end end
			if #correct == 0 then
				local prefix = TradeValues.normalize(name)
				for _, entry in ipairs(petEntries) do
					if TradeValues.normalize(entry.id):sub(1, #prefix) == prefix and tostring(entry.item.Year or "") == tostring(year) and not entry.item.Chroma then
						table.insert(correct, entry)
					end
				end
			end
			if #correct > 0 then matches = correct end
		end
		if kind then matches = TradeValues.filter(matches, function(item) return item.ItemType == kind end) end
		if #matches > 1 and value.cl then matches = TradeValues.filter(matches, function(item) return item.Rarity == value.cl end) end
		if #matches > 1 then
			local previous = matches
			if year then matches = TradeValues.filter(matches, function(item) return tostring(item.Year or "") == tostring(year) end) end
			if matches == previous then matches = TradeValues.filter(matches, function(item) return not item.Year end) end
		end
		if #matches > 1 then
			local previous = matches
			if value.e then matches = TradeValues.filter(matches, function(item) return tostring(item.Event or "") == value.e end) end
			if matches == previous then matches = TradeValues.filter(matches, function(item) return not item.Event end) end
		end
		for _, entry in ipairs(matches) do
			local key = entry.kind .. ":" .. entry.id
			local previous = byKey[key]
			if not previous then count += 1 end
			if not previous or previous.n >= #matches then byKey[key] = {v = amount, n = #matches} end
		end
	end
	local icon, chromaOf, byName = {}, {}, {}
	local function addIcon(item, key)
		local image = TradeValues.assetId(item.Image)
		if image and not icon[image] then icon[image] = key end
	end
	for id, item in pairs(weapons) do if type(item) == "table" then addIcon(item, "i:" .. tostring(id)) end end
	for id, item in pairs(weapons) do
		if type(item) == "table" and not item.Chroma and item.ItemID then
			local key = tostring(item.ItemID)
			if not icon[key] then icon[key] = "i:" .. tostring(id) end
		end
	end
	for id, item in pairs(pets) do if type(item) == "table" then addIcon(item, "p:" .. tostring(id)) end end
	for _, group in ipairs({{kind = "i", items = weapons, field = "ItemName"}, {kind = "p", items = pets, field = "Name"}}) do
		local regular = {}
		for id, item in pairs(group.items) do
			if type(item) ~= "table" or item.Chroma then continue end
			local key = TradeValues.normalize(item[group.field]) .. (group.kind == "i" and "|" .. tostring(item.ItemType) or "")
			if not regular[key] then regular[key] = group.kind .. ":" .. tostring(id) end
		end
		for id, item in pairs(group.items) do
			if type(item) ~= "table" then continue end
			local key = group.kind .. ":" .. tostring(id)
			local name = TradeValues.normalize(item[group.field])
			if item.Chroma then
				local base = regular[name .. (group.kind == "i" and "|" .. tostring(item.ItemType) or "")]
				if base then chromaOf[base] = key end
			end
			if byKey[key] then
				byName[name] = byName[name] or {}
				table.insert(byName[name], {key = key, chroma = item.Chroma == true})
			end
		end
	end
	return {byKey = byKey, icon = icon, chromaOf = chromaOf, byName = byName, n = count}
end
function TradeValues.format(value)
	if value >= 1000000 then return string.format("%.2fM", value / 1000000) end
	if value >= 10000 then return string.format("%.1fK", value / 1000) end
	if value >= 1000 then return string.format("%.2fK", value / 1000) end
	if value >= 100 then return tostring(math.floor(value + 0.5)) end
	if value >= 10 then return (string.format("%.1f", value):gsub("%.0$", "")) end
	return (string.format("%.2f", value):gsub("%.?0+$", ""))
end
function TradeValues.verdict(give, get)
	local difference = get - give
	if math.abs(difference) <= math.max(0.02 * math.max(give, get), 0.005) then return "even", nil end
	local sign = difference > 0 and "+" or "-"
	local percent = give > 0 and math.floor(math.abs(difference) / math.max(give, 0.0001) * 100 + 0.5) or nil
	return difference > 0 and "win" or "loss", sign .. TradeValues.format(math.abs(difference)) .. (percent and "  " .. sign .. math.min(percent, 99999) .. "%" or "")
end
function TradeValues.valueOf(state, tile, name)
	local mapped = state.mapped
	if not mapped then return nil end
	local tags = tile:FindFirstChild("Tags")
	local tag = tags and tags:FindFirstChild("Chroma")
	local chroma = tag ~= nil and tag.Visible == true
	local container = tile:FindFirstChild("Container")
	local icon = container and container:FindFirstChild("Icon")
	local id = icon and TradeValues.assetId(icon.Image)
	local key = id and mapped.icon[id]
	if key and chroma then key = mapped.chromaOf[key] or key end
	if key and mapped.byKey[key] then return mapped.byKey[key].v end
	for _, candidate in ipairs(mapped.byName[TradeValues.normalize(name)] or {}) do
		if candidate.chroma == chroma and mapped.byKey[candidate.key] then return mapped.byKey[candidate.key].v end
	end
	return nil
end
function TradeValues.database(state)
	local env = state.context.environment
	local ok, result = pcall(function()
		local database = state.context.storage:FindFirstChild("Database")
		local module = database and database:FindFirstChild("Sync")
		if module then return env.require(module) end
	end)
	return ok and result or nil
end
function TradeValues.readCache(state)
	local context, env = state.context, state.context.environment
	local ok, value = pcall(function()
		if not env.isfile("PulseHub/sv_values.json") then return nil end
		return context.http:JSONDecode(env.readfile("PulseHub/sv_values.json"))
	end)
	if not ok or type(value) ~= "table" or type(value.items) ~= "table" or not tonumber(value.t) then return nil end
	return value
end
function TradeValues.fetch(state)
	local env = state.context.environment
	local values = {}
	for _, category in ipairs(TradeValues.categories) do
		if not state.context.isAlive() then return nil end
		local url = "offline://supremevalues.com/mm2/" .. category
		local ok, html = pcall(function() return env.game:HttpGet(url) end)
		if not ok or type(html) ~= "string" or #html <= 5000 or not html:find("itemcolumn", 1, true) then
			local success, response = pcall(env.request, {Url = url, Method = "GET", Headers = {Accept = "text/html"}})
			html = success and type(response) == "table" and (response.Body or response.body) or nil
		end
		if type(html) ~= "string" or #html <= 5000 or not html:find("itemcolumn", 1, true) then return nil end
		local entries = TradeValues.parse(category, html, env.task.wait)
		if #entries < (TradeValues.minimum[category] or 1) then return nil end
		for _, entry in ipairs(entries) do table.insert(values, entry) end
		env.task.wait(0.3)
	end
	return #values >= 650 and values or nil
end
function TradeValues.accept(state, timestamp, items, source)
	local mapping = TradeValues.build(items, TradeValues.database(state), state.context.environment.task.wait)
	if not mapping or mapping.n <= 300 then return false end
	state.mapped, state.status = mapping, "ok"
	state.t, state.n, state.src = tonumber(timestamp) or os.time(), mapping.n, source
	return true
end
function TradeValues.load(state, force)
	if state.busy then return end
	if not force and state.status == "ok" and os.time() - state.t < 7200 then return end
	if not force and os.clock() < state.nextTry then return end
	state.busy = true
	state.context.environment.task.spawn(function()
		local loaded = false
		pcall(function()
			local cached = TradeValues.readCache(state)
			if cached and not force and os.time() - cached.t < 7200 and state.status ~= "ok" then
				loaded = TradeValues.accept(state, cached.t, cached.items, "cache")
				if loaded then return end
			end
			local fresh = TradeValues.fetch(state)
			if fresh then
				local timestamp = os.time()
				pcall(function() state.context.environment.writefile("PulseHub/sv_values.json", state.context.http:JSONEncode({t = timestamp, items = fresh})) end)
				loaded = TradeValues.accept(state, timestamp, fresh, "site")
				if loaded then return end
			end
			if cached and (state.status ~= "ok" or cached.t > state.t) then loaded = TradeValues.accept(state, cached.t, cached.items, "old") end
		end)
		if loaded then state.tries, state.nextTry = 0, 0
		else
			if not state.mapped then state.status = "fail" end
			state.tries = math.min(state.tries + 1, 6)
			state.nextTry = os.clock() + 15 * 2 ^ state.tries
		end
		state.busy = false
	end)
end
function TradeValues.item(tile)
	local name = tile:FindFirstChild("ItemName")
	local label = name and name:FindFirstChild("Label")
	local text = label and label.Text or ""
	if text == "" or text:find("^Loading") then return nil, 1 end
	local container = tile:FindFirstChild("Container")
	local amount = container and container:FindFirstChild("Amount")
	local quantity = amount and amount:IsA("TextLabel") and tonumber(tostring(amount.Text):match("%d+")) or 1
	return text, quantity or 1
end
function TradeValues.label(state, parent, name, group)
	local env = state.context.environment
	local label = parent:FindFirstChild(name)
	if label and (not label:IsA("TextLabel") or label:GetAttribute("st") ~= "troll") then label:Destroy(); label = nil end
	if not label then
		label = env.Instance.new("TextLabel")
		label.Name, label.BackgroundColor3, label.BackgroundTransparency = name, env.Color3.fromRGB(10, 10, 14), 0.15
		label.TextColor3, label.TextStrokeTransparency = env.Color3.new(1, 1, 1), 0.45
		label.TextXAlignment, label.Font, label.TextSize = env.Enum.TextXAlignment.Left, env.Enum.Font.GothamBold, 14
		label.BorderSizePixel, label.ZIndex = 0, 61
		label:SetAttribute("st", "troll")
		label.Parent = parent
	end
	state.labels[label] = group
	return label
end
function TradeValues.scale(object)
	local current, scale = object, 1
	while current and not current:IsA("LayerCollector") do
		local ok, item = pcall(current.FindFirstChildOfClass, current, "UIScale")
		if ok and item then scale *= item.Scale end
		current = current.Parent
	end
	return math.max(scale, 0.05)
end
function TradeValues.badge(state, tile, value, force, group)
	local env = state.context.environment
	local container = tile:FindFirstChild("Container") or tile
	local label = container:FindFirstChild("__PulseIV")
	if value == nil and not force then if label then label.Visible = false end; return end
	label = TradeValues.label(state, container, "__PulseIV", group)
	local size = math.clamp(math.floor(container.AbsoluteSize.Y / TradeValues.scale(container) * 0.19 + 0.5), 14, 24)
	local text = value ~= nil and TradeValues.format(value) or "?"
	label.Position, label.Size, label.TextSize = env.UDim2.fromOffset(3, 3), env.UDim2.fromOffset(math.max(size * 2, #text * size * 0.65 + 14), size), math.max(10, math.floor(size * 0.86 + 0.5))
	label.Text, label.Visible = " " .. text, true
	label.TextColor3 = value ~= nil and env.Color3.new(1, 1, 1) or env.Color3.fromRGB(184, 186, 196)
end
function TradeValues.offer(state, offer, group)
	local container = offer and offer:FindFirstChild("Container")
	if not container then return 0, 0, 0 end
	local total, known, count = 0, 0, 0
	for _, tile in ipairs(container:GetChildren()) do
		if not tile:IsA("GuiObject") then continue end
		local name, quantity
		if tile.Visible then name, quantity = TradeValues.item(tile) end
		if not name then TradeValues.badge(state, tile, nil, false, group); continue end
		local value = TradeValues.valueOf(state, tile, name)
		count += quantity
		if value ~= nil then total += value * quantity; known += quantity end
		TradeValues.badge(state, tile, value, true, group)
	end
	return total, known, count
end
function TradeValues.summary(state, offer, total, known, count, verdict)
	if not offer then return end
	local label = offer:FindFirstChild("__PulseSum")
	if count == 0 then
		if label then label.Visible = false end
		local verdictLabel = offer:FindFirstChild("__PulseVerdict")
		if verdictLabel then verdictLabel.Visible = false end
		return
	end
	local env = state.context.environment
	label = TradeValues.label(state, offer, "__PulseSum", "trade")
	label.Position, label.Size, label.TextSize = env.UDim2.new(0.5, 0, 0, 5), env.UDim2.fromOffset(115, 24), 14
	label.Text, label.Visible = " " .. TradeValues.format(total) .. (known < count and " +?" or ""), true
	local result = offer:FindFirstChild("__PulseVerdict")
	if not verdict then if result then result.Visible = false end; return end
	result = TradeValues.label(state, offer, "__PulseVerdict", "trade")
	result.Position, result.Size, result.TextSize = env.UDim2.new(0.5, 120, 0, 5), env.UDim2.fromOffset(140, 24), 14
	result.Text, result.Visible = " " .. verdict, true
end
function TradeValues.tiles(state, root, group)
	local total = 0
	if not root then return total end
	state.tileCache = state.tileCache or setmetatable({}, {__mode = "k"})
	local now, cached = os.clock(), state.tileCache[root]
	local interval = group == "tradeInventory" and 1.2 or 2
	if not cached or now - cached.at >= interval then
		cached = {at = now, tiles = {}}
		for _, child in ipairs(root:GetDescendants()) do
			if child.Name ~= "ItemName" or not child:IsA("GuiObject") then continue end
			local tile = child.Parent
			if tile and tile:FindFirstChild("Container") then table.insert(cached.tiles, tile) end
		end
		state.tileCache[root] = cached
	end
	for _, tile in ipairs(cached.tiles) do
		if not tile.Parent or tile.Visible == false then continue end
		local name, quantity = TradeValues.item(tile)
		local value = name and TradeValues.valueOf(state, tile, name) or nil
		if value ~= nil then total += value * quantity end
		TradeValues.badge(state, tile, value, false, group)
	end
	return total
end
function TradeValues.visible(object)
	local current = object
	while current and current:IsA("GuiObject") do
		if not current.Visible then return false end
		current = current.Parent
	end
	if current and current:IsA("ScreenGui") then return current.Enabled end
	return current ~= nil
end
function TradeValues.clear(state, group)
	for label, owner in pairs(state.labels) do
		if group and owner ~= group then continue end
		pcall(function() label:Destroy() end)
		state.labels[label] = nil
	end
end
function TradeValues.playerGui(state)
	return state.context.player:FindFirstChildOfClass("PlayerGui")
end
function TradeValues.tradeGui(state)
	local gui = TradeValues.playerGui(state)
	if not gui then return nil end
	for _, name in ipairs({"TradeGUI", "TradeGUI_Phone"}) do
		local screen = gui:FindFirstChild(name)
		local container = screen and screen.Enabled and screen:FindFirstChild("Container")
		local trade = container and container:FindFirstChild("Trade")
		if trade and trade.Visible ~= false then return screen, container, trade end
	end
	return nil
end
function TradeValues.inventoryGui(state)
	local gui = TradeValues.playerGui(state)
	if not gui then return nil end
	for _, name in ipairs({"MainGUI", "MainMobile"}) do
		local screen = gui:FindFirstChild(name)
		local game = screen and screen.Enabled and screen:FindFirstChild("Game")
		local inventory = game and game:FindFirstChild("Inventory")
		if inventory and TradeValues.visible(inventory) then return inventory, name == "MainMobile" end
	end
	return nil
end
function TradeValues.tradePanel(state, container, give, get, knownGive, countGive, knownGet, countGet, inventory)
	local env = state.context.environment
	local panel = container:FindFirstChild("__PulsePanel")
	if panel and (not panel:IsA("Frame") or panel:GetAttribute("v") ~= 4) then panel:Destroy(); panel = nil end
	if not panel then
		panel = env.Instance.new("Frame")
		panel.Name, panel.BackgroundTransparency, panel.BorderSizePixel, panel.ZIndex = "__PulsePanel", 1, 0, 40
		panel.Position, panel.Size = env.UDim2.new(0, 12, 0, 8), env.UDim2.new(0.5, -24, 0.25, -14)
		panel:SetAttribute("v", 4)
		panel.Parent = container
		for _, entry in ipairs({{"GiveL", "Left"}, {"GiveV", "Left"}, {"GiveS", "Left"},
			{"GetL", "Right"}, {"GetV", "Right"}, {"GetS", "Right"}, {"Src", "Right"}, {"Inv", "Left"}, {"Verdict", "Center"}}) do
			local label = env.Instance.new("TextLabel")
			label.Name, label.BackgroundTransparency, label.BorderSizePixel, label.ZIndex = entry[1], 1, 0, 42
			label.TextColor3, label.TextXAlignment, label.Font = env.Color3.new(1, 1, 1), env.Enum.TextXAlignment[entry[2]], env.Enum.Font.GothamBold
			label.Parent = panel
		end
		for _, name in ipairs({"GiveLine", "GetLine"}) do
			local line = env.Instance.new("Frame")
			line.Name, line.BackgroundColor3, line.BorderSizePixel, line.ZIndex = name, env.Color3.fromRGB(226, 46, 58), 0, 42
			if name == "GetLine" then line.AnchorPoint = env.Vector2.new(1, 0) end
			line.Parent = panel
		end
		local face = env.Instance.new("ImageLabel")
		face.Name, face.AnchorPoint, face.BackgroundTransparency, face.ZIndex = "Face", env.Vector2.new(0.5, 0.5), 1, 42
		face.Image, face.ScaleType, face.Parent = "rbxthumb://type=Asset&id=9631028060&w=150&h=150", env.Enum.ScaleType.Fit, panel
	end
	state.labels[panel] = "trade"
	local uiScale = TradeValues.scale(panel)
	local width, height = panel.AbsoluteSize.X / uiScale, panel.AbsoluteSize.Y / uiScale
	if width < 40 or height < 30 then return end
	local language = state.context.configuration.ui and state.context.configuration.ui.lang or "en"
	local texts = ({ru = {"РћРўР”РђРЃРЁР¬", "РџРћР›РЈР§РђР•РЁР¬", "Р’Р«Р“РћР”РќРћ", "РќР•Р’Р«Р“РћР”РќРћ", "РџРћР РћР’РќРЈ", "РїСЂРµРґРј.", "Р±РµР· С†РµРЅС‹", "РёРЅРІРµРЅС‚Р°СЂСЊ", "РјРёРЅ", "С‡"},
		uk = {"Р’Р†Р”Р”РђР„РЁ", "РћРўР РРњРЈР„РЁ", "Р’РР“Р†Р”РќРћ", "РќР•Р’РР“Р†Р”РќРћ", "РџРћР Р†Р’РќРЈ", "РїСЂРµРґРј.", "Р±РµР· С†С–РЅРё", "С–РЅРІРµРЅС‚Р°СЂ", "С…РІ", "РіРѕРґ"}})[language]
		or {"YOU GIVE", "YOU GET", "WIN", "LOSS", "FAIR", "items", "no value", "inventory", "min", "h"}
	local kind, difference = TradeValues.verdict(give, get)
	local result = ({win = texts[3], loss = texts[4], even = texts[5]})[kind]
	local function countLabel(count, known)
		return tostring(count) .. " " .. texts[6] .. (count > known and " В· " .. (count - known) .. " " .. texts[7] or "")
	end
	local scale, sideWidth = height / 120, width * 0.36
	local function place(name, x, y, w, h, size, text)
		local label = panel:FindFirstChild(name)
		label.Position, label.Size, label.TextSize, label.Text = env.UDim2.fromOffset(math.floor(x), math.floor(y)),
			env.UDim2.fromOffset(math.floor(w), math.floor(h)), math.max(8, math.floor(size)), text
	end
	place("GiveL", 0, 4 * scale, sideWidth, 15 * scale, 14 * scale, texts[1])
	place("GiveV", 0, 18 * scale, sideWidth, 42 * scale, 44 * scale, TradeValues.format(give))
	place("GiveS", 0, 68 * scale, sideWidth, 14 * scale, 13 * scale, countLabel(countGive, knownGive))
	place("GetL", width - sideWidth, 4 * scale, sideWidth, 15 * scale, 14 * scale, texts[2])
	place("GetV", width - sideWidth, 18 * scale, sideWidth, 42 * scale, 44 * scale, TradeValues.format(get))
	place("GetS", width - sideWidth, 68 * scale, sideWidth, 14 * scale, 13 * scale, countLabel(countGet, knownGet))
	local lineWidth = math.floor(math.min(72, sideWidth * 0.5))
	local giveLine, getLine = panel:FindFirstChild("GiveLine"), panel:FindFirstChild("GetLine")
	giveLine.Position, giveLine.Size = env.UDim2.fromOffset(0, math.floor(62 * scale)), env.UDim2.fromOffset(lineWidth, 3)
	getLine.Position, getLine.Size = env.UDim2.fromOffset(math.floor(width), math.floor(62 * scale)), env.UDim2.fromOffset(lineWidth, 3)
	local face = panel:FindFirstChild("Face")
	local faceSize = math.floor(math.min(58 * scale, width * 0.16))
	face.Size, face.Position = env.UDim2.fromOffset(faceSize, faceSize), env.UDim2.fromOffset(math.floor(width / 2), math.floor(38 * scale))
	face.ImageTransparency, face.Rotation = countGive + countGet == 0 and 0.55 or (kind == "loss" and 0.45 or 0), kind == "win" and -8 or 0
	local verdict = panel:FindFirstChild("Verdict")
	place("Verdict", width * 0.32, 84 * scale, width * 0.36, 24 * scale, 14 * scale,
		result .. (difference and "  " .. difference or ""))
	verdict.Visible = countGive + countGet > 0
	verdict.TextColor3 = kind == "win" and env.Color3.fromRGB(40, 196, 104) or kind == "loss" and env.Color3.fromRGB(226, 46, 58) or env.Color3.new(1, 1, 1)
	local age = math.max(0, os.time() - state.t)
	local source = state.t > 0 and "supremevalues В· " .. (age < 3600 and math.floor(age / 60) .. " " .. texts[9] or math.floor(age / 3600) .. " " .. texts[10]) or ""
	place("Src", width - sideWidth, 108 * scale, sideWidth, 12 * scale, 11 * scale, source)
	place("Inv", 0, 108 * scale, sideWidth, 12 * scale, 11 * scale, inventory > 0 and texts[8] .. " " .. TradeValues.format(inventory) or "")
	panel.Visible = true
end
function TradeValues.scanTrade(state)
	local screen, container, trade = TradeValues.tradeGui(state)
	if not screen or not state.settings.value then
		TradeValues.clear(state, "trade")
		TradeValues.clear(state, "tradeInventory")
		return
	end
	TradeValues.load(state, false)
	if state.status ~= "ok" then return end
	local yours, theirs = trade:FindFirstChild("YourOffer"), trade:FindFirstChild("TheirOffer")
	local give, knownGive, countGive = TradeValues.offer(state, yours, "trade")
	local get, knownGet, countGet = TradeValues.offer(state, theirs, "trade")
	local kind, difference = TradeValues.verdict(give, get)
	local language = state.context.configuration.ui and state.context.configuration.ui.lang or "en"
	local labels = ({ru = {win = "Р’Р«Р“РћР”РќРћ", loss = "РќР•Р’Р«Р“РћР”РќРћ", even = "РџРћР РћР’РќРЈ"},
		uk = {win = "Р’РР“Р†Р”РќРћ", loss = "РќР•Р’РР“Р†Р”РќРћ", even = "РџРћР Р†Р’РќРЈ"}})[language] or {win = "WIN", loss = "LOSS", even = "FAIR"}
	local verdict = labels[kind] .. (difference and "  " .. difference or "")
	TradeValues.summary(state, yours, give, knownGive, countGive)
	TradeValues.summary(state, theirs, get, knownGet, countGet, screen.Name == "TradeGUI_Phone" and verdict or nil)
	local inventory = 0
	if state.settings.inv ~= false then
		local items = container:FindFirstChild("Items")
		local main = items and items:FindFirstChild("Main")
		if main and TradeValues.visible(main) then inventory = TradeValues.tiles(state, main, "tradeInventory") end
	else TradeValues.clear(state, "tradeInventory") end
	if screen.Name ~= "TradeGUI_Phone" then TradeValues.tradePanel(state, container, give, get, knownGive, countGive, knownGet, countGet, inventory) end
end
function TradeValues.scanInventory(state)
	local inventory, mobile = TradeValues.inventoryGui(state)
	if not inventory or state.settings.inv == false then TradeValues.clear(state, "inventory"); return end
	TradeValues.load(state, false)
	if state.status ~= "ok" then return end
	local main = inventory:FindFirstChild("Main")
	local weapons, pets = main and main:FindFirstChild("Weapons"), main and main:FindFirstChild("Pets")
	local weaponTotal = TradeValues.tiles(state, weapons and weapons:FindFirstChild("Items"), "inventory")
	local petTotal = TradeValues.tiles(state, pets and pets:FindFirstChild("Items"), "inventory")
	local total = weaponTotal + petTotal
	local badge = inventory:FindFirstChild("__PulseInvBadge")
	if mobile or total <= 0 then if badge then badge.Visible = false end; return end
	local env = state.context.environment
	badge = TradeValues.label(state, inventory, "__PulseInvBadge", "inventory")
	badge.AnchorPoint, badge.Position, badge.Size = env.Vector2.new(0, 1), env.UDim2.new(0, 4, 0, -6), env.UDim2.fromOffset(360, 44)
	local language = state.context.configuration.ui and state.context.configuration.ui.lang or "en"
	local labels = ({ru = {"РРќР’Р•РќРўРђР Р¬", "РѕСЂСѓР¶РёРµ", "РїРёС‚РѕРјС†С‹"}, uk = {"Р†РќР’Р•РќРўРђР ", "Р·Р±СЂРѕСЏ", "СѓР»СЋР±Р»РµРЅС†С–"}})[language]
		or {"INVENTORY", "weapons", "pets"}
	badge.Text, badge.TextSize, badge.Visible = " " .. labels[1] .. "  " .. TradeValues.format(total) .. "   В·   " .. labels[2] .. " "
		.. TradeValues.format(weaponTotal) .. "   В·   " .. labels[3] .. " " .. TradeValues.format(petTotal), 15, true
end
function TradeValues.statusText(state)
	local language = state.context.configuration.ui and state.context.configuration.ui.lang or "en"
	local texts = ({ru = {"Р¦РµРЅС‹", "Р·Р°РіСЂСѓР·РєР°", "РЅРµРґРѕСЃС‚СѓРїРЅС‹", "РјРёРЅ", "С‡", "РЅР°Р·Р°Рґ", "РїСЂРµРґРјРµС‚РѕРІ"},
		uk = {"Р¦С–РЅРё", "Р·Р°РІР°РЅС‚Р°Р¶РµРЅРЅСЏ", "РЅРµРґРѕСЃС‚СѓРїРЅС–", "С…РІ", "РіРѕРґ", "С‚РѕРјСѓ", "РїСЂРµРґРјРµС‚С–РІ"}})[language]
		or {"Values", "loading", "unavailable", "min", "h", "ago", "items"}
	if state.status ~= "ok" then return texts[1] .. ": " .. (state.status == "fail" and not state.busy and texts[3] or texts[2]) end
	local age = math.max(0, os.time() - state.t)
	local elapsed = age < 3600 and math.floor(age / 60) .. " " .. texts[4] or math.floor(age / 3600) .. " " .. texts[5]
	return string.format("%s: %d %s В· %s %s В· supremevalues.com", texts[1], state.n, texts[7], elapsed, texts[6])
end

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
Groupboxes.Trades               = Tabs.Visuals:AddGroupbox({
    Side = "Left",
    Name = "Trades",
    Description = "",
    IconName = "chart-candlestick"
})
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

function TradeValues.install(context)
	local configuration, env, section = context.configuration, context.environment, context.section
	configuration.trade = configuration.trade or {}
	local settings = configuration.trade
	if settings.value == nil then settings.value = false end
	local state = {context = context, settings = settings, status = "idle", t = 0, n = 0, busy = false, tries = 0, nextTry = 0, src = "", labels = {}}
	state.valueOf = function(tile, name) return TradeValues.valueOf(state, tile, name) end
	state.byId = function(id)
		local entry = state.mapped and state.mapped.byKey["i:" .. tostring(id)]
		return entry and entry.v or nil
	end
	state.load = function(force) TradeValues.load(state, force) end
	getgenv().ii5601ware.sv = state
	section:AddToggle("TradeValueCounter", {Text = "Trade Value Counter", Default = settings.value == true, Callback = function(enabled)
		settings.value = enabled == true
		if enabled then TradeValues.load(state, false) else TradeValues.clear(state, "trade") end
	end})
	section:AddToggle("InventoryValues", {Text = "Inventory Values", Default = settings.inv ~= false, Callback = function(enabled)
		settings.inv = enabled == true
		if enabled then TradeValues.load(state, false)
		else TradeValues.clear(state, "inventory"); TradeValues.clear(state, "tradeInventory") end
	end})
	local note = section:AddLabel(Text = "supremevalues.com")
	local tradeTime, inventoryTime, noteTime, refreshTime = 0, 0, 0, 0
	if context.runService.Heartbeat then context.runService:Heartbeat(function(delta)
		tradeTime += delta
		inventoryTime += delta
		noteTime += delta
		refreshTime += delta
		if tradeTime >= 0.3 then tradeTime = 0; pcall(TradeValues.scanTrade, state) end
		if inventoryTime >= 0.6 then inventoryTime = 0; pcall(TradeValues.scanInventory, state) end
		if noteTime >= 2 then
			noteTime = 0
			pcall(function() if note and note.Parent then note:SetText(TradeValues.statusText(state)) end end)
		end
		if refreshTime >= 300 then
			refreshTime = 0
			if settings.value or settings.inv ~= false then TradeValues.load(state, false) end
		end
	end) end
	if settings.value or settings.inv ~= false then env.task.delay(3, function() if context.isAlive() then TradeValues.load(state, false) end end) end
	return state, function()
		TradeValues.clear(state)
		if getgenv().ii5601ware.sv == state then getgenv().ii5601ware.sv = nil end
	end
end

local connections, originalConnect = {}, context.connect
	context = table.clone(context)
	context.connect = function(signal, callback)
		local connection = originalConnect(signal, callback)
		table.insert(connections, connection)
		return connection
	end

local _, stopTradeValues = TradeValues.install({environment = environment, section = Groupboxes.Trades, configuration = settings,
		player = LocalPlayer, storage = game:GetService("ReplicatedStorage"), http = game:GetService("HttpService"),
		runService = game:GetService("RunService"), connect = connect, isAlive = function() return not window.Destroyed end})
