REBOL [
	Title: "Image Sorter"
	File:   %image-sort.r
	Date:   10-Jun-2000
	Version: 1.0.0
	Author: "Carl Sassenrath"
	Email: carl@rebol.com
	Purpose: {
		A great tool for sorting images into separate directories
		or deleting images.  Includes scrolling list of image
		files with highlight and scrolling list of target directories.
		Also uses cursor keys, space, and backspace for navigation.
	}
	Category: [view VID 3]
]

files: []
dirs: []
dirn: num: 0 ; scroll offsets
date-of?: func [f] [all [f: modified? f  f/date]]

show-img: does [
	if a-file [
		img/image: load root/:a-file
		name/text: reform [
			a-file "-" size? root/:a-file "bytes -" date-of? root/:a-file]
		show [name img]
	]
	show l1
]

do-file: func [/move dir] [
	if a-file [
		if move [write/binary root/:dir/:a-file read/binary root/:a-file]
		remove dir: find files a-file
		delete root/:a-file
		if tail? dir [dir: back dir]
		a-file: pick dir 1 ; could be none
	]
	show-img
]

next-file: func [/reverse /local file] [
	if a-file: all [
		file: find files a-file
		file: either reverse [back file] [
			either tail? next file [file] [file: next file]
		]
		pick file 1  ; could be none
	][
		if (index? file) <= num [num: max 0 num - 1]
		if (index? file) > (num + max-files) [num: num + 1]
		show l1
	]
	show-img
]

read-dir: [
	root: dirize either empty? trim dir-fld/text [%.][to-file dir-fld/text]
	either error? try [files: read root] [
		e1/text: reform ["Invalid directory:" root]
		e1/font/color: 240.50.10  show e1
	][unview/all]
]

view layout [
	backdrop effect [gradient 0x1 50.80.128 10.10.10]
	title "View what directory?" font [size: 16]
	dir-fld: field 300x24 read-dir
	across button "Enter" #"^M" read-dir
	button "Cancel" #"^(ESC)" [quit] return
	e1: text bold "(Just press Enter for current directory)"
]

while [not tail? files] [  ; find dirs and images
	file: files/1
	any [
		all [dir? root/:file  append dirs file  remove files]
		all [find [%.bmp %.jpg %.gif] find/last file "."
			files: next files
		]
		remove files
	]
]
files: head files

view layout [
	style bx text bold center middle 120x20 with [color: 0.0.100]
	backdrop effect [gradient 0x1 50.80.128 10.10.10]
	across at 20x20
	text "REBOL Image Sorter" 130x24 yellow bold middle ;font [size: 16]
	name: bx 360x24 font [style: none]
	sensor 1x1 keycode [right down #" "] [next-file]
	sensor 1x1 keycode [left up #"^(back)"] [next-file/reverse]
	button "Delete File" 160.0.0 #"^(del)" [do-file]
	tog: toggle "Fit" 50x24 colors [0.100.0 0.200.0] [
		img/effect: either tog/state [[aspect]][none] show img
	]
	button "Quit" 50x24 #"^(ESC)" [quit]
	return  space 0  pad 0x10
	t0: bx "Image Files" return
	l1: list 120x400 [
		t1: text 116x14 font [size: 10 color: black shadow: none] [
			a-file: t1/text  t1/font/color: black  show-img
		]
	] supply [
		count: count + num
		t1/color: either all [t1/text: files/:count  t1/text = a-file][
			yellow] [l1/color]
	]
	do [max-files: to-integer 400 / 14]
	s1: slider l1/size * 0x1 + 16x0 length? files [num: s1/data - 1 show l1]
	return pad 0x10
	bx "Move Image To" with [color: 160.0.0] return
	l2: list 120x150 [
		t2: text 116x14 font [size: 10 color: black shadow: none] [
			do-file/move t2/text
		]
	] supply [count: count + dirn t2/text: dirs/:count] 
	s2: slider l2/size * 0x1 + 16x0 length? dirs [dirn: s2/data - 1 show l2]
	return
	at t0/offset + 140x0
	img: frame 600x600 40.40.40 effect none
	do [a-file: files/1 show-img]
]
