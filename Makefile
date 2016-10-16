all: 
	hugo -t hugo-universal-theme

server:
	hugo server -t hugo-universal-theme

gh-pages:
	git subtree push --prefix=public git@github.com:adelehedrick/Fall-2016-CSCI-3055U.git gh-pages

