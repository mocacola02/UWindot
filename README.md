# UWindot
A log overlay, FPS counter, and command console window for Godot 4.5+ inspired by Unreal Engine 1's UWindow.

## Installation
Download the addons folder and drag it into the root of your Godot project. From there, add the `uwindot_master.tscn` scene where needed.
To add more commands, add a string match to `read_command` in `src_uwindot.gd` and custom command functions in `src_uwindot_commands.gd` (called with `CMD.[function name]`).

## License
Licensed under MIT. Please see the [LICENSE](https://github.com/mocacola02/UWindot/blob/main/LICENSE) file for more info.

## Disclaimer
No code is based on or lifted from the original UWindow concept. This is written from scratch, simply inspired by the visual layout of UWindow.
