# macOS Utility

**Swift** utility for interacting with **macOS**.

## Usage

### Toggle

The `toggle` subcommand is used to toggle an application between Active and hidden.

This can be useful in combination with a keyboard manager utility to bind an application to a keyboard shortcut for "_Quake-style_" functionality.

For example, using [`skhd`](https://github.com/koekeishiya/skhd):

```zsh
# Toggle WezTerm with ⇧⌘C
shift + cmd - t: MacOSUtility toggle --name=WezTerm --bundle-id='com.github.wez.wezterm'
# Toggle Visual Studio Code with ⇧⌘A
shift + cmd - a: MacOSUtility toggle --name=Code --bundle-id='com.microsoft.VSCode'
```
