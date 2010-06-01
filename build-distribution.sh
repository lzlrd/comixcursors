#! /bin/sh
# build-all-packages.sh
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
#
# This script creates all four packages of ComixCursors for distribution
# from the sources. Run it as root from inside the sources directory. 
#

CURSORSNAME=ComixCursors
VERSION="0.7"
export VERSION
SRCDIR=$PWD
DISTDIR=$PWD/dist

# Set the ICONSDIR destination to a default (if not already set).
ICONSDIR=${ICONSDIR:-~/.icons}
export ICONSDIR

mkdir --parents $DISTDIR
rm -rf $DISTDIR/*

if [ ! -d $DISTDIR ] ; then
  echo "Error: DISTDIR $DISTDIR not found, exiting."
  break
fi

#
# start
#

echo "Packaging $CURSORSNAME-$VERSION..."

#
# source packages
#
echo "Creating source package..."

cd $SRCDIR
make clean
cd ..
TARFILE=ComixCursors-sources-$VERSION.tar.bz2
if [ -f $TARFILE ] ; then rm $TARFILE; fi
tar -cjf $TARFILE $SRCDIR
mv $TARFILE $DISTDIR

#
# Now build the cursors for packaging.
#
echo "Installing cursor files..."

cd $SRCDIR
./install-all.sh

# Build one of the theme packages.
function build_packages {

  CURSORSNAME=$1
  shift 1
  SUMMARY=$*
  export CURSORSNAME
  export SUMMARY

  #
  # cursors packages
  #
  echo "Creating cursors package..."

  # now it's important that the $CURSORSNAME get processed in an "reverse" order,
  # so only directories matching package name get packed and deleted afterwards.

  cd ${ICONSDIR}/ 
  TARFILE=$CURSORSNAME-$VERSION.tar.bz2
  if [ -f $TARFILE ] ; then rm $TARFILE; fi
  tar -cjf $TARFILE $CURSORSNAME*
  mv $TARFILE $DISTDIR
  rm -rf $CURSORSNAME*

  #
  # RPM packages
  #
  PKGDIR=/usr/src/packages
  if [ -d $PKGDIR ] ; then
    echo "Creating RPM package..."
    cd $SRCDIR
    sh build-specfile.sh
    cp $CURSORSNAME.spec $PKGDIR/SPECS/$CURSORSNAME.spec
    cp $DISTDIR/$CURSORSNAME-$VERSION.tar.bz2 $PKGDIR/SOURCES/$CURSORSNAME-$VERSION.tar.bz2
    cd $PKGDIR/SOURCES/
    rpmbuild -bb $PKGDIR/SPECS/$CURSORSNAME.spec
    mv $PKGDIR/RPMS/noarch/$CURSORSNAME* $DISTDIR
  else 
    echo "Directory $PKGDIR not found, skipping RPM packaging."
  fi

}

build_packages ComixCursors-LH-Opaque The opaque left-handed Comix Cursors
build_packages ComixCursors-LH The left-handed Comix Cursors
build_packages ComixCursors-Opaque The opaque Comix Cursors
build_packages ComixCursors The original Comix Cursors


