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
}

--[[ Main Systems ]] --


local function coreLoop()
    while true do
        assert(not RoundService._ForceStop, 'Game has been force stopped.')
        for timer = RoundConfig['IntermissionDuration'], 0, -1 do
            print('Intermission: ' .. timer)
            task.wait(1)
        end
        
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