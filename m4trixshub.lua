repeat wait() until game:IsLoaded()

-- LIBRARY SOURCE

local colors = {
    SchemeColor = Color3.fromRGB(229, 175, 0),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(77, 77, 77)
}
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("m4trix Hub", colors)

-- SEARCH FOR ALL EGGS
local worldsParent = game.Workspace.Worlds -- Replace 'Workspace' with the appropriate parent where your "Worlds" parent is located

local function listItemsWithKeyword(parent, keyword, excludedItem)
    local itemsWithKeyword = {}
    
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant:IsA("Instance") and string.find(string.lower(descendant.Name), string.lower(keyword), 1, true) then
            if descendant.Name ~= excludedItem then
                table.insert(itemsWithKeyword, descendant.Name) -- Store the name as a string
            end
        end
    end
    
    return itemsWithKeyword
end

local keyword = "Egg" -- Change this to the desired keyword you're looking for
local excludedItem = "JJBAStoneOceanEgg" -- The item you want to exclude from the results
local eggs = listItemsWithKeyword(worldsParent, keyword, excludedItem)

-- Now 'itemsWithKeyword' is a list (table) containing the names of the items with the keyword "Egg" but excluding "JJBAStoneOceanEgg".

-- FUNCTIONS
function maxOpen()
	spawn(function()
		while getgenv().maxOpen do
			local A_1 = eggSelected
		    local Event = game:GetService("ReplicatedStorage").Remote.AttemptMultiOpen
		    Event:FireServer(A_1) 
		    wait(0.6)
		end
	end)
end

function multiOpen()
    spawn(function()
        while getgenv().multiOpen do
            local currentWorld = game:GetService("Players").LocalPlayer.World.Value
            local A_1 = game:GetService("Workspace").Worlds[currentWorld][eggSelected]
            local A_2 = 13
            local Event = game:GetService("ReplicatedStorage").Remote.OpenEgg
            Event:InvokeServer(A_1, A_2)
            wait(1)
        end
    end)
end

function antiAFK()
    spawn(function()
        while getgenv().antiAFK do
            for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
                v:Disable()
            end
            wait(60)
        end
    end)
end

function magnetGP()
    spawn(function()
        while getgenv().magnetGP do
            wait(1)
            local workspace = game:GetService("Workspace")
            local player = game.Players.LocalPlayer
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local effects = workspace:FindFirstChild("Effects")
            if effects then
                for _, effect in ipairs(effects:GetChildren()) do
                    pcall(function()
                        effect.Base.CFrame = humanoidRootPart.CFrame
                    end)
                end
            end
    	end
	end)
end

function autoClickGP()
	spawn(function()
		while getgenv().autoClickGP do
            wait(0.025)
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("ClickerDamage"):FireServer()
		end
	end)
end

function sprintGP()
	spawn(function()
		while getgenv().sprintGP do
            wait(0.25)
            if game.Players.LocalPlayer.Character.Humanoid.WalkSpeed < 30 then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
            end
		end
	end)
end


