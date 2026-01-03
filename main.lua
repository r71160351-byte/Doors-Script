-- DOORS AUTO-RUNNER & GOD MODE (STEALTH VERSION)
-- Kaynak: GitHub (mstudio45/MSVhub) üzerinden çekilmektedir.

-- AYARLAR (Çalıştırmadan önce bunlar aktif edilir)
_G.AutoSkip = true       -- Kapıları otomatik geçer.
_G.AutoLoot = true       -- Anahtarları ve önemli eşyaları toplar.
_G.AntiMonster = true    -- Rush/Ambush geldiğinde otomatik saklanır.
_G.Fullbright = true     -- Karanlığı tamamen kaldırır.

-- GITHUB YÜKLEYİCİ (Tek Seferde Hazırlanmıştır)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSVhub/main/Main.lua"))()
end)

-- NOT: Eğer MSVhub açılmazsa alternatif olarak aşağıdaki kararlı scripti kullanabilirsin:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/Source.lua"))()
