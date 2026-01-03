-- TA DOORS HUB v7 (FLASH EDITION - INSTANT TP LOGIC)
-- Senin attığın teleport mantığının "Anti-Cheat" korumalı hali.

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
    Speed = 45 -- Hızı 45'e çıkardık (Normalin 3 katı, Işınlanma gibi)
}

local CurrentStatus = "Hazır"

-- --- UI OLUŞTURMA ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TA_Doors_UI_v7"
if lp:WaitForChild("PlayerGui"):FindFirstChild("TA_Doors_UI_v7") then
    lp.PlayerGui.TA_Doors_UI_v7:Destroy()
end
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 300) 
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Kırmızı Tema (Hız için)
MainFrame.BorderSizePixel = 1
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- MOBİL SÜRÜKLEME
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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "⚡ TA HUB v7 (FLASH) ⚡"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = CurrentStatus
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.Parent = MainFrame

-- Butonlar
local btnY = 50
local function createButton(text, settingName)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, btnY)
    
    local isOn = _G.Settings[settingName]
    btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        _G.Settings[settingName] = not _G.Settings[settingName]
        local s = _G.Settings[settingName]
        btn.BackgroundColor3 = s and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    end)
    btn.Parent = MainFrame
    btnY = btnY + 32
end

createButton("AUTO FLASH (HIZLI)", "AutoRun")
createButton("GOD MODE", "GodMode")
createButton("ESP", "ESP")
createButton("NOCLIP", "Noclip")

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, 0, 0, 20)
CloseBtn.Position = UDim2.new(0, 0, 0.93, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "GİZLE"
CloseBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.TextSize = 10
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 20)
OpenBtn.Position = UDim2.new(0.5, -25, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenBtn.Text = "MENU"
OpenBtn.TextColor3 = Color3.white
Instance.new("UICorner", OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- HIZLI HAREKET MOTORU ---

-- ZORUNLU NOCLIP (Duvarları yok sayar)
RunService.Stepped:Connect(function()
    if (_G.Settings.Noclip or _G.Settings.AutoRun) and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

local function teleportTo(targetCFrame)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    -- Senin attığın kodun mantığı burada:
    -- Eğer mesafe kısaysa direkt ışınla, uzunda hızlıca kaydır (Kick yememek için)
    local targetPos = Vector3.new(targetCFrame.X, root.Position.Y, targetCFrame.Z)
    local distance = (root.Position - targetPos).Magnitude
    
    if distance < 1 then return nil end
    
    -- Eğer mesafe 15 birimden azsa DİREKT IŞINLA (Senin istediğin kod)
    if distance < 15 then
        root.CFrame = CFrame.new(targetPos)
        return nil
    else
        -- Mesafe uzunsa "Flash" gibi kayarak git (Oyun atmasın diye)
        local speed = _G.Settings.Speed
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        
        -- Takılma kontrolü (Duvar bugu fix)
        task.spawn(function()
            local sP = root.Position
            task.wait(0.5)
            if tween.PlaybackState == Enum.PlaybackState.Playing and (root.Position - sP).Magnitude < 0.5 then
                tween:Cancel()
                root.CFrame = root.CFrame * CFrame.new(0,0,5) -- Geri zıpla
            end
        end)
        return tween
    end
end

local function getLatestRoom()
    local rooms = Workspace:FindFirstChild("CurrentRooms") or Workspace:FindFirstChild("Rooms")
    if not rooms then return nil end
    local maxNum, target = -1, nil
    for _, r in pairs(rooms:GetChildren()) do
        local n = tonumber(r.Name)
        if n and n > maxNum then maxNum = n; target = r end
    end
    return target
end

local function createESP(obj, color)
    if not _G.Settings.ESP or obj:FindFirstChild("ESP") then return end
    local hl = Instance.new("Highlight", obj)
    hl.Name = "ESP"; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
end

-- --- ANA DÖNGÜ ---
task.spawn(function()
    while true do
        task.wait() -- Gecikme yok
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
            
            -- AUTO RUN (FLASH LOGIC)
            if _G.Settings.AutoRun then
                if room.Name == "50" or room.Name == "100" then
                    updateStatus("BOSS ODASI! Manuel.")
                else
                    updateStatus(">>> " .. room.Name)
                    local door = room:FindFirstChild("Door")
                    if door then
                        -- Kapının "Client" (yani kolu/menteşesi) yoksa kapının kendisine git
                        local target = door:FindFirstChild("Client") or door:FindFirstChild("Door") or door:FindFirstChild("Hinge")
                        
                        if target then
                            -- Anahtar Lazım mı?
                            if room:FindFirstChild("Assets") and door:FindFirstChild("Lock") and not lp.Character:FindFirstChild("Key") then
                                for _, v in pairs(room.Assets:GetDescendants()) do
                                    if v.Name == "KeyObtain" then
                                        -- Anahtara IŞINLAN
                                        teleportTo(v.CFrame)
                                        task.wait(0.05)
                                        fireproximityprompt(v:FindFirstChild("ModulePrompt"))
                                        task.wait(0.05)
                                        if lp.Backpack:FindFirstChild("Key") then lp.Character.Humanoid:EquipTool(lp.Backpack.Key) end
                                        break
                                    end
                                end
                            end
                            
                            -- Kapıya IŞINLAN / KAY
                            local t = teleportTo(target.CFrame)
                            if t then t.Completed:Wait() end
                            
                            -- Aç
                            for _, p in pairs(door:GetDescendants()) do
                                if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                            end
                            
                            -- Kapı açılır açılmaz İÇERİ IŞINLAN (Burada senin kodun devreye giriyor)
                            -- Kapı açıldığında bir sonraki oda yüklenene kadar azıcık bekle
                            if door:FindFirstChild("Open") then -- Kapı açıldıysa
                                teleportTo(target.CFrame * CFrame.new(0, 0, -15))
                            else
                                task.wait(0.1) -- Açılmasını bekle
                                teleportTo(target.CFrame * CFrame.new(0, 0, -15))
                            end
                        end
                    end
                end
            else
                updateStatus("...")
            end
        end
    end
end)

-- Canavar Koruması
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
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.Position) * CFrame.Angles(math.rad(-90), 0, 0)
    end
end)

game:GetService("Lighting").Brightness = 2
