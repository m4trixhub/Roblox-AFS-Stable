repeat wait() until game:IsLoaded()

-- LIBRARY SOURCE

getgenv().colors = {
    SchemeColor = Color3.fromRGB(229, 175, 0),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(77, 77, 77)
}
getgenv().Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
getgenv().Window = Library.CreateLib("m4trix Hub", colors)

-- SEARCH FOR ALL EGGS
getgenv().worldsParent = game.Workspace.Worlds -- Replace 'Workspace' with the appropriate parent where your "Worlds" parent is located

local function listItemsWithKeyword(parent, keyword, excludedItem)
    getgenv().itemsWithKeyword = {}
    
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant:IsA("Instance") and string.find(string.lower(descendant.Name), string.lower(keyword), 1, true) then
            if descendant.Name ~= excludedItem then
                table.insert(itemsWithKeyword, descendant.Name) -- Store the name as a string
            end
        end
    end
    
    return itemsWithKeyword
end

getgenv().keyword = "Egg" -- Change this to the desired keyword you're looking for
getgenv().excludedItem = "JJBAStoneOceanEgg" -- The item you want to exclude from the results
getgenv().eggs = listItemsWithKeyword(worldsParent, keyword, excludedItem)

-- Now 'itemsWithKeyword' is a list (table) containing the names of the items with the keyword "Egg" but excluding "JJBAStoneOceanEgg".

_G.player = game:GetService("Players").LocalPlayer
_G.worlds = game:GetService("Workspace"):WaitForChild("Worlds")
_G.currentWorld = player.World.Value
_G.savedPosition = nil
_G.savedWorld = nil


-- FUNCTIONS
function maxOpen()
	spawn(function()
		while getgenv().maxOpen do
			_G.A_1 = eggSelected
		    _G.Event = game:GetService("ReplicatedStorage").Remote.AttemptMultiOpen
		    Event:FireServer(A_1) 
		    wait(0.6)
		end
	end)
end

function multiOpen()
    spawn(function()
        while _G.multiOpen do
            _G.A_1 = game:GetService("Workspace").Worlds[currentWorld][eggSelected]
            _G.A_2 = 13
            _G.Event = game:GetService("ReplicatedStorage").Remote.OpenEgg
            Event:InvokeServer(A_1, A_2)
            wait(1)
        end
    end)
end

function antiAFK()
    spawn(function()
        while _G.antiAFK do
			wait()
			for i,v in pairs(getconnections(player.Idled)) do
				v:Disable()
				wait()
			end
        end
    end)
end

function magnetGP()
    spawn(function()
        while _G.magnetGP do
            wait(1)
            _G.workspace = game:GetService("Workspace")
            _G.humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            _G.effects = workspace:FindFirstChild("Effects")
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
		while _G.autoClickGP do
            wait(0.025)
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("ClickerDamage"):FireServer()
		end
	end)
end

function sprintGP()
	spawn(function()
		while _G.sprintGP do
            wait(0.25)
            if player.Character.Humanoid.WalkSpeed < 30 then
                player.Character.Humanoid.WalkSpeed = 30
            end
		end
	end)
end


function autoAttackGP()
    spawn(function()
        while _G.autoAttackGP do
			_G.enemies = workspace:WaitForChild("Worlds"):WaitForChild(currentWorld):WaitForChild("Enemies")
			_G.playerBody = player.Character:FindFirstChild("HumanoidRootPart")
			_G.playerName = player.Name
			_G.distance
			_G.closestEnemy
			
			for _, enemy in ipairs(enemies:GetChildren()) do
				wait()
				distance = ((enemy.HumanoidRootPart.Position or enemy.PrimaryPart.Position) - playerBody.Position).magnitude
				if distance < 20 then
					closestEnemy = enemy
					break
				end
			end
			while closestEnemy and (distance < 20) do
				distance = ((closestEnemy.HumanoidRootPart.Position or closestEnemy.PrimaryPart.Position) - playerBody.Position).magnitude
				contador = 0
				if contador == 0 then
					print("Sending pets to attack", closestEnemy.Name)
				end
				
				local myPets = game:GetService("Players").LocalPlayer.Pets:GetChildren()
				local allPets = workspace:WaitForChild("Pets"):GetChildren()

				local petModels = {} -- Table to store the model paths

				-- Find and store the model paths in the petModels table
				for _, myPet in ipairs(myPets) do
					local myPetName = myPet.Name
					for _, petModel in ipairs(allPets) do
						if petModel:IsA("Model") and petModel.Name == myPetName then
							table.insert(petModels, petModel:GetFullName())
							print('petModel added:', petModel.Name)
						end
						wait()
					end
				end


				-- Modify each model using the stored paths
				for _, petPath in ipairs(petModels) do
					local petModel = workspace:FindFirstChild(petPath)
					print('tentou atacar!')
					contador = contador + 1
					local args = {
						[1] = petPath,
						[2] = enemies:WaitForChild(closestEnemy.Name),
						[3] = contador
					}
					print('chegou')
					print(unpack(args))
					game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet"):FireServer(unpack(args))
					petPath.Data.Attacking.Value = args[2]
					print("Modifying:", petModel.Name)
					wait()
				end
				
				
				if not getgenv().autoAttackGP then
					for _, pet in ipairs(myPets) do
						local args = {
							[1] = workspace:WaitForChild("Pets"):WaitForChild(pet.Name),
						}
						game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet"):FireServer(unpack(args))
						game:GetService("Workspace").Pets[pet.Name].Data.Attacking.Value = nill
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
		while _G.dailySpin do
			wait(10)
			game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("DailySpin"):FireServer()
		end
	end)
