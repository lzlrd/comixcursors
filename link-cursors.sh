#!/bin/sh
#
# link-cursors.sh
# Create cursor-name links to make them work on various desktops. 
# This file is part of the ComixCursors package.
# 

if [ $# -ne 1 ] ; then
        echo "usage: $0 <CursorDirectory>"
        exit 1
fi

cd $1

# some basic X11 cursors

ln -sf default		left_ptr			# kcontrol mouse theme selection
ln -sf right-arrow	right_ptr			# not seen by now
ln -sf right-arrow	arrow				# nedit menu
ln -sf up-arrow		center_ptr			# QT examples cursors
ln -sf cell		cross				# QT examples cursors
ln -sf all-scroll	fleur				# mozilla move cursor
ln -sf help		question_arrow			# kcontrol mouse theme selection
ln -sf wait		watch				# kcontrol mouse theme selection
ln -sf progress		left_ptr_watch			# kcontrol mouse theme selection
ln -sf pointer		hand2				# kcontrol mouse theme selection
ln -sf col-resize	sb_h_double_arrow		# kcontrol mouse theme selection, mozilla resize cursor
ln -sf row-resize	sb_v_double_arrow		# mozilla resize cursor
ln -sf text		xterm				# konsole, konqueror, ...


# the KDE/Qt Cursor Hashes

ln -sf col-resize 	14fef782d02440884392942c11205230
ln -sf row-resize	2870a09082c103050810ffdffffe0204

ln -sf nwse-resize	c7088f0f3e6c8088236ef8e1e3e70000
ln -sf nesw-resize	fcf1c3c7cd4491d801f1e1c78f100000
ln -sf ns-resize	00008160000006810000408080010102
ln -sf ew-resize	028006030e0e7ebffc7f7070c0600140

ln -sf pointer		e29285e634086352946a0e7090d73106
ln -sf move		4498f0e0c1937ffe01fd06f973665830

ln -sf alias		640fb0e74195791501fd1ed57b41487f
ln -sf copy		6407b0e94181790501fd1e167b474872

ln -sf no-drop		03b6e0fcb3499374a867c041f52298f0
ln -sf help		d9ce0ab605698f320427677b458ad60b
ln -sf wait		0426c94ea35c87780ff01dc239897213
ln -sf progress		9116a3ea924ed2162ecab71ba103b17f

ln -sf all-scroll	9d800788f1b08800ae810202380a0822 # hand1, not seen by now
ln -sf progress		3ecb610c1bf2410f44200f48c40d3599 # left_ptr_watch, not seen by now
ln -sf copy		1081e37283d90000800003c07f3ef6bf # copy, not seen by now
ln -sf alias		3085a0e285430894940527032f8b26df # link, not seen by now
ln -sf move		9081237383d90e509aa00f00170e968f # move, not seen by now


# the Gnome cursor links

ln -sf nesw-resize	top_right_corner
ln -sf nesw-resize	bottom_left_corner
ln -sf nwse-resize	top_left_corner
ln -sf nwse-resize	bottom_right_corner
ln -sf ew-resize	left_side
ln -sf ew-resize	right_side
ln -sf ns-resize	top_side
ln -sf ns-resize	bottom_side
ln -sf all-scroll	plus

# since gtk 2.8
ln -sf help		dnd-ask
ln -sf copy		dnd-copy
ln -sf alias		dnd-link
ln -sf move		dnd-move
ln -sf no-drop		dnd-none


# the Mozilla cursor hashes

ln -sf progress		08e8e1c95fe2fc01f976f1e063a24ccd # moz-spinning
ln -sf help		5c6cd98b3f3ebcb1f9c7f1c204630408 # mozilla's question_arrow
ln -sf all-scroll	5aca4d189052212118709018842178c0 # moz-grab
ln -sf grabbing		208530c400c041818281048008011002 # moz-grabbing
ln -sf zoom-in		f41c0e382c94c0958e07017e42b00462 # moz-zoom-in
ln -sf zoom-out		f41c0e382c97c0938e07017e42800402 # moz-zoom-out
ln -sf copy		08ffe1cb5fe6fc01f906f1c063814ccf # moz-copy
ln -sf alias		0876e1c15ff2fc01f906f1c363074c0f # moz-alias
ln -sf context-menu	08ffe1e65f80fcfdf9fff11263e74c48 # moz-context-menu
# what is moz-cell?

# Mozilla cursor hashes for CSS3 cursor property

ln -sf no-drop          03b6e0fcb3499374a867d041f52298f0 # no-drop/not-allowed
ln -sf vertical-text	048008013003cff3c00c801001200000 # vertical-text
ln -sf col-resize       043a9f68147c53184671403ffa811cc5 # col-resize
ln -sf row-resize       c07385c7190e701020ff7ffffd08103c # row-resize
ln -sf nesw-resize      50585d75b494802d0151028115016902 # nesw-resize
ln -sf nwse-resize      38c5dff7c7b8962045400281044508d2 # nwse-resize

