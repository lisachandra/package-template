local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local TestEZ = require(Packages.TestEZ)

TestEZ.TestBootstrap.run(TestEZ.TestBootstrap :: any, { ServerScriptService.Tests }, TestEZ.Reporters.TextReporter, {})
