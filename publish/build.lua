local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

local game = roblox.deserializePlace(fs.readFile("package-template.rbxl"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")

fs.writeFile("package-template.rbxm", roblox.serializeModel({ ReplicatedStorage:FindFirstChild("Packages") }))
