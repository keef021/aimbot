local VERSION = "v2.0.0"

-- Initialize settings if they don't exist
if not getgenv().AimbotSettings then
	getgenv().AimbotSettings = {
		TeamCheck = true,
		VisibleCheck = true,
		IgnoreTransparency = true,
		IgnoredTransparency = 0.5,
		RefreshRate = 10,
		Keybind = "MouseButton2",
		ToggleKey = "RightShift",
		MaximumDistance = 300,
		AlwaysActive = false,
		Aimbot = {
			Enabled = true,
			TargetPart = "Head",
			Use_mousemoverel = true,
			Strength = 100,
			AimType = "Hold",
			AimAtNearestPart = false
		},
		AimAssist = {
			Enabled = false,
			MinFov = 15,
			MaxFov = 80,
			DynamicFov = true,
			ShowFov = false,
			Strength = 55,
			SlowSensitivity = true,
			SlowFactor = 1.75,
			RequireMovement = true
		},
		FovCircle = {
			Enabled = true,
			Dynamic = true,
			Radius = 100,
			Transparency = 1,
			Color = Color3.fromRGB(255,255,255),
			NumSides = 64,
		},
		TriggerBot = {
			Enabled = false,
			Delay = 60,
			Spam = true,
			ClicksPerSecond = 10,
			UseKeybind = false,
		},
		Crosshair = {
			Enabled = false,
			Transparency = 1,
			TransparencyKeybind = 1,
			Color = Color3.fromRGB(255, 0, 0),
			RainbowColor = false,
			Length = 15,
			Thickness = 2,
			Offset = 0
		},
		Prediction = {
			Enabled = false,
			Strength = 2
		},
		Priority = {},
		Whitelisted = {},
		WhitelistFriends = true,
		Ignore = {},
		-- Mobile settings
		MobileEnabled = false,
		MobileButton = {
			Visible = true,
			Position = UDim2.new(0.8, 0, 0.5, 0),
			Size = UDim2.new(0, 50, 0, 50),
			Color = Color3.fromRGB(128, 0, 255),
			Transparency = 0.5
		}
	}
end

local ss = getgenv().AimbotSettings

-- Core services
local players = game:GetService("Players")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Constants
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
local GameId = game.GameId

-- Helper functions
local mousemoverel = mousemoverel
local mouse1press = mouse1press or mouse1down
local mouse1release = mouse1release or mouse1up
local Drawingnew = Drawing.new 
local Fonts = Drawing.Fonts
local tableinsert = table.insert
local WorldToViewportPoint = camera.WorldToViewportPoint
local CFramenew = CFrame.new
local Vector2new = Vector2.new 
local fromRGB = Color3.fromRGB
local fromHSV = Color3.fromHSV
local mathfloor = math.floor
local mathclamp = math.clamp
local mathhuge = math.huge
local lower = string.lower
local osclock = os.clock
local RaycastParamsnew = RaycastParams.new
local taskwait = task.wait
local taskspawn = task.spawn

-- Aimbot variables
local mouse = uis:GetMouseLocation()
local ads = false
local olddelta = uis.MouseDeltaSensitivity
local triggering = false
local mousedown = false
local Ignore = {camera}
local destroyed = false

-- Game-specific configurations
local gids = {
	['arsenal'] = 111958650,
	['pf'] = 113491250,
	['pft'] = 115272207,
	['pfu'] = 1256867479,
	['bb'] = 1168263273,
	['rp'] = 2162282815,
	['mm2'] = 66654135
}

-- Set up game-specific ignore lists
if GameId == 111958650 or GameId == 115797356 or GameId == 147332621 then -- arsenal, counter blox, typical colors 2
	ss.Ignore = {workspace.Ray_Ignore}
elseif GameId == 833423526 then -- strucid
	ss.Ignore = {workspace.IgnoreThese}
elseif GameId == 2162282815 then -- rush point
	ss.Ignore = {camera, player.Character, workspace.RaycastIgnore, workspace.DroppedWeapons, workspace.MapFolder.Map.Ramps, workspace.MapFolder.Map.Walls.MapWalls}
elseif workspace:FindFirstChild("Ignore") then
	tableinsert(ss.Ignore, workspace.Ignore)
elseif workspace:FindFirstChild("RaycastIgnore") then
	tableinsert(ss.Ignore, workspace.RaycastIgnore)
end

if UAIM then
	UAIM:Destroy()
end

-- PROJECT CHEATS UI Creation
local ProjectUI = {}