end

function autoMount()
	spawn(function()
		while _G.autoMount do
			wait(1)
			if player.Mounting.Value == "" then
				game:GetService("ReplicatedStorage"):WaitForChild("Bindable").ToggleMount:Fire()
			end
		end
	end)
end

function savePosition()
    spawn(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			_G.savedWorld = currentWorld
            _G.savedPosition = player.Character.HumanoidRootPart.CFrame
        end
    end)
end
	
function teleportToSavedPosition()
    spawn(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local args = {
				[1] = savedWorld
			}
			
			player.Character.HumanoidRootPart.CFrame = savedPosition
			game:GetService("ReplicatedStorage").Remote.AttemptTravel:InvokeServer(unpack(args))
        end
    end)
end

function infTowerTP()
	spawn(function()
		while _G.infTowerTP do
			_G.infinityDoor = tostring(game:GetService("Workspace"):WaitForChild("Worlds"):WaitForChild("Tower"):WaitForChild("InfinityDoor"):WaitForChild("StartRoom").Value)
			_G.infinityInside = false
			wait(10)

			if infinityDoor == "StartRoom" then -- Detects if Infinity Tower door is open.
				local args = {
					[1] = 1
				}
				game:GetService("ReplicatedStorage").Remote:WaitForChild("JoinInfinityTower"):FireServer(unpack(args))	-- Teleports LocalPlayer to Infinity Tower.
				game:GetService("ReplicatedStorage"):WaitForChild("Bindable").AttemptTravel:Fire("InfinityTower", true)	--
				infinityInside = true
				wait(2)
			end

			while infinityInside do
				wait(5)
				if currentWorld == "Tower" then -- Detects if LocalPlayer is in Infinity Tower.
					teleportToSavedPosition()
					break
				end
			end

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
_G.multiOpen = false
Section:NewToggle("Multi Open", "Multi Open", function(state)
	_G.multiOpen = state
    if state then
        multiOpen()
    else
        print("Toggle Off")
    end
end)
-- Max Open
_G.maxOpen = false
Section:NewToggle("Max Open", "Max Open", function(state)
	_G.maxOpen = state
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
_G.magnetGP = false
Section:NewToggle("Magnet Gamepass", "Magnet Gamepass", function(state)
	_G.magnetGP = state
    if state then
        magnetGP()
    else
        print("Toggle Off")
    end
end)
-- AutoClick
_G.autoClickGP = false
Section:NewToggle("Autoclick Gamepass", "Autoclick Gamepass", function(state)
	_G.autoClickGP = state
    if state then
        autoClickGP()
    else
        print("Toggle Off")
    end
end)
-- AutoAttack
_G.autoAttackGP = false
Section:NewToggle("Auto Attack Gamepass (UNSTABLE)", "Auto Attack Gamepass (UNSTABLE)", function(state)
	_G.autoAttackGP = state
    if state then
        autoAttackGP()
    else
        print("Toggle Off")
    end
end)
-- Sprint
_G.sprintGP = false
Section:NewToggle("Sprint Gamepass", "Sprint Gamepass", function(state)
	_G.sprintGP = state
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
_G.antiAFK = false
Section:NewToggle("Anti-AFK", "Anti-AFK", function(state)
	_G.antiAFK = state
    if state then
        antiAFK()
    else
        print("Toggle Off")
    end
end)
-- Daily Spin
_G.dailySpin = false
Section:NewToggle("Daily Spin", "Daily Spin", function(state)
	_G.dailySpin = state
    if state then
        dailySpin()
    else
        print("Toggle Off")
    end
end)
-- Auto Mount
_G.autoMount = false
Section:NewToggle("Auto Mount", "Auto Mount", function(state)
	_G.autoMount = state
    if state then
        autoMount()
    else
        print("Toggle Off")
    end
end)

--- Zer0hub FIX
local Tab = Window:NewTab("Zer0hub Fix")
local Section = Tab:NewSection("Zer0hub Fix")
-- Save Position
Section:NewButton("Save Position", "Save Position", function()
    savePosition()
end)
-- Auto Infinity Tower TP
_G.infTowerTP = false
Section:NewToggle("Auto Infinity Tower TP", "Auto Infinity Tower TP", function(state)
	_G.infTowerTP = state
    if state then
        infTowerTP()
    else
        print("Toggle Off")
    end
end)
