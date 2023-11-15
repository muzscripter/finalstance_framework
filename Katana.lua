local Module = {}

local function Weld(A: BasePart, B: BasePart, Offset: CFrame, Name: string?)
	A.CFrame = B.CFrame * Offset
	
	local ExistingWeld = A:FindFirstChild("WeldConstraint")
	if ExistingWeld then
		if ExistingWeld.Name == 'KatanaWeld' then
			print('Found katana weld')
			
			ExistingWeld.Part0 = A
			ExistingWeld.Part1 = B
		end
	else
		local WeldConstraint = Instance.new('WeldConstraint')
		WeldConstraint.Part0 = A
		WeldConstraint.Part1 = B
		WeldConstraint.Parent = A
		WeldConstraint.Name = Name or string.format('Weld-%s', A.Name)
	end
end

function Module.Setup(Player)
	print('[SERVER] Attempting to setup katana')
	
	local Humanoid = Player.Character.Humanoid
	local Character = Player.Character
	local HumanoidRootPart = Character.HumanoidRootPart
	
	
	if not Character:FindFirstChild('Katana') then
		local Katana = (game:GetService('ReplicatedStorage'):WaitForChild('ref-graverealm')).Katana:Clone()
		local Sheathe = (game:GetService('ReplicatedStorage'):WaitForChild('ref-graverealm3')).Sheathe:Clone()
		local KatanaPart = Character:WaitForChild(Katana.Handle.ObjectValue.Value.Name)
		local SheathePart = Character:WaitForChild(Sheathe.Handle.ObjectValue.Value.Name)
		
		Weld(Katana.Handle, KatanaPart, Katana.Handle.ObjectValue.Value.CFrame:Inverse() * Katana.Handle.CFrame, 'KatanaWeld')
		Weld(Sheathe.Handle, SheathePart, Sheathe.Handle.ObjectValue.Value.CFrame:Inverse() * Sheathe.Handle.CFrame)

		Katana.Parent = Character
		Sheathe.Parent = Character
	else
		print('[SERVER] Player already has a katana')
	end
end

function Module.ChangeState(Player: any, State: boolean)
	local Humanoid = Player.Character.Humanoid
	local Character = Player.Character
	local HumanoidRootPart = Character.HumanoidRootPart
	
	if Character:FindFirstChild('Katana') then
        if State == true then
            local EquipTrack = Humanoid:LoadAnimation(game:GetService('ReplicatedStorage'):WaitForChild('EquipKatana'))
            EquipTrack.Priority = Enum.AnimationPriority.Action4
            
            EquipTrack:Play()
            
            local Sound = game:GetService('ReplicatedStorage')["Sheathe / Unseathe"]:Clone()
            Sound.PlayOnRemove = true
            Sound.Volume = 1
            Sound.Parent = Character
            Sound:Destroy()
            Sound = nil
            
            local Katana = Character:FindFirstChild('Katana')
            local Katana2 = game:GetService('ReplicatedStorage'):WaitForChild('ref-graverealm2').Katana
            local KatanaPart = Katana2:WaitForChild('Handle').ObjectValue.Value.Name
            
            local ExistingWeld = Katana.Handle:FindFirstChild("KatanaWeld")
            if ExistingWeld then
                
                Katana.Handle.CFrame = KatanaPart * Katana.Handle.ObjectValue.Value.CFrame:Inverse() * Katana.Handle.CFrame
                
                ExistingWeld.Part0 = Katana.Handle
                ExistingWeld.Part1 = KatanaPart
            end
            
            Katana.Parent = Character
        elseif State == false then
            print('[SERVER] Unequip weapon.')
        end

        return error('Failed to get proper state')
	end
	
end

function Module.M1()
end

function Module.Heavy()
end

return Module
