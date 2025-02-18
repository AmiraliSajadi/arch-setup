# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


# -------- EZA (better ls) --------
alias ls="eza --icons=always"


# -------- FZF --------
eval "$(fzf --zsh)"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# -------- Zoxide (better cd) --------
eval "$(zoxide init zsh)"

alias cd="z"


# -------- ZSH-AUTOSUGGESTIONS --------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# -------- ZSH-SYNTAX-HIGHLIGHTING --------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# -------- CUSTOM WALLPAPER SOLUTION --------
alias set-wall="$HOME/.config/wallpaper_solution/set-wall"


# -------- FASTFETCH ON NEW TERMINALS --------
fastfetch
