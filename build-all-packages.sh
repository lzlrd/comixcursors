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

# This script creates all four packages of ComixCursors for distribution
# from the sources. 
# It's ment to be run from the directory containig the sources e.g.
#
# > ls -l
# -rw-r--r-- 1 user users   433 20. Jun 12:07 build-all-packages.sh
# drwxr-xr-x 4 user users  4096 20. Jun 11:56 ComixCursors-LH-opaque-sources-0.6.1
# drwxr-xr-x 8 user users  4096 20. Jun 11:56 ComixCursors-LH-sources-0.6.1
# drwxr-xr-x 8 user users  4096 20. Jun 11:56 ComixCursors-opaque-sources-0.6.1
# drwxr-xr-x 8 user users  4096 20. Jun 12:06 ComixCursors-sources-0.6.1

VERSION="0.6.1"
PKGS="ComixCursors-LH-opaque ComixCursors-LH ComixCursors-opaque ComixCursors"
BASEDIR=$PWD
DISTDIR=$PWD/dist

# Set the ICONSDIR destination to a default (if not already set).
ICONSDIR=${ICONSDIR:-~/.icons}
export ICONSDIR

mkdir --parents $DISTDIR
rm -rf $DISTDIR/*

for PKG in $PKGS; do
  
  cd $BASEDIR
  SUBDIR=$PKG-sources-$VERSION

  if [ ! -d $SUBDIR ] ; then
    echo "Error: directory $SUBDIR not found, exiting."
    break
  fi

  echo "Packaging $PKG $VERSION..."

  #
  # source packages
  #
  echo "Creating source package..."

  cd $SUBDIR
  make clean
  cd $BASEDIR
  TARFILE=$SUBDIR.tar.bz2
  if [ -f $TARFILE ] ; then rm $TARFILE; fi
  tar -cjf $TARFILE $SUBDIR
  mv $TARFILE $DISTDIR

  echo "Installing cursor files..."

  cd $SUBDIR
  ./install-all.sh
  cp cursorlinks ${ICONSDIR}/

  #
  # cursors packages
  #
  echo "Creating cursors package..."

  # now it's important that the $PKGS get processed in an "reverse" order,
  # so only directories matching package name get packed. 

  cd ${ICONSDIR}/ 
  TARFILE=$PKG-$VERSION.tar.bz2
  if [ -f $TARFILE ] ; then rm $TARFILE; fi
  tar -cjhf $TARFILE $PKG* cursorlinks
  mv $TARFILE $DISTDIR
  rm -rf $PKG*

  #
  # RPM packages
  #
  PKGDIR=/usr/src/packages
  if [ -d $PKGDIR ] ; then
    echo "Creating RPM package..."
    cd $BASEDIR
    cp $SUBDIR/$PKG.spec $PKGDIR/SPECS/$PKG.spec
    cp $DISTDIR/$PKG-$VERSION.tar.bz2 $PKGDIR/SOURCES/$PKG-$VERSION.tar.bz2
    cd $PKGDIR/SOURCES/
    rpmbuild -bb $PKGDIR/SPECS/$PKG.spec
    mv $PKGDIR/RPMS/noarch/$PKG* $DISTDIR
  else 
    echo "Directory /usr/src/packages not found, skipping RPM packaging."
  fi

done
