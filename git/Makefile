# Path: Makefile
# This is the default target, so it will be run when you type `make`
# in the terminal
# It will run the `all` target, which will generate the slides.html file
# Then it will open the slides.html file in your default browser
#
all: index.html
	pandoc -t revealjs -s -o index.html slides.md --include-in-header=../styles.css -V transition=fade

