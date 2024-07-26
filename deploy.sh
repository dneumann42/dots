# A simple deployment script

execute() {
    $1 # &> /dev/null; print_result $? "${2:-$1}"
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

git submodule update --init --recursive

DOTFILES_DIR="$HOME/.dots"
CONFIG_DIR="$HOME/.config"

# Symlinks

## Symlink the configs

mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/scripts"

for cfg in "$DOTFILES_DIR/configs"/*; do
  src="$cfg"
  target="$CONFIG_DIR/$(printf "%s" "$cfg" | sed "s/.*\/\(.*\)/\1/g")"
  echo "$target"
  execute "ln -sf $src $target" "$src -> $target"
  execute "rm -rf $target/$(basename -- $target)"
done

print_success "configs deployed"

## Deploy the scripts

execute "ln -sf $DOTFILES_DIR/scripts/ $HOME/.local/bin/"

for scr in "$DOTFILES_DIR/scripts"/*; do
  src="$scr"
  target="$CONFIG_DIR/scripts/$(printf "%s" "$scr" | sed "s/.*\/\(.*\)/\1/g")"
  execute "ln -sf $src $target" "$src -> $target"
  execute "rm -rf $target/$(basename -- $target)"
done

EMACS_DIR="$HOME/.emacs.d/"
if [ -d $EMACS_DIR ]; then
  pushd $EMACS_DIR > /dev/null
  git stash
  git pull
  git stash pop
  popd > /dev/null
else
    execute "git clone git@github.com:dneumann42/dneumacs.git $EMACS_DIR"
fi

for src in "$DOTFILES_DIR/zsh"/*; do
    execute "ln -sf $src $HOME/.$(basename -- $src)"
done

for src in "$DOTFILES_DIR/sbcl"/*; do
    execute "ln -sf $src $HOME/.$(basename -- $src)"
done

print_success "scripts deployed"

NVIM_DIR="$CONFIG_DIR/nvim/"
if [ -d $NVIM_DIR ]; then
  pushd $CONFIG_DIR/nvim > /dev/null
  git stash
  git pull
  git stash pop
  popd > /dev/null
else
  execute "git clone git@github.com:dneumann42/neovim-config.git $CONFIG_DIR/nvim/"
fi

# handle installing rust
RUSTUP="$CONFIG_DIR/scripts/rustup.sh"
if ! [ -f $RUSTUP ]; then
    print_info "Downloading rustup installer..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$RUSTUP"
    sh $RUSTUP
fi
