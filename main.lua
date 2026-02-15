local Players = game:GetService("Players") 
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

pcall(function()
    if game.CoreGui:FindFirstChild("TroyanovvHub") then
        game.CoreGui.TroyanovvHub:Destroy()
    end
    if game.CoreGui:FindFirstChild("TroyMiniButton") then
        game.CoreGui.TroyMiniButton:Destroy()
    end
end)

local connections = {}
local destroyed = false

local function connect(signal,func)
    local c = signal:Connect(func)
    table.insert(connections,c)
    return c
end

local function destroyScript()
    destroyed = true
    for _,c in pairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    if game.CoreGui:FindFirstChild("TroyanovvHub") then
        game.CoreGui.TroyanovvHub:Destroy()
    end
    if game.CoreGui:FindFirstChild("TroyMiniButton") then
        game.CoreGui.TroyMiniButton:Destroy()
    end
end

local gameName = "Unknown"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    gameName = info.Name
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TroyanovvHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(18,18,24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,38)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "Troyanovv Hub v1.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1,1,1)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0,32,0,32)
CloseBtn.Position = UDim2.new(1,-36,0,3)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(90,0,0)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0,32,0,32)
MinBtn.Position = UDim2.new(1,-72,0,3)
MinBtn.Text = "–"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.new(0,0,0,38)
Sidebar.Size = UDim2.new(0,140,1,-38)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,30)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,12)

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,140,0,38)
Content.Size = UDim2.new(1,-140,1,-38)
Content.BackgroundTransparency = 1

local function createTab(text,posY)
    local btn = Instance.new("TextButton",Sidebar)
    btn.Size = UDim2.new(1,-16,0,32)
    btn.Position = UDim2.new(0,8,0,posY)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
    return btn
end

local MainTab = createTab("Main",15)
local FuncTab = createTab("Functions",55)
local MiscTab = createTab("Misc",95)
local ContactTab = createTab("Contact",135)

local MainPage = Instance.new("Frame",Content)
MainPage.Size = UDim2.new(1,0,1,0)
MainPage.BackgroundTransparency = 1

local FuncPage = MainPage:Clone()
FuncPage.Parent = Content
FuncPage.Visible = false

local MiscPage = MainPage:Clone()
MiscPage.Parent = Content
MiscPage.Visible = false

local ContactPage = MainPage:Clone()
ContactPage.Parent = Content
ContactPage.Visible = false

local function switch(page)
    MainPage.Visible=false
    FuncPage.Visible=false
    MiscPage.Visible=false
    ContactPage.Visible=false
    page.Visible=true
end

connect(MainTab.MouseButton1Click,function() switch(MainPage) end)
connect(FuncTab.MouseButton1Click,function() switch(FuncPage) end)
connect(MiscTab.MouseButton1Click,function() switch(MiscPage) end)
connect(ContactTab.MouseButton1Click,function() switch(ContactPage) end)

local function createInfoLabel(parent,y,text)
    local l=Instance.new("TextLabel",parent)
    l.Size=UDim2.new(1,-20,0,22)
    l.Position=UDim2.new(0,10,0,y)
    l.BackgroundTransparency=1
    l.Font=Enum.Font.Gotham
    l.TextSize=13
    l.TextColor3=Color3.fromRGB(200,200,200)
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.Text=text
    return l
end

local GameLabel=createInfoLabel(MainPage,15,"Game: "..gameName)
local FPSLabel=createInfoLabel(MainPage,45,"FPS: 0")
local PingLabel=createInfoLabel(MainPage,75,"Ping: 0")
local TimeLabel=createInfoLabel(MainPage,105,"Uptime: 0")
local ModeLabel=createInfoLabel(MainPage,135,"Anti-Afk mode: Auto-Jump")

local function createToggle(parent,y,name,default,callback)
    local holder=Instance.new("Frame",parent)
    holder.Size=UDim2.new(1,-20,0,32)
    holder.Position=UDim2.new(0,10,0,y)
    holder.BackgroundColor3=Color3.fromRGB(28,28,36)
    Instance.new("UICorner",holder).CornerRadius=UDim.new(0,8)

    local label=Instance.new("TextLabel",holder)
    label.Size=UDim2.new(1,-60,1,0)
    label.Position=UDim2.new(0,8,0,0)
    label.BackgroundTransparency=1
    label.Text=name
    label.Font=Enum.Font.Gotham
    label.TextSize=13
    label.TextColor3=Color3.new(1,1,1)
    label.TextXAlignment=Enum.TextXAlignment.Left

    local toggle=Instance.new("Frame",holder)
    toggle.Size=UDim2.new(0,36,0,18)
    toggle.Position=UDim2.new(1,-44,0.5,-9)
    toggle.BackgroundColor3=default and Color3.fromRGB(80,0,160) or Color3.fromRGB(50,50,60)
    Instance.new("UICorner",toggle).CornerRadius=UDim.new(1,0)

    local circle=Instance.new("Frame",toggle)
    circle.Size=UDim2.new(0,16,0,16)
    circle.Position=default and UDim2.new(1,-17,0.5,-8) or UDim2.new(0,1,0.5,-8)
    circle.BackgroundColor3=Color3.new(1,1,1)
    Instance.new("UICorner",circle).CornerRadius=UDim.new(1,0)

    local state=default

    holder.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            state=not state
            TweenService:Create(circle,TweenInfo.new(0.15),{
                Position=state and UDim2.new(1,-17,0.5,-8) or UDim2.new(0,1,0.5,-8)
            }):Play()
            TweenService:Create(toggle,TweenInfo.new(0.15),{
                BackgroundColor3=state and Color3.fromRGB(80,0,160) or Color3.fromRGB(50,50,60)
            }):Play()
            callback(state)
        end
    end)
