--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')



local Knit = require(ReplicatedStorage.Packages.Knit)

local VoteController = Knit.CreateController { Name = "VoteController" }


function VoteController:KnitStart()
    print('VoteController has been started')
    local VoteService = Knit.GetService('VoteService')
 --   VoteService.Vote:Fire('Obby')
    VoteService.DisplayVote:Connect(function(Mode, Sections)

    end)
end


function VoteController:KnitInit()
    print('VoteController has been initialized')
end


return VoteController