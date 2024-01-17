#!/usr/bin/env sh

## Single line will clone and deploy

mkdir -p $HOME/Repos && git clone --recurse-submodules  git@github.com:dneumann42/dots.git $HOME/Repos/dots && sh $HOME/Repos/dots/deploy.sh
