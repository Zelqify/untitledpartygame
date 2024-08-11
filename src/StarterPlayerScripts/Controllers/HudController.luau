--[[ Directories ]] --

local Players = game.Players
local ReplicatedStorage = game:GetService('ReplicatedStorage')


local Knit = require(ReplicatedStorage.Packages.Knit)

local HudController = Knit.CreateController { Name = "HudController" }

-- [[ Secondary Directories ]] --

local PlayerGui = game.Players.LocalPlayer:WaitForChild('PlayerGui')
local HUDUI = PlayerGui:WaitForChild('HUD')
local HudText = HUDUI:WaitForChild('Canvas'):WaitForChild('HudFrame'):WaitForChild('HudText')

-- [[ Main Systems ]] --
function HudController:KnitStart()
    print('HudController has been started')
    local RoundService = Knit.GetService('RoundService')
    RoundService.Update:Connect(function(Text)
        HudText.Text = Text
    end)
end


function HudController:KnitInit()
    print('HudController has been initialized')
end


return HudController