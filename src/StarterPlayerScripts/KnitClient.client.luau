local ReplicatedStorage = game:GetService('ReplicatedStorage')


local Knit = require(ReplicatedStorage.Packages.Knit)


Knit.AddControllers(script.Parent)

Knit.Start():andThen(function()
    print('Knit has been started on Client!')
end):catch(warn)
