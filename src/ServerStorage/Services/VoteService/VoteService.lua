--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)
local VoteConfig = require(Main.VoteConfig)

local VoteService = Knit.CreateService{
    Name = 'VoteService',
    Client = {},
}

--[[ Main Systems ]] --

function VoteService.new(VotingType)
    if VotingType == 'Gamemode' then
        
    elseif VotingType == 'Map' then

    else
        warn('Unable to start voting: Unknown VotingType')
    end
end





--[[ Misc ]] --


function VoteService:KnitStart()
    print('VoteService has been started')

end


function VoteService:KnitInit()
    print('VoteService has been initialized')
end

return VoteService