--[[ Directories ]] --
-- [[ Catch The Bomb ]] --
local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)

local Gameplay = Knit.CreateService{
    Name = 'Catch the Bomb',
    Client = {}
}


-- [[ Other Directories ]] --


--[[ Main Systems ]] --


local isPlaying = false

local function GiveBomb()
    
end
function Gameplay:StartGameplay(Map : Model)
    isPlaying = true
    local PlayersAlive = Players:GetPlayers()
    -- // Round Animasyonları yapılacak


    -- // Animasyondan sonra:
    task.wait(2)
    local spins = {}
    local BombPlayer = PlayersAlive[math.random(1,#PlayersAlive)]
    local Bomb = ReplicatedStorage.Assets.Bomb:Clone()
    Bomb.Parent = BombPlayer.Character
    Bomb:PivotTo(CFrame.new(BombPlayer.Character.Head.Position + Vector3.new(0,5,0)))
    
    local weld = Instance.new('WeldConstraint')
    weld.Parent = Bomb
    weld.Part0 = BombPlayer.Character.HumanoidRootPart
    weld.Part1 = Bomb.Hitbox
    for _,v in Map:GetDescendants() do
        if v:IsA('Model') and v.Name == 'SpinningHammer' then
            table.insert(spins, v)
        end
    end
    local hb_connection = RunService.PostSimulation:Connect(function(deltaTime)
        for _,v in spins do
            if v:IsA('Model') and v.Name == 'SpinningHammer' then
                local rotation = CFrame.Angles(0, 0, math.rad(90 * deltaTime))
                local modelCFrame = v:GetPivot()
                v:PivotTo(modelCFrame * rotation)
            end
        end
    end)

    for _,spin in spins do
        for _,part in spin:GetChildren() do
            if part:IsA('BasePart') then
                part.Touched:Connect(function(Hit)
                    if Hit.Parent:IsA('Model') and Hit.Parent:FindFirstChildOfClass('Humanoid') and Hit.Parent:FindFirstChild('IsRagdoll') then
                        task.spawn(function()
                              Hit.Parent.IsRagdoll.Value = true
                              task.wait(3)
                              Hit.Parent.IsRagdoll.Value = false
                        end)
                    end
                end)
            end
        end
    end
    

end

--[[ Misc ]] --


function Gameplay:KnitStart()
    print('Catch The Bomb has been started')
end


function Gameplay:KnitInit()
    print('Catch The Bomb has been initialized')
end

return Gameplay