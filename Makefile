build: set-date
	# Create output directory.
	mkdir -p out

	# Pre-process Markdown file to:
	#
	#   - Wrap version/date in \date{}.
	#   - Uncomment embedded LaTeX code.
	#   - Delete lines meant for README.md only.
	sed -e 's/^<!-- \(Version.*\) -->/\\date{\1}/' \
	    -e 's/<!-- :: *\(.*\) -->/\1/g' \
	    -e '/<!-- x -->/d' \
	    README.md > out/gitpr.md

	# Convert Markdown to LaTeX.
	pandoc --template=meta/template.tex -o out/gitpr.tmp.tex out/gitpr.md

	# Post-process LaTeX output to:
	#
	#   - Reduce header levels.
	#   - Prevent splitting of verbatim block between pages.
	#   - Use PNG format Creative Commons license logo.
	#   - Reduce size of Creative Commons license logo.
	sed -e 's/\\section/\\title/' \
	    -e 's/\\subsection/\\section/' \
	    -e 's/\\subsubsection/\\subsection/' \
	    -e 's/\\begin{verbatim}/\\begin{minipage}{\\linewidth}&/' \
	    -e 's/\\end{verbatim}/&\\end{minipage}/' \
	    -e 's/ccby\.svg/ccby.png/' \
	    -e 's/\\includegraphics/&[scale=0.75]/' \
	    out/gitpr.tmp.tex > out/gitpr.tex

	# Generate PDF.
	pdflatex out/gitpr.tex
	pdflatex out/gitpr.tex
	mv gitpr.pdf out/

	# Generate TXT:
	#
	#   - Uncomment version/date.
	#   - Delete embedded LaTeX code.
	#   - Delete images.
	#   - Use (c) as copyright symbol.
	#   - Delete lines meant for README.md only.
	sed -e 's/^<!-- \(Version.*\) -->/\1/' \
	    -e '/<!-- :: *\(.*\) -->/d' \
	    -e '/SHIELD_/d' \
	    -e '/DOWNLOAD_/d' \
	    -e '/CC BY 4.0 Logo/d' \
	    -e 's/&copy;/(c)/' \
	    -e '/<!-- x -->/d' \
	    README.md > out/gitpr.txt

install-tools-mac:
	brew cask install basictex
	brew install pandoc

clean:
	rm -rf out
	rm -f *.aux *.log *.out *.toc

view:
	-xdg-open out/gitpr.pdf || open out/gitpr.pdf
	-less out/gitpr.txt

set-date:
	sed "/<!-- Version/ s/(\(.*\))/($$(date +'%Y-%m-%d'))/" \
	    README.md > README.tmp
	mv README.tmp README.md

test: clean build view
