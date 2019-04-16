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
  
  cp gtk-$i.css $OUTDIR/$VARIANT/gtk-3.0/gtk.css
  cp gtk-widgets.css $OUTDIR/$VARIANT/gtk-3.0/gtk-widgets.css
  
  ./render-assets.sh $i
  
  cp -a assets/$i $OUTDIR/$VARIANT/gtk-3.0/assets
done
cd ..

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  cp index-$i.theme $OUTDIR/$VARIANT/index.theme
done
