#!/bin/bash

# source the global config file
source "./CONFIG"

function svg_substitutions {
    # Process an SVG file with custom substitutions.
    local infile="$1"

    sed \
        -e "s/#000000/$OUTLINECOLOR/g" \
        -e "s/stroke-width:20/stroke-width:$OUTLINE/g" \
        -e "s/#999999/$CURSORCOLORHI/g" \
        -e "s/#555555/$CURSORCOLORLO/g" \
        -e "s/#999933/$HILIGHTHI/g" \
        -e "s/#666600/$HILIGHTLO/g" \
        -e "s/#010101/$HAIR/g" \
        "$infile"
}

# the basic cursors
names="
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


mkdir --parents "build"
mkdir --parents "tmp"
mkdir --parents "cursors"
mkdir --parents "shadows"


for name in $names; do
    if [ -f "svg/${name}.svg" ] ; then
        svg_substitutions "svg/${name}.svg" > "tmp/tmp.svg"
        ./svg2png.bash "$name" "tmp/tmp.svg" "build/${name}.png"
    else
        echo "skipping $name: no svg file found."
    fi
done

# the pointer combined cursors

names="
alias
context-menu
copy
move
no-drop
"

for name in $names; do
    if [ -f "svg/${name}.svg" ] ; then
        svg_substitutions "svg/${name}.svg" > "tmp/tmp.svg"
        ./svg2png.bash -BACKGROUND "build/default.png" "${name}" "tmp/tmp.svg" "build/${name}.png"
    else
        echo "skipping $name: no svg file found."
    fi
done



mkdir --parents "build/help"
svg_substitutions "svg/help1.svg" > "tmp/tmp.svg"
./svg2png.bash -PART 1 -BACKGROUND "build/default.png" -TIME 2000 "help" "tmp/tmp.svg" "build/help/help1.png"
svg_substitutions "svg/help2.svg" > "tmp/tmp.svg"
./svg2png.bash -PART 2 -BACKGROUND "build/default.png" -TIME 500 "help" "tmp/tmp.svg" "build/help/help2.png"


mkdir --parents "build/progress"
svg_substitutions "svg/progress.svg" > "tmp/tmp.svg"
for (( i=1; $i < 25; i++ )); do
    ./svg2png.bash -PART $i -BACKGROUND "build/default.png" "progress" "tmp/tmp.svg" "build/progress/progress${i}.png"
    patch -f --silent "tmp/tmp.svg" "svg/progress.diff" >> /dev/null
done


mkdir --parents "build/wait"
svg_substitutions "svg/wait.svg" > "tmp/tmp.svg"
for (( i=1; $i < 37; i++ )); do
    ./svg2png.bash -PART $i "wait" "tmp/tmp.svg" "build/wait/wait${i}.png"
    patch -f --silent "tmp/tmp.svg" "svg/wait.diff" >> /dev/null
done

# make and install

echo "silent make"
make -silent
echo "silent make install"
make -silent install
