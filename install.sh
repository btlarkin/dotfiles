#!/bin/bash

########
# nvim #
########

mkdir -p "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_CONFIG_HOME/nvim/undo"

ln -sf "$HOME/dotfiles/nvim/init.vim" "$XDG_CONFIG_HOME/nvim"

# install neovim plugin manager
[ ! -f "$DOTFILES/nvim/autoload/plug.vim" ] \
    && curl -fLo "$DOTFILES/nvim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p "$XDG_CONFIG_HOME/nvim/autoload"
ln -sf "$DOTFILES/nvim/autoload/plug.vim" "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"

# Install (or update) all the plugins
nvim --noplugin +PlugUpdate +qa

#######
# X11 #
#######

rm -rf "$XDG_CONFIG_HOME/X11"
ln -s "$HOME/dotfiles/X11" "$XDG_CONFIG_HOME"

######
# i3 #
######

rm -rf "$XDG_CONFIG_HOME/i3"
ln -s "$HOME/dotfiles/i3" "$XDG_CONFIG_HOME"

#######
# Zsh #
#######

mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$HOME/dotfiles/zsh/.zshenv" "$HOME"
ln -sf "$HOME/dotfiles/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -sf "$HOME/dotfiles/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$HOME/dotfiles/zsh/external" "$XDG_CONFIG_HOME/zsh"

#########
# Fonts #
#########

mkdir -p "$XDG_DATA_HOME"
cp -rf "$DOTFILES/fonts" "$XDG_DATA_HOME"

#########
# dunst #
#########

mkdir -p "$XDG_CONFIG_HOME/dunst"
ln -sf "$DOTFILES/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"

#######
# git #
#######

mkdir -p "$XDG_CONFIG_HOME/git"
ln -sf "$DOTFILES/git/.gitconfig" "$XDG_CONFIG_HOME/git/.gitconfig"

########
# tmux #
########

mkdir -p "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

rm -rf "$XDG_CONFIG_HOME/tmuxp"
ln -sf "$DOTFILES/tmux/tmuxp" "$XDG_CONFIG_HOME/tmuxp"

[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

###########
# DevEnv  #
###########

# 1) Ensure root folder for DevEnv
mkdir -p "$HOME/DevEnv"

# 2) Sync your DevEnv/ templates & scripts from dotfiles
#    (Assumes you checked in a DevEnv/ directory alongside your other dotfiles)
rsync -a "$DOTFILES/DevEnv/templates" "$HOME/DevEnv/templates"
rsync -a "$DOTFILES/DevEnv/scripts"   "$HOME/DevEnv/scripts"

# 3) Make sure scripts are executable
chmod -R +x "$HOME/DevEnv/scripts"

# 4) Ensure local bin on PATH and create it
mkdir -p "$HOME/.local/bin"
#   you may already have this via your ~/.zshrc; just double-check
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$XDG_CONFIG_HOME/zsh/.zshrc" \
  || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$XDG_CONFIG_HOME/zsh/.zshrc"

# 5) Symlink the entry-point scripts into ~/.local/bin
ln -sf "$HOME/DevEnv/scripts/devnew.sh"       "$HOME/.local/bin/devnew"
ln -sf "$HOME/DevEnv/scripts/new_project.sh"  "$HOME/.local/bin/new_project"
ln -sf "$HOME/DevEnv/scripts/launch_project.sh" \
                                              "$HOME/.local/bin/launch_project"
# (You can also expose build.zsh & gist.zsh if you want:
# ln -sf "$HOME/DevEnv/scripts/build.zsh"   "$HOME/.local/bin/roadmap-build"
# ln -sf "$HOME/DevEnv/scripts/gist.zsh"    "$HOME/.local/bin/roadmap-gist"
# )

echo "✅ DevEnv installed to ~/DevEnv, helpers in ~/.local/bin"

