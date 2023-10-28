local datetime = require("@lune/datetime")
local process = require("@lune/process")
local fs = require("@lune/fs")

local function git(command: string, args: { string }): string
    local result = process.spawn("git", { command, table.unpack(args) })

    return if result.ok then result.stdout else result.stderr
end

local changelog = fs.readFile("../CHANGELOG.md")

local date = datetime.now():formatUniversalTime("%Y-%m-%d", "en")
local lastTag = git("describe", { "--tags", "--abbrev=0" })

local version = process.args[1]
local repo = process.args[2]

git("config", {
    "alias.changelog",
    `""log --pretty=format:'%s by @%an ([%h](https://github.com/{repo}/commit/%H))' --abbrev-commit""`,
})

local changesStr = `## {version} - {date}`
local changeLabels = { "Added", "Fixed", "Changed", "Removed" }
local commits = git("changelog", { `{lastTag}..HEAD` })

local authorHashes: { string } = {}
local toFormat: { [string]: {{ change: string, authorHashIndex: number }} } = {}

local authorHashPattern = "(by%s@[^%s]+%s%(%[[^%]]+%]%([%w%p]+%)%))"

local function lines(s: string)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

local function getChanges(commit: string): ({ [string]: { string } }?, number?)
    local authorHash = commit:match(authorHashPattern)
    local commit = commit:sub(1, -(#authorHash + 1))

    local changes = {}
    local related = false

    for _index, label in changeLabels do
        for index, change in commit:split(`${label:lower()}: `) do
            if change == commit or #change == 0 then continue end

            related = true
            changes[label] = changes[label] or {}

            for _index, label in changeLabels do
                change = change:split(`${label:lower()}: `)[1]
            end

            table.insert(changes[label], change)
        end
    end

    if not related then return end

    local authorHashIndex = #authorHashes + 1
    authorHashes[authorHashIndex] = authorHash

    return changes, authorHashIndex
end

for commit in lines(commits) do
    local changes, authorHashIndex = getChanges(commit)
    if not (changes and authorHashIndex) then continue end
    
    for label, subjects in changes do
        toFormat[label] = toFormat[label] or {}

        for _index, change in subjects do
            table.insert(toFormat[label], { change = change, authorHashIndex = authorHashIndex })
        end
    end
end

for label, changes in toFormat do
    changesStr = changesStr .. `\n### {label}`

    for _index, changeData in changes do
        local authorHash = authorHashes[changeData.authorHashIndex]

        changesStr = changesStr .. `\n- {changeData.change} {authorHash}`
    end
end

changesStr = changesStr .. "\n"

local newChangelog = {}
local index = 0

for line in lines(changelog) do
    index += 1; if index ~= 7 then
        table.insert(newChangelog, line)
        continue
    end

    table.insert(newChangelog, changesStr .. line)
end

if index == 6 then
    table.insert(newChangelog, changesStr)
end

fs.writeFile("../CHANGELOG.md", table.concat(newChangelog, "\n"))
