# WoW Swing Timer

A World of Warcraft Classic addon that displays swing timers for your main hand and off-hand weapons.

## Features

- **Real-time swing tracking**: Shows progress bars for main hand and off-hand weapon swings
- **Customizable UI**: Movable frame with configurable appearance
- **Dual wield support**: Automatically detects and shows off-hand timer when dual wielding
- **Slash commands**: Easy configuration through chat commands
- **Persistent settings**: Saves your preferences between sessions

## Installation

1. Download or clone this repository
2. Copy the `WowSwingTimer` folder to your WoW Classic `Interface\AddOns\` directory
3. Restart World of Warcraft or reload your UI (`/reload`)
4. Enable the addon in the AddOns menu at character selection

## Usage

### Slash Commands

- `/swingtimer` or `/st` - Show available commands
- `/swingtimer toggle` - Enable/disable the addon
- `/swingtimer reset` - Reset frame position to center

### Moving the Frame

Click and drag the swing timer frame to move it anywhere on your screen. The position will be saved automatically.

## How It Works

The addon monitors combat log events to detect when you perform weapon swings. It then starts timers based on your current weapon speeds, showing:

- **Main Hand (MH)**: Yellow progress bar for your main hand weapon
- **Off Hand (OH)**: Blue progress bar for your off-hand weapon (when dual wielding)

The bars fill up as your swing timer progresses, helping you time your attacks optimally.

## Customization

The addon stores settings in `WowSwingTimerDB` saved variables. You can modify these through the game or by editing the defaults in `Core.lua`:

- `enabled`: Enable/disable the addon
- `showMainHand`: Show main hand timer
- `showOffHand`: Show off-hand timer
- `framePosition`: Frame position on screen
- `barWidth`: Width of the progress bars
- `barHeight`: Height of the progress bars
- `showText`: Show remaining time text
- `backgroundColor`: Background color of bars
- `fillColor`: Fill color of bars

## Requirements

- World of Warcraft Classic (Interface version 11503)
- No other addon dependencies

## Known Issues

- Initial swing detection may require starting combat first
- Off-hand detection accuracy may vary with different weapon combinations

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve the addon.

## License

This project is open source. Feel free to modify and distribute as needed.