end

local autoJumpEnabled=true

createToggle(FuncPage,20,"Auto Jump every 10 sec",true,function(val)
    autoJumpEnabled=val
    ModeLabel.Text="Anti-Afk mode: "..(val and "Auto-Jump" or "Disabled")
end)

local keybind=Enum.KeyCode.RightShift
local waitingForKey=false

local KeybindButton=Instance.new("TextButton",MiscPage)
KeybindButton.Size=UDim2.new(1,-20,0,32)
KeybindButton.Position=UDim2.new(0,10,0,20)
KeybindButton.BackgroundColor3=Color3.fromRGB(28,28,36)
KeybindButton.Text="Menu Key: RightShift"
KeybindButton.Font=Enum.Font.Gotham
KeybindButton.TextSize=13
KeybindButton.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",KeybindButton).CornerRadius=UDim.new(0,8)

KeybindButton.MouseButton1Click:Connect(function()
    waitingForKey=true
    KeybindButton.Text="Press any key..."
end)

connect(UserInputService.InputBegan,function(input,gp)
    if gp or destroyed then return end

    if waitingForKey then
        if input.KeyCode~=Enum.KeyCode.Unknown then
            keybind=input.KeyCode
            KeybindButton.Text="Menu Key: "..input.KeyCode.Name
            waitingForKey=false
        end
        return
    end

    if input.KeyCode==keybind then
        Main.Visible=not Main.Visible
    end
end)

local Mini = Instance.new("TextButton")
Mini.Name = "TroyMiniButton"
Mini.Size = UDim2.new(0,42,0,42)
Mini.Position = UDim2.new(0,50,0,50)
Mini.BackgroundColor3 = Color3.fromRGB(60,0,130)
Mini.Text = "TH"
Mini.Font = Enum.Font.GothamBold
Mini.TextSize = 14
Mini.TextColor3 = Color3.new(1,1,1)
Mini.Parent = game.CoreGui
Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)
Mini.Visible = false

Mini.Active = true
Mini.Draggable = true
Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    destroyScript()
end)

local ContactText = Instance.new("TextLabel",ContactPage)
ContactText.Size = UDim2.new(1,-20,1,-60)
ContactText.Position = UDim2.new(0,10,0,10)
ContactText.BackgroundTransparency = 1
ContactText.TextWrapped = true
ContactText.TextYAlignment = Enum.TextYAlignment.Top
ContactText.Font = Enum.Font.Gotham
ContactText.TextSize = 14
ContactText.TextColor3 = Color3.fromRGB(210,210,210)
ContactText.Text = [[
contact & support / контакты и поддержка

EN:
if you encounter bugs, errors, or have suggestions for improvements,
feel free to reach out, feedback helps improve the project.

RU:
если вы столкнулись с багами, ошибками или хотите предложить
улучшения — свяжитесь со мной, ваш отзыв помогает развитию проекта.
]]

local TGBtn = Instance.new("TextButton",ContactPage)
TGBtn.Size = UDim2.new(0,32,0,32)
TGBtn.Position = UDim2.new(0,10,1,-40)
TGBtn.BackgroundColor3 = Color3.fromRGB(0,136,204)
TGBtn.Text = "T"
TGBtn.Font = Enum.Font.GothamBold
TGBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",TGBtn).CornerRadius = UDim.new(0,6)
TGBtn.MouseButton1Click:Connect(function()
    if syn and syn.request then
        syn.request({Url="https://t.me/troyanovv_exe", Method="GET"})
    end
    -- for most executors this will open link in browser:
    if setclipboard then setclipboard("https://t.me/troyanovv_exe") end
end)

local DCBtn = Instance.new("TextButton",ContactPage)
DCBtn.Size = UDim2.new(0,32,0,32)
DCBtn.Position = UDim2.new(0,52,1,-40)
DCBtn.BackgroundColor3 = Color3.fromRGB(114,137,218)
DCBtn.Text = "D"
DCBtn.Font = Enum.Font.GothamBold
DCBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",DCBtn).CornerRadius = UDim.new(0,6)
DCBtn.MouseButton1Click:Connect(function()
    if syn and syn.request then
        syn.request({Url="https://discord.gg/xyzxvx", Method="GET"})
    end
    if setclipboard then setclipboard("https://discord.gg/xyzxvx") end
end)

local fps=0
local frames=0
local last=tick()
local startTime=tick()

connect(RunService.RenderStepped,function()
    if destroyed then return end
    frames+=1
    if tick()-last>=1 then
        fps=frames
        frames=0
        last=tick()
    end
end)

connect(RunService.Heartbeat,function()
    if destroyed then return end
    local ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    local elapsed=math.floor(tick()-startTime)
    FPSLabel.Text="FPS: "..fps
    PingLabel.Text="Ping: "..ping.." ms"
    TimeLabel.Text="Uptime: "..elapsed.." s"
end)

local function setupCharacter(character)
    local humanoid=character:WaitForChild("Humanoid")
    while character.Parent and not destroyed do
        task.wait(10)
        if autoJumpEnabled and humanoid and humanoid.Health>0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

if player.Character then
    setupCharacter(player.Character)
end

connect(player.CharacterAdded,setupCharacter)
