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


-- Alphabetically order a table
function abc(a, b)
    if a:lower() < b:lower() then
      return true
    else
      return false
    end
end



-- Eggs stuff
local function listItemsWithKeyword(parent, keyword, excludedItem)
    getgenv().itemsWithKeyword = {}
    
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant:IsA("Instance") and string.find(string.lower(descendant.Name), string.lower(keyword), 1, true) then
            if descendant.Name ~= excludedItem then
                table.insert(itemsWithKeyword, descendant.Name) -- Store the name as a string
            end
        end
    end
    table.sort(itemsWithKeyword, abc)
    return itemsWithKeyword
end

getgenv().eggs = listItemsWithKeyword(game.Workspace.Worlds, "Egg", "JJBAStoneOceanEgg")
getgenv().player = game:GetService("Players").LocalPlayer
getgenv().currentWorld = game:GetService("Players").LocalPlayer.World.Value
getgenv().worlds = game:GetService("Workspace"):WaitForChild("Worlds"):GetChildren()
getgenv().savedPosition = Vector3.new(-4811.17041015625, -195.75247192382812, -6423.1240234375) -- Default LocalPlayer's Cframe.
getgenv().savedWorld = "TimeChamber"
getgenv().worldNames = {}
getgenv().enemiesCurrentWorld = {}
local enemiesList = {}
local timeTeam = {}
local draconicTeam = {}
local luckyTeam = {}
local currentTeam = {}
local enemy = nil

for _, world in worlds do
    if world.Name ~= "InfinityTower" and world.Name ~= "Dungeon" and world.Name ~= "Titan" then
        table.insert(worldNames, world.Name)
    end
end
table.sort(worldNames, abc)


print("Running...")
-- FUNCTIONS
function maxOpen()
	spawn(function()
		while getgenv().maxOpen do
            local cdMaxOpen = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Hatch.Buttons.Multi.Price.Text
            task.wait(0.1)
            if cdMaxOpen == "0:00" or cdMaxOpen == "MAX" then
                if luckyTeam then
                    equipLucky()
                    print('Time de lucky equipado.')
                end
                task.wait(1)
                print('Tentando roletar.')
                getgenv().A_1 = eggSelected
                getgenv().Event = game:GetService("ReplicatedStorage").Remote.AttemptMultiOpen
                Event:FireServer(A_1)
                task.wait(1)
                if timeTeam then
                    equipTime()
                    task.wait(1.5)
                end
            end
		end
	end)
end

