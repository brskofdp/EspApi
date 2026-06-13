local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

if getgenv().ESPAPI and getgenv()._ESP_Loaded then return getgenv().ESPAPI end
getgenv()._ESP_Loaded = true

local DefaultConfig = {
    Enabled = false,
    SelfESP = false,
    TeamCheck = false,
    MaxDistance = 200,
    FontSize = 11,
    Font = Enum.Font.SourceSansBold,
    FadeOut = { OnDistance = false, OnDeath = false, OnLeave = false },
    Options = {
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = false, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled  = false, Thermal = false, VisibleCheck = false,
            FillRGB = Color3.fromRGB(119, 120, 255), Fill_Transparency = 50,
            OutlineRGB = Color3.fromRGB(119, 120, 255), Outline_Transparency = 0,
            Rainbow = false, RainbowSpeed = 0.5,
            TeamColor = false, TeamColorOverride = false, TeamColorRGB = Color3.fromRGB(255, 80, 80)
        },
        Names = { Enabled = false, RGB = Color3.fromRGB(255, 255, 255), TeamColor = false, Rainbow = false, RainbowSpeed = 0.5 },
        Flags = { Enabled = false },
        Distances = { Enabled = false, Position = "Text", RGB = Color3.fromRGB(255, 255, 255) },
        Healthbar = {
            Enabled = false, HealthText = false, Lerp = false, HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 2.5, Gradient = false,
            GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(60, 60, 125), GradientRGB3 = Color3.fromRGB(119, 120, 255),
        },
        Boxes = {
            Animate = false, RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0),
            GradientFill = false, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = { Enabled = false, Transparency = 0.75, RGB = Color3.fromRGB(0, 0, 0) },
            Full = { Enabled = false, RGB = Color3.fromRGB(255, 255, 255) },
            Corner = { Enabled = false, RGB = Color3.fromRGB(255, 255, 255) },
        };
    };
}
local function deepCopy(v)
    if type(v) ~= "table" then return v end
    local r={} for i,x in pairs(v) do r[i]=deepCopy(x) end return r
end
local ESP = deepCopy(DefaultConfig)
ESP.Connections = { RunService = RunService }
ESP.Fonts = {}

getgenv().ESPAPI = {}
local API = getgenv().ESPAPI
API.Config = ESP

