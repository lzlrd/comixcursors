Name:           ComixCursors
Version:        0.6.1
Release:        1%{?dist}
Summary:        The original Comix Cursors

Group:          System/X11/Icons
License:        LGPLv3
URL:            http://kde-look.org/content/show.php?content=32627
Source0:        %{name}-%{version}.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildArch:	noarch

Requires: 	XFree86

Packager:	Jens Luetkens <j.luetkens@hamburg.de>
Distribution:	generic

prefix: /usr/share

%description
X11 mouse theme with a comics feeling.
 Package comes with 50 different mouse themes for X11.
 6 colors (black, blue, green, orange, red and white)
 4 different sizes (small, regular, large and huge)
 2 different weights (slim and normal)
 ..
 and one for christmas and one with ghost

%prep
%setup -q -c %{name}-%{version} -n %{name}-%{version}

%build

%install
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"

install -d %{buildroot}%{prefix}/icons

for d in %{name}-*; do
    ./link-cursors "$d/cursors"
    cp -R $d %{buildroot}%{prefix}/icons
done


%clean
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"

%files
%defattr(-,root,root,-)
#%doc AUTHORS COPYING README ChangeLog
%dir %{prefix}/icons/%{name}-*
%{prefix}/icons/%{name}-*/*



%changelog
* Mon Nov 02 2009 Jens Luetkens <j.luetkens@limitland.de> - 0.6.1
- fix install script to process all files correctly

* Fri Jun 19 2009 Jens Luetkens <j.luetkens@endiancode.de> - 0.6.0
- license changed to LGPLv3
- added red cursors
- add mozilla css3 cursor hashes (thanx to thx)

* Fri May 30 2008 Jens Luetkens <j.luetkens@endiancode.de> - 0.5.1
- progress animation expanded to 24 frames
- wait cursor fixes
- zoom cursor fixes

* Fri Sep 14 2007 Jens Luetkens <j.luetkens@limtiland.de> - 0.5.0
- optimized build script caching shadow files
- svgs and HOTSPOTS scaled to 500x500 to match svg2png script
- slight svg fixes and cleanup
- opaque versions

* Thu Sep 14 2006 Jens Luetkens <j.luetkens@limitland.de> 0.4.3
- fixed .theme file syntax (=), thanks to Sune Vuorela

* Fri Jul 14 2006 Jens Luetkens <j.luetkens@hamburg.de> - 0.4.2
- added Huge cursor size
- rpm installation now into /usr/share/icons

* Fri Feb 10 2006 Jens Luetkens <j.luetkens@hamburg.de> - 0.4.1
- additional dnd cursor links for gnome (and firefox)

* Wed Feb 08 2006 Jens Luetkens <j.luetkens@hamburg.de> - 0.4
- freedesktop cursor names
- additional mozilla cursors
- add left-handed packages (-LH)

* Thu Dec 22 2005 Jens Luetkens <j.luetkens@hamburg.de> - 0.3.2
- grab hand fix (firefox)

* Thu Dec 22 2005 Jens Luetkens <j.luetkens@hamburg.de> - 0.3.1
- mozilla/firefox fix

* Thu Dec 22 2005 Jens Luetkens <j.luetkens@hamburg.de> - 0.3
- added black (and christmas)
- single configuration file
- cleanup

* Mon Dec 19 2005 Jens Luetkens <j.luetkens@hamburg.de> - 0.2
- four colors (and ghost)
- three sizes
- sources
- customization script

* Sat Dec 17 2005 Jens Luetkens <j.luetkens@hamburg.de> - 0.1
- initial version white
