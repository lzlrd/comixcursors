#! /bin/bash
#
# install-all.sh
# Part of ComixCursors, a desktop cursor theme.
#
# Copyright © 2010 Ben Finney <ben+gnome@benfinney.id.au>
# Copyright © 2006–2010 Jens Luetkens <j.luetkens@hamburg.de>
#
# This work is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this work. If not, see <http://www.gnu.org/licenses/>.

# the original cursors
themename_root="ComixCursors"
sizes=("Small" "Regular" "Large" "Huge")
colors=("Black" "Blue" "Green" "Orange" "Red" "White")
weights=("" "Slim")

# Set the ICONSDIR destination to a default (if not already set).
ICONSDIR=${ICONSDIR:-~/.icons}
export ICONSDIR

# argument processing and usage
function usage {
  echo ""
  echo "  $0 [OPTION]"
  echo "  Install the ComixCursors mouse theme."
  echo "  OPTIONS:"
  echo "    -h:    Display this help."
  echo "    -u:    Uninstall the ComixCursors mouse theme."
  echo ""
  exit
}

while getopts ":uh" opt; do
  case $opt in
    h)
      usage
      ;;
    u)
      UNINSTALL=true
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done

function build_theme {
    # Build the cursors for a particular theme.
    THEMENAME="$1"

    destdir="${ICONSDIR}/${themename_root}-${THEMENAME}"
    if [ -d "${destdir}" ] ; then
        rm -r "${destdir}"
    fi

    export THEMENAME
    if [ $UNINSTALL ] ; then
        make uninstall
    else
        printf "\nBuilding \"${THEMENAME}\":\n\n"
        ./build-cursors
        make
        make install
    fi
}

for color in "${colors[@]}" ; do
    for size in "${sizes[@]}" ; do
        for weight in "${weights[@]}" ; do
            if [ "${weight}" ] ; then
                build_theme "${color}-${size}-${weight}"
            else
                build_theme "${color}-${size}"
            fi
        done
    done
done

build_theme "Ghost"
build_theme "Christmas"
