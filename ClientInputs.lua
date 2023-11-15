--// Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local ContextActionService = game:GetService('ContextActionService')
local TweenService = game:GetService('TweenService')

--// Variables
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local CurrentSkillSet = nil
local PlayerGui = Player.PlayerGui

Humanoid.WalkSpeed = 10
local CustomMovement = require(script:WaitForChild('CustomMovement'))
local HoldingWKey

local InputBegan = coroutine.create(function()
	UserInputService.InputBegan:Connect(function(ClientInput, GameProcessedEvent)
		if GameProcessedEvent then return end
		local Info, Input = nil, nil
		
		if ClientInput.KeyCode == Enum.KeyCode.Q then
			CustomMovement:Dash(Player)
		end
		
		if ClientInput.KeyCode == Enum.KeyCode.E then
			Input = 'Equip'
			Info = {['Request'] = 'Katana', ['Input'] = 'Equip'}

			ReplicatedStorage.Remotes.RequestInput:FireServer(Input, Info)
			
		end
		if ClientInput.UserInputType == Enum.UserInputType.MouseButton1 then
			Input = 'M1'
			Info = {['Request'] = 'M1', ['Input'] = 'M1'}

			ReplicatedStorage.Remotes.RequestInput:FireServer(Input, Info)
		end

		if ClientInput.KeyCode == Enum.KeyCode.F then
			Input = 'Block'
			Info = {['Request'] = 'Block', ['Input'] = 'Block'}

			ReplicatedStorage.Remotes.RequestInput:FireServer(Input, Info)
		end
	end)
end)

local InputEnded = coroutine.create(function()
	UserInputService.InputEnded:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.W then
			HoldingWKey = false

			CustomMovement:Sprint(Player, Character, false)
		elseif Input.KeyCode == Enum.KeyCode.F then
			local data = {
				Request = 'Block',
				Input = 'false'
			}

			ReplicatedStorage.Remotes.characterFilter:FireServer(data)
		end
	end)
end)

local SprintTimer = 0 
local function SprintW(ActionName, InputState, InputObject)
	if ActionName == "SprintW" then
		if InputState == Enum.UserInputState.Begin then
			if DateTime.now().UnixTimestampMillis - SprintTimer <= 300 then
				CustomMovement:Sprint(Player, Character, true)
			end
			
			SprintTimer = DateTime.now().UnixTimestampMillis
		elseif InputState == Enum.UserInputState.End then
			
			print('[CLIENT] Input End')
			CustomMovement:Sprint(Player, Character, false)
		end
	end
	return Enum.ContextActionResult.Pass
end

ContextActionService:BindAction("SprintW", SprintW, false, Enum.KeyCode.W)

coroutine.resume(InputBegan)
coroutine.resume(InputEnded)
