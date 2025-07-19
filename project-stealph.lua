-- Advanced Mobile Roleplay Spy v3.0 - Delta/Hydrogen Compatible
-- Specialized for money tracking, salary monitoring and script generation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Mobile-friendly storage (NO localStorage)
local spyData = {
    remoteEvents = {},
    remoteFunctions = {},
    moneyTransfers = {},
    salaryLogs = {},
    chatLogs = {},
    playerActions = {},
    gameValues = {},
    scriptTemplates = {}
}

-- Money detection patterns
local moneyPatterns = {
    "money", "cash", "dinheiro", "grana", "coins", "moedas",
    "salary", "salario", "wage", "pagamento", "payment",
    "bank", "banco", "conta", "account", "balance", "saldo",
    "transfer", "transferir", "send", "enviar", "give", "dar",
    "buy", "comprar", "sell", "vender", "price", "preco"
}

local jobPatterns = {
    "job", "work", "emprego", "trabalho", "profissao",
    "police", "policia", "medic", "medico", "taxi",
    "delivery", "entrega", "mechanic", "mecanico"
}

-- Mobile-optimized GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileRoleplaySpy"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Mobile optimized)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 150)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💰 MOBILE MONEY SPY"
titleLabel.TextColor3 = Color3.black
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Toggle Button (Mobile friendly)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -80, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "💰\nSPY"
toggleButton.TextColor3 = Color3.white
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.white
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 17)
closeCorner.Parent = closeButton

-- Tab System (Mobile optimized)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 40)
tabFrame.Position = UDim2.new(0, 5, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"💰Money", "💼Jobs", "📜Scripts", "⚙️Config"}
local tabButtons = {}
local contentFrames = {}

-- Create mobile-friendly tabs
for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.25, -2, 1, 0)
    tabButton.Position = UDim2.new(0.25 * (i-1), 2, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.white
    tabButton.TextSize = 10
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    tabButtons[tabName] = tabButton
    
    -- Content Frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, -10, 1, -100)
    contentFrame.Position = UDim2.new(0, 5, 0, 95)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.Visible = false
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame
    
    contentFrames[tabName] = contentFrame
end

-- Show first tab
contentFrames["💰Money"].Visible = true
tabButtons["💰Money"].BackgroundColor3 = Color3.fromRGB(0, 200, 100)

-- Tab switching
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        for name, frame in pairs(contentFrames) do
            frame.Visible = false
            tabButtons[name].BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        end
        contentFrames[tabName].Visible = true
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end)
end

-- Toggle functionality
local function toggleGui()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end
end

toggleButton.MouseButton1Click:Connect(toggleGui)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
end)

-- Mobile touch support for hotkey
if UserInputService.TouchEnabled then
    local doubleTapTime = 0
    UserInputService.TouchTap:Connect(function(touchPositions, processed)
        if not processed and #touchPositions == 2 then
            local currentTime = tick()
            if currentTime - doubleTapTime < 0.5 then
                toggleGui()
            end
            doubleTapTime = currentTime
        end
    end)
end

-- Utility Functions
local function addLog(contentFrame, text, color, isImportant)
    local logFrame = Instance.new("Frame")
    logFrame.Size = UDim2.new(1, -5, 0, isImportant and 35 or 25)
    logFrame.Position = UDim2.new(0, 2, 0, #contentFrame:GetChildren() * (isImportant and 37 or 27))
    logFrame.BackgroundColor3 = isImportant and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(20, 20, 25)
    logFrame.BorderSizePixel = 0
    logFrame.Parent = contentFrame
    
    if isImportant then
        local logCorner = Instance.new("UICorner")
        logCorner.CornerRadius = UDim.new(0, 4)
        logCorner.Parent = logFrame
    end
    
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, -10, 1, 0)
    logLabel.Position = UDim2.new(0, 5, 0, 0)
    logLabel.BackgroundTransparency = 1
    logLabel.Text = text
    logLabel.TextColor3 = color or Color3.white
    logLabel.TextSize = isImportant and 11 or 9
    logLabel.Font = isImportant and Enum.Font.GothamBold or Enum.Font.Code
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.TextYAlignment = Enum.TextYAlignment.Top
    logLabel.TextWrapped = true
    logLabel.Parent = logFrame
    
    -- Copy button for important logs
    if isImportant then
        local copyButton = Instance.new("TextButton")
        copyButton.Size = UDim2.new(0, 40, 0, 20)
        copyButton.Position = UDim2.new(1, -45, 0, 2)
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        copyButton.BorderSizePixel = 0
        copyButton.Text = "📋"
        copyButton.TextColor3 = Color3.white
        copyButton.TextSize = 12
        copyButton.Font = Enum.Font.Gotham
        copyButton.Parent = logFrame
        
        local copyCorner = Instance.new("UICorner")
        copyCorner.CornerRadius = UDim.new(0, 10)
        copyCorner.Parent = copyButton
        
        copyButton.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(text)
                copyButton.Text = "✓"
                wait(1)
                copyButton.Text = "📋"
            end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * (isImportant and 37 or 27))
    contentFrame.CanvasPosition = Vector2.new(0, contentFrame.CanvasSize.Y.Offset)
