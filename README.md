# Dustin's dotfiles

## Managing submodules with git

### Adding a new submodule to configs

```sh
git submodule add git@github.com:dneumann42/dustins-editor.git configs/nvim
```

### Cloning the repo with submodules

```sh
git clone --recurse-submodules git@github.com:dneumann42/dots.git 
```

### Initializing submodules if cloned non recursive

note that this is also done during the deploy

```sh
git submodule update --init --recursive
```

## TODO:

+ [ ] add a config ignore file for config directories I don't want deployed
