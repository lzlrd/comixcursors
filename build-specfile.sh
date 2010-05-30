#!/bin/sh

# argument processing and usage
function usage {
  echo ""
  echo "  $0 [OPTION]"
  echo "  Generate the ComixCursors RPM .spec files."
  echo "  OPTIONS:"
  echo "    -h:    Display this help."
  echo "    -u:    Remove the .spec files."
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

# start here

function build_spec_file {

  CURSORSNAME=${CURSORSNAME:-$1}
  VERSION=${VERSION:-$2}
  shift 2
  SUMMARY=${SUMMARY:-$*}
  SPECFILE=${CURSORSNAME}.spec

  if [ $UNINSTALL ] ; then
    rm ${SPECFILE}
  else 
    sed "s/CURSORSNAME/${CURSORSNAME}/g" ComixCursors.spec.in \
      | sed "s/VERSION/${VERSION}/g" \
      | sed "s/SUMMARY/${SUMMARY}/g" \
      > ${SPECFILE}
    cat NEWS >> ${SPECFILE}
  fi
}

build_spec_file ComixCursors 0.7 The original Comix Cursors

