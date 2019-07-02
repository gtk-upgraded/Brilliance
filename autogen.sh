#!/bin/bash

WORKDIR="$PWD/src"
OUTDIR="$PWD/package"

cd $WORKDIR

INDEX=$WORKDIR/variant-index

rm -rf $OUTDIR/*

RENDER=false

args=("$@")
for f in ${!args[@]}
do
  case ${args[$f]} in
    -c | --clean)
      for i in `cat $INDEX`
      do
        rm -rf ../src/gtk-3.0/$i/assets-render/assets/*
      done
      
      exit
    ;;
    -r | --render)
      RENDER=true
    ;;
    -h | --help)
      echo " -h  --help   Show this"
      echo " -c  --clean  Remove previously rendered images"
      echo " -r  --render Force run image generation script (much verbose!)"
      exit
    ;;
  esac
done

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

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  mkdir $OUTDIR/$VARIANT/gtk-3.0
  
  cd $i
    sass -C --sourcemap=none gtk.scss gtk.css
    [ -f 'gtk-dark.scss' ] && sass -C --sourcemap=none gtk-dark.scss gtk-dark.css
    
    cp gtk.css $OUTDIR/$VARIANT/gtk-3.0/gtk.css
    [ -f 'gtk-dark.scss' ] && cp gtk-dark.css $OUTDIR/$VARIANT/gtk-3.0/gtk-dark.css

    if [ $RENDER ]; then
      cd assets-render
        ./render-assets.sh
      cd ..
      
      cp -a assets-render/assets $OUTDIR/$VARIANT/gtk-3.0/assets
    fi
  
  cd ..
  
done
cd ..

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  cp index-$i.theme $OUTDIR/$VARIANT/index.theme
done
