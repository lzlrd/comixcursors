#! /bin/bash

# the original cursors
themename="ComixCursors"
sizes=("Small" "Regular" "Large" "Huge")
colors=("Black" "Blue" "Green" "Orange" "Red" "White")
weights=("" "Slim")

# Set the ICONSDIR destination to a default (if not already set).
ICONSDIR=${ICONSDIR:-~/.icons}
export ICONSDIR

function build_subtheme {
    # Build the cursors for a particular subtheme.
    subthemename="$1"

    destdir="${ICONSDIR}/$themename-${subthemename}"
    if [ -d "${destdir}" ] ; then
        rm -r "${destdir}"
    fi

    THEMENAME="${subthemename}"
    export THEMENAME
    printf "\nBuilding \"${subthemename}\":\n\n"
    ./build-cursors
    make
    make install
}

for color in "${colors[@]}" ; do
    for size in "${sizes[@]}" ; do
        for weight in "${weights[@]}" ; do
            if [ "${weight}" ] ; then
                build_subtheme "${color}-${size}-${weight}"
            else
                build_subtheme "${color}-${size}"
            fi
        done
    done
done

build_subtheme "Ghost"
build_subtheme "Christmas"
