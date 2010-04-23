#!/bin/bash

# source the global config file
source CONFIG

# process svg file

SED1="sed s/#000000/$OUTLINECOLOR/g"
SED2="sed s/stroke-width:20/stroke-width:$OUTLINE/g"
SED3="sed s/#999999/$CURSORCOLORHI/g"
SED4="sed s/#555555/$CURSORCOLORLO/g"
SED5="sed s/#999933/$HILIGHTHI/g"
SED6="sed s/#666600/$HILIGHTLO/g"
SED7="sed s/#010101/$HAIR/g"

# the basic cursors
FILES="
all-scroll 
cell 
col-resize 
crosshair 
default 
e-resize 
ew-resize 
grabbing 
n-resize 
ne-resize 
nesw-resize 
not-allowed 
ns-resize 
nw-resize 
nwse-resize 
pencil 
pirate 
pointer 
right-arrow 
row-resize 
s-resize 
se-resize 
sw-resize 
text 
up-arrow 
vertical-text 
w-resize 
X-cursor
zoom-in
zoom-out
"


if [ ! -d build ] ; then mkdir build; fi
if [ ! -d tmp ] ; then mkdir tmp; fi
if [ ! -d cursors ] ; then mkdir cursors; fi
if [ ! -d shadows ] ; then mkdir shadows; fi


for f in $FILES; do 
  if [ -f svg/$f.svg ] ; then
    cat svg/$f.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
    ./svg2png.bash $f
  else
    echo "skipping $f: no svg file found."
  fi
done

# the pointer combined cursors

FILES="
alias
context-menu
copy
move
no-drop
"

for f in $FILES; do 
  if [ -f svg/$f.svg ] ; then
    cat svg/$f.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
    ./svg2png.bash $f $f -BACKGROUND default -SHADOW move
  else
    echo "skipping $f: no svg file found."
  fi
done



if [ ! -d build/help ] ; then
	mkdir build/help
fi
cat svg/help1.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
./svg2png.bash help -PART 1 -BACKGROUND default -SHADOW move -TIME 2000
cat svg/help2.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
./svg2png.bash help -PART 2 -BACKGROUND default -SHADOW move -TIME 500


if [ ! -d build/progress ] ; then
	mkdir build/progress
fi
cat svg/progress.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
for (( i=1; $i < 25; i++ )); do
  ./svg2png.bash progress -PART $i -BACKGROUND default -SHADOW move
  patch -f --silent tmp/tmp.svg svg/progress.diff >> /dev/null
done


if [ ! -d build/wait ] ; then
	mkdir build/wait
fi
cat svg/wait.svg | $SED1 | $SED2 \
    | $SED3 | $SED4 | $SED5 | $SED6 | $SED7 > tmp/tmp.svg
for (( i=1; $i < 37; i++ )); do
  ./svg2png.bash wait -PART $i 
  patch -f --silent tmp/tmp.svg svg/wait.diff >> /dev/null
done

# make and install

echo "silent make"
make -silent
echo "silent make install"
make -silent install

