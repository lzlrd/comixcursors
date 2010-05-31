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

SHELL=/bin/bash

ICONSDIR ?= ${HOME}/.icons
THEMENAME ?= custom

GENERATED_FILES :=

ifeq (@LH-,$(findstring @LH-,@${THEMENAME}))
	orientation = LeftHanded
else
	orientation = RightHanded
endif

svgdir = svg
indir = ${svgdir}/${orientation}
configdir = ComixCursorsConfigs
configfile = ${configdir}/${THEMENAME}.CONFIG
themefile = ${configdir}/${THEMENAME}.theme
workdir = tmp
builddir = build
xcursor_builddir = cursors

destdir = ${ICONSDIR}/ComixCursors-${THEMENAME}
xcursor_destdir = ${destdir}/cursors

template_configfile = ${configdir}/custom.CONFIG
template_themefile = ${configdir}/custom.theme

# Derive cursor file names.
conffiles = $(wildcard ${builddir}/*.conf)
cursornames = $(foreach conffile,${conffiles},$(basename $(notdir ${conffile})))
cursorfiles = $(foreach cursor,${cursornames},${xcursor_builddir}/${cursor})

GENERATED_FILES += ${svgdir}/*/*.frame*.svg
GENERATED_FILES += ${workdir}
GENERATED_FILES += ${builddir}
GENERATED_FILES += ${xcursor_builddir}

# Packaging files.
news_file = NEWS
news_content = NEWS.content.txt
rpm_spec_file = ComixCursors.spec
rpm_spec_template = ${rpm_spec_file}.in

GENERATED_FILES += ${news_content} ${rpm_spec_file}


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

.PHONY: uninstall
uninstall:
	$(RM) -r ${destdir}


.PHONY: custom-theme
custom-theme: ${configfile} ${themefile}

${configfile}: ${template_configfile}
	cp "$<" "$@"

${themefile}: ${template_themefile}
	cp "$<" "$@"


.PHONY: rpm
rpm: ${rpm_spec_file}

${news_content}: ${news_file}
	# Get only the news entries from the news file.
	tac "$<" \
	| awk ' \
		{ text_buffer = text_buffer $$0 ORS ; if (formfeed_seen) print } \
		/^\x0c/ { if (!formfeed_seen) { formfeed_seen = 1 ; next } } \
		END { if (!formfeed_seen) { ORS = "" ; print text_buffer } }' \
	| tac > "$@"

${rpm_spec_file}: ${rpm_spec_template} ${news_content}
	cat "$<" "${news_content}" > "$@"


.PHONY: clean
clean:
	$(RM) -r ${GENERATED_FILES}


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
