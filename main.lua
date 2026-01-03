-- TA DOORS HUB v10 (AUTO-LAYOUT FIX)
-- Butonların kaybolma sorununu %100 çözen, Otomatik Hizalamalı Sürüm.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- --- AYARLAR ---
_G.Settings = {
    AutoRun = false,
    GodMode = true,
    Noclip = true,
    ESP = true,
    Speed = 45 -- Flash Hızı
}

local CurrentStatus = "Hazır - v10"

-- --- UI OLUŞTURMA (GARANTİLİ YÖNTEM) ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TA_Doors_UI_v10"
if lp:WaitForChild("PlayerGui"):FindFirstChild("TA_Doors_UI_v10") then
    lp.PlayerGui.TA_Doors_UI_v10:Destroy()
end
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ANA ÇERÇEVE
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0) -- Ekranın %30'u genişlikte
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0) -- Tam Ortala
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 170, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- ***SİHİRLİ DOKUNUŞ: UI LIST LAYOUT***
-- Bu zımbırtı butonları otomatik dizer, kaybolmalarını engeller.
local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5) -- Butonlar arası boşluk
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Padding = Instance.new("UIPadding") -- Kenar boşlukları
Padding.Parent = MainFrame
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)

-- KÖŞELERİ YUVARLAT
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- MOBİL SÜRÜKLEME (DRAG)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


-- --- BUTON OLUŞTURUCU (GARANTİLİ) ---
local function CreateElement(class, props)
    local newObj = Instance.new(class)
    for k, v in pairs(props) do
        newObj[k] = v
    end
    return newObj
end

-- BAŞLIK
CreateElement("TextLabel", {
    Parent = MainFrame,
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "🔥 TA HUB v10 🔥",
    TextColor3 = Color3.fromRGB(255, 170, 0),
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    LayoutOrder = 1 -- En tepede durur
})

-- DURUM YAZISI
local StatusLabel = CreateElement("TextLabel", {
    Parent = MainFrame,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = CurrentStatus,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    LayoutOrder = 2
})

-- BUTON FONKSİYONU
local function CreateToggleBtn(text, settingName, order)
    local btn = CreateElement("TextButton", {
        Parent = MainFrame,
        Size = UDim2.new(0.9, 0, 0, 40), -- Genişlik %90
        BackgroundColor3 = _G.Settings[settingName] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        LayoutOrder = order
    })
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.Activated:Connect(function()
        _G.Settings[settingName] = not _G.Settings[settingName]
        btn.BackgroundColor3 = _G.Settings[settingName] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    end)
end

-- BUTONLARI EKLE
CreateToggleBtn("AUTO RUN (HIZLI)", "AutoRun", 3)
CreateToggleBtn("GOD MODE", "GodMode", 4)
CreateToggleBtn("ESP", "ESP", 5)
CreateToggleBtn("NOCLIP", "Noclip", 6)

-- GİZLE BUTONU
local CloseBtn = CreateElement("TextButton", {
    Parent = MainFrame,
    Size = UDim2.new(0.9, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    Text = "MENÜYÜ GİZLE",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    LayoutOrder = 7
})
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)

-- MENÜ AÇMA BUTONU (EKRANIN ÜSTÜNDE SABİT)
local OpenBtn = CreateElement("TextButton", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 80, 0, 35),
    Position = UDim2.new(0.5, -40, 0, 10),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Text = "AÇ",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold
})
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
OpenBtn.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)


-- --- OYUN MANTIĞI (FLASH + CRASH GUARD) ---

local function updateStatus(text)
    StatusLabel.Text = text
end

