Developer Notes
===============
This document contains notes that may be useful to the developers of and
contributors to the `gitpr` documentation project.


Output Files
------------
The PDF output of the document is generated with `pandoc` and `basictex`
on macOS High Sierra. There is a `Makefile` in the top-level project
directory with convenient `make targets` to install these tools.

On Mac, enter the following commands to generate the output files.

    make install-tools-mac
    make

These commands generates a PDF output file and a TXT output file in the
`out` directory relative to the top-level project directory.

On Linux, install `pandoc` and `texlive` yourself and then enter the
following command to generate the output files.

    make


Release
-------
Perform the following tasks for every release.

  - Update version line in README.md.
  - Update version in download URLs.
  - Update copyright notice in README.md.
  - Build output documents.

        make

  - Ensure that `out/gitpr.pdf` and `out/gitpr.txt` look good.
  - Tag the release.

        git tag -a <VERSION> -m "Version <VERSION>"
        git push origin <VERSION>

  - Upload `out/gitpr.pdf` and `out/gitpr.txt` to GitHub release page.
