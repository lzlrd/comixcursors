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
  echo "    -PART <part>              animated cursors part#"
  echo "    -BACKGROUND <file>        background image file"
  echo "    -TIME <milliseconds>      duration for this animation frame"
  echo ""
  exit -1
fi

# don't do transparency post-processing by default
# used for ComixCursors but not for flatbedcursors
CURSORTRANS=0

# read config file .sh syntax)
source CONFIG

# some initialisation before argument processing
PART=0
FIXPART=""

# parse argument list
while [ "${1::1}" == "-" ]; do
    case $1 in
	-PART)
            shift
	    PART=$1
	    ;;
	-BACKGROUND)
	    shift
	    BACKGROUND="$1"
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

if [ ! -d tmp ]; then mkdir tmp ; fi
if [ ! -d shadows ]; then mkdir shadows ; fi

if [ $PART -lt 1 ]; then
	echo "processing $NAME..."
else
	echo "processing $NAME part $PART..."
	FIXPART=$PART
	SUBPATH="$NAME"/
fi

# write the hotspot config file
if [ $BACKGROUND ] ; then
    background_file="$(basename $BACKGROUND)"
    hotspot_name="${background_file%%.png}"
else
    hotspot_name="$NAME"
fi
HOTSPOT=( $(grep "^$hotspot_name" HOTSPOTS) )

HOTX=$(echo "${HOTSPOT[1]} * $SIZE / 500" | bc)
HOTY=$(echo "${HOTSPOT[2]} * $SIZE / 500" | bc)

cursorconfig="$(dirname $outfile)/${NAME}.conf"
if [ $PART -lt 2 ]; then
    if [ -e "${cursorconfig}" ]; then
        rm "${cursorconfig}"
    fi
fi
if [ $PART -gt 0 ]; then
    echo "$SIZE $HOTX $HOTY $outfile $TIME" >> "${cursorconfig}"
else
    echo "$SIZE $HOTX $HOTY $outfile" >> "${cursorconfig}"
fi

SHADOWIMAGE="shadows/$NAME-$SIZE-$SHADOWCOLOR-$SHADOWTRANS.png"
CURSORIMAGE="tmp/cursor.png"
SCALEDIMAGE="tmp/scaledcursor.png"

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

# compose the image
svg2png "$infile" "$CURSORIMAGE" $TMPSIZE

if [ ! -f "$SHADOWIMAGE" ]; then
    # Make the shadow image from an extract of the cursor.
    convert \
        -extract ${SHADOWSIZE}x${SHADOWSIZE}+${LEFT}+${LEFT} \
        -resize ${TMPSIZE}x${TMPSIZE} \
        "$CURSORIMAGE" "$SCALEDIMAGE"

  convert -modulate 0 \
     -fill "$SHADOWCOLOR" \
     -colorize 100 \
     -channel Alpha \
     -fx \'a-$SHADOWTRANS\' \
     "$SCALEDIMAGE" "$SHADOWIMAGE"

  mogrify -channel Alpha \
     -blur ${SCALEBLUR}x${SCALEBLUR} \
     -resize 50% \
     "$SHADOWIMAGE"

  mogrify -roll +${XMOVE}+${YMOVE} \
     "$SHADOWIMAGE"
fi

if [ $(echo "$CURSORTRANS > 0" | bc) -gt 0 ]; then
   # echo "applying cursor transparency: $CURSORTRANS ..."
   convert -channel Alpha -fx \'a-$CURSORTRANS\' "$CURSORIMAGE" "$CURSORIMAGE"
fi

composite -geometry ${SIZE}x${SIZE} "$CURSORIMAGE" "$SHADOWIMAGE" "$outfile"

if [ "$BACKGROUND" ]; then
    composite "$outfile" "$BACKGROUND" "$outfile"
fi
