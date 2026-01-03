-- DOORS HUB v4

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
    Notify = true,
    Speed = 19
}

local CurrentStatus = "Hazır..."

-- --- UI OLUŞTURMA ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TA_Doors_UI_v4_Fix"
if lp:WaitForChild("PlayerGui"):FindFirstChild("TA_Doors_UI_v4_Fix") then
    lp.PlayerGui.TA_Doors_UI_v4_Fix:Destroy()
end
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 480)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Sürükleme
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "TA DOORS HUB v4"
Title.TextColor3 = Color3.fromRGB(255, 185, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Durum: " .. CurrentStatus
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- Buton Oluşturucu
local btnY = 70
local function createButton(text, settingName, colorOn, colorOff)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, btnY)
    
    local isOn = _G.Settings[settingName]
    btn.BackgroundColor3 = isOn and (colorOn or Color3.fromRGB(0, 150, 0)) or (colorOff or Color3.fromRGB(150, 0, 0))
    btn.Text = text .. ": " .. (isOn and "AÇIK" or "KAPALI")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        _G.Settings[settingName] = not _G.Settings[settingName]
        local newState = _G.Settings[settingName]
        btn.BackgroundColor3 = newState and (colorOn or Color3.fromRGB(0, 150, 0)) or (colorOff or Color3.fromRGB(150, 0, 0))
        btn.Text = text .. ": " .. (newState and "AÇIK" or "KAPALI")
    end)
    btn.Parent = MainFrame
    btnY = btnY + 40
end

createButton("OTOMATİK KOŞU", "AutoRun")
createButton("GOD MODE (KORUMA)", "GodMode")
createButton("ESP (GÖRÜŞ)", "ESP")
createButton("BİLDİRİMLER", "Notify", Color3.fromRGB(0, 100, 200), Color3.fromRGB(50, 50, 50))
createButton("NOCLIP", "Noclip", Color3.fromRGB(100, 0, 100), Color3.fromRGB(50, 50, 50))

-- EŞYA BUTONLARI
local ItemLabel = Instance.new("TextLabel", MainFrame)
ItemLabel.Size = UDim2.new(1, 0, 0, 20)
ItemLabel.Position = UDim2.new(0, 0, 0, btnY)
ItemLabel.BackgroundTransparency = 1
ItemLabel.Text = "--- GÖRSEL EŞYALAR ---"
ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
ItemLabel.Font = Enum.Font.Gotham
ItemLabel.TextSize = 12
ItemLabel.Parent = MainFrame
btnY = btnY + 25

local function createItemButton(itemName, itemId)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, btnY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.Text = "Ekle: " .. itemName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        local tool = Instance.new("Tool")
        tool.Name = itemName
        tool.RequiresHandle = false
        local handle = Instance.new("Part", tool)
        handle.Name = "Handle"; handle.Size = Vector3.new(1, 1, 3); handle.Transparency = 1
        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshId = "rbxassetid://" .. itemId; mesh.TextureId = ""; mesh.Scale = Vector3.new(1, 1, 1)
        tool.Parent = lp.Backpack
    end)
    btn.Parent = MainFrame
    btnY = btnY + 35
end

createItemButton("Fake Crucifix", "11603246853")
createItemButton("Skeleton Key", "11361274534")
createItemButton("Shears (Makas)", "12549216773")

-- Kapatma Tuşu
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0.9, 0, 0, 25)
CloseBtn.Position = UDim2.new(0.05, 0, 0.93, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.Text = "GİZLE (Sağ Shift)"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
Instance.new("UICorner", CloseBtn)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
UserInputService.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end end)

-- --- FONKSİYONLAR ---

local function updateStatus(text, color)
    StatusLabel.Text = "Durum: " .. text
    StatusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function notify(title, msg)
    if _G.Settings.Notify then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = title; Text = msg; Duration = 5;
            })
        end)
    end
end

local function createESP(obj, color, text)
    if not _G.Settings.ESP then return end
    if obj:FindFirstChild("TA_Highlight") then return end
    local hl = Instance.new("Highlight", obj)
    hl.Name = "TA_Highlight"; hl.FillColor = color; hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.5
    local bg = Instance.new("BillboardGui", obj)
    bg.AlwaysOnTop = true; bg.Size = UDim2.new(0,100,0,30); bg.StudsOffset = Vector3.new(0,2,0)
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold
end

