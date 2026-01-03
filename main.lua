-- TA DOORS HUB v9 (OPTIMIZED & STABLE)
-- ChatGPT'nin önerdiği performans ve hata düzeltmeleri uygulandı.

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
    Speed = 45
}

local CurrentStatus = "Hazır - v9 Stable"
local LoopRunning = true

-- --- SES SİSTEMİ (OPTIMIZE EDİLDİ) ---
-- Her seferinde yeni sound yaratmak yerine bir kere yaratıp kullanıyoruz.
local UI_Sound = Instance.new("Sound")
UI_Sound.SoundId = "rbxassetid://4590657391"
UI_Sound.Volume = 0.5
UI_Sound.Parent = workspace -- UI silinse bile ses çalışsın diye

local function playClick()
    UI_Sound:Play()
end

-- --- UI OLUŞTURMA ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TA_Doors_UI_v9"
if lp:WaitForChild("PlayerGui"):FindFirstChild("TA_Doors_UI_v9") then
    lp.PlayerGui.TA_Doors_UI_v9:Destroy()
end
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150) -- Stabilite Yeşili
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Parent = ScreenGui -- Parent kesin atandı

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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "🛡️ TA HUB v9 (STABLE) 🛡️"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 15
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = CurrentStatus
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- Buton Oluşturucu
local btnY = 60
local function createButton(text, settingName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, btnY)
    btn.BackgroundColor3 = _G.Settings[settingName] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.Activated:Connect(function()
        _G.Settings[settingName] = not _G.Settings[settingName]
        btn.BackgroundColor3 = _G.Settings[settingName] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        playClick()
    end)
    btnY = btnY + 40
end

createButton("AUTO RUN (BAŞLAT)", "AutoRun")
createButton("GOD MODE", "GodMode")
createButton("ESP", "ESP")
createButton("NOCLIP", "Noclip")

-- GİZLE BUTONU (AnchorPoint ile sabitlendi)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.5, 0, 1, -5) -- En alta sabitle
CloseBtn.AnchorPoint = Vector2.new(0.5, 1) -- Merkezden hizala
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "GİZLE"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)

-- MENÜ AÇMA BUTONU (Parent Fix)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 30)
OpenBtn.Position = UDim2.new(0.5, -30, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "MENU"
OpenBtn.TextColor3 = Color3.white
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui -- KESİN PARENT ATAMASI
Instance.new("UICorner", OpenBtn)
OpenBtn.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)


-- --- MOTOR KISMI (OPTIMIZED) ---

local function updateStatus(text)
    StatusLabel.Text = text
end

-- NOCLIP OPTİMİZASYONU
-- Her frame yerine sadece AutoRun açıksa ve gerekliyse çalışır.
-- GetDescendants yerine GetChildren kullanarak performansı artırıyoruz (R15 için yeterli).
RunService.Stepped:Connect(function()
    if _G.Settings.Noclip and lp.Character then
        -- Sadece BasePart olanları ve CanCollide açık olanları bul
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
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
    
    if distance < 15 then
        root.CFrame = CFrame.new(targetPos)
        return nil
    else
        local speed = _G.Settings.Speed
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        return tween
    end
end

local function getLatestRoom()
    local success, result = pcall(function()
        local rooms = Workspace:FindFirstChild("CurrentRooms") or Workspace:FindFirstChild("Rooms")
        if not rooms then return nil end
        local maxNum, target = -1, nil
        for _, rm in pairs(rooms:GetChildren()) do
            local n = tonumber(rm.Name)
            if n and n > maxNum then maxNum = n; target = rm end
        end
        return target
    end)
    if success then return result else return nil end
end

local function createESP(obj, color)
    if not _G.Settings.ESP or obj:FindFirstChild("ESP") then return end
    local hl = Instance.new("Highlight", obj)
    hl.Name = "ESP"; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
end

-- --- ANA DÖNGÜ (CPU DOSTU) ---
task.spawn(function()
    while LoopRunning do
        task.wait(0.05) -- CPU kullanımını düşürmek için küçük bekleme (Stabilite sağlar)
        
        local success, err = pcall(function()
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
                        updateStatus("BOSS ODASI: MANUEL")
                    else
                        updateStatus("HIZLI GİDİLİYOR: " .. room.Name)
                        local door = room:FindFirstChild("Door")
                        if door then
                            local target = door:FindFirstChild("Client") or door:FindFirstChild("Door") or door:FindFirstChild("Hinge")
                            
                            if target then
                                -- Anahtar (Prompt Kontrollü)
                                if room:FindFirstChild("Assets") and door:FindFirstChild("Lock") and not lp.Character:FindFirstChild("Key") then
                                    for _, v in pairs(room.Assets:GetDescendants()) do
                                        if v.Name == "KeyObtain" then
                                            teleportTo(v.CFrame)
                                            task.wait(0.05)
                                            local prompt = v:FindFirstChild("ModulePrompt")
                                            if prompt then fireproximityprompt(prompt) end -- Hata koruması
                                            task.wait(0.05)
                                            if lp.Backpack:FindFirstChild("Key") then lp.Character.Humanoid:EquipTool(lp.Backpack.Key) end
                                            break
                                        end
                                    end
                                end
                                
                                -- Kapıya Git
                                local t = teleportTo(target.CFrame)
                                if t then t.Completed:Wait() end
                                
                                -- Aç
                                for _, p in pairs(door:GetDescendants()) do
                                    if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                                end
                                
                                -- İçeri Işınlan
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
        
        if not success then
            warn("TA v9 Hata Yakalandı (Oyun durmadı):", err)
            task.wait(0.5) -- Hata durumunda biraz bekle ki spam yapmasın
        end
    end
end)

-- Canavar Koruması
Workspace.ChildAdded:Connect(function(v)
    if not _G.Settings.GodMode then return end
    local n = v.Name
    if n=="RushMoving" or n=="AmbushMoving" or n=="A60" or n=="A120" then
        _G.Settings.AutoRun = false
        updateStatus("⚠️ KORUMA MODU")
        local r = lp.Character.HumanoidRootPart
        local old = r.CFrame
        r.CFrame = old * CFrame.new(0, 80, 0); r.Anchored = true
        repeat task.wait(0.5) until not v.Parent
        r.Anchored = false; r.CFrame = old
        _G.Settings.AutoRun = true
    elseif n=="SeekMoving" then
        _G.Settings.AutoRun = false
        updateStatus("⚠️ SEEK - KOŞ!")
    elseif n=="Eyes" then
        -- Eyes için sadece yere bak, AutoRun açıksa kapat ki kafa karışmasın
        _G.Settings.AutoRun = false
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.Position) * CFrame.Angles(math.rad(-90), 0, 0)
    end
end)

game:GetService("Lighting").Brightness = 2
print("TA DOORS HUB v9 (STABLE) YÜKLENDİ")
