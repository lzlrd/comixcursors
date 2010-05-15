#!/bin/bash
##########################################################
# svg2png.bash
# Copyright © 2010 Ben Finney <ben+debian@benfinney.id.au>
# Copyright © 2006 Jens Luetkens <j.luetkens@limitland.de>
# version: ComixCursors 0.5.0
#          flatbedcursors 0.1 (compatible)
#
# Take a simple svg file, export it to an image,
# do some image magig, generate a shadow, scale
# and merge it to a single image.
#
# Required tools:
# ImageMagick:  http://www.imagemagick.org/
# librsvg:      http://librsvg.sourceforge.net/
#
##########################################################

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

if [ $frame -lt 1 ]; then
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
HOTSPOT=( $(grep "^$hotspot_name" HOTSPOTS) )

HOTX=$(echo "${HOTSPOT[1]} * $SIZE / 500" | bc)
HOTY=$(echo "${HOTSPOT[2]} * $SIZE / 500" | bc)

xcursor_config="$(dirname $outfile)/${NAME}.conf"
if [[ $frame < 2 ]] ; then
    if [ -e "${xcursor_config}" ]; then
        rm "${xcursor_config}"
    fi
fi
if [[ $frame > 0 ]] ; then
    echo "$SIZE $HOTX $HOTY $outfile $TIME" >> "${xcursor_config}"
else
    echo "$SIZE $HOTX $HOTY $outfile" >> "${xcursor_config}"
fi

bare_image="${outfile%.png}.bare.png"
shadow_image="${outfile%.png}.shadow.png"
silhouette_image="${outfile%.png}.silhouette.png"

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

# Render the bare cursor image.

svg2png "$infile" "$bare_image" $TMPSIZE

# Make the shadow image from an extract of the bare image.

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

# Apply alpha-channel opacity to the bare image.

if [ $(echo "$CURSORTRANS > 0" | bc) -gt 0 ]; then
    convert -channel Alpha -fx \'a-$CURSORTRANS\' "$bare_image" "$bare_image"
fi

# Compose the final image.

composite -geometry ${SIZE}x${SIZE} "$bare_image" "$shadow_image" "$outfile"

if [ "$background_image" ]; then
    composite "$outfile" "$background_image" "$outfile"
fi
