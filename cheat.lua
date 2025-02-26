-- Settings -----------------------------------------------------------------------------------------------------
local toggleKey = Enum.KeyCode.RightBracket
local shutdownKey = nil
-----------------------------------------------------------------------------------------------------------------

-- Actuall code down here!!! ------------------------------------------------------------------------------------

-- Global Variables ---------------------------------------------------------------------------------------------
local plr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("StarterGui")
-----------------------------------------------------------------------------------------------------------------

local library
if RunService:IsStudio() then
	library = require(script:WaitForChild("ErisModularGuiV2"))
else
	library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Eri-Yoshimi/Eri-s-Modular-Gui/refs/heads/main/v2.lua'))()
end

local Style = {
	name = "Spiked script by Eri",
	size = UDim2.new(0, 400, 0, 400),
	primaryColor = Color3.new(1, 0.333333, 0),
	secondaryColor = Color3.new(1, 0.666667, 0),
	backgroundColor = Color3.new(0, 0, 0),
	draggable = true,
	centered = true,
	freemouse = true,
	maxPages = 2,
	barY = 20,
	startMinimized = false,
	toggleBind = toggleKey,
}

local window = library:Initialize(Style)

if shutdownKey ~= nil then
	game:GetService("UserInputService").InputBegan:Connect(function(key)
		if key.KeyCode == shutdownKey then
			window:Destroy()
		end
	end)
end

-----------------------------------------------------------------------------------------------------------------

local function removeCharAC(char)
	local ac1 = char:FindFirstChild("P")
	local ac2 = char:FindFirstChild("S")
	if ac1 then
		ac1:Destroy()
	end
	if ac2 then
		ac2:Destroy()
	end
end

removeCharAC(plr.Character or plr.CharacterAdded:Wait())
plr.CharacterAdded:Connect(function(char)
	removeCharAC(char)
end)

-----------------------------------------------------------------------------------------------------------------

local values = window:createNewModule("Value Changer")

local maxChargeToggle, chargesToggled = values:AddToggle("Set All Charges To Max")
maxChargeToggle.Activated:Connect(function()
	for i, v in plr:FindFirstChild("PlayerGui"):GetChildren() do
		if v:IsA("ScreenGui") and string.match(string.lower(v.Name), string.lower("Bar")) ~= nil then
			v.Enabled = not chargesToggled:GetState()
		end
	end
end)
RunService.Heartbeat:Connect(function()
	if chargesToggled:GetState() then
		for i, v in plr.Character:GetChildren() do
			if v:IsA("NumberValue") and string.match(string.lower(v.Name), string.lower("Charge")) ~= nil then
				if v:GetAttribute("MaxCharge") then
					v.Value = v:GetAttribute("MaxCharge")
				end
			end
		end
	end
end)

local infStamina, infStaminaToggled = values:AddToggle("Infinite Stamina")
RunService.Heartbeat:Connect(function()
	if infStaminaToggled:GetState() then
		local stamina = plr:FindFirstChild("PlayerScripts"):FindFirstChild("Stamina")
		if stamina then
			if stamina:GetAttribute("MaxStamina") then
				stamina.Value = stamina:GetAttribute("MaxStamina")
			end
		end
	end
end)

local diveLenghtSlider = values:AddSlider("Dive length", 1, 50)
diveLenghtSlider.OnValueChanged:Connect(function(value)
	plr:SetAttribute("DIVELENGTH", value)
end)
local floatSlider = values:AddSlider("Floatiness length", 1, 83.34)
floatSlider.OnValueChanged:Connect(function(value)
	plr:SetAttribute("FLOATINESS", value)
end)

local hipHeightToggle, hipHeightToggled = values:AddToggle("Hip Height Increase/Float")
hipHeightToggle.Activated:Connect(function()
	local hum = plr.Character:FindFirstChild("Humanoid")
	if hum then
		hum.HipHeight = hipHeightToggled:GetState() and 12 or 0
	end
end)

local remotes = window:createNewModule("Remotes")

local spikingToggle, spikingToggled = remotes:AddToggle("Constantly Spike")
local spikeEvent = game:GetService("ReplicatedStorage").Mechanics.Spike
RunService.Heartbeat:Connect(function()
	if spikingToggled:GetState() then
		spikeEvent:FireServer(plr:GetMouse().Hit.LookVector, 99999999999, "SPIKE")
	end
end)

local OPspikingToggle, OPspikingToggled = remotes:AddToggle("Constantly Spike (INSTANT/OP)")
local spikeEvent = game:GetService("ReplicatedStorage").Mechanics.Spike
RunService.Heartbeat:Connect(function()
	if OPspikingToggled:GetState() then
		spikeEvent:FireServer(plr:GetMouse().Hit.LookVector * 10, 99999999999, "SPIKE")
	end
end)

local misc = window:createNewModule("Misc")
local removeZones = misc:AddButton("Remove Court Zones")
removeZones.Activated:Connect(function()
	local courtA = workspace:FindFirstChild("COURT_A")
	if courtA then
		pcall(function()
			local t1Z = courtA:FindFirstChild("TEAM_1"):FindFirstChild("ZONE")
			if t1Z then
				t1Z:Destroy()
			end
		end)
		pcall(function()
			local t2Z = courtA:FindFirstChild("TEAM_2"):FindFirstChild("ZONE")
			if t2Z then
				t2Z:Destroy()
			end
		end)
		pcall(function()
			local walls = courtA:FindFirstChild("WALLS")
			if walls then
				walls:Destroy()
			end
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------

-- Credit Notification ------------------------------------------------------------------------------------------
CoreGui:SetCore("SendNotification", {
	Title = "No Big Deal Cheat Injected";
	Text = "Made by Eri";
	Duration = 5;
})
-----------------------------------------------------------------------------------------------------------------
