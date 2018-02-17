output:
	# Create output directory.
	mkdir -p out

	# Pre-process Markdown file to:
	#
	#   - Wrap version in \date{}.
	#   - Expose embedded LaTeX code.
	sed -e 's/^Version.*/\\date{&}/' \
	    -e 's/<!-- :: *\(.*\) -->/\1/g' \
	    -e 's/<!-- :: *\(.*\) -->/\1/g' \
	    README.md > out/gitpr.md

	# Convert Markdown to LaTeX.
	pandoc --template=meta/template.tex -o out/gitpr.tmp.tex out/gitpr.md

	# Post-process LaTeX output to:
	#
	#   - Reduce header levels.
	#   - Use original Creative Commons license logo.
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

	# Generate TXT.
	sed -e '/<!--/d' \
	    -e '/SHIELD_/d' \
	    -e '/DOWNLOAD_/d' \
	    -e '/CC BY 4.0 Logo/d' \
	    -e 's/&copy;/(c)/' \
	    README.md > out/gitpr.txt

install-tools-mac:
	brew cask install basictex
	brew install pandoc

clean:
	rm -rf out
	rm -f *.aux *.log *.out *.toc