function ProjectUI:CreateUI()
	local UI = {}
	
	-- Create main UI framework
	local ProjectCheats = Instance.new("ScreenGui")
	if syn and syn.protect_gui then
		syn.protect_gui(ProjectCheats)
		ProjectCheats.Parent = CoreGui
	elseif gethui then
		ProjectCheats.Parent = gethui()
	else
		ProjectCheats.Parent = CoreGui
	end
	
	ProjectCheats.Name = "ProjectCheats"
	ProjectCheats.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ProjectCheats.ResetOnSpawn = false
	
	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 600, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = false
	MainFrame.Parent = ProjectCheats
	
	-- Create shadow effect
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 30, 1, 30)
	Shadow.Position = UDim2.new(0, -15, 0, -15)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
	Shadow.Parent = MainFrame
	
	-- Title bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame
	
	-- Logo
	local LogoContainer = Instance.new("Frame")
	LogoContainer.Name = "LogoContainer"
	LogoContainer.Size = UDim2.new(0, 30, 0, 30)
	LogoContainer.BackgroundTransparency = 1
	LogoContainer.Parent = TitleBar
	
	local Logo = Instance.new("ImageLabel")
	Logo.Name = "Logo"
	Logo.Size = UDim2.new(0, 20, 0, 20)
	Logo.Position = UDim2.new(0.5, -10, 0.5, -10)
	Logo.BackgroundTransparency = 1
	Logo.Image = "rbxassetid://13358366693" -- Placeholder network icon
	Logo.ImageColor3 = Color3.fromRGB(128, 0, 255)
	Logo.Parent = LogoContainer
	
	-- Title
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(0, 200, 1, 0)
	Title.Position = UDim2.new(0, 30, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.Text = "PROJECT CHEATS"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar
	
	-- Close button
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Position = UDim2.new(1, -30, 0, 0)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 16
	CloseButton.Parent = TitleBar
	
	-- Tab bar
	local TabBar = Instance.new("Frame")
	TabBar.Name = "TabBar"
	TabBar.Size = UDim2.new(1, 0, 0, 40)
	TabBar.Position = UDim2.new(0, 0, 0, 30)
	TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	TabBar.BorderSizePixel = 0
	TabBar.Parent = MainFrame
	
	-- Tab container
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(1, 0, 1, -70)
	TabContainer.Position = UDim2.new(0, 0, 0, 70)
	TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame
	
	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 150, 1, 0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = TabContainer
	
	-- Content area
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -150, 1, 0)
	ContentArea.Position = UDim2.new(0, 150, 0, 0)
	ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	ContentArea.BorderSizePixel = 0
	ContentArea.Parent = TabContainer
	
	-- Version label
	local VersionLabel = Instance.new("TextLabel")
	VersionLabel.Name = "VersionLabel"
	VersionLabel.Size = UDim2.new(0, 60, 0, 20)
	VersionLabel.Position = UDim2.new(1, -65, 1, -25)
	VersionLabel.BackgroundTransparency = 1
	VersionLabel.Font = Enum.Font.Gotham
	VersionLabel.Text = VERSION
	VersionLabel.TextColor3 = Color3.fromRGB(128, 128, 128)
	VersionLabel.TextSize = 14
	VersionLabel.Parent = MainFrame
	
	-- Set up tabs
	local tabs = {}
	local tabButtons = {}
	local activeTab = nil
	
	local function createTab(name, iconId)
		-- Create tab button
		local tabButton = Instance.new("TextButton")
		tabButton.Name = name.."Tab"
		tabButton.Size = UDim2.new(0, 100, 1, 0)
		tabButton.BackgroundTransparency = 1
		tabButton.Font = Enum.Font.GothamSemibold
		tabButton.Text = name
		tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		tabButton.TextSize = 14
		tabButton.Parent = TabBar
		
		-- Position the tab button
		local tabCount = #tabButtons
		tabButton.Position = UDim2.new(0, 100 * tabCount, 0, 0)
		
		-- Indicator for active tab
		local indicator = Instance.new("Frame")
		indicator.Name = "Indicator"
		indicator.Size = UDim2.new(1, 0, 0, 2)
		indicator.Position = UDim2.new(0, 0, 1, -2)
		indicator.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		indicator.Parent = tabButton
		
		-- Create tab content
		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Name = name.."Content"
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 1
		tabContent.BorderSizePixel = 0
		tabContent.ScrollBarThickness = 4
		tabContent.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
		tabContent.Visible = false
		tabContent.Parent = ContentArea
		
		-- Set up auto layout for tab content
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 10)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Parent = tabContent
		
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 15)
		padding.PaddingLeft = UDim.new(0, 15)
		padding.PaddingRight = UDim.new(0, 15)
		padding.PaddingBottom = UDim.new(0, 15)
		padding.Parent = tabContent
		
		-- Create element functions for this tab
		local tab = {
			button = tabButton,
			content = tabContent,
			name = name
		}
		
		-- Add to tab registry
		table.insert(tabs, tab)
		table.insert(tabButtons, tabButton)
		
		-- Set up click event
		tabButton.MouseButton1Click:Connect(function()
			UI:SetActiveTab(name)
		end)
		
		-- Return tab object
		return tab
	end
	
	function UI:SetActiveTab(name)
		for _, tab in pairs(tabs) do
			if tab.name == name then
				tab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
				tab.button.Indicator.Visible = true
				tab.content.Visible = true
				activeTab = tab
			else
				tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
				tab.button.Indicator.Visible = false
				tab.content.Visible = false
			end
		end
	end
	
	-- Function to create a section in a tab
	function UI:CreateSection(tab, name)
		local section = {}
		
		-- Create section container
		local sectionFrame = Instance.new("Frame")
		sectionFrame.Name = name.."Section"
		sectionFrame.Size = UDim2.new(1, -20, 0, 30) -- Will be resized automatically
		sectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		sectionFrame.BorderSizePixel = 0
		section.frame = sectionFrame
		
		-- Create section title
		local sectionTitle = Instance.new("TextLabel")
		sectionTitle.Name = "Title"
		sectionTitle.Size = UDim2.new(1, 0, 0, 30)
		sectionTitle.BackgroundTransparency = 1
		sectionTitle.Font = Enum.Font.GothamSemibold
		sectionTitle.Text = name
		sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		sectionTitle.TextSize = 14
		sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
		sectionTitle.Parent = sectionFrame
		
		-- Add padding
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 10)
		padding.PaddingRight = UDim.new(0, 10)
		padding.Parent = sectionTitle
		
		-- Create content container
		local contentFrame = Instance.new("Frame")
		contentFrame.Name = "Content"
		contentFrame.Size = UDim2.new(1, 0, 1, -30)
		contentFrame.Position = UDim2.new(0, 0, 0, 30)
		contentFrame.BackgroundTransparency = 1
		contentFrame.Parent = sectionFrame
		
		-- Setup layout for content
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Parent = contentFrame
		
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 5)
		padding.PaddingBottom = UDim.new(0, 10)
		padding.PaddingLeft = UDim.new(0, 10)
		padding.PaddingRight = UDim.new(0, 10)
		padding.Parent = contentFrame
		
		-- Add to tab
		sectionFrame.Parent = tab.content
		
		-- Function to update section height based on content
		function section:UpdateHeight()
			local contentSize = layout.AbsoluteContentSize
			contentFrame.Size = UDim2.new(1, 0, 0, contentSize.Y + 15)
			sectionFrame.Size = UDim2.new(1, -20, 0, contentSize.Y + 45)
		end
		
		-- Functions to add elements
		function section:AddToggle(name, callback, default)
			local toggle = {}
			local state = default or false
			
			-- Create toggle frame
			local toggleFrame = Instance.new("Frame")
			toggleFrame.Name = name.."Toggle"
			toggleFrame.Size = UDim2.new(1, 0, 0, 30)
			toggleFrame.BackgroundTransparency = 1
			toggleFrame.Parent = contentFrame
			
			-- Create label
			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.Size = UDim2.new(1, -50, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.Text = name
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = toggleFrame
			
			-- Create toggle button
			local toggleButton = Instance.new("Frame")
			toggleButton.Name = "ToggleButton"
			toggleButton.Size = UDim2.new(0, 40, 0, 20)
			toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
			toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			toggleButton.BorderSizePixel = 0
			toggleButton.Parent = toggleFrame
			
			-- Create toggle indicator
			local indicator = Instance.new("Frame")
			indicator.Name = "Indicator"
			indicator.Size = UDim2.new(0, 16, 0, 16)
			indicator.Position = UDim2.new(0, 2, 0.5, -8)
			indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			indicator.BorderSizePixel = 0
			indicator.Parent = toggleButton
			
			-- Create hit detection
			local hitBox = Instance.new("TextButton")
			hitBox.Name = "HitBox"
			hitBox.Size = UDim2.new(1, 0, 1, 0)
			hitBox.BackgroundTransparency = 1
			hitBox.Text = ""
			hitBox.Parent = toggleFrame
			
			-- Set initial state
			if state then
				toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
				indicator.Position = UDim2.new(1, -18, 0.5, -8)
			end
			
			-- Toggle function
			function toggle:Set(value)
				state = value
				if state then
					toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
					TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
				else
					toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
					TweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
				end
				if callback then callback(state) end
			end
			
			-- Click handler
			hitBox.MouseButton1Click:Connect(function()
				toggle:Set(not state)
			end)
			
			-- Set initial state
			toggle:Set(state)
			
			section:UpdateHeight()
			return toggle
		end
		
		function section:AddSlider(name, min, max, default, callback)
			local slider = {}
			local value = default or min
			
			-- Create slider frame
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Name = name.."Slider"
			sliderFrame.Size = UDim2.new(1, 0, 0, 50)
			sliderFrame.BackgroundTransparency = 1
			sliderFrame.Parent = contentFrame
			
			-- Create label
			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.Size = UDim2.new(1, -50, 0, 20)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.Text = name
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = sliderFrame
			
			-- Create value label
			local valueLabel = Instance.new("TextLabel")
			valueLabel.Name = "ValueLabel"
			valueLabel.Size = UDim2.new(0, 40, 0, 20)
			valueLabel.Position = UDim2.new(1, -40, 0, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Font = Enum.Font.Gotham
			valueLabel.Text = tostring(value)
			valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			valueLabel.TextSize = 14
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Parent = sliderFrame
			
			-- Create slider bar background
			local sliderBg = Instance.new("Frame")
			sliderBg.Name = "SliderBg"
			sliderBg.Size = UDim2.new(1, 0, 0, 6)
			sliderBg.Position = UDim2.new(0, 0, 0.5, 5)
			sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			sliderBg.BorderSizePixel = 0
			sliderBg.Parent = sliderFrame
			
			-- Create slider fill
			local sliderFill = Instance.new("Frame")
			sliderFill.Name = "SliderFill"
			sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			sliderFill.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
			sliderFill.BorderSizePixel = 0
			sliderFill.Parent = sliderBg
			
			-- Create slider knob
			local sliderKnob = Instance.new("Frame")
			sliderKnob.Name = "SliderKnob"
			sliderKnob.Size = UDim2.new(0, 10, 0, 16)
			sliderKnob.Position = UDim2.new((value - min) / (max - min), -5, 0.5, -8)
			sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sliderKnob.BorderSizePixel = 0
			sliderKnob.Parent = sliderBg
			
			-- Create hit detection
			local hitBox = Instance.new("TextButton")
			hitBox.Name = "HitBox"
			hitBox.Size = UDim2.new(1, 0, 1, 0)
			hitBox.BackgroundTransparency = 1
			hitBox.Text = ""
			hitBox.Parent = sliderBg
			
			-- Set value function
			function slider:Set(newValue)
				value = math.clamp(newValue, min, max)
				valueLabel.Text = tostring(math.floor(value * 10) / 10)
				
				local percent = (value - min) / (max - min)
				sliderFill.Size = UDim2.new(percent, 0, 1, 0)
				sliderKnob.Position = UDim2.new(percent, -5, 0.5, -8)
				
				if callback then callback(value) end
			end
			
			-- Drag functionality
			local dragging = false
			hitBox.MouseButton1Down:Connect(function()
				dragging = true
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = UserInputService:GetMouseLocation()
					local framePos = sliderBg.AbsolutePosition
					local frameSize = sliderBg.AbsoluteSize
					
					local relativeX = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
					local newValue = min + (relativeX * (max - min))
					
					slider:Set(newValue)
				end
			end)
			
			-- Set initial value
			slider:Set(value)
			
			section:UpdateHeight()
			return slider
		end
		
		function section:AddDropdown(name, options, default, callback)
			local dropdown = {}
			local selected = default or options[1] or ""
			local open = false
			
			-- Create dropdown frame
			local dropdownFrame = Instance.new("Frame")
			dropdownFrame.Name = name.."Dropdown"
			dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
			dropdownFrame.BackgroundTransparency = 1
			dropdownFrame.Parent = contentFrame
			
			-- Create label
			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.Size = UDim2.new(1, 0, 0, 20)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.Text = name
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = dropdownFrame
			
			-- Create dropdown button
			local dropdownButton = Instance.new("TextButton")
			dropdownButton.Name = "DropdownButton"
			dropdownButton.Size = UDim2.new(1, 0, 0, 30)
			dropdownButton.Position = UDim2.new(0, 0, 0, 20)
			dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			dropdownButton.BorderSizePixel = 0
			dropdownButton.Font = Enum.Font.Gotham
			dropdownButton.Text = ""
			dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropdownButton.TextSize = 14
			dropdownButton.Parent = dropdownFrame
			
			-- Create selected text
			local selectedText = Instance.new("TextLabel")
			selectedText.Name = "SelectedText"
			selectedText.Size = UDim2.new(1, -30, 1, 0)
			selectedText.BackgroundTransparency = 1
			selectedText.Font = Enum.Font.Gotham
			selectedText.Text = selected
			selectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
			selectedText.TextSize = 14
			selectedText.TextXAlignment = Enum.TextXAlignment.Left
			selectedText.Parent = dropdownButton
