--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RunService = game:GetService('RunService')

local Knit = require(ReplicatedStorage.Packages.Knit)

local CM_Controller = Knit.CreateController { Name = "ClientMovementController" }

-- [[ Secondary Directories ]] --

function CM_Controller:KnitStart()
    print('Client Movement Controller has been started')
    local CTBService = Knit.GetService('Catch the Bomb')
    RunService.RenderStepped:Connect(function(deltaTime)
        for _,v in game.Workspace:GetDescendants() do
            if v.Name == 'SpinningHammer' then
                if v:IsA('Model') and v.Name == 'SpinningHammer' then
                    local rotation = CFrame.Angles(0, 0, math.rad(90 * deltaTime))
                    local modelCFrame = v:GetPivot()
                    v:PivotTo(modelCFrame * rotation)
                end
            end
        end
    end)
    CTBService.Impulse:Connect(function(Force)
        local Character = game.Players.LocalPlayer.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.AssemblyLinearVelocity = Force
    end)
end


function CM_Controller:KnitInit()
    print('Client Movement has been initialized')
end


return CM_Controller