#!/bin/sh

# the original cursors
SIZES="Small Regular Large Huge"
COLORS="Black Blue Green Orange Red White"
NAME="ComixCursors"

for c in $COLORS; do 
  for s in $SIZES; do 
    # install bold version
    if [[ -f ComixCursorsConfigs/$c-$s.CONFIG && -f ComixCursorsConfigs/$c-$s.theme ]] ; then
      echo -e "\ninstalling \"$c $s\":\n"
      cp ComixCursorsConfigs/$c-$s.CONFIG CONFIG
      cp ComixCursorsConfigs/$c-$s.theme index.theme
      ./install.bash
      sleep 3
      if [ -d ~/.icons/$NAME-$c-$s ] ; then
        rm -r ~/.icons/$NAME-$c-$s
      fi
      mv ~/.icons/ComixCursors-Custom ~/.icons/$NAME-$c-$s
    fi
    # install slim version, these will use the shadows from the bold version
    if [[ -f ComixCursorsConfigs/$c-$s-Slim.CONFIG && -f ComixCursorsConfigs/$c-$s-Slim.theme ]] ; then
      echo -e "\ninstalling \"$c $s Slim\":\n"
      cp ComixCursorsConfigs/$c-$s-Slim.CONFIG CONFIG
      cp ComixCursorsConfigs/$c-$s-Slim.theme index.theme
      ./install.bash
      sleep 3
      if [ -d ~/.icons/$NAME-$c-$s-Slim ] ; then
        rm -r ~/.icons/$NAME-$c-$s-Slim
      fi
      mv ~/.icons/ComixCursors-Custom ~/.icons/$NAME-$c-$s-Slim
    fi
  done
done

echo -e "\ninstalling Ghost:\n"
cp ComixCursorsConfigs/Ghost.CONFIG CONFIG
cp ComixCursorsConfigs/Ghost.theme index.theme
./install.bash
if [ -d ~/.icons/$NAME-Ghost ] ; then
  rm -r ~/.icons/$NAME-Ghost
fi
mv ~/.icons/ComixCursors-Custom ~/.icons/$NAME-Ghost

echo -e "\ninstalling Christmas:\n"
cp ComixCursorsConfigs/Christmas.CONFIG CONFIG
cp ComixCursorsConfigs/Christmas.theme index.theme
./install.bash
if [ -d ~/.icons/$NAME-Christmas ] ; then
  rm -r ~/.icons/$NAME-Christmas
fi
mv ~/.icons/ComixCursors-Custom ~/.icons/$NAME-Christmas

cp ComixCursorsConfigs/custom.CONFIG CONFIG
cp ComixCursorsConfigs/custom.theme index.theme
