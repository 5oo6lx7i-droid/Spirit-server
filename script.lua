-- ============================================================
-- KVN Whitelist System v2.0
-- Discord: https://discord.gg/8wWxAnJMN
-- ============================================================
-- نظام التحقق: يقرأ الأسماء من GitHub
-- إذا اسمك موجود → السكربت يشتغل
-- إذا مو موجود → واجهة "أنت ليس مفعل"
-- ============================================================

local WHITELIST_URL = "https://raw.githubusercontent.com/5oo6lx7i-droid/Spirit-server/main/whitelist.txt"
local DISCORD_INVITE = "https://discord.gg/8wWxAnJMN"

-- ============================================================
-- جلب قائمة الأسماء من GitHub
-- ============================================================
local function fetchAllowedUsers()
    local ok, response = pcall(function()
        return game:HttpGet(WHITELIST_URL .. "?t=" .. tostring(os.time()))
    end)
    if not ok or not response then
        return {}, "تعذر الاتصال بالسيرفر"
    end
    local users = {}
    for line in response:gmatch("[^\r\n]+") do
        local name = line:match("^%s*(.-)%s*$")
        if name and #name > 0 and not name:match("^#") then
            users[#users + 1] = name
        end
    end
    return users, nil
end

-- ============================================================
-- المتغيرات الأساسية
-- ============================================================
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local allowed, fetchErr = fetchAllowedUsers()
local myName = lp.Name

-- ============================================================
-- التحقق من المستخدم
-- ============================================================
local isAllowed = false
for _, name in ipairs(allowed) do
    if name == myName then
        isAllowed = true
        break
    end
end

-- ============================================================
-- إذا مو موجود → واجهة كبيرة "أنت ليس مفعل"
-- ============================================================
if not isAllowed then
    local parent = CoreGui
    pcall(function() if gethui then parent = gethui() end end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KVNBlocked"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 420)
    frame.Position = UDim2.new(0.5, -250, 0.5, -210)
    frame.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(220, 38, 38)
    stroke.Thickness = 3
    stroke.Parent = frame

    local icon = Instance.new("TextLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(1, 0, 0, 100)
    icon.Position = UDim2.new(0, 0, 0, 20)
    icon.Font = Enum.Font.GothamBlack
    icon.TextSize = 80
    icon.TextColor3 = Color3.fromRGB(220, 38, 38)
    icon.Text = "⛔"
    icon.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 130)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "أنت ليس مفعل في السكربت"
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, -40, 0, 30)
    sub.Position = UDim2.new(0, 20, 0, 185)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 16
    sub.TextColor3 = Color3.fromRGB(148, 163, 184)
    sub.Text = "اسمك: " .. myName
    sub.Parent = frame

    if fetchErr then
        local errLabel = Instance.new("TextLabel")
        errLabel.BackgroundTransparency = 1
        errLabel.Size = UDim2.new(1, -40, 0, 20)
        errLabel.Position = UDim2.new(0, 20, 0, 215)
        errLabel.Font = Enum.Font.Gotham
        errLabel.TextSize = 12
        errLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        errLabel.Text = "⚠ " .. fetchErr
        errLabel.Parent = frame
    end

    local hint = Instance.new("TextLabel")
    hint.BackgroundTransparency = 1
    hint.Size = UDim2.new(1, -40, 0, 70)
    hint.Position = UDim2.new(0, 20, 0, 245)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 14
    hint.TextWrapped = true
    hint.TextColor3 = Color3.fromRGB(148, 163, 184)
    hint.Text = "تواصل معنا في الديسكورد عشان نضيف اسمك:\ndiscord.gg/8wWxAnJMN"
    hint.Parent = frame

    local dcBtn = Instance.new("TextButton")
    dcBtn.Size = UDim2.new(0, 200, 0, 40)
    dcBtn.Position = UDim2.new(0.5, -100, 0, 320)
    dcBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    dcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dcBtn.Font = Enum.Font.GothamBold
    dcBtn.TextSize = 16
    dcBtn.Text = "انضم للديسكورد"
    dcBtn.AutoButtonColor = false
    dcBtn.Parent = frame

    local dcCorner = Instance.new("UICorner")
    dcCorner.CornerRadius = UDim.new(0, 10)
    dcCorner.Parent = frame

    dcBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(DISCORD_INVITE) end
            if toclipboard then toclipboard(DISCORD_INVITE) end
        end)
        dcBtn.Text = "✅ تم نسخ الرابط"
        task.wait(1.5)
        dcBtn.Text = "انضم للديسكورد"
    end)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "KVN",
            Text = "أنت ليس مفعل في السكربت",
            Duration = 5
        })
    end)

    return
end

-- ============================================================
-- ✅ المستخدم مفعّل → نكمل
-- ============================================================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "KVN",
        Text = "✅ تم التحقق — مرحباً " .. myName,
        Duration = 3
    })
end)

print("═══════════════════════════════════════")
print("[KVN] ✅ مرحباً " .. myName)
print("[KVN] 🎯 جاري تشغيل السكربت...")
print("═══════════════════════════════════════")

-- ═══════════════════════════════════════════════════════════════
-- ⬇⬇⬇⬇⬇  السكربت الأصلي (Payload المشفّر)  ⬇⬇⬇⬇⬇
-- ═══════════════════════════════════════════════════════════════
-- 
-- 🎯 الصق هنا الجزء الثاني من ملفك الأصلي كامل
--    (يبدأ من: -- [ LuauShield Vercel Protected Delivery ... )
--    وينتهي عند: return UeynqU()
-- 
-- ═══════════════════════════════════════════════════════════════
-- ⬆⬆⬆⬆⬆  نهاية السكربت الأصلي  ⬆⬆⬆⬆⬆
-- ═══════════════════════════════════════════════════════════════
