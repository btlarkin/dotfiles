fpath=($ZDOTDIR/external $fpath)

source "$XDG_CONFIG_HOME/zsh/aliases"

zmodload zsh/complist
# key binds
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


autoload -Uz compinit; compinit
_comp_options+=(globdots) # With hidden files
source ~/dotfiles/zsh/external/completion.zsh

autoload -Uz prompt_purification_setup; prompt_purification_setup

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using
setopt PUSHD_SILENT

bindkey -v
export KEYTIMEOUT=1

autoload -Uz cursor_mode && cursor_mode

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source ~/dotfiles/zsh/external/bd.zsh

if [ $(command -v "fzf") ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

if [ "$(tty)" = "/dev/tty1" ];
then
    pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

source $DOTFILES/zsh/scripts.sh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── DevAccelerator new-project + roadmap-builder ───
devnew() {
  if (( $# < 2 )); then
    cat <<-USAGE >&2
Usage:
  devnew project "<Project Title>"
  devnew roadmap-builder <target-dir>
USAGE
    return 1
  fi

  local tpl=$1; shift
  local name=$1
  local dest=~/projects/"$name"

  case $tpl in
    project)
      # your existing flow
      new_project "$name"
      cd ~/projects/"$name"
      launch_project
      obsidian ~/workspace/DevAccelerator/03_Projects/"$(echo $name | slugify)".md &>/dev/null &;;
      
    roadmap-builder)
      # 1) copy skeleton
      if [[ ! -d ~/.templates/custom-roadmap-builder ]]; then
        echo "❌ Template not found at ~/.templates/custom-roadmap-builder" >&2
        return 1
      fi
      cp -R ~/.templates/custom-roadmap-builder "$dest"
      cd "$dest"

      # 2) make sure scripts are executable
      chmod +x build.zsh gist.zsh

      # 3) seed config.json if missing
      [[ -f config.json ]] || cp config.json.sample config.json

      # 4) dependency check
      for dep in jq sed unzip curl xclip tmuxp; do
        if ! command -v $dep &>/dev/null; then
          echo "⚠️  Missing '$dep'. Install via your package manager." >&2
        fi
      done

      # 5) initial build (and warn if jq is truly missing)
      if command -v jq &>/dev/null; then
        echo "📦 Running initial build…"
        ./build.zsh
      else
        echo "⏭ Skipping build; install jq first." >&2
      fi

      # 6) drop into tmuxp session
      if command -v tmuxp &>/dev/null; then
        tmuxp load .tmuxp/roadmap.yaml
      else
        echo "⏭ Install tmuxp to auto-launch workspace." >&2
      fi
      ;;

    *)
      echo "Unknown template: $tpl" >&2; return 1;;
  esac
}

export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/DevEnv/scripts:$PATH"
alias devnew='devnew.sh'

export PATH="$HOME/.local/bin:$PATH"
