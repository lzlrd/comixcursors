#! /usr/bin/make -f
#
# Makefile
# Part of ComixCursors, a desktop cursor theme.
#
# Copyright © 2010 Ben Finney <ben+gnome@benfinney.id.au>
# Copyright © 2006–2010 Jens Luetkens <j.luetkens@hamburg.de>
# Copyright © 2003 Unai G
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

# Makefile for ComixCursors project.

ICONSDIR ?= ${HOME}/.icons
THEMENAME ?= custom

indir = svg
themefile = ComixCursorsConfigs/${THEMENAME}.theme
workdir = tmp
builddir = build
xcursor_builddir = cursors

destdir = ${ICONSDIR}/ComixCursors-${THEMENAME}
xcursor_destdir = ${destdir}/cursors

# Derive cursor file names.
conffiles = $(wildcard ${builddir}/*.conf)
cursornames = $(foreach conffile,${conffiles},$(basename $(notdir ${conffile})))
cursorfiles = $(foreach cursor,${cursornames},${xcursor_builddir}/${cursor})


.PHONY: all
all: ${cursorfiles}

${xcursor_builddir}/%: ${builddir}/%.conf ${builddir}/%*.png
	xcursorgen "$<" "$@"


.PHONY: install
install: all
# Create necessary directories.
	install -d "${ICONSDIR}" "${ICONSDIR}/default"
	rm -rf "${destdir}"
	install -d "${xcursor_destdir}"

# Install the cursors.
	install -m u=rw,go=r "${xcursor_builddir}"/* "${xcursor_destdir}"

# Install the theme configuration file.
	install -m u=rw,go=r "${themefile}" "${destdir}"/index.theme

# Install alternative name symlinks for the cursors.
	./link-cursors "${xcursor_destdir}"

.PHONY: clean
clean::
# cleanup temporary build files
	$(RM) -r ${indir}/progress[0-9]*.svg
	$(RM) -r ${indir}/wait[0-9]*.svg
	$(RM) -r ${builddir}
	$(RM) -r ${xcursor_builddir}
	$(RM) -r ${workdir}


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
