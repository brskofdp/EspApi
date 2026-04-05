local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

local ESP = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled  = true,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 100,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 100,
            VisibleCheck = true,
        },
        Names = {
            Enabled = true,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = true,
        },
        Distances = {
            Enabled = true, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = true, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = false,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = true,  
            HealthText = true, Lerp = false, HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 2.5,
            Gradient = true, GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(60, 60, 125), GradientRGB3 = Color3.fromRGB(119, 120, 255), 
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = true,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        };
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();

local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756"
};

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

do
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
    });

    local DupeCheck = function(plr)
        if ScreenGui:FindFirstChild(plr.Name) then
            ScreenGui[plr.Name]:Destroy()
        end
    end

    local ESP_func = function(plr)
        coroutine.wrap(DupeCheck)(plr)
        local Name = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}})
        local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
        local BehindHealthbar = Functions:Create("Frame", {Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
        local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Weapons.GradientRGB2)}})
        local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local Flag1 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})

        local Updater = function()
            local Connection
            local function HideESP()
                Box.Visible = false
                Name.Visible = false
                Distance.Visible = false
                Weapon.Visible = false
                Healthbar.Visible = false
                BehindHealthbar.Visible = false
                HealthText.Visible = false
                WeaponIcon.Visible = false
                LeftTop.Visible = false
                LeftSide.Visible = false
                BottomSide.Visible = false
                BottomDown.Visible = false
                RightTop.Visible = false
                RightSide.Visible = false
                BottomRightSide.Visible = false
                BottomRightDown.Visible = false
                Flag1.Visible = false
                Chams.Enabled = false
                Flag2.Visible = false
                if not plr then
                    ScreenGui:Destroy()
                    Connection:Disconnect()
                end
            end

            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if not ESP.Enabled then HideESP(); return end
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = plr.Character.HumanoidRootPart
                    local Humanoid = plr.Character:WaitForChild("Humanoid")
                    local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714

                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        if ESP.FadeOut.OnDistance then
                            for _, el in pairs({Box, Outline, Name, Distance, Weapon, Healthbar, BehindHealthbar, HealthText, WeaponIcon, LeftTop, LeftSide, BottomSide, BottomDown, RightTop, RightSide, BottomRightSide, BottomRightDown, Chams, Flag1, Flag2}) do
                                Functions:FadeOutOnDist(el, Dist)
                            end
                        end

                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then

                            -- Chams
                            Chams.Adornee = plr.Character
                            Chams.Enabled = ESP.Drawing.Chams.Enabled
                            Chams.FillColor = ESP.Drawing.Chams.FillRGB
                            Chams.OutlineColor = ESP.Drawing.Chams.OutlineRGB
                            if ESP.Drawing.Chams.Thermal then
                                local breathe = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                Chams.FillTransparency = ESP.Drawing.Chams.Fill_Transparency * breathe * 0.01
                                Chams.OutlineTransparency = ESP.Drawing.Chams.Outline_Transparency * breathe * 0.01
                            end
                            Chams.DepthMode = ESP.Drawing.Chams.VisibleCheck and "Occluded" or "AlwaysOnTop"

                            -- Corner Boxes
                            LeftTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            LeftTop.Position = UDim2.new(0, Pos.X - w/2, 0, Pos.Y - h/2)
                            LeftTop.Size = UDim2.new(0, w/5, 0, 1)
                            LeftSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            LeftSide.Position = UDim2.new(0, Pos.X - w/2, 0, Pos.Y - h/2)
                            LeftSide.Size = UDim2.new(0, 1, 0, h/5)
                            BottomSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            BottomSide.Position = UDim2.new(0, Pos.X - w/2, 0, Pos.Y + h/2)
                            BottomSide.Size = UDim2.new(0, 1, 0, h/5)
                            BottomSide.AnchorPoint = Vector2.new(0, 5)
                            BottomDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            BottomDown.Position = UDim2.new(0, Pos.X - w/2, 0, Pos.Y + h/2)
                            BottomDown.Size = UDim2.new(0, w/5, 0, 1)
                            BottomDown.AnchorPoint = Vector2.new(0, 1)
                            RightTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            RightTop.Position = UDim2.new(0, Pos.X + w/2, 0, Pos.Y - h/2)
                            RightTop.Size = UDim2.new(0, w/5, 0, 1)
                            RightTop.AnchorPoint = Vector2.new(1, 0)
                            RightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            RightSide.Position = UDim2.new(0, Pos.X + w/2 - 1, 0, Pos.Y - h/2)
                            RightSide.Size = UDim2.new(0, 1, 0, h/5)
                            RightSide.AnchorPoint = Vector2.new(0, 0)
                            BottomRightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            BottomRightSide.Position = UDim2.new(0, Pos.X + w/2, 0, Pos.Y + h/2)
                            BottomRightSide.Size = UDim2.new(0, 1, 0, h/5)
                            BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                            BottomRightDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                            BottomRightDown.Position = UDim2.new(0, Pos.X + w/2, 0, Pos.Y + h/2)
                            BottomRightDown.Size = UDim2.new(0, w/5, 0, 1)
                            BottomRightDown.AnchorPoint = Vector2.new(1, 1)

                            -- Boxes
                            Box.Position = UDim2.new(0, Pos.X - w/2, 0, Pos.Y - h/2)
                            Box.Size = UDim2.new(0, w, 0, h)
                            Box.Visible = ESP.Drawing.Boxes.Full.Enabled
                            Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Enabled and (ESP.Drawing.Boxes.GradientFill and ESP.Drawing.Boxes.Filled.Transparency or 1) or 1
                            Box.BorderSizePixel = ESP.Drawing.Boxes.Filled.Enabled and 1 or 0
                            RotationAngle = RotationAngle + (tick() - Tick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi/4 * tick() - math.pi/2)
                            Gradient1.Rotation = ESP.Drawing.Boxes.Animate and RotationAngle or -45
                            Gradient2.Rotation = ESP.Drawing.Boxes.Animate and RotationAngle or -45
                            Tick = tick()

                            -- Healthbar
                            local health = Humanoid.Health / Humanoid.MaxHealth
                            Healthbar.Visible = ESP.Drawing.Healthbar.Enabled
                            Healthbar.Position = UDim2.new(0, Pos.X - w/2 - 6, 0, Pos.Y - h/2 + h * (1 - health))
                            Healthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h * health)
                            BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled
                            BehindHealthbar.Position = UDim2.new(0, Pos.X - w/2 - 6, 0, Pos.Y - h/2)
                            BehindHealthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                            if ESP.Drawing.Healthbar.HealthText then
                                local hp = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                HealthText.Position = UDim2.new(0, Pos.X - w/2 - 6, 0, Pos.Y - h/2 + h * (1 - hp/100) + 3)
                                HealthText.Text = tostring(hp)
                                HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                                HealthText.TextColor3 = ESP.Drawing.Healthbar.Lerp and (health >= 0.75 and Color3.fromRGB(0,255,0) or health >= 0.5 and Color3.fromRGB(255,255,0) or health >= 0.25 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0)) or ESP.Drawing.Healthbar.HealthTextRGB
                            else
                                HealthText.Visible = false
                            end

                            -- Names
                            Name.Visible = ESP.Drawing.Names.Enabled
                            if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                Name.Text = string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s', ESP.Options.FriendcheckRGB.R*255, ESP.Options.FriendcheckRGB.G*255, ESP.Options.FriendcheckRGB.B*255, plr.Name)
                            else
                                Name.Text = string.format('(<font color="rgb(255,0,0)">E</font>) %s', plr.Name)
                            end
                            Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h/2 - 9)

                            -- Distance
                            if ESP.Drawing.Distances.Enabled then
                                if ESP.Drawing.Distances.Position == "Bottom" then
                                    Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h/2 + 18)
                                    WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h/2 + 15)
                                    Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h/2 + 7)
                                    Distance.Text = string.format("%d meters", math.floor(Dist))
                                    Distance.Visible = true
                                elseif ESP.Drawing.Distances.Position == "Text" then
                                    Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h/2 + 8)
                                    WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h/2 + 5)
                                    Distance.Visible = false
                                    if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                        Name.Text = string.format('(<font color="rgb(%d,%d,%d)">F</font>) %s [%d]', ESP.Options.FriendcheckRGB.R*255, ESP.Options.FriendcheckRGB.G*255, ESP.Options.FriendcheckRGB.B*255, plr.Name, math.floor(Dist))
                                    else
                                        Name.Text = string.format('(<font color="rgb(255,0,0)">E</font>) %s [%d]', plr.Name, math.floor(Dist))
                                    end
                                    Name.Visible = ESP.Drawing.Names.Enabled
                                end
                            else
                                Distance.Visible = false
                            end

                            -- Weapons
                            Weapon.Text = "none"
                            Weapon.Visible = ESP.Drawing.Weapons.Enabled
                        else
                            HideESP()
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

    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Name ~= lplayer.Name then
            coroutine.wrap(ESP_func)(v)
        end      
    end
    game:GetService("Players").PlayerAdded:Connect(function(v)
        coroutine.wrap(ESP_func)(v)
    end)
end

