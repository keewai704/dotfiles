[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&size=30&letterSpacing=tiny&duration=2000&pause=3000&color=F7F7F7&center=true&vCenter=true&width=435&lines=Eli's+Dotfiles)](https://git.io/typing-svg)

<img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice7.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice1.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice4.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice5.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice6.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/rice3.png" width = "50%">


> [!TIP]
> Check out [MyFetch](https://github.com/elifouts/MyFetch) now!

This contains My **Arch** Linux Dotfiles for a clean-looking lightweight **Hyprland** setup.

***ENJOY!!***

-Eli F.


> [!WARNING] 
>  
> All configurations are wired to `Matugen`.
>

Matugen generates the live theme from your wallpaper. A few compatibility files are still written under `~/.cache/wal` so older app configs and `pywal.nvim` can keep reading the color names they expect.

# Install

> [!CAUTION]
> 
> This script is experimental and might not work properly. Please make sure you know what you are doing ***Please Please Please***
<details>
  <summary>Arch Install Script</summary>
  
- With this script you should be able to install everything together, or the applications and their configs individually.
- Dont worry it only really installs what is needed unless you select the everything script.

  ```
  cd && git clone https://github.com/elifouts/Dotfiles.git dotfiles
  cd ~/dotfiles/InstallScripts
  chmod +x install.sh
  ./install.sh
  ```  
</details>


## My Applications




<details>
  
  <summary>🚥 Waybar</summary>
  
![waybar1](https://github.com/elifouts/Dotfiles/blob/main/images/waybar1.png)
![waybar2](https://github.com/elifouts/Dotfiles/blob/main/images/waybar6.png)
![waybar3](https://github.com/elifouts/Dotfiles/blob/main/images/waybar4.png)
![waybar4](https://github.com/elifouts/Dotfiles/blob/main/images/waybar3.png)
![waybar5](https://github.com/elifouts/Dotfiles/blob/main/images/waybar2.png)

  
  ## Overview
  This is my minimal Waybar setup for Hyprland, designed to be clean and efficient. It includes all the essential features I wanted in Waybar. For additional needs like volume control, I use `swaync`, which can be triggered from Waybar. 

  ## Workspaces
  I’ve configured the workspaces so that if there is content on a workspace, the dot appears darker. This helps you keep track of your open content! Inspiration from [Gbar](https://github.com/scorpion-26/gBar).

  ![2025-01-04-030026_hyprshot](https://github.com/user-attachments/assets/31668572-b35d-4acb-8525-8cb0e5669101)
  
  ## Expanding Waybar
  In the screenshot below, you’ll see a method to hide and reveal certain widgets you don’t need all the time. You can easily add or remove widgets in `~/.config/waybar/config` under the `group/expand` section.
  
  - **Network Widget**: I’ve configured it to not display your IP by default (it did that for some reason). Clicking the network widget opens `nmtui` in an available terminal emulator.
  
  - **Hyprpicker Widget**: This custom widget lets you use `hyprpicker`, display values when hovered, and copy the hex value to your clipboard.
    
    ![image](https://github.com/user-attachments/assets/f8c723c0-a9c9-4fa6-a3c8-bda06e81f81d)

  ## Configuration
  
  ### *How To Install*
1. **Install [Waybar](https://github.com/Alexays/Waybar)**
2. Copy the `Dotfiles/.config/waybar` folder into `~/.config`

***NOTE*** *Run Matugen once with a wallpaper or Waybar will not have generated colors to load.*

  ### Dependencies
  ```
  waybar
  kitty
  hyprpicker
  matugen
  pacman-contrib
  libnotify
  wl-clipboard
  blueman
  bluez
  networkmanager
  swaync
  paru
  ```

  ### How to Add Blur

  Add this to the end of your `hyprland.conf`:
  
  ```
  layerrule = blur, waybar
  layerrule = ignorezero, waybar
  layerrule = ignorealpha 0.5, waybar
  ```

</details>


<details>
  <summary>🔍 Wofi</summary>
    <img src="https://github.com/elifouts/Dotfiles/blob/main/images/wofi1.png" width = "35%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wofi2.png" width = "35%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wofi3.png" width = "35%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wofi4.png" width = "35%">


  ## Configuration

  ### *How To Install*
  
1. **Install `Wofi`:**

   ```
    sudo pacman -S wofi
   ```
   
2. Copy the `Dotfiles/.config/wofi` folder into `~/.config`
3. **Launching Wofi**
    - I launch wofi like this:
   
      ```config
      wofi --show drun -n
      ```

### How to Add Blur to Wofi

Add this to the end of your `hyprland.conf`:

```
layerrule = blur, wofi
layerrule = ignorezero, wofi
layerrule = ignorealpha 0.5, wofi
```

### `Matugen` with Wofi

**If you want Matugen colors**
- Keep the generated color import at the top of `~/.config/wofi/style.css`.
**If you don't want Matugen colors**
- You can remove the top line of your style.css and replace the colors at the top with your desired choice.
</details>

<details>
  <summary>🔔 Swaync</summary>
  <img src="https://github.com/elifouts/Dotfiles/blob/main/images/swaync1.png" width = "20%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/swaync2.png" width = "20%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/swaync3.png" width = "20%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/swaync4.png" width = "20%">


  ## Configuration
  
  ### *How To Install*
  
1. **Install [Swaync](https://github.com/ErikReider/SwayNotificationCenter)**
2. Copy the `Dotfiles/.config/swaync` folder into `~/.config`

  ### Dependencies for `Swaync`
  ```
  swaync
  matugen
  gvfs
  libnotify
  ```
  
  ### How to Add Blur to Swaync
  
  Add this to the end of your `hyprland.conf`:
  
  ```
  layerrule = blur, swaync-control-center
  layerrule = blur, swaync-notification-window
  layerrule = ignorezero, swaync-control-center
  layerrule = ignorezero, swaync-notification-window
  layerrule = ignorealpha 0.5, swaync-control-center
  layerrule = ignorealpha 0.5, swaync-notification-window
  ```

</details>

<details>
  <summary>🔒 Hyprlock</summary>
  <img src="https://github.com/elifouts/Dotfiles/blob/main/images/lock1.PNG" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/lock2.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/lock3.png" width = "50%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/lock4.png" width = "50%">
  
  ## Overview
    
  - Hyprlock uses the current wallpaper from Matugen to generate a background, displays a greeting with your username, and applies Matugen colors.
  - You can bind Hyprlock to a key, use it with `hypridle`, or configure it however you prefer.
  - If you want to configure `hypridle` as well, I’ve included a `hypridle.conf` file in the same directory as Hyprlock.

  ## Configuration
  
  ### *How To Install*
1. **Install [Hyprlock](https://github.com/hyprwm/hyprlock/)**
2. Copy `Dotfiles/.config/hypr/hyprlock.conf` to `~/.config/hypr`

</details>

<details>
  <summary>🚪 Login Manager (SDDM)</summary>

  ## Overview

  - This uses `sddm` with the Qt6 `sddm-astronaut-theme`.
  - The installer adds a custom Dotfiles theme variant that uses `wallpapers/pywallpaper.jpg`, the same warm sky wallpaper the rest of the setup starts from.
  - SDDM is only enabled after you confirm it, so it will not replace another display manager by accident.

  ### *How To Install*
1. Run the installer and choose **Login manager (SDDM)**:

   ```bash
   cd ~/dotfiles/InstallScripts
   ./install.sh
   ```

2. Preview the greeter without logging out:

   ```bash
   sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme
   ```

  ### Dependencies
  ```
  sddm
  sddm-astronaut-theme
  qt6-5compat
  qt6-declarative
  qt6-multimedia-ffmpeg
  qt6-svg
  qt6-virtualkeyboard
  bibata-cursor-theme-bin
  ```

</details>

<details>
  <summary>Tailscale Exit Node</summary>

  ## Overview

  - Installs persistent IP forwarding config at `/etc/sysctl.d/99-tailscale.conf`.
  - Installs a NetworkManager dispatcher hook that applies Tailscale's UDP GRO forwarding tuning to the default route interface.
  - Can enable `tailscaled`, Tailscale SSH, and exit-node advertisement.

  ### *How To Install*

1. Run the installer and choose **Tailscale exit node**:

   ```bash
   cd ~/dotfiles/InstallScripts
   ./install.sh
   ```

2. Approve **Use as exit node** in the Tailscale admin console if it is not auto-approved.

  ### Dependencies
  ```
  tailscale
  ethtool
  NetworkManager
  ```

</details>

<details>
  <summary>⌨️ Fcitx5 Input Method</summary>

  ## Overview

  - Hyprland starts `fcitx5 -d` and exports the Wayland-friendly input method environment.
  - `XMODIFIERS` is set for X11/XWayland apps.
  - `QT_IM_MODULE` and `QT_IM_MODULES` are set for Qt on non-KWin compositors.
  - GTK uses `gtk-3.0/settings.ini`, `gtk-4.0/settings.ini`, and `.gtkrc-2.0` instead of a global `GTK_IM_MODULE`.
  - The included default Fcitx5 profile keeps `keyboard-us` available and uses `hazkey` for Japanese input.

  ### *How To Install*

1. Run the installer and choose **Fcitx5 input method**:

   ```bash
   cd ~/dotfiles/InstallScripts
   ./install.sh
   ```

2. Log out and back in, or reboot.
3. Run `fcitx5-configtool` to adjust input methods and shortcuts.

  ### Dependencies
  ```
  fcitx5
  fcitx5-configtool
  fcitx5-gtk
  fcitx5-qt
  fcitx5-hazkey-bin
  ```

</details>

<details>
  <summary>📝 Nvim</summary>
<img src="https://github.com/elifouts/Dotfiles/blob/main/images/nvim1.png" width = "30%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/nvim2.png" width = "30%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/nvim3.png" width = "30%">
  
## Overview

- This Neovim "rice" is a simplified version of Lazyvim, created with custom Lua files. It’s lightweight and includes only what you need. I just installed lazy and configured only the pluggins I wanted.
- It features:
  - Alpha-nvim
  - Matugen-backed theme
  - Autocompletion
  - Lualine
  - Tabline
  - Glow
  - Noice
  - Mini-icons
  - Snacks
    - bigfile
    - indent
    - input
    - quickfile
    - scroll
    - statuscolumn
    - words
  - Neo-tree
  - Telescope
  - Treesitter
  - Gitsigns
  - Colorizer

### *How To Install*
1. **Install `Neovim`:**
    ```bash
    paru -S neovim
    ```
2. Copy `Dotfiles/.config/nvim` into `~/.config/`

3. Start `nvim` and watch it install all necessary components.

</details>

<details>
  <summary>🚪 Wlogout</summary>
  <img src="https://github.com/elifouts/Dotfiles/blob/main/images/wlogout1.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wlogout2.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wlogout3.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/wlogout4.png" width = "40%">
  
### *How To Install*
1. **Install `wlogout`:**
   
    ```bash
    paru -S wlogout
    ```
2. Copy `Dotfiles/.config/wlogout` into `~/.config/`
3. If not already set make sure you set a key bind in hyprland.conf to launch wlogout.
</details>


<details>
  <summary>🖼️ Wallpaper Solution/Matugen</summary>
  
  ![image](https://github.com/user-attachments/assets/7cbe58e3-7226-4537-8e69-bb316cdfaebc)





## General Overview

- The `wallpaper.sh` script in `Dotfiles/.config/hypr/` applies a wallpaper using `swww` and runs `matugen image` with `Dotfiles/.config/matugen/config.toml`. It updates Waybar, Kitty, Cava, SwayNC, GTK, nvim compatibility colors, and Pywalfox compatibility output.
- The script uses Wofi to select wallpapers. I have not been able to optimize the wallpaper loading so it might load slowly but it should work.

### Dependencies

- `swww`
- `matugen`
- `wofi`
- `fd`

### *How To Install*
- Install dependencies:

     ```bash
     paru -S swww matugen wofi fd
     ```
     
1. **Copy Configuration Files:**
   - Copy `Dotfiles/.config/matugen` to `~/.config/` to provide Matugen templates.
   - Copy `Dotfiles/.config/hypr/wallpaper.sh` to `~/.config/hypr/`.
   - Copy `Dotfiles/.config/wofi` to `~/.config/`. ( Check the Wofi tab for how to configure blur )

2. Bind the script to a key combination of your choice to easily change your wallpaper.

3. Make sure to add the following line to your `hyprland.conf`:

     ```bash
     exec-once = swww-daemon
     ```

  
</details>

<details>
  <summary>🦊 Pywalfox</summary>
  <img src="https://github.com/elifouts/Dotfiles/blob/main/images/fox1.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/fox2.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/fox3.png" width = "40%"><img src="https://github.com/elifouts/Dotfiles/blob/main/images/fox4.png" width = "40%">

  ## Overview

  - This is a way to configure `Firefox` so that it uses Matugen-generated compatibility colors. After proper configuration, `Firefox` will change automatically when the wallpaper script runs Matugen.

  ### Dependencies
  ```
  Firefox
  Python
  Matugen
  ```

 ### *How To Install*
1. **Install [Pywalfox](https://github.com/Frewacom/pywalfox)**
2. Run `pywalfox install`
3. Install Firefox add-on for PywalFox
4. Run `pywalfox update` in your terminal or let the Matugen post-hook run it after generating colors.


</details>

<details>
  <summary>🚀 Starship</summary>

## Overview

  - This uses Starship's official Pure preset. Matugen is configured to keep that preset in place when themes are regenerated.

 ### *How To Install*
1. **Install [Starship](https://github.com/starship/starship?tab=readme-ov-file#-installation)**
2. Copy the `Dotfiles/.config/starship.toml` folder into `~/.config`
3. Add this to your `.bashrc` file:

   ```bash
    eval "$(starship init bash)"
   ```
   - Or go [here](https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship) to find what you need for your shell.
</details>

<details>
  <summary>🎨 GTK Themes</summary>
  
  ### I use these GTK themes
  
  - Widget Theme: Materia-dark
  - Icon Theme: Qogir-dark
</details>

## Keybinds

`Mod+Return` / `Mod+T` - Open terminal

`Mod+D` / `Mod+R` / `Mod+Space` - Open app launcher (Wofi)

`Mod+E` - Open Thunar

`Mod+W` - Open browser

`Mod+C` - Open editor

`Mod+Q` / `Mod+B` - Close focused window

`Mod+F` - Fullscreen

`Mod+V` - Toggle floating

`Mod+H/J/K/L` or `Mod+Arrow` - Move focus

`Mod+Shift+H/J/K/L` or `Mod+Shift+Arrow` - Move window

`Mod+Ctrl+H/J/K/L` or `Mod+Ctrl+Arrow` - Resize window

`Mod+1-0` - Switch workspaces

`Mod+Shift+1-0` - Move window to workspace

`Mod+G` - Music scratchpad

`Mod+N` - Toggle notification center

`Mod+L` - Lock

`Mod+Shift+E` - Power menu (wlogout)

`Mod+Shift+R` - Reload Hyprland

`Mod+Shift+M` - Quit Hyprland

`Alt+Tab` - Cycle windows

`Alt+B` - Waybar style selector (Wofi)

`Alt+A` - Toggle Waybar

`Alt+R` - Reload Swaync

`Alt+W` - Wallpaper selector (Wofi)

`Print` - Region screenshot

`Shift+Print` - Window screenshot

`Ctrl+Print` - Output screenshot

`Alt+PgUp` / `Alt+PgDown` - Monitor brightness up/down

> [!NOTE]
> This is not every keybind, just the ones worth remembering.
> 
> More can be found and changed in `~/.config/hypr/hyprland.conf`

## Help

<details>
  <summary>Apps Fuzzy or Blurry?</summary>
  
  #### This may be because they need to be run with Wayland or are Electron applications
  
  - The solution I found is to add the following to `/usr/share/applications/{app}.desktop` after `exec=/app/executable/app`
  - Works on `Discord`
  
  ```
  --enable-features=UseOzonePlatform --ozone-platform=wayland --uri=%U
  ```

  - ***NOTE*** This gets removed if the app is redownloaded! I'm not sure how to make this a global thing. I have tried and failed. Help?

</details>

<details>
  <summary>Cant Find a file that is in .cache?</summary>

### You may be looking for a file that looks something like this:

`@import url('../../.cache/wal/colors-waybar.css');`

That file is generated by `Matugen` for compatibility with these configs. Run `~/.config/hypr/wallpaper.sh` once, or run `matugen image /path/to/wallpaper --config ~/.config/matugen/config.toml`, then try again. Alternatively, you can do one of the following:

- create your own file which would look something like this:
```
@define-color background <Replace>;
@define-color color0 <Replace>;
@define-color color9 <Repace>;
```
Instead of those colors, you can use whichever color is needed by the style.css file.

- create the colors manually in the style.css files you took those paths from. 
```
@define-color <ColorName> <Color>;
```

- Find the sections of that file that are calling the missing file, such as `$color2` or `@color2` and replace it with a valid value.

</details>



## Notes
- If you want Cava to work with `Matugen`, the template is already configured in `.config/matugen/config.toml`.
- Am about to start working on an eww dashboard so look out for that
<details>
  <summary>📥 Download Suggestions</summary>
  
  - This is everything I think is essential to have. At least for me. I would suggest doing your own research before blindly downloading everything here. This is here just so if I break my computer which we all know I will, I can remember what I need/want!
    
```txt
git
wlogout
nvim
zip unzip
pipewire
hyprpicker
hypridle
hyprlock
hyprshot
sddm
sddm-astronaut-theme
qt6-5compat
qt6-declarative
qt6-virtualkeyboard
qt6-svg
qt6-multimedia-ffmpeg
bibata-cursor-theme-bin
bpytop
nerdfetch
paru
wl-clipboard
wl-copy
ttf-hackgen
starship
uv
ffmpeg
aria2
atomicparsley
rtmpdump
gogcli
thunar
grim
slurp
gnome-network-displays
discord
Firefox
pacman-contrib
swaync
matugen
waybar
swww
blueman
bluez
networkmanager
gvfs
libnotify
pavucontrol
pipewire-pulse
nwg-look
wofi
s-tui
python-pywalfox
fcitx5
fcitx5-configtool
fcitx5-gtk
fcitx5-qt
fcitx5-hazkey-bin
auto-cpufreq
powertop
qogir-icon-theme
fd
materia-dark-gtk
```
  
  Fun to have
  
  ```
  asciiquarium
  libcaca
  cowsay
  snake
  2048
  terminal-mines mines-tui
  genact  
  no-more-secrets
  lolcat
  ```
  Cool things you don't need
  ```
  waypaper
  ranger
  howdoi
  bottom
  ```
</details>
