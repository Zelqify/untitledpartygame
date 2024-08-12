--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)
local RoundConfig = require(Main.RoundConfig)


local RoundService = Knit.CreateService{
    Name = 'RoundService',
    _ForceStop = false,
    Client = {
        Update = Knit.CreateSignal()
    }
}


-- [[ Other Directories ]] --

local VoteService = require(ServerStorage.Services.VoteService.VoteService)

--[[ Main Systems ]] --

local function SpawnMap(Mode, Map)
    local map = ReplicatedStorage.Maps[Mode][Map]:Clone()
    map.Parent = game.Workspace
    return map
end

local function SpawnPlayers(Map : Model)
    for index,v in Players:GetChildren() do
        local Character = v.Character
        if Character == nil then
            v.CharacterAdded:Wait()
            Character = v.Character
        end
        local TP_CFrame = CFrame.new(Map:FindFirstChild('Spawns'):GetChildren()[index].Position, Map.WorldPivot.Position)
        Character:PivotTo(TP_CFrame)
    end
end

local function coreLoop()
    while true do
        assert(not RoundService._ForceStop, 'Game has been force stopped.')
        for timer = RoundConfig['IntermissionDuration'], 0, -1 do
            RoundService.Client.Update:FireAll('Intermission: ' .. timer)
            task.wait(1)
        end
        local ModeResults = VoteService.new('Gamemode')
        RoundService.Client.Update:FireAll('Selected gamemode is: ' .. ModeResults)
        task.wait(2)
        local MapResults = VoteService.new('Map', ModeResults)
        RoundService.Client.Update:FireAll('Selected map is: ' .. MapResults)
        local CurrentMap = SpawnMap(ModeResults, MapResults)
        for _,v in CurrentMap:GetDescendants() do
            if v:IsA('HingeConstraint') then
                v.Enabled = true
            end
            if v.Name == 'SpinningHammer' then
                for _,obj in v:GetDescendants() do
                    if obj:IsA('BasePart') and obj.Name ~= 'Center' then
                        obj.Anchored = false
                    end
                end
            end
        end
        task.wait(5)
        SpawnPlayers(CurrentMap)
        local GameplayService = Knit.GetService(ModeResults)
        local LeaderboardResults = GameplayService:StartGameplay(CurrentMap)
        local WinnersString = table.concat(LeaderboardResults, ', ', 1,#LeaderboardResults)
        RoundService.Client.Update:FireAll(WinnersString .. ' has won the game!')
        task.wait(4)
        CurrentMap:Destroy()
    end
end

--[[ Misc ]] --


function RoundService:KnitStart()
    print('RoundService has been started')
    coreLoop()
end


function RoundService:KnitInit()
    print('RoundService has been initialized')
end

return RoundService