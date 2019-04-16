#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

ASSETS_DIR="assets/$1"
SRC_FILE="assets-$1.svg"

HIDPI=1

INDEX="assets.txt"

if [ ! -d $ASSETS_DIR ]; then
  mkdir $ASSETS_DIR
fi

for i in `cat $INDEX`
  do
  if [ -f $ASSETS_DIR/$i.png ]; then
      echo $ASSETS_DIR/$i.png exists.
  else
      echo
      echo Rendering $ASSETS_DIR/$i.png
      $INKSCAPE --export-id=$i \
                --export-id-only \
                --export-png=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
      && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png 
  fi
  
  if [ $HIDPI -eq 1 ]; then
    if [ -f $ASSETS_DIR/$i@2.png ]; then
        echo $ASSETS_DIR/$i@2.png exists.
    else
        echo
        echo Rendering $ASSETS_DIR/$i@2.png
        $INKSCAPE --export-id=$i \
                  --export-dpi=180 \
                  --export-id-only \
                  --export-png=$ASSETS_DIR/$i@2.png $SRC_FILE >/dev/null \
        && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i@2.png 
    fi
  fi
done
exit 0
