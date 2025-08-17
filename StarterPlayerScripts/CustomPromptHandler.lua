-- === CustomPromptHandler v2.0 ===
-- Ten skrypt idzie do StarterPlayer/StarterPlayerScripts jako LocalScript

local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local promptsGui = playerGui:WaitForChild("ProximityPromptsGui")

local customSellPromptTemplate = promptsGui:WaitForChild("CustomSellPrompt")
local currentPromptInstance, currentHoldTween = nil, nil

ProximityPromptService.PromptShown:Connect(function(prompt)
    if prompt.Style == Enum.ProximityPromptStyle.Custom and not currentPromptInstance then
        currentPromptInstance = customSellPromptTemplate:Clone()
        currentPromptInstance.Enabled = true
        
        local oN, oL, sP = prompt:GetAttribute("ObjectName") or "", prompt:GetAttribute("ObjectLevel") or 1, prompt:GetAttribute("SellPrice") or 0
        local iT, aT = currentPromptInstance:FindFirstChild("InfoText"), currentPromptInstance:FindFirstChild("ActionText")
        
        if iT then
            iT.Text = oN.." (Lvl "..oL..")"
        end
        if aT then
            aT.Text = "[Przytrzymaj "..prompt.KeyboardKeyCode.Name.."]"
        end
        
        currentPromptInstance.Adornee = prompt.Parent
        currentPromptInstance.StudsOffset = Vector3.new(0, 3, 0)
        currentPromptInstance.Parent = promptsGui
    end
end)

ProximityPromptService.PromptHidden:Connect(function(prompt)
    if currentPromptInstance then
        if currentHoldTween then
            currentHoldTween:Cancel()
            currentHoldTween = nil
        end
        currentPromptInstance:Destroy()
        currentPromptInstance = nil
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if currentPromptInstance and prompt.Style == Enum.ProximityPromptStyle.Custom then
        local pF = currentPromptInstance:FindFirstChild("ProgressFill")
        if pF then
            if currentHoldTween then
                currentHoldTween:Cancel()
            end
            pF.Size = UDim2.new(1, 0, 0.001, 0)
            local tI, g = TweenInfo.new(prompt.HoldDuration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}
            currentHoldTween = TweenService:Create(pF, tI, g)
            currentHoldTween:Play()
        end
    end
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt)
    if currentPromptInstance and prompt.Style == Enum.ProximityPromptStyle.Custom then
        local pF = currentPromptInstance:FindFirstChild("ProgressFill")
        if pF then
            if currentHoldTween then
                currentHoldTween:Cancel()
                currentHoldTween = nil
            end
            pF.Size = UDim2.new(1, 0, 0.001, 0)
        end
    end
end)
