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
CURSORDIR = ${ICONSDIR}/ComixCursors-Custom
BUILDDIR = cursors

#Define here the animation cursor directories
ANIMATED_CURSORS:= wait progress help

########################################################################

#Find list of cursors
conffiles = $(wildcard build/*.conf)
cursorfiles:= $(foreach conffile,$(conffiles),$(BUILDDIR)/$(subst ./,,$(subst .conf,,$(subst build/,,$(conffile)))))
cursornames:= $(foreach conffile,$(conffiles),$(subst ./,,$(subst .conf,,$(subst build/,,$(conffile)))))
animcursorfiles:=$(foreach animationfile,$(ANIMATED_CURSORS),$(BUILDDIR)/$(animationfile))
animcursornames:=$(ANIMATED_CURSORS)

CURSORS = $(cursorfiles)
CURSORNAMES= $(cursornames)
ANIMATIONS= $(animcursorfiles)
ANIMATIONNAMES=$(animcursornames)


.PHONY: all

all: $(CURSORS) $(ANIMATIONS)

install: all
#	Create necessary directories
	if test ! -d ${ICONSDIR} ;then mkdir ${ICONSDIR}; fi
	if test ! -d ${ICONSDIR}/default ;then mkdir ${ICONSDIR}/default;fi
	if test -d $(CURSORDIR) ;then rm -rf $(CURSORDIR); fi
	if test ! -d $(CURSORDIR) ;then mkdir $(CURSORDIR); fi
	if test ! -d $(CURSORDIR)/cursors ;then mkdir $(CURSORDIR)/cursors; fi

#	Copy the cursors
	cp -Rf $(BUILDDIR)/* $(CURSORDIR)/cursors

#	Copy the configuration file
	cp -f  index.theme $(CURSORDIR)

	sh link-cursors.sh $(CURSORDIR)/cursors

#Normal Cursors
define CURSOR_template
$(BUILDDIR)/$(1): build/$(1).png build/$(1).conf
	xcursorgen build/$(1).conf $(BUILDDIR)/$(1)
endef

$(foreach cursor,$(CURSORNAMES),$(eval $(call CURSOR_template,$(cursor))))

#Animated Cursors
define ANIMCURSOR_template
$(BUILDDIR)/$(1):  build/$(1)/$(1).conf build/$(1)/*.png
	xcursorgen build/$(1)/$(1).conf $(BUILDDIR)/$(1)
endef

$(foreach anim,$(ANIMATIONNAMES),$(eval $(call ANIMCURSOR_template,$(anim))))

.PHONY: clean
clean:: clean-all

.PHONY: clean-all
clean-all:: clean-build clean-cursors clean-tmp clean-shadows

.PHONY: clean-build
clean-build::
	$(RM) -r build

.PHONY: clean-cursors
clean-cursors::
	$(RM) -r cursors

.PHONY: clean-tmp
clean-tmp::
	$(RM) -r tmp

.PHONY: clean-shadows
clean-shadows::
	$(RM) -r shadows


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
