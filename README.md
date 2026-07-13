# sr

One command to flip your macOS scroll direction. No System Settings, no menus.

```
$ sr
Scroll direction: traditional (reversed)
$ sr
Scroll direction: natural
```

## Install

```
curl -fsSL https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main/install.sh | zsh
```

This drops `sr` into `~/.local/bin` and adds that folder to your `PATH` if it isn't there already. Restart your terminal (or `source ~/.zshrc`) and you're done.

## Uninstall

```
curl -fsSL https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main/uninstall.sh | zsh
```

## How it works

macOS stores scroll direction as a global preference:

```
defaults read -g com.apple.swipescrolldirection
```

`sr` reads that value, flips it, and kills `cfprefsd` so the change applies immediately instead of waiting for apps to re-read their cached prefs.

## Limitations

This toggles scroll direction globally, mouse and trackpad together. macOS doesn't expose a per-device switch through `defaults`. If you want mouse and trackpad to scroll independently, look at [Scroll Reverser](https://github.com/pilotmoon/Scroll-Reverser), which hooks into input events at a lower level for that.

## Contributing

Commits follow [Conventional Commits](https://www.conventionalcommits.org) (`feat:`, `fix:`, `chore:`, etc.), enforced by a local git hook. See [CONTRIBUTING.md](CONTRIBUTING.md) for setup.

## License

MIT
