#!/bin/bash

fail() { tput setaf 1 && echo 'ERROR: '$@ && exit 1; }

AZURRA_PATH=$HOME/Github/Azurra_framework

[ ! -d $AZURRA_PATH ] && fail 'Source directory not found. You need a copy of https://github.com/B00merang-Project/Azurra_framework installed'

rm -rf src/Azurra
rm -rf src/gtk-3.0

cp -r $AZURRA_PATH/Azurra src
cp -r $AZURRA_PATH/Brilliance src/gtk-3.0

echo "Sources updated"
