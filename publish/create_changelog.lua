local datetime = require("@lune/datetime")
local process = require("@lune/process")
local fs = require("@lune/fs")

local function git(command: string, args: { string })
    local result = process.spawn("git", { command, table.unpack(args) })

    return result.ok and result.stdout or result.stderr
end

local function lines(s: string)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
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

local changes = `## {version} - {date}\n`
local commitChanges: { [string]: string } = {
    Added = git("changelog", { `--grep="added:"`, `{lastTag}..HEAD` }),
    Fixed = git("changelog", { `--grep="fixed:"`, `{lastTag}..HEAD` }),
    Changed = git("changelog", { `--grep="changed:"`, `{lastTag}..HEAD` }),
    Removed = git("changelog", { `--grep="removed:"`, `{lastTag}..HEAD` }),
}

for change, commits in commitChanges do
    local toConcat = {}; for line in lines(commits) do
        print(line)
        table.insert(toConcat, "-" .. (line:match(change:lower() .. ":(.*)") or ""))
    end

    changes = changes .. `### {change}\n{table.concat(toConcat, "\n")}\n`
end

local newChangelog = {}
local index = 0

for line in lines(changelog) do
    index += 1; if index ~= 7 then
        table.insert(newChangelog, line)
        continue
    end

    table.insert(newChangelog, changes .. line)
end

if index == 6 then
    table.insert(newChangelog, changes)
end

fs.writeFile("../CHANGELOG.md", table.concat(newChangelog, "\n"))
