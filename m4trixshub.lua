repeat task.wait() until game:IsLoaded()

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
getgenv().currentWorld = game:GetService("Players").LocalPlayer.World.Value
getgenv().worlds = game:GetService("Workspace"):WaitForChild("Worlds")
getgenv().savedPosition = Vector3.new(-4811.17041015625, -195.75247192382812, -6423.1240234375) -- Default LocalPlayer's Cframe.
getgenv().savedWorld = "TimeChamber"															-- Default LocalPlayer's world.
local timeTeam = {}
local draconicTeam = {}

print("Running...")

-- FUNCTIONS
function maxOpen()
	spawn(function()
		while getgenv().maxOpen do
			getgenv().A_1 = eggSelected
		    getgenv().Event = game:GetService("ReplicatedStorage").Remote.AttemptMultiOpen
		    Event:FireServer(A_1) 
		    task.wait(0.6)
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
            task.wait(1)
        end
    end)
end

function antiAFK()
    spawn(function()
        while getgenv().antiAFK do
			task.wait()
			for i,v in pairs(getconnections(player.Idled)) do
				v:Disable()
				task.wait()
			end
        end
    end)
end

function magnetGP()
    spawn(function()
        while getgenv().magnetGP do
            task.wait(1)
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
            task.wait(0.025)
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("ClickerDamage"):FireServer()
		end
	end)
end

function sprintGP()
	spawn(function()
		while getgenv().sprintGP do
            task.wait(0.25)
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
				task.wait()
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
						task.wait()
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
					task.wait()
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
				task.wait() -- Adjust the delay before the next iteration
			end
		end
	end)
end


function dailySpin()
	spawn(function()
		while getgenv().dailySpin do
			task.wait(10)
			game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("DailySpin"):FireServer()
		end
	end)
end

function autoMount()
	spawn(function()
		while getgenv().autoMount do
			task.wait(1)
			if player.Mounting.Value == "" then
				game:GetService("ReplicatedStorage"):WaitForChild("Bindable").ToggleMount:Fire()
			end
		end
	end)
end

function savePosition()
    spawn(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			savedPosition = player.Character.HumanoidRootPart.CFrame								-- Saves LocalPlayer's Cframe.
			savedWorld = player.World.Value								-- Saves LocalPlayer's World.
            print(savedPosition)
            print(savedWorld)
        end
    end)
end

function teleportToSavedPosition()
    spawn(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			task.wait(2)
			local args = {
				[1] = savedWorld
			}
			print("Teleporting pt. 1")
			player.Character.HumanoidRootPart.CFrame = savedPosition									-- Loads saved LocalPlayer's Cframe.
            print("Teleporting pt. 2")
			game:GetService("ReplicatedStorage").Remote.AttemptTravel:InvokeServer(unpack(args))		-- Loads saved LocalPlayer's World.
        end
    end)
end

function saveDraconic()
    spawn(function()
        draconicTeam = {}

        print('======== ANALYZING... =========')
        for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
            if pet:IsA("Model") then
                if pet:FindFirstChild("Data") then
                    if tostring(pet.Data.Owner.Value) == player.Name then
                        table.insert(draconicTeam, pet.Data.UID.Value)
                        print("The following pet was successfully saved: " .. pet.Name .. ", UID: " .. pet.Data.UID.Value)
                    end
                end
            end
        end
        repeat task.wait() until draconicTeam
        print("Team saved!")
    end)
end

function saveTime()
    spawn(function()
        timeTeam = {}

        print('======== ANALYZING... =========')
        for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
            if pet:IsA("Model") then
                if pet:FindFirstChild("Data") then
                    if tostring(pet.Data.Owner.Value) == player.Name then
                        table.insert(timeTeam, pet.Data.UID.Value)
                        print("The following pet was successfully saved: " .. pet.Name .. ", UID: " .. pet.Data.UID.Value)
                    end
                end
            end
        end
        repeat task.wait() until timeTeam
        print("Team saved!")
    end)
end

function equipDraconic()
	spawn(function()
        local contador = 0

        for _, petId in ipairs(draconicTeam) do
            print(petId)
        end

        print("Equipping equipDraconic function...")
        for _, petId in ipairs(draconicTeam) do
            task.wait()
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
            print(petId)
        end

        print("Executing equipTime function...")
        for _, petId in ipairs(timeTeam) do
            task.wait()
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

            print('------------------------ Searching for the next Infinity Tower... ----------------------------')
			task.wait(5)

            if game:GetService("Players").LocalPlayer.World.Value == "InfinityTower" then
                while true do
                    print('Waiting for Infinity Tower to end...')
                    task.wait(2)
                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui:WaitForChild("InfinityTowerLose").Visible == true then
                        break
                    end
                end
                print('------------------------- INFINITY TOWER ENDED -----------------------------')

                if timeTeam then
                    print('----------------------- EQUIPPING TIME TEAM -----------------------------')
                    equipTime()
                    task.wait(3)
                end

                teleportToSavedPosition()
                task.wait(2)
            else

                if tostring(game:GetService("Workspace"):WaitForChild("Worlds"):WaitForChild("Tower"):WaitForChild("InfinityDoor"):WaitForChild("StartRoom").Value) == "StartRoom" then -- Detects if Infinity Tower door is open.
                    local args = {
                        [1] = 1
                    }
                    game:GetService("ReplicatedStorage").Remote:WaitForChild("JoinInfinityTower"):FireServer(unpack(args))	-- Teleports LocalPlayer to Infinity Tower.
                    game:GetService("ReplicatedStorage"):WaitForChild("Bindable").AttemptTravel:Fire("InfinityTower", true)	--
                    print('------------------- INFINITY TOWER STARTED! --------------------')

                    if draconicTeam then
                        print('----------------------- EQUIPPING DRACONIC TEAM -----------------------')
                        equipDraconic()
                        task.wait(3)
                    end

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

local Section = Tab:NewSection("[DEBUG]")
-- Equip Draconic team
Section:NewButton("Equip Draconic", "Equip Draconic", function()
    equipDraconic()
end)
-- Equip Time team
Section:NewButton("Equip Time", "Equip Time", function()
    equipTime()
end)
-- TESTE
Section:NewButton("Teleport to Saved Position", "Teleport Position", function()
    teleportToSavedPosition()
end)
