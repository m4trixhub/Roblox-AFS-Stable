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

--


local Tab = Window:NewTab("MAIN")
-- OPEN STARS
local Section = Tab:NewSection("Open Stars")
Section:NewDropdown("Select Egg", "Select Egg", eggs, function(currentState)
    getgenv().eggSelected = currentState -- This will print the selected egg when chosen from the dropdown
end)


getgenv().multiOpen = false
Section:NewToggle("Multi Open", "Multi Open", function(state)
	getgenv().multiOpen = state
    if state then
        multiOpen()
    else
        print("Toggle Off")
    end
end)

getgenv().maxOpen = false
Section:NewToggle("Max Open", "Max Open", function(state)
	getgenv().maxOpen = state
    if state then
        maxOpen()
    else
        print("Toggle Off")
    end
end)