end

-- Enhanced money detection
local function containsMoneyKeyword(text)
    if type(text) ~= "string" then
        text = tostring(text)
    end
    text = text:lower()
    
    for _, pattern in pairs(moneyPatterns) do
        if text:find(pattern) then
            return true, pattern
        end
    end
    return false
end

local function containsJobKeyword(text)
    if type(text) ~= "string" then
        text = tostring(text)
    end
    text = text:lower()
    
    for _, pattern in pairs(jobPatterns) do
        if text:find(pattern) then
            return true, pattern
        end
    end
    return false
end

-- Advanced argument analysis
local function analyzeArgs(args)
    local result = {}
    local hasNumber = false
    local hasMoneyKeyword = false
    local moneyValue = nil
    
    for i, arg in ipairs(args) do
        local argStr = tostring(arg)
        
        -- Check for numbers (potential money values)
        if type(arg) == "number" and arg > 0 then
            hasNumber = true
            if arg >= 10 then -- Minimum reasonable money amount
                moneyValue = arg
            end
        end
        
        -- Check for money keywords
        local isMoney, keyword = containsMoneyKeyword(argStr)
        if isMoney then
            hasMoneyKeyword = true
        end
        
        if type(arg) == "string" then
            table.insert(result, '"' .. argStr .. '"')
        else
            table.insert(result, argStr)
        end
    end
    
    return table.concat(result, ", "), hasNumber, hasMoneyKeyword, moneyValue
end

-- Remote monitoring with enhanced money detection
local function hookRemoteEvent(remote)
    if spyData.remoteEvents[remote.Name] then return end
    spyData.remoteEvents[remote.Name] = true
    
    local connection = remote.OnClientEvent:Connect(function(...)
        local args = {...}
        local argsStr, hasNumber, hasMoneyKeyword, moneyValue = analyzeArgs(args)
        
        -- Check remote name for money patterns
        local remoteMoney, remoteKeyword = containsMoneyKeyword(remote.Name)
        
        if hasMoneyKeyword or remoteMoney or (hasNumber and moneyValue and moneyValue >= 10) then
            local logText = string.format("💰 [%s] %s | Args: %s", 
                os.date("%X"), remote.Name, argsStr)
            
            addLog(contentFrames["💰Money"], logText, Color3.fromRGB(100, 255, 100), true)
            
            -- Store for script generation
            table.insert(spyData.moneyTransfers, {
                remoteName = remote.Name,
                args = args,
                timestamp = os.time(),
                value = moneyValue
            })
            
            -- Auto-generate script template
            local scriptTemplate = string.format([[
-- Money Remote: %s
-- Args: %s
-- Value detected: %s
game:GetService("ReplicatedStorage"):FindFirstChild("%s"):FireServer(%s)
]], remote.Name, argsStr, moneyValue or "unknown", remote.Name, argsStr)
            
            table.insert(spyData.scriptTemplates, scriptTemplate)
        end
        
        -- Check for job-related remotes
        local isJob, jobKeyword = containsJobKeyword(remote.Name)
        if isJob or containsJobKeyword(argsStr) then
            local logText = string.format("💼 [%s] %s | Args: %s", 
                os.date("%X"), remote.Name, argsStr)
            
            addLog(contentFrames["💼Jobs"], logText, Color3.fromRGB(255, 200, 100), true)
        end
    end)
end

local function hookRemoteFunction(remote)
    if spyData.remoteFunctions[remote.Name] then return end
    spyData.remoteFunctions[remote.Name] = true
    
    local originalInvoke = remote.OnClientInvoke
    remote.OnClientInvoke = function(...)
        local args = {...}
        local argsStr, hasNumber, hasMoneyKeyword, moneyValue = analyzeArgs(args)
        
        local remoteMoney = containsMoneyKeyword(remote.Name)
        
        if hasMoneyKeyword or remoteMoney then
            local logText = string.format("💰 [%s] FUNC: %s | Args: %s", 
                os.date("%X"), remote.Name, argsStr)
            
            addLog(contentFrames["💰Money"], logText, Color3.fromRGB(255, 255, 100), true)
        end
        
        if originalInvoke then
            return originalInvoke(...)
        end
    end