local function moveTo(targetCFrame)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local targetPos = Vector3.new(targetCFrame.X, root.Position.Y, targetCFrame.Z)
    local distance = (root.Position - targetPos).Magnitude
    if distance < 1 then return nil end
    local tween = TweenService:Create(root, TweenInfo.new(distance / _G.Settings.Speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    return tween
end

local function getLatestRoom()
    local rooms = Workspace:FindFirstChild("CurrentRooms") or Workspace:FindFirstChild("Rooms")
    if not rooms then return nil end
    local latestRoomNum = -1
    local targetRoom = nil
    for _, room in pairs(rooms:GetChildren()) do
        local num = tonumber(room.Name)
        if num and num > latestRoomNum then
            latestRoomNum = num
            targetRoom = room
        end
    end
    return targetRoom
end

-- --- ANA DÖNGÜ ---
task.spawn(function()
    while true do
        task.wait(0.1)
        
        -- NOCLIP
        if _G.Settings.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end

        local room = getLatestRoom()
        if room then
            -- ESP
            if _G.Settings.ESP then
                for _, v in pairs(room:GetDescendants()) do
                    if v.Name == "LiveHintBook" then createESP(v, Color3.fromRGB(0, 255, 255), "Kitap") end
                    if v.Name == "KeyObtain" then createESP(v, Color3.fromRGB(255, 255, 0), "Anahtar") end
                    if v.Name == "BreakerSwitch" then createESP(v, Color3.fromRGB(255, 0, 255), "Şalter") end
                    if v:IsA("Model") and (v.Name == "Flashlight" or v.Name == "Lighter" or v.Name == "Vitamins") then
                        createESP(v, Color3.fromRGB(255, 255, 255), v.Name)
                    end
                end
            end

            -- AUTO RUN
            if room.Name == "50" then
                updateStatus("ODA 50 - AutoRun Durdu", Color3.fromRGB(255, 0, 0))
            elseif room.Name == "100" then
                updateStatus("ODA 100 - AutoRun Durdu", Color3.fromRGB(255, 0, 0))
            elseif _G.Settings.AutoRun then
                updateStatus("Oda Geçiliyor: " .. room.Name, Color3.fromRGB(0, 255, 0))
                
                if room:FindFirstChild("Door") then
                    local door = room.Door
                    local target = door:FindFirstChild("Client") or door:FindFirstChild("Door")
                    
                    if target then
                        -- Anahtar Alma (CRASH FIX)
                        if room:FindFirstChild("Assets") and door:FindFirstChild("Lock") and not lp.Character:FindFirstChild("Key") then
                            updateStatus("Anahtar Alınıyor...", Color3.fromRGB(255, 255, 0))
                            for _, v in pairs(room.Assets:GetDescendants()) do
                                if v.Name == "KeyObtain" then
                                    highlightObj(v, Color3.fromRGB(255, 255, 0), "Anahtar")
                                    local keyMove = moveTo(v.CFrame) -- Fix: Değişkene ata
                                    if keyMove then keyMove.Completed:Wait() end -- Fix: Varsa bekle
                                    
                                    fireproximityprompt(v:FindFirstChild("ModulePrompt"))
                                    task.wait(0.5)
                                    if lp.Backpack:FindFirstChild("Key") then lp.Character.Humanoid:EquipTool(lp.Backpack.Key) end
                                    break
                                end
                            end
                        end
                        
                        -- Kapıya Git
                        local move = moveTo(target.CFrame)
                        if move then move.Completed:Wait() end
                        
                        -- Aç
                        for _, p in pairs(door:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                        end
                        
                        -- Gir
                        task.wait(0.4)
                        local enter = moveTo(target.CFrame * CFrame.new(0, 0, -15))
                        if enter then enter.Completed:Wait() end
                    end
                end
            else
                if not (room.Name == "50" or room.Name == "100") then
                    updateStatus("Beklemede...", Color3.fromRGB(200, 200, 200))
                end
            end
        end
    end
end)

-- --- CANAVAR DEDEKTÖRÜ ---
Workspace.ChildAdded:Connect(function(v)
    local n = v.Name
    local isMonster = (n == "RushMoving" or n == "AmbushMoving" or n == "A60" or n == "A120" or n == "Eyes" or n == "SeekMoving")
    
    if isMonster then
        notify("TEHLİKE!", n .. " Geliyor! Saklan!")
        createESP(v, Color3.fromRGB(255, 0, 0), n)
        
        if _G.Settings.GodMode then
            local char = lp.Character
            if not char then return end
            
            if n == "RushMoving" or n == "AmbushMoving" or n == "A60" or n == "A120" then
                _G.Settings.AutoRun = false
                updateStatus("KORUMA AKTİF: " .. n, Color3.fromRGB(255, 0, 0))
                local root = char.HumanoidRootPart
                local old = root.CFrame
                root.CFrame = old * CFrame.new(0, 80, 0)
                root.Anchored = true
                repeat task.wait(0.5) until not v.Parent
                root.Anchored = false
                root.CFrame = old
                _G.Settings.AutoRun = true
                updateStatus("Tehlike Geçti", Color3.fromRGB(0, 255, 0))
                
            elseif n == "Eyes" then
                 -- Eyes Fix: Sadece yere bak ve bekle (Hata vermez)
                 _G.Settings.AutoRun = false -- AutoRun'ı kapat ki kafa titremesin
                 updateStatus("EYES! YERE BAKILIYOR...", Color3.fromRGB(0, 255, 255))
                 char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position) * CFrame.Angles(math.rad(-90), 0, 0)
                 
            elseif n == "SeekMoving" then
                 _G.Settings.AutoRun = false
                 updateStatus("SEEK! KENDİN KOŞ!", Color3.fromRGB(255, 0, 0))
                 notify("SEEK", "Koşma Sahnesi Başladı! Hile durduruldu.")
            end
        end
    end
end)

game:GetService("Lighting").Brightness = 2
game:GetService("Lighting").ClockTime = 14
game:GetService("Lighting").FogEnd = 100000

print("DOORS HUB v4 YÜKLENDİ")
