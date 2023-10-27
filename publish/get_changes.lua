--!nonstrict

local stdio = require("@lune/stdio")
local fs = require("@lune/fs")

local changelog = fs.readFile("../CHANGELOG.md")

local title_pattern = "##%s*%d+%.%d+%.%d+%s*-%s*%d%d%d%d%-%d%d%-%d%d"

local changes = {}
local found = false
local index = 0

for change in changelog:gmatch("([^\n]+)") do
    index += 1; if index < 5 then
        continue
    end

    if change:match(title_pattern) then
        if found then
            break
        else
            found = true
        end
    end

    table.insert(changes, change)
end

stdio.write(table.concat(changes, "\n"))