end

-- Scan for remotes
local function scanRemotes(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("RemoteEvent") then
            spawn(function() hookRemoteEvent(child) end)
        elseif child:IsA("RemoteFunction") then
            spawn(function() hookRemoteFunction(child) end)
        end
        
        if child:IsA("Folder") or child:IsA("Model") then
            spawn(function() scanRemotes(child) end)
        end
    end
end

-- Initial scan
scanRemotes(ReplicatedStorage)
scanRemotes(workspace)

-- Monitor new remotes
ReplicatedStorage.ChildAdded:Connect(function(child)
    wait(0.1)
    if child:IsA("RemoteEvent") then
        hookRemoteEvent(child)
    elseif child:IsA("RemoteFunction") then
        hookRemoteFunction(child)
    elseif child:IsA("Folder") then
        scanRemotes(child)
    end
end)

-- Player value monitoring (money in leaderstats)
local function monitorPlayerValues(plr)
    if plr.leaderstats then
        for _, stat in pairs(plr.leaderstats:GetChildren()) do
            if containsMoneyKeyword(stat.Name) then
                stat:GetPropertyChangedSignal("Value"):Connect(function()
                    local logText = string.format("💰 %s's %s changed to: %s", 
                        plr.Name, stat.Name, tostring(stat.Value))
                    addLog(contentFrames["💰Money"], logText, Color3.fromRGB(150, 200, 255))
                end)
            end
        end
    end
end

-- Monitor existing and new players
for _, plr in pairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function()
        wait(2)
        monitorPlayerValues(plr)
    end)
    if plr.Character then
        monitorPlayerValues(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(2)
        monitorPlayerValues(plr)
    end)
end)

-- Script generation in Scripts tab
local function generateScripts()
    local scriptsContent = contentFrames["📜Scripts"]
    
    -- Clear existing content
    for _, child in pairs(scriptsContent:GetChildren()) do
        child:Destroy()
    end
    
    -- Money spawn script
    local moneySpawnScript = [[-- Auto Money Spawner (Generated)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Detected money remotes:]]

    for _, transfer in pairs(spyData.moneyTransfers) do
        if transfer.value and transfer.value >= 100 then
            moneySpawnScript = moneySpawnScript .. string.format([[

-- %s (Value: %s)
spawn(function()
    while wait(1) do
        pcall(function()
            ReplicatedStorage:FindFirstChild("%s"):FireServer(%s)
        end)
    end
end)]], transfer.remoteName, transfer.value, transfer.remoteName, table.concat(transfer.args, ", "))
        end
    end
    
    addLog(scriptsContent, moneySpawnScript, Color3.fromRGB(100, 255, 200), true)
    
    -- Salary collector script
    local salaryScript = [[-- Auto Salary Collector
local ReplicatedStorage = game:GetService("ReplicatedStorage")

spawn(function()
    while wait(60) do -- Every minute
        for _, remote in pairs(ReplicatedStorage:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("salary") or name:find("salario") or name:find("wage") then
                    pcall(function()
                        remote:FireServer()
                    end)
                end
            end
        end
    end
end)]]
    
    addLog(scriptsContent, salaryScript, Color3.fromRGB(255, 200, 100), true)
end

-- Config tab
local configContent = contentFrames["⚙️Config"]

local function createConfigButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, #configContent:GetChildren() * 40)
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.white
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = configContent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    configContent.CanvasSize = UDim2.new(0, 0, 0, #configContent:GetChildren() * 40)
end

-- Add config buttons
createConfigButton("🔄 Generate Money Scripts", generateScripts)
createConfigButton("📋 Copy All Money Logs", function()
    local allLogs = ""
    for _, transfer in pairs(spyData.moneyTransfers) do
        allLogs = allLogs .. string.format("%s: %s\n", transfer.remoteName, table.concat(transfer.args, ", "))
    end
    if setclipboard then
        setclipboard(allLogs)
    end
end)
createConfigButton("🗑️ Clear All Logs", function()
    for _, frame in pairs(contentFrames) do
        for _, child in pairs(frame:GetChildren()) do
            child:Destroy()
        end
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    end
    spyData.moneyTransfers = {}
    spyData.scriptTemplates = {}
end)

-- Make draggable (mobile friendly)
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Auto-notification system
local function showNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 3;
        })
    end)
end

-- In
