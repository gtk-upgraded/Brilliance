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
  LIGHT_VARIANT=Radiance-Flat-${i^}
  DARK_VARIANT=Ambiance-Blackout-Flat-${i^}
  
  mkdir -p $OUTDIR/$VARIANT/gtk-2.0
  mkdir -p $OUTDIR/$LIGHT_VARIANT/gtk-2.0
  mkdir -p $OUTDIR/$DARK_VARIANT/gtk-2.0
  
  cp -r img $OUTDIR/$VARIANT/gtk-2.0/
  cp -r img $OUTDIR/$LIGHT_VARIANT/gtk-2.0/
  cp -r img $OUTDIR/$DARK_VARIANT/gtk-2.0/
  
  cp -r apps $OUTDIR/$VARIANT/gtk-2.0/
  cp -r apps $OUTDIR/$LIGHT_VARIANT/gtk-2.0/
  cp -r apps $OUTDIR/$DARK_VARIANT/gtk-2.0/
  
  cp main.rc $OUTDIR/$VARIANT/gtk-2.0/
  cp main-light.rc $OUTDIR/$LIGHT_VARIANT/gtk-2.0/main.rc
  cp main.rc $OUTDIR/$DARK_VARIANT/gtk-2.0/
  
  cp gtkrc-$i $OUTDIR/$VARIANT/gtk-2.0/gtkrc
  cp gtkrc-$i-light $OUTDIR/$LIGHT_VARIANT/gtk-2.0/gtkrc
  cp gtkrc-$i-dark $OUTDIR/$DARK_VARIANT/gtk-2.0/gtkrc

done
cd ..

# gtk3
cd gtk-3.0

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  LIGHT_VARIANT=Radiance-Flat-${i^}
  DARK_VARIANT=Ambiance-Blackout-Flat-${i^}
  
  mkdir -p $OUTDIR/$VARIANT/gtk-3.0
  mkdir -p $OUTDIR/$LIGHT_VARIANT/gtk-3.0
  mkdir -p $OUTDIR/$DARK_VARIANT/gtk-3.0
  
  cd $i
    sass -C --sourcemap=none gtk.scss gtk.css
    sass -C --sourcemap=none gtk-dark.scss gtk-dark.css
    sass -C --sourcemap=none gtk-light.scss gtk-light.css
    
    cp gtk.css $OUTDIR/$VARIANT/gtk-3.0/gtk.css
    cp gtk-dark.css $OUTDIR/$VARIANT/gtk-3.0/gtk-dark.css
    cp gtk-light.css $OUTDIR/$VARIANT/gtk-3.0/gtk-light.css
    
    cp gtk-light.css $OUTDIR/$LIGHT_VARIANT/gtk-3.0/gtk.css
    cp gtk-dark.css $OUTDIR/$DARK_VARIANT/gtk-3.0/gtk.css

    if [ $RENDER == true ]; then
      cd assets-render
        ./render-assets.sh
      cd ..
    fi
    
    cp -a assets-render/assets $OUTDIR/$VARIANT/gtk-3.0/assets
    cp -a assets-render/assets $OUTDIR/$LIGHT_VARIANT/gtk-3.0/assets
    cp -a assets-render/assets $OUTDIR/$DARK_VARIANT/gtk-3.0/assets
  
  cd ..
  
done
cd ..

for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  cp index-$i.theme $OUTDIR/$VARIANT/index.theme
done
