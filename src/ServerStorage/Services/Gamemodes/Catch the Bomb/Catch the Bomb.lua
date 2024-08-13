--[[ Directories ]] --
-- [[ Catch The Bomb ]] --
local Players = game.Players
local LocalizationService = game:GetService('LocalizationService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local ServerStorage = game.ServerStorage

local Main = script.Parent

local Config = require(script.Parent.Config)

local isPlaying = false

local Gameplay = {}

function Gameplay:StartGameplay(Map : Model)
    isPlaying = true
    local PlayersAlive = Players:GetPlayers()


end

return Gameplay