local function merge(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then merge(t1[k], v) else t1[k] = deepCopy(v) end
        else t1[k] = v end
    end
end

function API.SetEnabled(v) ESP.Enabled = v end
function API.SetTeamCheck(v) ESP.TeamCheck = v end
function API.SetMaxDistance(v) ESP.MaxDistance = v end
function API.SetFontSize(v) ESP.FontSize = v end
function API.SetFont(v)
    if typeof(v) == "string" then
        ESP.Font = Enum.Font[v] or Enum.Font.SourceSansBold
    elseif typeof(v) == "EnumItem" then
        ESP.Font = v
    end
end
function API.SetSelfESP(v) ESP.SelfESP = v end
function API.SetFadeOnDistance(v) ESP.FadeOut.OnDistance = v end
function API.SetFadeOnDeath(v) ESP.FadeOut.OnDeath = v end
function API.SetFadeOnLeave(v) ESP.FadeOut.OnLeave = v end
function API.SetFriendCheck(v) ESP.Options.Friendcheck = v end
function API.SetFriendCheckRGB(v) ESP.Options.FriendcheckRGB = v end
function API.SetChams(enabled, fillRGB, outlineRGB)
    ESP.Drawing.Chams.Enabled = enabled
    if fillRGB then ESP.Drawing.Chams.FillRGB = fillRGB end
    if outlineRGB then ESP.Drawing.Chams.OutlineRGB = outlineRGB end
end
function API.SetChamsThermal(v) ESP.Drawing.Chams.Thermal = v end
function API.SetChamsVisCheck(v) ESP.Drawing.Chams.VisibleCheck = v end
function API.SetChamsFillAlpha(v) ESP.Drawing.Chams.Fill_Transparency = v end
function API.SetChamsOutAlpha(v) ESP.Drawing.Chams.Outline_Transparency = v end
function API.SetChamsRainbow(v) ESP.Drawing.Chams.Rainbow = v end
function API.SetChamsRainbowSpeed(v) ESP.Drawing.Chams.RainbowSpeed = v end
function API.SetChamsTeamColor(v) ESP.Drawing.Chams.TeamColor = v end
function API.SetChamsTeamColorOverride(v) ESP.Drawing.Chams.TeamColorOverride = v end
function API.SetChamsTeamColorRGB(v) ESP.Drawing.Chams.TeamColorRGB = v end

function API.SetNames(enabled, color)
    ESP.Drawing.Names.Enabled = enabled
    if color then ESP.Drawing.Names.RGB = color end
end
function API.SetNamesRGB(v) ESP.Drawing.Names.RGB = v end
function API.SetNamesTeamColor(v) ESP.Drawing.Names.TeamColor = v end
function API.SetNamesRainbow(v) ESP.Drawing.Names.Rainbow = v end
function API.SetHealthbar(enabled, color)
    ESP.Drawing.Healthbar.Enabled = enabled
    if color then ESP.Drawing.Healthbar.HealthTextRGB = color end
end
function API.SetHealthText(v) ESP.Drawing.Healthbar.HealthText = v end
function API.SetHealthLerp(v) ESP.Drawing.Healthbar.Lerp = v end
function API.SetHealthTextRGB(v) ESP.Drawing.Healthbar.HealthTextRGB = v end
function API.SetHealthbarWidth(v) ESP.Drawing.Healthbar.Width = v end
function API.SetDistances(enabled, pos, color)
    ESP.Drawing.Distances.Enabled = enabled
    if pos then ESP.Drawing.Distances.Position = pos end
    if color then ESP.Drawing.Distances.RGB = color end
end
function API.SetDistancePos(v) ESP.Drawing.Distances.Position = v end
function API.SetDistancesRGB(v) ESP.Drawing.Distances.RGB = v end
function API.SetBoxesFull(enabled, color)
    ESP.Drawing.Boxes.Full.Enabled = enabled
    if color then ESP.Drawing.Boxes.Full.RGB = color end
end
function API.SetBoxesCorner(enabled, color)
    ESP.Drawing.Boxes.Corner.Enabled = enabled
    if color then ESP.Drawing.Boxes.Corner.RGB = color end
end
function API.SetBoxesFilled(enabled, alpha, color)
    ESP.Drawing.Boxes.Filled.Enabled = enabled
    if alpha then ESP.Drawing.Boxes.Filled.Transparency = alpha end
    if color then ESP.Drawing.Boxes.Filled.RGB = color end
end
function API.SetBoxesAnimate(enabled, speed)
    ESP.Drawing.Boxes.Animate = enabled
    if speed then ESP.Drawing.Boxes.RotationSpeed = speed end
end
function API.SetBoxesGradient(enabled, rgb1, rgb2)
    ESP.Drawing.Boxes.Gradient = enabled
    if rgb1 then ESP.Drawing.Boxes.GradientRGB1 = rgb1 end
    if rgb2 then ESP.Drawing.Boxes.GradientRGB2 = rgb2 end
end
function API.SetBoxesGradFill(enabled, rgb1, rgb2)
    ESP.Drawing.Boxes.GradientFill = enabled
    if rgb1 then ESP.Drawing.Boxes.GradientFillRGB1 = rgb1 end
    if rgb2 then ESP.Drawing.Boxes.GradientFillRGB2 = rgb2 end
end
function API.SetBoxesSpeed(v) ESP.Drawing.Boxes.RotationSpeed = v end
function API.SetBoxesFilledAlpha(v) ESP.Drawing.Boxes.Filled.Transparency = v end
function API.SetBoxesCornerRGB(v) ESP.Drawing.Boxes.Corner.RGB = v end
function API.SetBoxesFullRGB(v) ESP.Drawing.Boxes.Full.RGB = v end
function API.SetBoxesFilledRGB(v) ESP.Drawing.Boxes.Filled.RGB = v end
function API.SetFlags(v) ESP.Drawing.Flags.Enabled = v end
function API.GetConfig() return ESP end
function API.Reset() merge(ESP, DefaultConfig) end

local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local Cam = Workspace.CurrentCamera;

local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        elseif element:IsA("ImageLabel") then
            element.ImageTransparency = 1 - transparency
        elseif element:IsA("UIStroke") then
            element.Transparency = 1 - transparency
        elseif element:IsA("Frame") then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Highlight") then
            element.FillTransparency = 1 - transparency
            element.OutlineTransparency = 1 - transparency
        end
    end
end

local ScreenGui
function API.Refresh()
    if CoreGui:FindFirstChild("ESPHolder") then
        CoreGui:FindFirstChild("ESPHolder"):Destroy()
    end
    ScreenGui = Functions:Create("ScreenGui", { Parent = CoreGui, Name = "ESPHolder" })
    for _, v in pairs(Players:GetPlayers()) do
        coroutine.wrap(ESP_func)(v)
    end
end

ScreenGui = CoreGui:FindFirstChild("ESPHolder") or Functions:Create("ScreenGui", { Parent = CoreGui, Name = "ESPHolder" })

local DupeCheck = function(plr)
    if ScreenGui:FindFirstChild(plr.Name) then
        ScreenGui[plr.Name]:Destroy()
    end
    if plr.Character and plr.Character:FindFirstChild("EuphoriaChams") then
        plr.Character:FindFirstChild("EuphoriaChams"):Destroy()
    end
end

function ESP_func(plr)
    coroutine.wrap(DupeCheck)(plr)
    local Name = Functions:Create("TextLabel", {Name = plr.Name, Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = ESP.Font or Enum.Font.SourceSansBold, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
    local Distance = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = ESP.Font or Enum.Font.SourceSansBold, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
    local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
    local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}})
    local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
    local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}})

    local BehindHealthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0, BorderSizePixel = 0})
    local Healthbar = Functions:Create("Frame", {Parent = BehindHealthbar, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0, BorderSizePixel = 0})
    local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)}})

    local HealthText = Functions:Create("TextLabel", {Parent = BehindHealthbar, Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = ESP.Font or Enum.Font.SourceSansBold, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})

    local Chams = Functions:Create("Highlight", {Name = "EuphoriaChams", FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})

    local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})

    local Updater = function()
        local Connection
        local function HideESP()
            Box.Visible = false
            Name.Visible = false
            Distance.Visible = false
            Healthbar.Visible = false
            BehindHealthbar.Visible = false
            HealthText.Visible = false
            LeftTop.Visible = false
            LeftSide.Visible = false
            BottomSide.Visible = false
            BottomDown.Visible = false
            RightTop.Visible = false
            RightSide.Visible = false
            BottomRightSide.Visible = false
            BottomRightDown.Visible = false
            Chams.Enabled = false
            if not plr or not plr.Parent then
                Name:Destroy()
                Distance:Destroy()
                Box:Destroy()
                Healthbar:Destroy()
                BehindHealthbar:Destroy()
                HealthText:Destroy()
                LeftTop:Destroy()
                LeftSide:Destroy()
                BottomSide:Destroy()
                BottomDown:Destroy()
                RightTop:Destroy()
                RightSide:Destroy()
                BottomRightSide:Destroy()
                BottomRightDown:Destroy()
                Chams:Destroy()
                if Connection then Connection:Disconnect() end
            end
        end

        Connection = Euphoria.RunService.RenderStepped:Connect(function()
            if not ESP.Enabled then HideESP(); return end
            if not plr.Character then HideESP(); return end

            local HRP = plr.Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if not HRP or not Humanoid then HideESP(); return end

            local isSelf = (plr == lplayer)
            if isSelf and not ESP.SelfESP then HideESP(); return end

            local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
            local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714

            if OnScreen and Dist <= ESP.MaxDistance then
                local top, onScreenTop = Cam:WorldToScreenPoint(HRP.Position + Vector3.new(0, 3, 0))
                local bottom, onScreenBottom = Cam:WorldToScreenPoint(HRP.Position - Vector3.new(0, 3.5, 0))

                local h = math.abs(bottom.Y - top.Y)
                local w = h * 0.6

                if ESP.FadeOut.OnDistance then
                    for _, el in pairs({Box, Outline, Name, Distance, BehindHealthbar, Healthbar, HealthText, LeftTop, LeftSide, BottomSide, BottomDown, RightTop, RightSide, BottomRightSide, BottomRightDown, Chams}) do
                        Functions:FadeOutOnDist(el, Dist)
                    end
                end

                local pass = false
                if isSelf then
                    pass = true
                elseif ESP.TeamCheck then
                    if (lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team) then
                        pass = true
                    end
                else
                    pass = true
                end

                if pass then
                    local currentFont = ESP.Font or Enum.Font.SourceSansBold
                    Name.Font = currentFont
                    Distance.Font = currentFont
                    HealthText.Font = currentFont

                    Name.TextSize = ESP.FontSize
                    Distance.TextSize = ESP.FontSize
                    HealthText.TextSize = ESP.FontSize

                    if Chams.Parent ~= plr.Character then
                        Chams.Parent = plr.Character
                    end
                    Chams.Adornee = plr.Character
                    Chams.Enabled = ESP.Drawing.Chams.Enabled

                    local fillRGB = ESP.Drawing.Chams.FillRGB
                    local outlineRGB = ESP.Drawing.Chams.OutlineRGB

                    if ESP.Drawing.Chams.Rainbow then
                        fillRGB = Color3.fromHSV((tick() * ESP.Drawing.Chams.RainbowSpeed) % 1, 1, 1)
                        outlineRGB = Color3.fromHSV((tick() * ESP.Drawing.Chams.RainbowSpeed) % 1, 1, 1)
                    elseif ESP.Drawing.Chams.TeamColor then
                        if plr.Team then
                             fillRGB = plr.TeamColor.Color
                            if ESP.Drawing.Chams.TeamColorOverride then
                                outlineRGB = ESP.Drawing.Chams.TeamColorRGB
                            else
                                outlineRGB = plr.TeamColor.Color
                            end
                        else
                            fillRGB = ESP.Drawing.Chams.TeamColorRGB
                            outlineRGB = ESP.Drawing.Chams.TeamColorRGB
                        end
                    end

                    Chams.FillColor = fillRGB
                    Chams.OutlineColor = outlineRGB

                    if ESP.Drawing.Chams.Thermal then
                        local breathe = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                        Chams.FillTransparency = (ESP.Drawing.Chams.Fill_Transparency/100) * breathe * 0.01 + (ESP.Drawing.Chams.Fill_Transparency/100)
                        Chams.OutlineTransparency = (ESP.Drawing.Chams.Outline_Transparency/100) * breathe * 0.01 + (ESP.Drawing.Chams.Outline_Transparency/100)
                    else
                        Chams.FillTransparency = ESP.Drawing.Chams.Fill_Transparency / 100
                        Chams.OutlineTransparency = ESP.Drawing.Chams.Outline_Transparency / 100
                    end
                    Chams.DepthMode = ESP.Drawing.Chams.VisibleCheck and "Occluded" or "AlwaysOnTop"


                    for _, c in pairs({LeftTop, LeftSide, BottomSide, BottomDown, RightTop, RightSide, BottomRightSide, BottomRightDown}) do
                        c.BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB
                        c.Visible = ESP.Drawing.Boxes.Corner.Enabled
                    end
                    LeftTop.Position = UDim2.new(0, Pos.X - w/2, 0, top.Y)
                    LeftTop.Size = UDim2.new(0, w/5, 0, 1)

                    LeftSide.Position = UDim2.new(0, Pos.X - w/2, 0, top.Y)
                    LeftSide.Size = UDim2.new(0, 1, 0, h/5)

                    BottomSide.Position = UDim2.new(0, Pos.X - w/2, 0, bottom.Y - h/5)
                    BottomSide.Size = UDim2.new(0, 1, 0, h/5)
                    BottomSide.AnchorPoint = Vector2.new(0, 0)

                    BottomDown.Position = UDim2.new(0, Pos.X - w/2, 0, bottom.Y)
                    BottomDown.Size = UDim2.new(0, w/5, 0, 1)
                    BottomDown.AnchorPoint = Vector2.new(0, 0)

                    RightTop.Position = UDim2.new(0, Pos.X + w/2 - w/5, 0, top.Y)
                    RightTop.Size = UDim2.new(0, w/5, 0, 1)
                    RightTop.AnchorPoint = Vector2.new(0, 0)

                    RightSide.Position = UDim2.new(0, Pos.X + w/2 - 1, 0, top.Y)
                    RightSide.Size = UDim2.new(0, 1, 0, h/5)
                    RightSide.AnchorPoint = Vector2.new(0, 0)

                    BottomRightSide.Position = UDim2.new(0, Pos.X + w/2 - 1, 0, bottom.Y - h/5)
                    BottomRightSide.Size = UDim2.new(0, 1, 0, h/5)
                    BottomRightSide.AnchorPoint = Vector2.new(0, 0)

                    BottomRightDown.Position = UDim2.new(0, Pos.X + w/2 - w/5, 0, bottom.Y)
                    BottomRightDown.Size = UDim2.new(0, w/5, 0, 1)
                    BottomRightDown.AnchorPoint = Vector2.new(0, 0)


                    Box.Position = UDim2.new(0, Pos.X - w/2, 0, top.Y)
                    Box.Size = UDim2.new(0, w, 0, h)
                    Box.Visible = ESP.Drawing.Boxes.Full.Enabled or ESP.Drawing.Boxes.Filled.Enabled
                    if ESP.Drawing.Boxes.GradientFill then
                        Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        Box.BackgroundColor3 = ESP.Drawing.Boxes.Filled.Enabled and ESP.Drawing.Boxes.Filled.RGB or Color3.fromRGB(0,0,0)
                    end
                    Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Enabled and ESP.Drawing.Boxes.Filled.Transparency or 1
                    Box.BorderSizePixel = ESP.Drawing.Boxes.Filled.Enabled and 1 or 0

                    Outline.Enabled = ESP.Drawing.Boxes.Full.Enabled
                    Outline.Color = ESP.Drawing.Boxes.Full.RGB

                    Gradient1.Enabled = ESP.Drawing.Boxes.GradientFill
                    if ESP.Drawing.Boxes.GradientFill then
                        Gradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}
                    end

                    Gradient2.Enabled = ESP.Drawing.Boxes.Gradient
                    if ESP.Drawing.Boxes.Gradient then
                        Gradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}
                    end

                    local rawRot = ESP.Drawing.Boxes.Animate and ((tick() * ESP.Drawing.Boxes.RotationSpeed) % 360) or 315
                    if rawRot > 180 then rawRot = rawRot - 360 end
                    Gradient1.Rotation = rawRot
                    Gradient2.Rotation = rawRot


                    local maxHealth = Humanoid.MaxHealth
                    local health = 0
                    if maxHealth and maxHealth > 0 then
                        health = math.clamp(Humanoid.Health / maxHealth, 0, 1)
                    end

                    BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled
                    BehindHealthbar.Position = UDim2.new(0, Pos.X - w/2 - 6, 0, top.Y)
                    BehindHealthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                    BehindHealthbar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    BehindHealthbar.BackgroundTransparency = 0

                    Healthbar.Visible = ESP.Drawing.Healthbar.Enabled
                    Healthbar.Position = UDim2.new(0, 0, 1 - health, 0)
                    Healthbar.Size = UDim2.new(1, 0, health, 0)
                    Healthbar.BackgroundTransparency = 0

                    if ESP.Drawing.Healthbar.Gradient then
                        HealthbarGradient.Enabled = true
                        HealthbarGradient.Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1),
                            ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2),
                            ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)
                        }
                        Healthbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        HealthbarGradient.Enabled = false
                        Healthbar.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), health)
                    end

                    if ESP.Drawing.Healthbar.HealthText then
                        local hp = math.floor(health * 100)
                        HealthText.Position = UDim2.new(0.5, 0, 1 - hp/100, 3)
                        HealthText.Text = tostring(hp)
                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                        HealthText.TextColor3 = ESP.Drawing.Healthbar.Lerp and (health >= 0.75 and Color3.fromRGB(0,255,0) or health >= 0.5 and Color3.fromRGB(255,255,0) or health >= 0.25 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0)) or ESP.Drawing.Healthbar.HealthTextRGB
                    else
                        HealthText.Visible = false
                    end


                    Name.Visible = ESP.Drawing.Names.Enabled
                    local nameColor = ESP.Drawing.Names.RGB
                    if ESP.Drawing.Names.Rainbow then
                        nameColor = Color3.fromHSV((tick() * ESP.Drawing.Names.RainbowSpeed) % 1, 1, 1)
                    elseif ESP.Drawing.Names.TeamColor then
                        if plr.Team then
                            nameColor = plr.TeamColor.Color
                        end
                    end
                    Name.TextColor3 = nameColor

                    if isSelf then
                        Name.Text = string.format('(<font color="rgb(0,255,0)">You</font>) %s', plr.Name)
                    elseif ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                        Name.Text = string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s', ESP.Options.FriendcheckRGB.R*255, ESP.Options.FriendcheckRGB.G*255, ESP.Options.FriendcheckRGB.B*255, plr.Name)
                    else
                        Name.Text = plr.Name
                    end
                    Name.Position = UDim2.new(0, Pos.X, 0, top.Y - 9)


                    if ESP.Drawing.Distances.Enabled then
                        Distance.TextColor3 = ESP.Drawing.Distances.RGB
                        if ESP.Drawing.Distances.Position == "Bottom" then
                            Distance.Position = UDim2.new(0, Pos.X, 0, bottom.Y + 7)
                            Distance.Text = string.format("%d meters", math.floor(Dist))
                            Distance.Visible = true
                        elseif ESP.Drawing.Distances.Position == "Text" then
                            Distance.Visible = false
                            if isSelf then
                                Name.Text = string.format('(<font color="rgb(0,255,0)">You</font>) %s [%d]', plr.Name, math.floor(Dist))
                            elseif ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                Name.Text = string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s [%d]', ESP.Options.FriendcheckRGB.R*255, ESP.Options.FriendcheckRGB.G*255, ESP.Options.FriendcheckRGB.B*255, plr.Name, math.floor(Dist))
                            else
                                Name.Text = string.format('%s [%d]', plr.Name, math.floor(Dist))
                            end
                        end
                    else
                        Distance.Visible = false
                    end
                else
                    HideESP()
                end
            else
                HideESP()
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, v in pairs(Players:GetPlayers()) do
    coroutine.wrap(ESP_func)(v)
end
Players.PlayerAdded:Connect(function(v)
    coroutine.wrap(ESP_func)(v)
end)

return API