function multiOpen()
    spawn(function()
        while getgenv().multiOpen do
            getgenv().A_1 = game:GetService("Workspace").Worlds[currentWorld][eggSelected]
            getgenv().A_2 = tonumber(string.match(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Hatch.Buttons.Open.Price.Text, "%d+"))
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
            task.wait()
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
            task.wait(0.1)
			local Event = game:GetService("ReplicatedStorage").Remote.ClickerDamage
			Event:FireServer()
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

function searchEnemies()
    spawn(function()

        local enemies = workspace.Worlds[currentWorld].Enemies:GetChildren()
        enemiesList = {}
        if #enemies then
            for _, enemy in ipairs(enemies) do
                task.wait()
                if enemy:FindFirstChild("HumanoidRootPart") then
                    print(enemy, "foi inserido em enemiesList")
                    table.insert(enemiesList, enemy)
                end
            end
        end
    end)
end

-- Função para verificar se um objeto é um inimigo válido (Workspace ou Nil)
local function isValidEnemy(obj)
    if not obj then return false end
    -- Verifica se tem as partes básicas de um inimigo (ajuste conforme o jogo)
    local hasHealth = obj:FindFirstChild("Health") or obj:FindFirstChild("Data")
    local hasRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
    
    -- Se for um Model ou tiver cara de inimigo, retornamos true
    return (obj:IsA("Model") or obj:IsA("Part")) and hasRoot
end

-- Busca o inimigo mais próximo em qualquer lugar (Workspace + Nil)
local function getAnyClosestEnemy()
    local closest = nil
    local dist = 300 -- Raio de alcance do ataque
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local pPos = char.HumanoidRootPart.Position

    -- 1. Procura no Workspace (Mundo Atual)
    local worldFolder = workspace.Worlds:FindFirstChild(player.World.Value)
    local enemiesFolder = worldFolder and worldFolder:FindFirstChild("Enemies")
    
    if enemiesFolder then
        for _, v in ipairs(enemiesFolder:GetChildren()) do
            if isValidEnemy(v) then
                local d = (v.HumanoidRootPart.Position - pPos).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
    end

    -- 2. Se não achou nada perto no Workspace, tenta no Nil (Inimigos invisíveis/glitchados)
    if not closest then
        for _, v in ipairs(getnilinstances()) do
            if isValidEnemy(v) and v.Name ~= player.Name then
                -- Tentamos pegar a posição dele (se existir)
                local vRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("PrimaryPart")
                if vRoot then
                    local d = (vRoot.Position - pPos).Magnitude
                    if d < dist then
                        dist = d
                        closest = v
                    end
                end
            end
        end
    end

    return closest
end

function autoAttackTP()
    spawn(function()
        while getgenv().autoAttackTP do
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local currentWorld = player.World.Value
                
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end

                local playerHRP = player.Character.HumanoidRootPart
                local enemiesFolder = workspace.Worlds[currentWorld]:FindFirstChild("Enemies")
                if not enemiesFolder then return end

                -- PEGA APENAS OS PETS DO PLAYER
                local petFolder = workspace:FindFirstChild("Pets")
                if not petFolder then return end

                petFolder = petFolder:FindFirstChild(player.Name)
                if not petFolder then return end

                local sendPetRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet")

                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        local distance = (enemy.HumanoidRootPart.Position - playerHRP.Position).Magnitude

                        if distance < 200 then
                            -- TELEPORTA CORRETAMENTE
                            playerHRP.CFrame = enemy.HumanoidRootPart.CFrame

                            local contador = 1

                            for _, pet in ipairs(petFolder:GetChildren()) do
                                if pet:IsA("Model") and pet:FindFirstChild("Data") then
                                    if tostring(pet.Data.Owner.Value) == player.Name then
                                        local args = {
                                            [1] = pet,
                                            [2] = enemy,
                                            [3] = contador
                                        }

                                        sendPetRemote:FireServer(unpack(args))
                                        pet.Data.Attacking.Value = enemy
                                        contador += 1
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
            task.wait()
        end
    end)
end





-- AUTO ATTACK EXTRA (Dungeon, Infinity Tower...): more optimized.
function autoAttackExtra()
    spawn(function()
        while getgenv().autoAttackExtra do
            local player = game:GetService("Players").LocalPlayer
            local currentWorld = player.World.Value
            local playerPosition = player.Character.HumanoidRootPart.Position
            
            local equippedPets = {}
            for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
                task.wait()
                if pet:IsA("Model") and pet:FindFirstChild("Data") and tostring(pet.Data.Owner.Value) == player.Name then
                    table.insert(equippedPets, pet)
                end
            end

            local nearestEnemy = workspace.Worlds[currentWorld].Enemies:GetChildren()[1]
            if nearestEnemy then
                local enemyPosition = nearestEnemy.HumanoidRootPart.Position
                local distance = (enemyPosition - playerPosition).Magnitude
                if distance < 200 then
                    player.Character.HumanoidRootPart.CFrame = nearestEnemy.PrimaryPart.CFrame 
                    local contador = 1
                    print('SENDING PETS TO ATTACK...')

                    for _, pet in ipairs(equippedPets) do
                        local args = {
                            [1] = pet,
                            [2] = nearestEnemy,
                            [3] = contador
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SendPet"):FireServer(unpack(args))
                        pet.Data.Attacking.Value = args[2]
                        contador = contador + 1
                    end
                end
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

        print('======== ANALYZING CURRENT TEAM... =========')
        for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
            if pet:IsA("Model") then
                if pet:FindFirstChild("Data") then
                    if tostring(pet.Data.Owner.Value) == player.Name then
                        table.insert(draconicTeam, pet.Data.UID.Value)
                        print("The following pet was successfully saved on Draconic team: " .. pet.Name .. ", UID: " .. pet.Data.UID.Value)
                    end
                end
            end
        end

        repeat task.wait() until draconicTeam
        print("Team saved!")
    end)
end

function saveLucky()
    spawn(function()
        luckyTeam = {}

        print('======== ANALYZING CURRENT TEAM... =========')
        for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
            if pet:IsA("Model") then
                if pet:FindFirstChild("Data") then
                    if tostring(pet.Data.Owner.Value) == player.Name then
                        table.insert(luckyTeam, pet.Data.UID.Value)
                        print("The following pet was successfully saved on Lucky team: " .. pet.Name .. ", UID: " .. pet.Data.UID.Value)
                    end
                end
            end
        end

        repeat task.wait() until luckyTeam
        print("Team saved!")
    end)
end

function saveTime()
    spawn(function()
        timeTeam = {}

        print('======== ANALYZING CURRENT TEAM... =========')
        for _, pet in ipairs(game:GetService("Workspace").Pets:GetChildren()) do
            if pet:IsA("Model") then
                if pet:FindFirstChild("Data") then
                    if tostring(pet.Data.Owner.Value) == player.Name then
                        table.insert(timeTeam, pet.Data.UID.Value)
                        print("The following pet was successfully saved on Time team: " .. pet.Name .. ", UID: " .. pet.Data.UID.Value)
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

        print("Equipping Draconic team...")
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

function equipLucky()
	spawn(function()
        local contador = 0

        print("Equipping Lucky team...")
        for _, petId in ipairs(luckyTeam) do
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

        print("Equipping Time team...")
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
                getgenv().autoAttackExtra = true
                autoAttackExtra()
                while true do
                    print('Waiting for Infinity Tower to end...')
                    task.wait(2)
                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui:WaitForChild("InfinityTowerLose").Visible == true then
                        getgenv().autoAttackExtra = false
                        task.wait(4)
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
                    task.wait(3)
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

function teleportWorld(worldChoice)
    spawn(function()
        local args = {
            [1] = worldChoice
        }
        game:GetService("ReplicatedStorage").Remote.AttemptTravel:InvokeServer(unpack(args))
        task.wait(0.5)
        player.Character.HumanoidRootPart.CFrame = workspace.Worlds[worldChoice].Spawns:WaitForChild("SpawnLocation").CFrame      
    end)
end

--- MAIN
local Tab = Window:NewTab("MAIN")
-- Choose Egg
local Section = Tab:NewSection("Open Stars (AUTO Lucky/Time team)")
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

-- Auto Attack (TP)
local Section = Tab:NewSection("Auto Farm")
getgenv().autoAttackTP = false
Section:NewToggle("Auto Attack (TP)", "Auto Attack (TP)", function(state)
	getgenv().autoAttackTP = state
    if state then
        autoAttackTP()
    else
        print("Toggle Off")
    end
end)

--- GAMEPASSES
local Tab = Window:NewTab("GAMEPASS")
local Section = Tab:NewSection("Gamepass")
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
-- Teleport Worlds
local Section = Tab:NewSection("TP")
Section:NewDropdown("Worlds", "Worlds", worldNames, function(currentState)
    getgenv().worldSelected = currentState -- This will     print the selected egg when chosen from the dropdown
end)
Section:NewButton("Teleport", "Teleport", function()
    teleportWorld(worldSelected)
end)

--- Zer0hub FIX
local Tab = Window:NewTab("EXTRA MODES")
local Section = Tab:NewSection("Infinity Tower")
-- Auto Infinity Tower TP
getgenv().infTowerTP = false
Section:NewToggle("Auto Infinity Tower", "Auto Infinity Tower", function(state)
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

--- Teams
local Tab = Window:NewTab("TEAMS")
local Section = Tab:NewSection("Save Team")
-- Save Draconic team
Section:NewButton("Save Draconic", "Save Draconic", function()
    saveDraconic()
end)
-- Equip Lucky team
Section:NewButton("Save Lucky", "Save Lucky", function()
    saveLucky()
end)
-- Save Time team
Section:NewButton("Save Time", "Save Time", function()
    saveTime()
end)



--- [DEBUG]
local Tab = Window:NewTab("[DEBUG]")
local Section = Tab:NewSection("[DEBUG]")
-- Equip Draconic team
Section:NewButton("Equip Draconic", "Equip Draconic", function()
    equipDraconic()
end)
-- Equip Lucky team
Section:NewButton("Equip Lucky", "Equip Lucky", function()
    equipLucky()
end)
-- Equip Time team
Section:NewButton("Equip Time", "Equip Time", function()
    equipTime()
end)
-- Teleport to Saved Position
Section:NewButton("Teleport to Saved Position", "Teleport Position", function()
    teleportToSavedPosition()
end)



