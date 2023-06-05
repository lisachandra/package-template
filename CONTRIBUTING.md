# Contributing
## Working on package-template
To get started working on package-template, you'll need:
- A purpose (maybe you're fixing, adding or removing something)
- [Wally](https://github.com/UpliftGames/wally)
- [Foreman](https://github.com/Roblox/foreman)
- [Rojo](https://github.com/rojo-rbx/rojo/)
- [Luau LSP](https://github.com/JohnnyMorganz/luau-lsp)

And an intermediate understanding of:
- [Luau](https://luau-lang.org)
- [Type checking](https://luau-lang.org/typecheck)

Then you should:

- Create a fork from the main branch
- Install required wally packages
- Generate a rojo sourcemap with dev.project.json

## Pull Request
Before you submit a new pull request, check:
- Up-to-date: Ensure your code isn't outdated
- Code Style: Ensure your code follows the [offical Roblox Lua style guide](https://roblox.github.io/lua-style-guide)
- Tests: Run and add nescessary tests with [TestEZ](https://github.com/Roblox/testez) (no errors allowed!)
- Analyze: Analyze your code with [Luau LSP](https://github.com/JohnnyMorganz/luau-lsp) (no errors allowed!)
- Squashing: Squash your commits into a single commit with [git's interactive rebase](https://docs.github.com/en/get-started/using-git/about-git-rebase)
