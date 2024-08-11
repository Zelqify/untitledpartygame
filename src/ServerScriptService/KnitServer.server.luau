local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Knit = require(ReplicatedStorage.Packages.Knit)

print('Starting Knit Server')
local start = tick()
Knit.AddServices(game.ServerStorage.Services.RoundService)
Knit.AddServices(game.ServerStorage.Services.VoteService)
Knit.AddServices(game.ServerStorage.Services.Gamemodes["Catch the Bomb"])

Knit.Start():andThen(function()
    local timeTaken = tick() - start
    print('Knit has been started on Server (It took total of ' .. timeTaken .. ' seconds!')
end):catch(warn)
