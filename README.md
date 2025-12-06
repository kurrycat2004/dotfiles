## Dotfiles
- Install chezmoi (one of:)
  - `sh -c "$(curl -fsLS get.chezmoi.io)"`
  - `sudo pacman -S chezmoi`

- Pull dotfiles
  - `chezmoi init git@github.com:kurrycat2004/dotfiles.git`

- Packages
  - required: `alacritty anyrun niri noctalia-shell`
  - want: `btop chameleos lf micro`

- Apply dotfiles
  - `chezmoi apply`