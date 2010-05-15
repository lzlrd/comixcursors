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
destdir = ${ICONSDIR}/ComixCursors-${THEMENAME}
cursordir = ${destdir}/cursors
BUILDDIR = cursors

# Derive cursor file names.
conffiles = $(wildcard build/*.conf)
cursorfiles:= $(foreach conffile,$(conffiles),$(BUILDDIR)/$(subst ./,,$(subst .conf,,$(subst build/,,$(conffile)))))
cursornames:= $(foreach conffile,$(conffiles),$(subst ./,,$(subst .conf,,$(subst build/,,$(conffile)))))
animcursornames = wait progress help
animcursorfiles := $(foreach cursorname,${animcursornames},$(BUILDDIR)/${cursorname})


.PHONY: all
all: ${cursorfiles} ${animcursorfiles}

.PHONY: install
install: all
# Create necessary directories.
	install -d "${ICONSDIR}" "${ICONSDIR}/default"
	rm -rf "${destdir}"
	install -d "${cursordir}"

# Install the cursors.
	install -m u=rw,go=r "${BUILDDIR}"/* "${cursordir}"

# Install the theme configuration file.
	install -m u=rw,go=r "${themefile}" "${destdir}"/index.theme

# Install alternative name symlinks for the cursors.
	./link-cursors "${cursordir}"

# Normal Cursors
define CURSOR_template
$(BUILDDIR)/$(1): build/$(1).conf build/$(1).png
	xcursorgen "$$<" "$$@"
endef

$(foreach cursor,${cursornames},$(eval $(call CURSOR_template,$(cursor))))

# Animated Cursors
define ANIMCURSOR_template
$(BUILDDIR)/$(1): build/$(1)/$(1).conf build/$(1)/*.png
	xcursorgen "$$<" "$$@"
endef

$(foreach anim,${animcursornames},$(eval $(call ANIMCURSOR_template,$(anim))))

.PHONY: clean
clean::
# cleanup temporary build files
	$(RM) -r ${indir}/*.orig ${indir}/*.rej
	$(RM) -r ${indir}/progress[0-9]*.svg
	$(RM) -r ${indir}/wait[0-9]*.svg
	$(RM) -r build
	$(RM) -r cursors
	$(RM) -r tmp
	$(RM) -r shadows


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
