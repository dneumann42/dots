set fish_greeting

set -gx BROWSER firefox;
set -gx WALLPAPER "$HOME/Pictures/wallpaper.png";

set -gx PATH "$HOME/.nimble/bin/" $PATH
set -gx PATH "$HOME/.local/share/pnpm/" $PATH
set -gx PATH "$HOME/.config/scripts/" $PATH
set -gx PATH "$HOME/.luarocks/bin/" $PATH

alias gs="git status"
alias ga="git add ."
alias gc="git commit"

# pnpm
set -gx PNPM_HOME "/home/dneumann/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# opam configuration
source /home/dneumann/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
