## Dotfiles
- Install chezmoi (one of:)
  - `sh -c "$(curl -fsLS get.chezmoi.io)"`
  - `sudo pacman -S chezmoi`

- Pull dotfiles
  - `chezmoi init git@github.com:kurrycat2004/dotfiles.git`

- Packages
  - required: 
    - `alacritty`
    - `niri`
    - `noctalia-shell`
  - want: 
    - `btop`
    - `lf`
    - `micro`
    - [`vellum`](https://github.com/greyxp1/vellum)

- Apply dotfiles
  - `chezmoi apply`