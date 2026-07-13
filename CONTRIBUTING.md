# Contributing

## One-time setup

This repo ships its own git hooks, no npm/husky needed. Point git at them once:

```
git config core.hooksPath .githooks
```

That's it. From then on your commits get checked locally before they land.

## Commit convention

Commits follow [Conventional Commits](https://www.conventionalcommits.org):

```
type(scope): short description
```

Allowed types:

| Type       | Use for                                      |
|------------|-----------------------------------------------|
| `feat`     | a new feature                                 |
| `fix`      | a bug fix                                     |
| `docs`     | documentation only                            |
| `style`    | formatting, no code change                    |
| `refactor` | code change that isn't a fix or a feature     |
| `perf`     | performance improvement                       |
| `test`     | adding or fixing tests                        |
| `build`    | build system or dependencies                  |
| `ci`       | CI configuration                              |
| `chore`    | maintenance, no src or test changes           |
| `revert`   | reverts a previous commit                     |

Examples:

```
feat(sr): add per-device toggle support
fix(install): handle missing ~/.local/bin
docs(readme): clarify uninstall steps
chore: bump license year
```

Scope is optional. Breaking changes get a `!` before the colon, e.g. `feat!: drop support for bash`.

The `commit-msg` hook will reject anything that doesn't match this format. The `pre-commit` hook runs a quick syntax check on the shell scripts and, if you have [shellcheck](https://www.shellcheck.net) installed, lints them too.
