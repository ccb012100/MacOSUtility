# macOS Utility

**Swift** utility for interacting with **macOS**.

## Usage

### Toggle

The `toggle` subcommand is used to toggle an application between Active and hidden.

This can be useful in combination with a keyboard manager utility to bind an application to a keyboard shortcut for "_Quake-style_" functionality.

#### Configure in [skhd](https://github.com/koekeishiya/skhd)

```zsh
# Toggle WezTerm with ⇧⌘T
shift + cmd - t: $HOME/.local/bin/MacOSUtility toggle com.github.wez.wezterm
# Toggle Visual Studio Code with ⇧⌘A
shift + cmd - a: $HOME/.local/bin/MacOSUtility toggle com.microsoft.VSCode
```

#### Configure in [Karabiner-Elements](https://karabiner-elements.pqrs.org/)

```zsh
{
    "description": "Toggle WezTerm with ⇧⌘T",
    "manipulators": [
        {
            "from": {
                "key_code": "t",
                "modifiers": {
                    "mandatory": [
                        "left_shift",
                        "left_command"
                    ]
                }
            },
            "to": [
                {
                    "shell_command": "$HOME/.local/bin/MacOSUtility toggle 'com.github.wez.wezterm'"
                }
            ],
            "type": "basic"
        }
    ]
}
```