-- NOCLIP
RunService.Stepped:Connect(function()
    if _G.Settings.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

local function teleportTo(targetCFrame)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    local targetPos = Vector3.new(targetCFrame.X, root.Position.Y, targetCFrame.Z)
    local distance = (root.Position - targetPos).Magnitude
    
    if distance < 1 then return nil end
    
    -- FLASH MODU (15 metreden kısaysa direkt ışınla)
    if distance < 15 then
        root.CFrame = CFrame.new(targetPos)
        return nil
    else
        local info = TweenInfo.new(distance / _G.Settings.Speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        return tween
    end
end

local function getLatestRoom()
    local s, r = pcall(function()
        local rooms = Workspace:FindFirstChild("CurrentRooms") or Workspace:FindFirstChild("Rooms")
        if not rooms then return nil end
        local maxNum, target = -1, nil
        for _, rm in pairs(rooms:GetChildren()) do
            local n = tonumber(rm.Name)
            if n and n > maxNum then maxNum = n; target = rm end
        end
        return target
    end)
    return s and r or nil
end

local function createESP(obj, color)
    if not _G.Settings.ESP or obj:FindFirstChild("ESP") then return end
    local hl = Instance.new("Highlight", obj)
    hl.Name = "ESP"; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
end

-- ANA DÖNGÜ
task.spawn(function()
    while true do
        task.wait(0.05)
        pcall(function()
            local room = getLatestRoom()
            if room then
                -- ESP
                if _G.Settings.ESP then
                    for _, v in pairs(room:GetDescendants()) do
                        if v.Name == "KeyObtain" then createESP(v, Color3.fromRGB(255, 255, 0)) end
                        if v.Name == "LiveHintBook" then createESP(v, Color3.fromRGB(0, 255, 255)) end
                        if v.Name == "BreakerSwitch" then createESP(v, Color3.fromRGB(255, 0, 255)) end
                    end
                end
                
                -- AUTO RUN
                if _G.Settings.AutoRun then
                    if room.Name == "50" or room.Name == "100" then
                        updateStatus("BOSS: MANUEL")
                    else
                        updateStatus(">>> " .. room.Name)
                        local door = room:FindFirstChild("Door")
                        if door then
                            local target = door:FindFirstChild("Client") or door:FindFirstChild("Door")
                            if target then
                                -- Anahtar
                                if room:FindFirstChild("Assets") and door:FindFirstChild("Lock") and not lp.Character:FindFirstChild("Key") then
                                    for _, v in pairs(room.Assets:GetDescendants()) do
                                        if v.Name == "KeyObtain" then
                                            teleportTo(v.CFrame)
                                            task.wait(0.05)
                                            fireproximityprompt(v:FindFirstChild("ModulePrompt"))
                                            task.wait(0.05)
                                            if lp.Backpack:FindFirstChild("Key") then lp.Character.Humanoid:EquipTool(lp.Backpack.Key) end
                                            break
                                        end
                                    end
                                end
                                
                                -- Kapıya Git ve Aç
                                local t = teleportTo(target.CFrame)
                                if t then t.Completed:Wait() end
                                for _, p in pairs(door:GetDescendants()) do
                                    if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                                end
                                
                                -- İçeri Dal
                                if door:FindFirstChild("Open") then
                                    teleportTo(target.CFrame * CFrame.new(0, 0, -15))
                                else
                                    task.wait(0.1)
                                    teleportTo(target.CFrame * CFrame.new(0, 0, -15))
                                end
                            end
                        end
                    end
                else
                    updateStatus("Beklemede...")
                end
            end
        end)
    end
end)

-- CANAVAR KORUMASI
Workspace.ChildAdded:Connect(function(v)
    if not _G.Settings.GodMode then return end
    local n = v.Name
    if n=="RushMoving" or n=="AmbushMoving" or n=="A60" or n=="A120" then
        _G.Settings.AutoRun = false
        updateStatus("⚠️ KORUMA")
        local r = lp.Character.HumanoidRootPart
        local old = r.CFrame
        r.CFrame = old * CFrame.new(0, 80, 0); r.Anchored = true
        repeat task.wait(0.5) until not v.Parent
        r.Anchored = false; r.CFrame = old
        _G.Settings.AutoRun = true
    elseif n=="SeekMoving" then
        _G.Settings.AutoRun = false
        updateStatus("⚠️ SEEK!")
    elseif n=="Eyes" then
        _G.Settings.AutoRun = false
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.Position) * CFrame.Angles(math.rad(-90), 0, 0)
    end
end)

game:GetService("Lighting").Brightness = 2
