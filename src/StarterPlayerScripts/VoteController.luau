--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)

local VoteController = Knit.CreateController { Name = "VoteController" }


function VoteController:KnitStart()
    print('VoteController has been started')
    local VoteService = Knit.GetService('VoteService')
    task.wait(20)
    print('VOTING!!')
    VoteService.Vote:Fire('Obby')
end


function VoteController:KnitInit()
    print('VoteController has been initialized')
end


return VoteController