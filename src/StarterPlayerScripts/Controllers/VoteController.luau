--[[ Directories ]] --

local Players = game.Players
local LocalizationService = game:GetService('LocalizationService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')

local Knit = require(ReplicatedStorage.Packages.Knit)

local VoteController = Knit.CreateController { Name = "VoteController" }
local PlayerGui = game.Players.LocalPlayer:WaitForChild('PlayerGui')
local VoteUI = PlayerGui:WaitForChild('HUD'):WaitForChild('Canvas').VoteMenus

VoteUI.Position -= UDim2.new(0,0,1,0)
local isHiding = true
function VoteController:KnitStart()
    print('VoteController has been started')
    local VoteService = Knit.GetService('VoteService')
    VoteService.DisplayVote:Connect(function(Mode, sections)
        print(sections)
        for index,v in VoteUI:GetChildren() do
            if v.Name ~= 'UIListLayout' then
                 local section = sections[index - 1]
                 v.Mapname.Text = section
                 -- [[ Add Photography Later On Kuzey ]] --
            end
           
        end
        VoteUI.Visible = true
        isHiding = false
        TweenService:Create(VoteUI,TweenInfo.new(0.5,Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = VoteUI.Position + UDim2.new(0,0,1,0)}):Play()
    end)

    VoteService.HideVotes:Connect(function()
        if isHiding == true then
            return
        end
        TweenService:Create(VoteUI,TweenInfo.new(0.5,Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = VoteUI.Position - UDim2.new(0,0,1,0)}):Play()
    end)

    for index,v in VoteUI:GetChildren() do
        if v.Name ~= 'UIListLayout' then
            v.Button.Votebutton.MouseButton1Up:Connect(function()
                local toVote = v.Mapname.Text
                VoteService.Vote:Fire(toVote)
                isHiding = true
                TweenService:Create(VoteUI,TweenInfo.new(0.5,Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = VoteUI.Position - UDim2.new(0,0,1,0)}):Play()
            end)
        end
       
    end

end


function VoteController:KnitInit()
    print('VoteController has been initialized')
end


return VoteController