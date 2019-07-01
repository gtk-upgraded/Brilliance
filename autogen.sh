#!/bin/bash

WORKDIR="$PWD/src"
OUTDIR="$PWD/package"

cd $WORKDIR

INDEX=$WORKDIR/variant-index

rm -rf $OUTDIR/*

#gtk2
cd gtk-2.0
for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  mkdir $OUTDIR/$VARIANT
  
  mkdir $OUTDIR/$VARIANT/gtk-2.0
  cp -r img $OUTDIR/$VARIANT/gtk-2.0/
  cp -r apps $OUTDIR/$VARIANT/gtk-2.0/
  cp main.rc $OUTDIR/$VARIANT/gtk-2.0/
  
  cp gtkrc-$i $OUTDIR/$VARIANT/gtk-2.0/gtkrc

done
cd ..

# gtk3
cd gtk-3.0
# same file for everyone, only colors change
sass -C --sourcemap=none _common.scss gtk-widgets.css

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  mkdir $OUTDIR/$VARIANT/gtk-3.0
  
  cd $i
  
  sass -C --sourcemap=none gtk.scss gtk.css
  cp gtk.css $OUTDIR/$VARIANT/gtk-3.0/gtk.css
  cp -a assets $OUTDIR/$VARIANT/gtk-3.0/assets

  cd assets-render
  ./render-assets.sh
  cd ..
  
  cd ..
  
done
cd ..

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  cp index-$i.theme $OUTDIR/$VARIANT/index.theme
done
