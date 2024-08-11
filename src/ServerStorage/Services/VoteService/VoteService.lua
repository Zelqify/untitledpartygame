--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Knit = require(ReplicatedStorage.Packages.Knit)
local VoteConfig = require(Main.VoteConfig)

local VoteService = Knit.CreateService{
    Name = 'VoteService',
    Client = {
        Vote = Knit.CreateSignal(),
        DisplayVote = Knit.CreateSignal()
    },
}

--[[ Main Systems ]] --
local availableVotings = {}
local clientsVoted = {}

local RoundService

function VoteService.new(VotingType, args)
    if VotingType == 'Gamemode' then
        table.clear(availableVotings)
        table.clear(clientsVoted)
        for i = 1,3 do
            local selected 
            repeat
                selected = VoteConfig.GameModes[math.random(1,#VoteConfig.GameModes)]
                local doesExist 
                if availableVotings[selected] then
                    doesExist = true
                else
                    doesExist = false
                end
                task.wait()
            until not doesExist
            availableVotings[selected] = 0
        end
        local toPass =  {}
        for section,_ in availableVotings do
            table.insert(toPass, section)
        end
        
        VoteService.Client.DisplayVote:FireAll('Gamemode', toPass)
        for timer = VoteConfig.VoteDuration, 0,-1 do
            RoundService.Client.Update:FireAll('Now vote for a game mode! (' .. timer .. ')')
            task.wait(1)
        end
        local results
        local best_voted = 0
        local equals = {}

        for section,vote_amount in availableVotings do
            if vote_amount > best_voted then
                table.clear(equals)
                best_voted = vote_amount
                results = section
                table.insert(equals, results)
            elseif vote_amount == best_voted then
                table.insert(equals, section)
            end
        end

        if #equals > 1 then
            results = equals[math.random(1,#equals)]
        end
        availableVotings = {}
        clientsVoted = {}
        return results
    elseif VotingType == 'Map' then
        table.clear(availableVotings)
        table.clear(clientsVoted)
        for i = 1,3 do
            local selected 
            repeat
                selected = VoteConfig.Maps[args][math.random(1,3)]
                local doesExist 
                if availableVotings[selected] then
                    doesExist = true
                else
                    doesExist = false
                end
                task.wait()
            until not doesExist
            availableVotings[selected] = 0
        end
        local toPass =  {}
        for section,_ in availableVotings do
            table.insert(toPass, section)
        end
        
        VoteService.Client.DisplayVote:FireAll('Map', toPass)
        for timer = VoteConfig.VoteDuration, 0,-1 do
            RoundService.Client.Update:FireAll('Now vote for a map! (' .. timer .. ')')
            task.wait(1)
        end
        local results
        local best_voted = 0
        local equals = {}

        for section,vote_amount in availableVotings do
            if vote_amount > best_voted then
                table.clear(equals)
                best_voted = vote_amount
                results = section
                table.insert(equals, results)
            elseif vote_amount == best_voted then
                table.insert(equals, section)
            end
        end

        if #equals > 1 then
            print('Selecting from equals.')
            results = equals[math.random(1,#equals)]
        end
        availableVotings = {}
        clientsVoted = {}
        return results

    else
        warn('Unable to start voting: Unknown VotingType')
    end
end

--[[ Client Systems ]] --






--[[ Misc ]] --


function VoteService:KnitStart()
    print('VoteService has been started')
    RoundService = Knit.GetService('RoundService')
    VoteService.Client.Vote:Connect(function(Client, Vote)
        if clientsVoted[Client] ~= nil then
            local section = clientsVoted[Client]
            availableVotings[section] -= 1
            clientsVoted[Client] = nil
        end
        if availableVotings[Vote] == nil then
            return
        end
        availableVotings[Vote] += 1
        clientsVoted[Client] = Vote
    end)
end


function VoteService:KnitInit()
    print('VoteService has been initialized')
end

return VoteService