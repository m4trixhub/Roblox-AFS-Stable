repeat task.wait() until game:IsLoaded()

// INICIO DO GUI

local ScreenGui = Instance.new("ScreenGui")
local TradeHopGUI = Instance.new("Frame")
local Frame = Instance.new("Frame")
local StateText = Instance.new("TextLabel")
local CreditText = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TradeHopGUI.Name = "TradeHopGUI"
TradeHopGUI.Parent = ScreenGui
TradeHopGUI.Active = true
TradeHopGUI.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
TradeHopGUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
TradeHopGUI.BorderSizePixel = 0
TradeHopGUI.Position = UDim2.new(0.299933225, 0, 0.299498737, 0)
TradeHopGUI.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)

Frame.Parent = TradeHopGUI
Frame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0110223098, 0, 0.023809351, 0)
Frame.Size = UDim2.new(0.977822065, 0, 0.948245764, 0)

StateText.Name = "StateText"
StateText.Parent = TradeHopGUI
StateText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StateText.BackgroundTransparency = 1.000
StateText.BorderColor3 = Color3.fromRGB(0, 0, 0)
StateText.BorderSizePixel = 0
StateText.Position = UDim2.new(0.146960542, 0, 0.347744346, 0)
StateText.Size = UDim2.new(0.705811679, 0, 0.300000012, 0)
StateText.Font = Enum.Font.SourceSansBold
StateText.Text = "Searching..."
StateText.TextColor3 = Color3.fromRGB(255, 255, 255)
StateText.TextSize = 100.000
StateText.TextStrokeTransparency = 0.600

CreditText.Name = "CreditText"
CreditText.Parent = TradeHopGUI
CreditText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CreditText.BackgroundTransparency = 1.000
CreditText.BorderColor3 = Color3.fromRGB(0, 0, 0)
CreditText.BorderSizePixel = 0
CreditText.Position = UDim2.new(0.709752798, 0, 0.839599073, 0)
CreditText.Size = UDim2.new(0.278289944, 0, 0.130827099, 0)
CreditText.Font = Enum.Font.SourceSans
CreditText.Text = "m4trixhub"
CreditText.TextColor3 = Color3.fromRGB(255, 85, 0)
CreditText.TextSize = 40.000
CreditText.TextStrokeTransparency = 0.600

// FIM DO GUI


local player = game.Players.LocalPlayer.Character.HumanoidRootPart
local closeButton = game:GetService("Players").LocalPlayer.PlayerGui.PAGES.PlayerBoothUI.CloseButton

getgenv().searching = true

while searching do 
    for _, booth in pairs(workspace.Folder:GetChildren()) do
        if booth:FindFirstChild("PromptHolderPart") and booth.PromptHolderPart:FindFirstChild("BoothInteractPrompt") then

            local prompt = booth.PromptHolderPart.BoothInteractPrompt
            prompt.MaxActivationDistance = 200
            task.wait(0.3)
            fireproximityprompt(prompt)
            task.wait(1)
            for _, unit in pairs(game:GetService("Players").LocalPlayer.PlayerGui.PAGES.PlayerBoothUI.BoothUIScrollingFrame:GetChildren()) do
                task.wait(0.15)
                if unit.UnitGridPrefab and unit.UnitGridPrefab.Button and unit.UnitGridPrefab.Button.UnitNameLabel
                    local unitName = unit.UnitGridPrefab.Button.UnitNameLabel.Text
                    if unitName == "Chance Taker" or
                        unitName == "The Gamer" or
                        unitName == "★ The Pro Gamer" or
                        unitName == "★ Chance King" then
                        
                        local priceUnitStr = unit.UnitGridPrefab.OnSaleFrame.TextLabel.Text
                        local priceUnitInt = tonumber(str:gsub(",", ""))
                                              
                       
                        if priceUnitInt < 120000 then
                      
                            StateText.Text = "FOUND!"
                            searching = false
                            break
							
                        end
                    end
                end
            end
            fireclickdetector(closeButton)
        end
    end
	print("Nada encontrado!")
    
    //
    // CHANGE SERVER !!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //
    
end
