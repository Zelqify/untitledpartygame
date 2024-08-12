--[[ Directories ]] --
-- [[ Catch The Bomb ]] --
local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(script.Parent.Config)
local Gameplay = Knit.CreateService{
    Name = 'Catch the Bomb',
    Client = {}
}


-- [[ Other Directories ]] --


--[[ Main Systems ]] --


local isPlaying = false
local counting = false
local RoundService

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

    local Highlight = ReplicatedStorage.Assets.TargetedHighlight:Clone()
    local TimerGui = ReplicatedStorage.Assets.TimerGui:Clone()

    Highlight.Parent = BombPlayer.Character
    Highlight.Enabled = true
    TimerGui.Parent = Bomb.Hitbox
    
    RoundService.Client.Update:FireAll('Be the last to get exploded to win the game!')

    local weld = Instance.new('WeldConstraint')
    weld.Parent = Bomb
    weld.Part0 = BombPlayer.Character.HumanoidRootPart
    weld.Part1 = Bomb.Hitbox

    for _,v in Map:GetDescendants() do
        if v:IsA('Model') and v.Name == 'SpinningHammer' then
            table.insert(spins, v)
        end
    end

    local function Reshuffle()
        BombPlayer = PlayersAlive[math.random(1,#PlayersAlive)]
        Bomb = ReplicatedStorage.Assets.Bomb:Clone()
        Bomb.Parent = BombPlayer.Character
        Bomb:PivotTo(CFrame.new(BombPlayer.Character.Head.Position + Vector3.new(0,5,0)))
        
        TimerGui = ReplicatedStorage.Assets.TimerGui:Clone()
        TimerGui.Parent = Bomb.Hitbox

        local weld = Instance.new('WeldConstraint')
        weld.Parent = Bomb
        weld.Part0 = BombPlayer.Character.HumanoidRootPart
        weld.Part1 = Bomb.Hitbox
        
        Highlight = ReplicatedStorage.Assets.TargetedHighlight:Clone()
        Highlight.Parent = BombPlayer.Character

        TimerGui.Enabled = true
        counting = true
    end
    -- // Spin Handler
    local hb_connection = RunService.PostSimulation:Connect(function(deltaTime)
        for _,v in spins do
            if v:IsA('Model') and v.Name == 'SpinningHammer' then
                local rotation = CFrame.Angles(0, 0, math.rad(90 * deltaTime))
                local modelCFrame = v:GetPivot()
                v:PivotTo(modelCFrame * rotation)
            end
        end
    end)
    local countdownFrom = Config.BombStartDuration

    task.spawn(function()
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
    end)
    local function resizeModel(model, a)
        local base = model.PrimaryPart
        for _, part in pairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Position = base.Position:Lerp(part.Position, a)
                part.Size *= a
            end
        end
    end
    -- // Bomb System,
            -- Explosion
    local function Explosion()
        local Explosion = Instance.new('Explosion')
        Explosion.Parent = Bomb.Hitbox
        local scale = Instance.new('NumberValue')
        scale.Parent = game.Workspace
        scale.Value = 1
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Value = 5}):Play()
        local lastValue = scale.Value
        scale.Changed:Connect(function(value)
            resizeModel(Bomb, value / lastValue)
            lastValue = value
        end)
        for _,v in Bomb:GetChildren() do
            if v:IsA('BasePart') then
                TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Transparency = 1}):Play()
            end
        end
        BombPlayer.Character.Humanoid.Health = 0
        counting = false
        Highlight:Destroy()
        task.wait(0.2)
        Bomb:Destroy()
        task.wait(1)
        for index,player in PlayersAlive do
            if player == BombPlayer then
                PlayersAlive[index] = nil
            end
        end
        Reshuffle()
    end
            -- Bomb Countdown
    counting = true
    task.spawn(function()
        while isPlaying do
            if counting == true then
                 for Count = countdownFrom,0,-1 do
                task.wait(0.01)
                if string.len(tostring(Count)) == 4 then
                    local minute = 0
                    local second = tonumber(string.sub(tostring(Count),1,2))
                    if second >= 60 then
                        local fitted = math.round(second / 60 )
                        second -= fitted * second
                        minute = fitted
                    end
                    local millisecond = tonumber(string.sub(tostring(Count),3,4))
                    TimerGui.Timer.Text = '0' .. minute .. ':' .. second .. ':' .. millisecond
                end
                if string.len(tostring(Count)) == 3 then
                    local minute = 0
                    local second = string.sub(tostring(Count),1,1)
                    local millisecond = string.sub(tostring(Count),2,3)
                    TimerGui.Timer.Text = '0' .. minute .. ':' .. second .. ':' .. millisecond
                end
                if string.len(tostring(Count)) == 2 then
                    TimerGui.Timer.Text = '00:00:' .. Count
                end
                if string.len(tostring(Count)) == 1 then
                    TimerGui.Timer.Text = '00:00:0' .. Count
                end
                if Count == 0 then
                    Explosion()
                end
            end
        else
            task.wait()
            return
        end
           
        end
    end)
    -- // Round System

    RunService.Heartbeat:Connect(function(deltaTime)
        if #PlayersAlive <= 1 then
            hb_connection:Disconnect()  
            isPlaying = false
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if table.find(PlayersAlive, player) then
            for i,v in PlayersAlive do
                if player == v then
                    PlayersAlive[i] = nil
                end
            end
        end
        if player == BombPlayer then
            Reshuffle()
        end
    end)
    while true do
        task.wait()
        if isPlaying == false then
            Bomb:Destroy()
            Highlight:Destroy()

            return PlayersAlive
        end
    end
end

--[[ Misc ]] --


function Gameplay:KnitStart()
    print('Catch The Bomb has been started')
    RoundService = Knit.GetService('RoundService')
end


function Gameplay:KnitInit()
    print('Catch The Bomb has been initialized')
end

return Gameplay