-- TA DOORS "GOD SPEED" (NO UI - DIRECT TELEPORT LOGIC)
-- Menü yok. Sadece hız ve bitiriş var.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

-- --- AYARLAR (BYPASS İÇİN) ---
_G.Active = true
_G.Speed = 0.1 -- Tween süresi (Işınlanma gibi ama yumuşak)

-- 1. FİZİK MOTORUNU KAPAT (NOCLIP & ANTICHEAT BYPASS)
-- Karakterin fiziğini kapatıyoruz ki oyun "bu adam duvardan geçti" diye ağlamasın.
RunService.Stepped:Connect(function()
    if _G.Active and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        -- Yerçekimini de kapatalım ki düşme
        if lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- 2. IŞIKLARI YAK (Görmen için)
local L = game:GetService("Lighting")
L.Brightness = 2
L.ClockTime = 14
L.FogEnd = 100000

-- 3. HAREKET FONKSİYONU (BYPASSLI)
local function InstantTP(targetCFrame)
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Oyunu kandırmak için CFrame'i direkt atamak yerine Pivot kullanıyoruz
    -- ve çok hızlı bir Tween yapıyoruz.
    local info = TweenInfo.new(_G.Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, info, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- 4. ANAHTAR ALMA MOTORU
local function getKey(room)
    local assets = room:FindFirstChild("Assets")
    if assets then
        for _, v in pairs(assets:GetDescendants()) do
            if v.Name == "KeyObtain" then
                InstantTP(v.CFrame)
                task.wait(0.1)
                fireproximityprompt(v:FindFirstChild("ModulePrompt"))
                task.wait(0.1)
                return true
            end
        end
    end
    return false
end

-- 5. CANAVAR SİLİCİ (ENTITY REMOVER)
-- Rush, Ambush falan gelirse direkt siliyoruz. Uğraşmak yok.
Workspace.ChildAdded:Connect(function(v)
    if not _G.Active then return end
    local n = v.Name
    if n == "RushMoving" or n == "AmbushMoving" or n == "A60" or n == "A120" then
        -- Client tarafında sil, bize zarar veremesin
        v:Destroy()
    elseif n == "Eyes" then
        v:Destroy()
    elseif n == "SeekMoving" then
        -- Seek gelirse silinmez ama biz ondan hızlıyız
        print("Seek Geldi, Gazlıyoruz!")
    end
end)

-- 6. ANA DÖNGÜ (SPEEDRUN)
task.spawn(function()
    print("GOD SPEED AKTİF - TUTUN!")
    
    while _G.Active do
        task.wait() -- Mümkün olan en kısa bekleme
        
        -- En son odayı bul
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local maxRoom = -1
            local targetRoom = nil
            
            for _, r in pairs(rooms:GetChildren()) do
                local n = tonumber(r.Name)
                if n and n > maxRoom then
                    maxRoom = n
                    targetRoom = r
                end
            end
            
            if targetRoom then
                -- ODA 50 (KÜTÜPHANE) GEÇİŞİ
                if targetRoom.Name == "50" then
                     -- Oda 50'deysen kapıya git
                     local door = targetRoom:FindFirstChild("Door")
                     if door then
                        InstantTP(door:GetPivot())
                     end
                     -- Burayı manuel geçmen gerekebilir çünkü şifre var
                
                -- ODA 100 (SON)
                elseif targetRoom.Name == "100" then
                    print("SONA GELDİK!")
                    _G.Active = false -- Scripti durdur
                
                -- NORMAL ODALAR
                else
                    local door = targetRoom:FindFirstChild("Door")
                    if door then
                        local client = door:FindFirstChild("Client") or door:FindFirstChild("Door")
                        if client then
                            -- Kilitli mi?
                            if targetRoom:FindFirstChild("Assets") and door:FindFirstChild("Lock") then
                                -- Anahtarın yoksa git al
                                if not lp.Character:FindFirstChild("Key") then
                                    getKey(targetRoom)
                                    -- Eline al
                                    if lp.Backpack:FindFirstChild("Key") then
                                        lp.Character.Humanoid:EquipTool(lp.Backpack.Key)
                                    end
                                end
                            end
                            
                            -- Kapıya Git
                            InstantTP(client.CFrame)
                            
                            -- Aç
                            for _, p in pairs(door:GetDescendants()) do
                                if p:IsA("ProximityPrompt") then
                                    fireproximityprompt(p)
                                end
                            end
                            
                            -- Kapı açılınca ileri atıl (Oda yüklenmesi için)
                            if door:FindFirstChild("Open") then
                                InstantTP(client.CFrame * CFrame.new(0, 0, -20))
                            end
                        end
                    end
                end
            end
        end
    end
end)
