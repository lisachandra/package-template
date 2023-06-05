local game = remodel.readPlaceFile("package-template.rbxl")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
remodel.writeModelFile("package-template.rbxm", ReplicatedStorage:FindFirstChild("package-template") :: RemodelInstance)
