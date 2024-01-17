# A simple deployment script

## What this does is create symlinks for each folder 
## in configs/ to $HOME/.config (XDG)

# Some display utilities

execute() {
    $1 # &> /dev/null
    print_result $? "${2:-$1}"
}

print_error() {
    printf "\e[0;31m[✖] $1 $2\e[0m\n"
}

print_info() {
    printf "\n\e[0;35m$1\e[0m\n\n"
}

print_question() {
    printf "\e[0;33m[?] $1\e[0m"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m[✔] $1\e[0m\n"
}

# update and init the submodules
git submodule update --init --recursive

# [note] I don't like hardcoding this, I would
# prefer to have this be a variable, will do that later
DOTFILES_DIR="$HOME/Projects/dots"
CONFIG_DIR="$HOME/.config"

# Symlinks

## Create extra home directories

mkdir -p $HOME/Repos
mkdir -p $HOME/Projects
mkdir -p "$HOME/.local/bin/"

## Symlink the configs

mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/scripts"

for cfg in "$DOTFILES_DIR/configs"/*; do
  src="$cfg"
  target="$CONFIG_DIR/$(printf "%s" "$cfg" | sed "s/.*\/\(.*\)/\1/g")"
  execute "ln -sf $src $target" "$src -> $target"
  execute "rm -rf $target/$(basename -- $target)"
done

print_success "configs deployed"

# Deploy the scripts

execute "ln -sf $DOTFILES_DIR/scripts/ $HOME/.local/bin/"

for scr in "$DOTFILES_DIR/scripts"/*; do
  src="$scr"
  target="$CONFIG_DIR/scripts/$(printf "%s" "$scr" | sed "s/.*\/\(.*\)/\1/g")"
  execute "ln -sf $src $target" "$src -> $target"
  execute "rm -rf $target/$(basename -- $target)"
done

execute "ln -sf $DOTFILES_DIR/emacs $HOME/.emacs.d"
execute "rm -rf $DOTFILES_DIR/emacs/emacs"

## ZSH

for src in "$DOTFILES_DIR/zsh"/*; do
    echo $src
    execute "ln -sf $src $HOME/.$(basename -- $src)"
done

print_success "scripts deployed"

## Change the shell to fish

## sudo chsh -s $(which fish)
## chsh -s $(which fish)