function autoAttackGP()
    spawn(function()
        while getgenv().autoAttackGP do
			local currentWorld = game:GetService("Players").LocalPlayer.World.Value
			local enemyList = game:GetService("Workspace").Worlds[currentWorld].Enemies:GetChildren()
			local playerBody = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local distance
			local closestEnemy
			
			for _, enemy in ipairs(enemyList) do
				wait()
				distance = ((enemy.HumanoidRootPart.Position or enemy.PrimaryPart.Position) - playerBody.Position).magnitude
				if distance < 35 then
					closestEnemy = enemy
					break
				end
			end
			while closestEnemy and (distance < 35) do
				distance = ((closestEnemy.HumanoidRootPart.Position or closestEnemy.PrimaryPart.Position) - playerBody.Position).magnitude
				contador = 0
				if contador == 0 then
					print("Sending pets to attack", closestEnemy.Name)
				end
				
				local myPets = game:GetService("Players").LocalPlayer.Pets:GetChildren()

				for _, pet in ipairs(myPets) do
					if tostring(workspace:WaitForChild("Pets"):WaitForChild(pet.Name).Data.Owner.Value) == game:GetService("Players").LocalPlayer.Name then
						print('tentou atacar!')
						contador = contador + 1
						local args = {
							[1] = workspace:WaitForChild("Pets"):WaitForChild(pet.Name),
							[2] = workspace:WaitForChild("Worlds"):WaitForChild(currentWorld):WaitForChild("Enemies"):WaitForChild(closestEnemy.Name),
							[3] = contador
						}
						game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet"):FireServer(unpack(args))
						game:GetService("Workspace").Pets[pet.Name].Data.Attacking.Value = args[2]
					end
				end
				if not getgenv().autoAttackGP then
					for _, pet in ipairs(myPets) do
						if tostring(workspace:WaitForChild("Pets"):WaitForChild(pet.Name).Data.Owner.Value) == game:GetService("Players").LocalPlayer.Name then
							local args = {
								[1] = workspace:WaitForChild("Pets"):WaitForChild(pet.Name),
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet"):FireServer(unpack(args))
							game:GetService("Workspace").Pets[pet.Name].Data.Attacking.Value = nill
						end
					end
					break
				end
				wait() -- Adjust the delay before the next iteration
			end
		end
	end)
end


function dailySpin()
	spawn(function()
		while getgenv().dailySpin do
	            wait(10)
	            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("DailySpin"):FireServer()
		end
	end)
end


--- MAIN
local Tab = Window:NewTab("MAIN")
-- Choose Egg
local Section = Tab:NewSection("Open Stars")
Section:NewDropdown("Select Egg", "Select Egg", eggs, function(currentState)
    getgenv().eggSelected = currentState -- This will print the selected egg when chosen from the dropdown
end)
-- Multi Open
getgenv().multiOpen = false
Section:NewToggle("Multi Open", "Multi Open", function(state)
	getgenv().multiOpen = state
    if state then
        multiOpen()
    else
        print("Toggle Off")
    end
end)
-- Max Open
getgenv().maxOpen = false
Section:NewToggle("Max Open", "Max Open", function(state)
	getgenv().maxOpen = state
    if state then
        maxOpen()
    else
        print("Toggle Off")
    end
end)

--- GAMEPASSES
local Tab = Window:NewTab("GAMEPASS")
local Section = Tab:NewSection("Gamepass")
-- Magnet
getgenv().magnetGP = false
Section:NewToggle("Magnet Gamepass", "Magnet Gamepass", function(state)
	getgenv().magnetGP = state
    if state then
        magnetGP()
    else
        print("Toggle Off")
    end
end)
-- AutoClick
getgenv().autoClickGP = false
Section:NewToggle("Autoclick Gamepass", "Autoclick Gamepass", function(state)
	getgenv().autoClickGP = state
    if state then
        autoClickGP()
    else
        print("Toggle Off")
    end
end)
-- AutoAttack
getgenv().autoAttackGP = false
Section:NewToggle("Auto Attack Gamepass", "Auto Attack Gamepass", function(state)
	getgenv().autoAttackGP = state
    if state then
        autoAttackGP()
    else
        print("Toggle Off")
    end
end)
-- Sprint
getgenv().sprintGP = false
Section:NewToggle("Sprint Gamepass", "Sprint Gamepass", function(state)
	getgenv().sprintGP = state
    if state then
        sprintGP()
    else
        print("Toggle Off")
    end
end)

--- MISC
local Tab = Window:NewTab("MISC")
local Section = Tab:NewSection("Misc")
-- Anti-AFK
getgenv().antiAFK = false
Section:NewToggle("Anti-AFK", "Anti-AFK", function(state)
	getgenv().antiAFK = state
    if state then
        antiAFK()
    else
        print("Toggle Off")
    end
end)
-- Daily Spin
getgenv().dailySpin = false
Section:NewToggle("Daily Spin", "Daily Spin", function(state)
	getgenv().dailySpin = state
    if state then
        dailySpin()
    else
        print("Toggle Off")
    end
end)
