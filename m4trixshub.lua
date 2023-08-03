repeat wait() until game:IsLoaded()

-- LIBRARY SOURCE

getgenv().colors = {
    SchemeColor = Color3.fromRGB(207, 7, 0),
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

getgenv().player = game:GetService("Players").LocalPlayer
getgenv().currentWorld = player.World.Value
getgenv().allPets = game:GetService("Workspace").Pets:GetChildren()
getgenv().worlds = game:GetService("Workspace"):WaitForChild("Worlds")
getgenv().savedPosition = Vector3.new(-4811.17041015625, -195.75247192382812, -6423.1240234375) -- Default LocalPlayer's Cframe.
getgenv().savedWorld = "TimeChamber"															-- Default LocalPlayer's world.


-- FUNCTIONS
function maxOpen()
	spawn(function()
		while getgenv().maxOpen do
			getgenv().A_1 = eggSelected
		    getgenv().Event = game:GetService("ReplicatedStorage").Remote.AttemptMultiOpen
		    Event:FireServer(A_1) 
		    wait(0.6)
		end
	end)
end

function multiOpen()
    spawn(function()
        while getgenv().multiOpen do
            getgenv().A_1 = game:GetService("Workspace").Worlds[currentWorld][eggSelected]
            getgenv().A_2 = 13
            getgenv().Event = game:GetService("ReplicatedStorage").Remote.OpenEgg
            Event:InvokeServer(A_1, A_2)
            wait(1)
        end
    end)
end

function antiAFK()
    spawn(function()
        while getgenv().antiAFK do
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
        while getgenv().magnetGP do
            wait(1)
            getgenv().workspace = game:GetService("Workspace")
            getgenv().humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            getgenv().effects = workspace:FindFirstChild("Effects")
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
            if player.Character.Humanoid.WalkSpeed < 30 then
                player.Character.Humanoid.WalkSpeed = 30
            end
		end
	end)
end


function autoAttackGP()
    spawn(function()
        while getgenv().autoAttackGP do
			getgenv().enemies = workspace:WaitForChild("Worlds"):WaitForChild(currentWorld):WaitForChild("Enemies")
			getgenv().playerBody = player.Character:FindFirstChild("HumanoidRootPart")
			getgenv().playerName = player.Name
			local distance
			local closestEnemy
			
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
		while getgenv().dailySpin do
			wait(10)
			game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("DailySpin"):FireServer()
		end
	end)
end

function autoMount()
	spawn(function()
		while getgenv().autoMount do
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
			savedPosition = player.Character.HumanoidRootPart.CFrame									-- Saves LocalPlayer's Cframe.
			savedWorld = currentWorld																	-- Saves LocalPlayer's World.
        end
    end)
end
	
function teleportToSavedPosition()
    spawn(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local args = {
				[1] = savedWorld
			}
			
			player.Character.HumanoidRootPart.CFrame = savedPosition									-- Loads saved LocalPlayer's Cframe.
			game:GetService("ReplicatedStorage").Remote.AttemptTravel:InvokeServer(unpack(args))		-- Loads saved LocalPlayer's World.
        end
    end)
end

function saveDraconic()
    spawn(function()
		getgenv().draconicTeam = {}

		print('Saving Draconic team...')
		for _, pet in ipairs(allPets) do
			if pet:isA("Model") then
				if pet.Data then
					if tostring(pet.Data.Owner.Value) == player.Name then
						table.insert(draconicTeam, pet:GetDebugId())
					end
				end
			end
		end
    end)
end

function saveTime()
    spawn(function()
		getgenv().timeTeam = {}

		print('Saving Time team...')
		for _, pet in ipairs(allPets) do
			if pet:isA("Model") then
				if pet.Data then
					if tostring(pet.Data.Owner.Value) == player.Name then
						table.insert(draconicTeam, pet:GetDebugId())
					end
				end
			end
		end
    end)
end

function equipDraconic()
	spawn(function()
		local contador = 0

		for _, petId in ipairs(draconicTeam) do
			wait()
			contador = contador + 1

			local args = {
				[1] = petId,
				[2] = "Equip",
				[3] = contador
			}

			game:GetService("ReplicatedStorage").Remote.ManagePet:FireServer(unpack(args))
		end

	end)
end

function equipTime()
	spawn(function()
		local contador = 0

		for _, petId in ipairs(timeTeam) do
			wait()
			contador = contador + 1

			local args = {
				[1] = petId,
				[2] = "Equip",
				[3] = contador
			}

			game:GetService("ReplicatedStorage").Remote.ManagePet:FireServer(unpack(args))
		end

	end)
end

function infTowerTP()
	spawn(function()
		while getgenv().infTowerTP do
			getgenv().infinityDoor = tostring(game:GetService("Workspace"):WaitForChild("Worlds"):WaitForChild("Tower"):WaitForChild("InfinityDoor"):WaitForChild("StartRoom").Value)
			getgenv().infinityInside = false
			wait(10)

			if infinityDoor == "StartRoom" then -- Detects if Infinity Tower door is open.
				local args = {
					[1] = 1
				}
				game:GetService("ReplicatedStorage").Remote:WaitForChild("JoinInfinityTower"):FireServer(unpack(args))	-- Teleports LocalPlayer to Infinity Tower.
				game:GetService("ReplicatedStorage"):WaitForChild("Bindable").AttemptTravel:Fire("InfinityTower", true)	--
				infinityInside = true
				wait(2)
				if draconicTeam then
					equipDraconic()
				end
			end

			while infinityInside do
				wait(5)
				if currentWorld == "Tower" then -- Detects if LocalPlayer is in Infinity Tower.
					if timeTeam then
						equipTime()
					end
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
Section:NewToggle("Auto Attack Gamepass (UNSTABLE)", "Auto Attack Gamepass (UNSTABLE)", function(state)
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
-- Auto Mount
getgenv().autoMount = false
Section:NewToggle("Auto Mount", "Auto Mount", function(state)
	getgenv().autoMount = state
    if state then
        autoMount()
    else
        print("Toggle Off")
    end
end)

--- Zer0hub FIX
local Tab = Window:NewTab("Zer0hub Fix")
local Section = Tab:NewSection("Infinity Tower")

-- Auto Infinity Tower TP
getgenv().infTowerTP = false
Section:NewToggle("Auto Infinity Tower TP", "Auto Infinity Tower TP", function(state)
	getgenv().infTowerTP = state
    if state then
        infTowerTP()
    else
        print("Toggle Off")
    end
end)
-- Save Position
Section:NewButton("Save Position", "Save Position", function()
    savePosition()
end)

local Section = Tab:NewSection("Saving Teams")
-- Save Draconic team
Section:NewButton("Save Draconic", "Save Draconic", function()
    saveDraconic()
end)
-- Save Time team
Section:NewButton("Save Time", "Save Time", function()
    saveTime()
end)
