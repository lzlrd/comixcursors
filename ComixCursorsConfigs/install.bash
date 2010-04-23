#!/bin/bash

FILES="
Black-Huge
Black-Huge-Slim
Black-Large
Black-Large-Slim
Black-Regular
Black-Regular-Slim
Black-Small
Black-Small-Slim
White-Huge
White-Huge-Slim
White-Large
White-Large-Slim
White-Regular
White-Regular-Slim
White-Small
White-Small-Slim
Blue-Huge
Blue-Huge-Slim
Blue-Large
Blue-Large-Slim
Blue-Regular
Blue-Regular-Slim
Blue-Small
Blue-Small-Slim
Green-Huge
Green-Huge-Slim
Green-Large
Green-Large-Slim
Green-Regular
Green-Regular-Slim
Green-Small
Green-Small-Slim
Orange-Huge
Orange-Huge-Slim
Orange-Large
Orange-Large-Slim
Orange-Regular
Orange-Regular-Slim
Orange-Small
Orange-Small-Slim
Ghost
Christmas
"

for f in $FILES; do 
  echo "
  INSTALLING $f
  "
  
  cp $f.CONFIG ../CONFIG
  cp $f.theme ../index.theme

  cd ..
  ./install.bash
  cd ComixCursorsConfigs
  
  rm -rf ~/.icons/ComixCursors-$f
  mv ~/.icons/ComixCustom ~/.icons/ComixCursors-$f
  
done

cp custom.CONFIG ../CONFIG
cp custom.theme ../index.theme
