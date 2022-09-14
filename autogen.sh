#!/bin/bash

WORKDIR="$PWD/src"
OUTDIR="$PWD"

# sassc check
[ ! -f "/usr/bin/sassc" ] && echo "sassc is not installed, or not found at '/usr/bin/sassc'" && exit 1

# remove previous generation
for d in ./*
do
  [ -d $d/Azurra ] && continue
  [ -d $d ] && rm -r $d
done

cd $WORKDIR

INDEX=$WORKDIR/variant-index

RENDER=false
GEN=true

gen_index() {
  target="$1"
  name="$2"
  series="$3" 
  
  echo "[Desktop Entry]
Type=X-GNOME-Metatheme
Name=$name
Comment=$series, a redesigned modern & flat theme with modern colors. Originally by RAVEfinity.com, now maintained by Elbullazul
Encoding=UTF-8

Name[en_CA]=index-aqua.theme

[X-GNOME-Metatheme]
GtkTheme=Ambiance-Flat-Aqua
MetacityTheme=Ambiance-Flat-Aqua
IconTheme=Vibrancy-Full-Dark-Aqua
CursorTheme=DMZ-White
ButtonLayout=close,minimize,maximize:" >> "$target"
}

while [ "$1" != "" ]; do
  case $1 in
    -c | --clean)
      for i in `cat $INDEX`; do
        rm -rf ../src/gtk-3.0/$i/assets-render/assets/*
        rm -rf ../src/gtk-3.0/$i/assets-render-dark/assets/*
      done
      exit
    ;;
    -r | --render)
      RENDER=true
    ;;
    -n | --no-gen)
      GEN=false
    ;;
    -h | --help)
      echo " -h  --help   Show this"
      echo " -c  --clean  Remove previously rendered assets"
      echo " -r  --render Force run image generation script (much verbose!)"
      echo " -n  --no-gen Do not generate SASS"
      exit
    ;;
  esac
  shift
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
  cp main-dark.rc $OUTDIR/$DARK_VARIANT/gtk-2.0/main.rc
  
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
    if [ $GEN == true ]; then
      echo "Running SASS for ${i^}"
    
      sassc -M gtk.scss gtk.css
      sassc -M gtk-dark.scss gtk-dark.css
      sassc -M gtk-light.scss gtk-light.css
    fi
    
    cp gtk.css $OUTDIR/$VARIANT/gtk-3.0/gtk.css
    cp gtk-dark.css $OUTDIR/$VARIANT/gtk-3.0/gtk-dark.css
    cp gtk-light.css $OUTDIR/$VARIANT/gtk-3.0/gtk-light.css
    
    cp gtk-light.css $OUTDIR/$LIGHT_VARIANT/gtk-3.0/gtk.css
    cp gtk-dark.css $OUTDIR/$DARK_VARIANT/gtk-3.0/gtk.css

    if [ $RENDER == true ]; then
      (cd assets-render && ./render-assets.sh)
      (cd assets-render-dark && ./render-assets.sh)
        
      cp -r assets-render/assets/* assets
      cp -r assets-render-dark/assets/* assets-dark
    fi
    
    cp -a assets-render/assets $OUTDIR/$VARIANT/gtk-3.0/assets
    cp -a assets-render/assets $OUTDIR/$LIGHT_VARIANT/gtk-3.0/assets
    cp -a assets-render-dark/assets $OUTDIR/$DARK_VARIANT/gtk-3.0/assets
  
  cd ..
  
done
cd ..

# static files
for i in `cat $INDEX`
do
  VARIANT=Ambiance-Flat-${i^}
  LIGHT_VARIANT=Radiance-Flat-${i^}
  DARK_VARIANT=Ambiance-Blackout-Flat-${i^}
  
  cp -a metacity-1/$i $OUTDIR/$VARIANT/metacity-1
  cp -a metacity-1/$i-light $OUTDIR/$LIGHT_VARIANT/metacity-1
  cp -a metacity-1/$i-dark $OUTDIR/$DARK_VARIANT/metacity-1
  
  cp -a unity/$i $OUTDIR/$VARIANT/unity
  cp -a unity/$i-light $OUTDIR/$LIGHT_VARIANT/unity
  cp -a unity/$i-dark $OUTDIR/$DARK_VARIANT/unity
  
  cp -a xfwm4/$i $OUTDIR/$VARIANT/xfwm4
  cp -a xfwm4/$i-light $OUTDIR/$LIGHT_VARIANT/xfwm4
  cp -a xfwm4/$i-dark $OUTDIR/$DARK_VARIANT/xfwm4
  
  gen_index $OUTDIR/$VARIANT/index.theme $VARIANT 'Ambiance-Flat'
  gen_index $OUTDIR/$LIGHT_VARIANT/index.theme $LIGHT_VARIANT 'Radiance-Flat'
  gen_index $OUTDIR/$DARK_VARIANT/index.theme $DARK_VARIANT 'Ambiance-Blackout-Flat'
done
