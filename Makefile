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
