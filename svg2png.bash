#!/bin/bash
##########################################################
# svg2png.bash                                           #
# 2006 Jens Luetkens <j.luetkens@limitland.de>           #
# version: ComixCursors 0.5.0                            #
#          flatbedcursors 0.1 (compatible)               #
#                                                        #
# take a simple svg file, export it to an image,         #
# do some image magig, generate a shadow, scale          #
# and merge it to a single image                         #
#                                                        #
# Required tools:                                        #
# ImageMagick : http://www.imagemagick.org               #
# Inkscape    : http://www.inkscape.org                  #
#                                                        #
##########################################################

if [ $# -lt 1 ]; then
  echo ""
  echo "Usage: $0 <in name> {options}"
  echo ""
  echo "Options:"
  echo "    -PART <part>              animated cursors part#"
  echo "    -BACKGROUND <name>        background image name"
  echo "    -SHADOW <name>            shadow image name"
  echo "    -TIME <milliseconds>      background image name"
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
NAME=$1
SHADOW=$NAME

# parse argument list
while [ "$1" != "" ]; do
	case $1 in
		-PART  )	shift
					PART=$1
					;;
		-BACKGROUND  )	shift
					BACKGROUND=$1
					;;
		-SHADOW  )	shift
					SHADOW=$1
					;;
		-TIME  )	shift
					TIME=$1
					;;
	esac
	shift
done

TMPSIZE=`echo " $SIZE * $TMPSCALE" | bc`

XMOVE=`echo "$XOFFSET * $TMPSCALE" | bc`
YMOVE=`echo "$YOFFSET * $TMPSCALE" | bc`

SCALEBLUR=`echo "$BLUR * $TMPSCALE" | bc`
SCALESIZE=`echo "$SIZE * $TMPSCALE" | bc`
CROP=`echo "($SCALESIZE - $TMPSIZE) / 2" | bc`

# scaling the shadow from a 500x500 px image
RIGHT=`echo "500 / $SHADOWSCALE" | bc`
LEFT=`echo "500 - $RIGHT" | bc`

if [ ! -d tmp ]; then mkdir tmp ; fi
if [ ! -d shadows ]; then mkdir shadows ; fi

if [ $PART -lt 1 ]; then
	echo "processing $NAME..."
else
	echo "processing $NAME part $PART..."
	FIXPART=$PART
	SUBPATH=$NAME/
fi

# write the hotspot config file
if [ $BACKGROUND ] ; then 
  HOTSPOT=(`grep "^$BACKGROUND" HOTSPOTS`)
else 
  HOTSPOT=(`grep "^$NAME" HOTSPOTS`)
fi
	
HOTX=`echo "${HOTSPOT[1]} * $SIZE / 500" | bc`
HOTY=`echo "${HOTSPOT[2]} * $SIZE / 500" | bc`
	
if [ $PART -lt 2 ]; then
  if [ -e build/$SUBPATH$NAME.conf ]; then
    rm build/$SUBPATH$NAME.conf
  fi
fi 
if [ $PART -gt 0 ]; then
  echo "$SIZE $HOTX $HOTY build/$SUBPATH$NAME$PART.png $TIME" >> build/$SUBPATH$NAME.conf
else
  echo "$SIZE $HOTX $HOTY build/$NAME.png" >> build/$NAME.conf
fi

INFILE=tmp/tmp.svg
OUTFILE=build/$SUBPATH$NAME$FIXPART.png
SHADOWIMAGE=shadows/$SHADOW-$SIZE-$SHADOWCOLOR-$SHADOWTRANS.png
CURSORIMAGE=tmp/cursor.png
SCALEDIMAGE=tmp/scaledcursor.png

# compose the image
inkscape -e $CURSORIMAGE \
   -w $TMPSIZE \
   -h $TMPSIZE \
   -b $OUTLINECOLOR \
   -y 0 \
   -d 72 \
   $INFILE >> /dev/null

if [ ! -f $SHADOWIMAGE ]; then
  # echo "creating shadow image $SHADOWIMAGE..."
  # scaling the shadow must be done with exporting a different area from inkscape...
  inkscape -e $SCALEDIMAGE \
     -a $LEFT:$LEFT:$RIGHT:$RIGHT \
     -w $TMPSIZE \
     -h $TMPSIZE \
     -b $OUTLINECOLOR \
     -y 0 \
     -d 72 \
   $INFILE >> /dev/null
  
  convert -modulate 0 \
     -fill "$SHADOWCOLOR" \
     -colorize 100 \
     -channel Alpha \
     -fx \'a-$SHADOWTRANS\' \
     $SCALEDIMAGE $SHADOWIMAGE

  mogrify -channel Alpha \
     -blur $SCALEBLUR\x$SCALEBLUR \
     -resize 50% \
     $SHADOWIMAGE

  mogrify -roll +$XMOVE+$YMOVE \
     $SHADOWIMAGE
fi

if [ `echo "$CURSORTRANS > 0" | bc` -gt 0 ]; then
   # echo "applying cursor transparency: $CURSORTRANS ..."
   convert -channel Alpha -fx \'a-$CURSORTRANS\' $CURSORIMAGE $CURSORIMAGE
fi

composite -geometry $SIZEx$SIZE $CURSORIMAGE $SHADOWIMAGE $OUTFILE

if [ $BACKGROUND ]; then
   composite $OUTFILE build/$BACKGROUND.png $OUTFILE
fi
