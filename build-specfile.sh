#!/bin/sh

# argument processing and usage
function show_usage_message {
    cat <<_EOT_
Usage: $0 [option]

Generate the ComixCursors RPM spec file.

Uses the environment variables PACKAGENAME, VERSION, and SUMMARY to
determine the parameters of the spec file.

Options:
    -h:    Display this help text, then exit.
    -u:    Remove the .spec file.

_EOT_
}

while getopts ":uh" opt; do
    case $opt in
        h)
            show_usage_message
            exit
            ;;
        u)
            UNINSTALL=true
            ;;
        *)
            printf "Unexpected option: -%s\n" "$OPTARG" >&2
            show_usage_message
            exit 2
            ;;
    esac
done

# start here

function build_spec_file {

    PACKAGENAME=${PACKAGENAME:-$1}
    VERSION=${VERSION:-$2}
    shift 2
    SUMMARY=${SUMMARY:-$*}
    SPECFILE=${PACKAGENAME}.spec

    if [ $UNINSTALL ] ; then
        rm ${SPECFILE}
    else
        sed "s/PACKAGENAME/${PACKAGENAME}/g" ComixCursors.spec.in \
            | sed "s/VERSION/${VERSION}/g" \
            | sed "s/SUMMARY/${SUMMARY}/g" \
            > ${SPECFILE}
        cat NEWS >> ${SPECFILE}
    fi
}

build_spec_file ComixCursors 0.7 The original Comix Cursors
