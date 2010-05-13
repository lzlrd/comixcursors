#! /bin/bash

# the original cursors
themename="ComixCursors"
sizes=("Small" "Regular" "Large" "Huge")
colors=("Black" "Blue" "Green" "Orange" "Red" "White")
weights=("" "Slim")

# Set the ICONSDIR destination to a default (if not already set).
ICONSDIR=${ICONSDIR:-~/.icons}
export ICONSDIR

workdir="${ICONSDIR}/${themename}-Custom"

function build_subtheme {
    # Build the cursors for a particular subtheme.
    subthemename="$1"

    destdir="${ICONSDIR}/$NAME-${subthemename}"
    configfile="${themename}Configs/${subthemename}.CONFIG"
    themefile="${themename}Configs/${subthemename}.theme"
    if [[ -f "${configfile}" && -f "${themefile}" ]] ; then
        printf "\nBuilding \"${subthemename}\":\n\n"
        cp "${configfile}" "CONFIG"
        cp "${themefile}" "index.theme"
        ./install.bash
        if [ -d "${destdir}" ] ; then
            rm -r "${destdir}"
        fi
        mv "${workdir}" "${destdir}"
    fi
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

cp "${themename}Configs/custom.CONFIG" "CONFIG"
cp "${themename}Configs/custom.theme" "index.theme"
