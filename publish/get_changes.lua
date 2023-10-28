local stdio = require("@lune/stdio")
local fs = require("@lune/fs")

local changelog = fs.readFile("../CHANGELOG.md")

local title_pattern = "##%s%d+%.%d+%.%d+%s-%s%d%d%d%d%-%d%d%-%d%d"

local function lines(s: string)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

local changes = {}
local found = false
local index = 0

for line in lines(changelog) do
    index += 1; if index < 7 then
        continue
    end

    if line:match(title_pattern) then
        if found then
            break
        else
            found = true
        end
    end

    table.insert(changes, line)
end

stdio.write(table.concat(changes, "\n"))
