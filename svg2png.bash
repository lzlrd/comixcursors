#! /bin/bash
# svg2png.bash
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

# Take a simple svg file, export it to an image,
# do some image magig, generate a shadow, scale
# and merge it to a single image.
#
# Required tools:
# ImageMagick:  http://www.imagemagick.org/
# librsvg:      http://librsvg.sourceforge.net/

if [ $# -lt 1 ]; then
  echo ""
  echo "Usage: $0 [options] <in name> <in file> <out file>"
  echo ""
  echo "Options:"
  echo "    -FRAME <frame num>        animated cursors frame number"
  echo "    -BACKGROUND <file>        background image file"
  echo "    -TIME <milliseconds>      duration for this animation frame"
  echo ""
  exit -1
fi

THEMENAME="${THEMENAME:-custom}"

configfile="ComixCursorsConfigs/${THEMENAME}.CONFIG"
hotspotsfile="svg$LH/HOTSPOTS"

# don't do transparency post-processing by default
# used for ComixCursors but not for flatbedcursors
CURSORTRANS=0

# source the theme config file
source "${configfile}"

# some initialisation before argument processing
frame=0

# parse argument list
while [ "${1::1}" == "-" ]; do
    case $1 in
	-FRAME)
            shift
	    frame=$1
	    ;;
	-BACKGROUND)
	    shift
	    background_image="$1"
	    ;;
	-TIME)
	    shift
	    TIME=$1
	    ;;
    esac
    shift
done

NAME="$1"
infile="$2"
outfile="$3"

TMPSIZE=$(echo "$SIZE * $TMPSCALE" | bc)

XMOVE=$(echo "$XOFFSET * $TMPSCALE" | bc)
YMOVE=$(echo "$YOFFSET * $TMPSCALE" | bc)

SCALEBLUR=$(echo "$BLUR * $TMPSCALE" | bc)
SCALESIZE=$(echo "$SIZE * $TMPSCALE" | bc)

# Scaling the shadow from the cursor image.
SHADOWSIZE=$(echo "$TMPSIZE * $SHADOWSCALE" | bc)
RIGHT=$(echo "$TMPSIZE / $SHADOWSCALE" | bc)
LEFT=$(echo "$TMPSIZE - $RIGHT" | bc)

if [ "$frame" -lt 1 ]; then
    echo "processing $NAME..."
else
    echo "processing $NAME frame $frame..."
fi

# write the hotspot config file
if [ "$background_image" ] ; then
    background_filename="$(basename $background_image)"
    hotspot_name="${background_filename%.png}"
else
    hotspot_name="$NAME"
fi
HOTSPOT=( $(grep "^$hotspot_name" "$hotspotsfile") )

HOTX=$(echo "${HOTSPOT[1]} * $SIZE / 500" | bc)
HOTY=$(echo "${HOTSPOT[2]} * $SIZE / 500" | bc)

xcursor_config="$(dirname $outfile)/${NAME}.conf"
if [ "$frame" -lt 2 ] ; then
    if [ -e "${xcursor_config}" ]; then
        rm "${xcursor_config}"
    fi
fi

if [ "$frame" -gt 0 ] ; then
    echo "$SIZE $HOTX $HOTY $outfile $TIME" >> "${xcursor_config}"
else
    echo "$SIZE $HOTX $HOTY $outfile" >> "${xcursor_config}"
fi

image_name="${outfile%.png}"
bare_image="${image_name}.bare.png"
shadow_name="${image_name%.frame*}"
shadow_image="${shadow_name}${LH}.${SIZE}.${SHADOWCOLOR}.${SHADOWTRANS}.shadow.png"
silhouette_image="${image_name}.silhouette.png"

function svg2png {
    # Convert a single SVG image to PNG.
    local infile="$1"
    local outfile="$2"
    local size=$3

    rsvg --format png \
        --dpi-x 72 --dpi-y 72 \
        --width $size --height $size \
        "$infile" "$outfile"
}

function make_shadow_image {
    # Make the shadow image from a bare image and a silhouette.
    local infile="$1"
    local silhouette_image="$2"
    local shadow_image="$3"

    convert \
        -extract ${SHADOWSIZE}x${SHADOWSIZE}+${LEFT}+${LEFT} \
        -resize ${TMPSIZE}x${TMPSIZE} \
        "$bare_image" "$silhouette_image"

    convert -modulate 0 \
        -fill "$SHADOWCOLOR" \
        -colorize 100 \
        -channel Alpha \
        -fx \'a-$SHADOWTRANS\' \
        "$silhouette_image" "$shadow_image"

    mogrify -channel Alpha \
        -blur ${SCALEBLUR}x${SCALEBLUR} \
        -resize 50% \
        "$shadow_image"

    mogrify -roll +${XMOVE}+${YMOVE} \
        "$shadow_image"

}

# Render the bare cursor image.
svg2png "$infile" "$bare_image" $TMPSIZE

# Check whether the shadow image is cached.
if [ ! -f "$shadow_image" ] ; then
    # Make the shadow image.
    make_shadow_image "$bare_image" "$silhouette_image" "$shadow_image"
fi

# Apply alpha-channel opacity to the bare image.
if [ $(echo "$CURSORTRANS > 0" | bc) -gt 0 ]; then
    convert -channel Alpha -fx \'a-$CURSORTRANS\' "$bare_image" "$bare_image"
fi

# Compose the final image.
composite -geometry ${SIZE}x${SIZE} "$bare_image" "$shadow_image" "$outfile"

if [ "$background_image" ]; then
    composite "$outfile" "$background_image" "$outfile"
fi
