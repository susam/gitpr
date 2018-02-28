Fork and Pull Request Workflow
==============================
<!-- :: \iffalse -->
[![Download PDF][SHIELD_PDF]][DOWNLOAD_PDF]
[![Download TXT][SHIELD_TXT]][DOWNLOAD_TXT]
[![CC BY 4.0 License][SHIELD_CCBY]][CCBY]
<!-- :: -->
[SHIELD_PDF]: https://img.shields.io/badge/download-PDF-brightgreen.svg
[SHIELD_TXT]: https://img.shields.io/badge/download-TXT-brightgreen.svg
[SHIELD_CCBY]: https://img.shields.io/badge/license-CC%20BY%204.0-blue.svg
[DOWNLOAD_PDF]: https://github.com/susam/gitpr/releases/download/0.1.0/gitpr.pdf
[DOWNLOAD_TXT]: https://github.com/susam/gitpr/releases/download/0.1.0/gitpr.txt
<!-- :: \fi -->
<!-- Version 0.1.1-draft (2018-02-28) -->
<!-- :: \maketitle -->

This document describes how developers may contribute pull requests to
an upstream repository and how upstream owners may merge pull requests
from contributors according to the very popular fork and pull request
workflow followed in many projects on GitHub.

The download buttons above download version 0.1.0 <!-- x -->
(the latest stable release) of this document. <!-- x -->
<!-- x -->
The most recent version of this document is available at
<https://github.com/susam/gitpr>.

<!-- :: \iffalse -->

Contents
--------
* [Introduction](#introduction)
* [Quick Reference](#quick-reference)
* [Create Pull Request](#create-pull-request)
  * [Fork and Clone](#fork-and-clone)
  * [Work on Pull Request](#work-on-pull-request)
  * [Keep Your Fork Updated](#keep-your-fork-updated)
  * [Squash Commits](#squash-commits)
  * [Rebase Commits](#rebase-commits)
  * [Delete Branch](#delete-branch)
* [Merge Pull Request](#merge-pull-request)
  * [Without Merge Commit](#without-merge-commit)
  * [With Merge Commit](#with-merge-commit)
* [Nifty Commands](#nifty-commands)
* [License](#license)
* [Support](#support)

<!-- :: \fi -->
<!-- :: \tableofcontents -->
<!-- :: \pagebreak -->

Introduction
------------
Every project has a main development branch where the developers push
commits on a day-to-day basis. Usually, the main development branch is
`master` but some projects choose to have `develop` or `trunk` or
another branch for day-to-day development activities. We refer to this
main development branch as *main development branch* throughout this
document to keep the text general. However in the command examples and
ASCII-diagrams, we use `master` as an example of the main development
branch.

We use the following placeholders in the command examples and
ASCII-diagrams in this document:

  - `GITHUB`: [`github.com`](https://github.com/) or domain
    name/hostname of your private GitHub Enterprise system.
  - `USER` or `CONTRIBUTOR`: The user that forks an upstream repository,
    creates pull requests, and sends them to the upstream repository.
  - `UPSTREAM-OWNER`: Owner of the upstream repository. This is the name
    of the user or organization that merges pull requests into the
    upstream repository.
  - `REPO`: Repository name.
  - `FILES`: One or more filenames to be staged for a commit.
  - `TOPIC-BRANCH`: Feature-specific or bug-specific branch where a
    contributor develops her or his contribution. This is referred to as
    *topic branch* in the text.

These placeholders should be substituted with appropriate values while
executing the commands.

Beginners to this workflow should always remember that a Git branch is
not a container of commits, but rather a lightweight moving pointer that
points to a commit in the commit history.

    A---B---C
            ↑
         (master)

When a new commit is made in a branch, its branch pointer simply moves
to point to the last commit in the branch.

    A---B---C---D
                ↑
             (master)

A branch is merely a pointer to the tip of a series of commits. With
this little thing in mind, seemingly complex operations like rebase and
fast-forward merges become easy to understand and use.

The next section, *[Quick Reference](#quick-reference)*, provides a brief
summary of all the frequently used commands involved in creating and merging
pull requests.

<!-- :: \pagebreak -->

Quick Reference
---------------
Here is a brief summary of all the commands used to create and merge
pull requests in this document. This section serves as a quick
reference.

    # CREATE PULL REQUEST
    # ===================
    # Fork upstream and clone your fork.
    git clone https://GITHUB/USER/REPO.git
    cd REPO
    git remote add upstream https://GITHUB/UPSTREAM-OWNER/REPO.git
    git remote -v

    # Work on pull request in a new topic branch.
    git checkout -b TOPIC-BRANCH
    git add FILES
    git commit
    git push origin TOPIC-BRANCH

    # Go to your fork on GitHub, switch to the topic branch, and
    # click *Compare & pull request*.

    # Keep your fork's main development branch updated with upstream's.
    git fetch upstream
    git checkout master
    git merge upstream/master
    git push origin master

    # Squash commits, e.g., last 3 commits in topic branch (optional).
    git checkout TOPIC-BRANCH
    git rebase -i HEAD~3
    git push -f origin TOPIC-BRANCH

    # Rebase topic branch on the main development branch (optional).
    git checkout TOPIC-BRANCH
    git rebase master

    # Delete topic branch branch after pull request is merged.
    git checkout master
    git branch -D TOPIC-BRANCH
    git push -d origin TOPIC-BRANCH

<!-- :: \pagebreak -->

    # MERGE PULL REQUEST (WITHOUT MERGE COMMIT)
    # =========================================
    # Clone upstream repo.
    git clone https://GITHUB/UPSTREAM-OWNER/REPO.git
    cd REPO

    # Pull changes in pull request into a temporary branch.
    git checkout -b pr
    git pull https://GITHUB/CONTRIBUTOR/REPO.git TOPIC-BRANCH

    # Rebase pull request on the main development branch.
    git rebase master

    # Merge pull request and delete temporary branch.
    git checkout master
    git merge pr
    git branch -d pr

    # Push the updated main development branch to upstream repo.
    git push origin master


    # MERGE PULL REQUEST (WITH MERGE COMMIT)
    # ======================================
    # Clone upstream repo.
    git clone https://GITHUB/UPSTREAM-OWNER/REPO.git
    cd REPO

    # Pull changes in pull request into a temporary branch.
    git checkout -b pr
    git pull https://GITHUB/CONTRIBUTOR/REPO.git TOPIC-BRANCH

    # Merge pull request and delete temporary branch
    git checkout master
    git merge --no-ff pr
    git branch -d pr

    # Push the updated main development branch to upstream repo.
    git push origin master

The next two sections, *[Create Pull Request](#create-pull-request)*
and *[Merge Pull Request](#merge-pull-request)*, elaborate these
commands in detail.

<!-- :: \pagebreak -->

Create Pull Request
-------------------
This section is meant for developers who contribute new commits to the
upstream repository from their personal fork.


### Fork and Clone
On GitHub, fork the upstream repository to your personal user account.

Then clone your fork from your personal GitHub user account to your
local system and set the upstream repository URL as a remote named
`upstream`.

    git clone https://GITHUB/USER/REPO.git
    cd REPO
    git remote add upstream https://GITHUB/UPSTREAM-OWNER/REPO.git
    git remote -v

The remote named `upstream` points to the upstream repository.
The remote named `origin` points to your fork.

In the fork and pull request workflow, a contributor must never push
commits to `upstream`. A contributor must only push commits to `origin`.


### Work on Pull Request
Work on a new pull request in a new topic branch and commit to your
fork. Remember to use a meaningful name instead of `TOPIC-BRANCH` in the
commands below.

    git checkout -b TOPIC-BRANCH
    git add FILES
    git commit
    git push origin TOPIC-BRANCH

Create pull request via GitHub web interface as per the following steps:

  - Go to your fork on GitHub.
  - Switch to the topic branch.
  - Click *Compare & pull request*.
  - Click *Create pull request*.

Wait for an upstream developer to review and merge your pull request.

If there are review comments to be addressed, continue working on your
branch, commiting, optionally squashing and rebasing them, and pushing
them to the topic branch of `origin` (your fork). Any further commits
pushed to the topic branch automatically become part of the existing
pull request.

In the fork and pull request workflow, a contributor should never commit
anything to the main development branch of personal fork. This makes it
very easy to keep the main development branch of your fork in sync with
that of the upstream repository. This is explained in the next
subsection.


### Keep Your Fork Updated
As new pull requests get merged into the upstream's main development
branch, the main development branch of your fork begins falling behind
it.

The commands below show how to update your fork's main development
branch with the new commits in the upstream's main development branch.

    git fetch upstream
    git checkout master
    git merge upstream/master
    git push origin master

The `git merge` command above simply fast-forwards the main development
branch from an earlier commit to the last commit in the upstream's main
development branch.

When your main development branch falls behind the upstream's main
development branch, the upstream's main development branch extends
linearly from the last commit in your main development branch, provided
that there are no additional commits to your main development branch
that has caused it to diverge.

                  E---F---G (TOPIC-BRANCH)
                 /
    A---B---C---D (master)
                 \
                  H---I---J (upstream/master)


With such a commit history, when the upstream's main development branch
is merged into your main development branch, the merge is done by simply
fast-forwarding the pointer of your main development branch to the last
commit in the upstream's main development branch.

                  E---F---G (TOPIC-BRANCH)
                 /
    A---B---C---D
                 \
                  H---I---J (upstream/master, master)


### Squash Commits
This is an optional step to keep the commit history concise.

If there are review comments to a pull request which need to be
addressed in a new commit, or if there are minor fixes to be committed
to an existing pull request, it may result in multiple commits in
the topic branch.

         E---F---G (TOPIC-BRANCH)
        /
    A---B---C---D  (master)

It may be a good idea to squash the multiple commits in the pull request
into a single commit.

         E'       (TOPIC-BRANCH)
        /
    A---B---C---D (master)

The following example shows how to squash the last 3 commits into a
single commit and publish the squashed commit to the pull request.

    git checkout TOPIC-BRANCH
    git rebase -i HEAD~3
    git push -f origin TOPIC-BRANCH

This brings up an editor with the last 3 commits ordered from earliest
to last. Leave the first commit untouched. Replace `pick` with `squash`
in the next two lines, save, and quit the editor.

This brings up an editor again. Clean up the commit message, save, and
quit the editor.

The `-f` (force) option in the `git push` command is necessary only if
you are pushing to an already existing pull request branch because doing
so overwrites the history of the branch. Normally, overwriting history
is strictly discouraged but this is one of the rare scenarios where it
is safe to overwrite the commit history because the commits are being
pushed to a personal branch in a personal fork without affecting the
upstream repository.

Note: Even if the pull request developer does not squash commits, the
upstream developers always have the option to squash the commits
themselves before merging the pull request into the upstream repository.


### Rebase Commits
This is an optional step to keep the commit history as linear as possible.

The main development branch may have diverged since the topic branch was
created.

         E---F---G (TOPIC-BRANCH)
        /
    A---B---C---D  (master)

It may be a good idea to move the commits in the topic branch and place
them on top of the main development branch, so that the topic branch
extends linearly from the last commit in the main development branch.

                  E'---F'---G' (TOPIC-BRANCH)
                 /
    A---B---C---D  (master)

The following command shows how to rebase the topic branch on the main
development branch.

    git checkout TOPIC-BRANCH
    git rebase master

Note: Even if the the pull request developer does not rebase commits,
the upstream developers always have the option to rebase the commits
themselves before merging the pull request into upstream.


### Delete Branch
Once the upstream developer has merged your pull request, you may delete
the topic branch from your local system as well as from your fork.

    git checkout master
    git branch -D TOPIC-BRANCH
    git push -d origin TOPIC-BRANCH

The next section, *[Merge Pull Request]*, explains how an upstream owner
can merge pull request from contributors into the upstream repository.

<!-- :: \pagebreak -->

Merge Pull Request
------------------
This section is meant for lead developers who own the upstream
repository and merge pull requests from contributors to it.

There are two popular methods to merge commits: one that does not
introduce an additional merge commit, and another that does.

Both method are perfectly acceptable. Both methods are discussed below.

Which method you choose depends on whether you want to maintain a
concise commit history consisting only of development commits or if you
want to introduce additional merge commits for every merge into your
commit history.


### Without Merge Commit
Clone the upstream repository to your local system.

    git clone https://GITHUB/UPSTREAM-OWNER/REPO.git
    cd REPO

Create a temporary branch (`pr` for example) to pull the contribution
(pull request) from the CONTRIBUTOR's branch in it:

    git checkout -b pr
    git pull https://GITHUB/CONTRIBUTOR/REPO.git TOPIC-BRANCH

If the main development branch has diverged from the branch in the pull
request, move the commits in the pull request and place them on top of
the main development branch, so that the branch in the pull request
extends linearly from the main development branch.

    git rebase master

See *[Rebase Commits](#rebase-commits)* section above for more details.

Squash multiple commits in the pull request into fewer commits (if
desired). See *[Squash Commits](#squash-commits)* section above for more
details.

After sufficient testing, merge the commits in the pull request into the
main development branch and remove the pull request branch.

    git checkout master
    git merge pr
    git branch -d pr

Finally, push the current state of the main development branch to the
upstream repository.

    git push origin master

The `git merge` command above simply fast-forwards the main development
branch from an earlier commit to the last commit in the pull request
thereby making both the main development branch and the pull request
branch point to the same commit. This achieves the merge from the pull
request branch into the main development branch without creating a new
merge commit.

After a pull request branch is rebased on the main development branch,
the pull request branch becomes a linear extension of the main
development branch.

                  E'---F'---G' (pr)
                 /
    A---B---C---D (master)

With such a commit history, when the pull request branch is now merged
into the main development branch, the merge is done by simply
fast-forwarding the pointer of the main development branch to the last
commit in the pull request branch.

                  E'---F'---G' (pr, master)
                 /
    A---B---C---D


### With Merge Commit
Clone the upstream repository to your local system.

    git clone https://GITHUB/UPSTREAM-OWNER/REPO.git
    cd REPO

Create a temporary branch (`pr` for example) to pull the contribution
(pull request) from the CONTRIBUTOR's branch in it:

    git checkout -b pr
    git pull https://GITHUB/CONTRIBUTOR/REPO.git TOPIC-BRANCH

Squash multiple commits in the pull request into one commit (if
desired). See [*Squash Commits*](#squash-commits) section above for more
details.

After sufficient testing, merge the commits in pull request into the
main development branch.

    git checkout master
    git merge --no-ff pr
    git branch -d pr

Finally, push the current state of the main development branch (with the
commits from the pull request in it) to the upstream repository.

    git push origin master

The `--no-ff` (no fast-forward) option in the `git merge` command
ensures that a merge commit is always created even when a fast-forward
merge is possible.

                  E'---F'---G' (pr)
                 /           \
    A---B---C---D-------------H (master)

<!-- :: \pagebreak -->

Nifty Commands
--------------
This is a bonus section that describes a few aliases and commands that
may be useful during day-to-day development activities. When git merges
crash and burn, these aliases and commands may be useful to check the
current state of the repository.


### Pretty Logs
The following commands create aliases to run `git log` with various subsets of
{`--pretty`, `--graph`, `--all`} options to display commit logs in a compact
form, i.e., one line per log.

    # Define
    FORMAT="%C(auto)%h %C(magenta)%ad %C(cyan)%an%C(auto)%d %s"
    PRETTY="--pretty=format:'$FORMAT' --date=short"
    git config --global alias.lga "log --graph --all $PRETTY"
    git config --global alias.lg "log --graph $PRETTY"
    git config --global alias.la "log --all $PRETTY"
    git config --global alias.ll "log $PRETTY"
    git config --global alias.lf "log --pretty=fuller --stat"

    # Use aliases
    git lga
    git lg
    git la
    git ll
    git lf


### Staged Changes
While `git diff` shows the unstaged changes in the working directory, it
is necessary to use the `--cached` option with `git diff` to see the
changes staged for the next commit. The following command creates a
convenient alias for this option.

    # Define aliases
    git config --global alias.diffc "diff --cached"
    git config --global alias.dc "diff --cached"

    # Use aliases
    git diffc
    git dc


### Verbose Branches
The following commands provides aliases to list branches with verbose
information. The second alias includes remote branches too in the
output.

    # Define aliases
    git config --global alias.br "branch -vv"
    git config --global alias.brr "branch -vva"

    # Use aliases
    git br
    git brr

### Find Merge Base
Find a common ancestor of two branches with this command. It helps to
find the commit after which two branches began diverging.

    git merge-base upstream/master TOPIC-BRANCH


### Some Git Wisdom
Enter one of the commands below in your command shell depending on your
operating system, or just open the URL with your web browser.

    open https://xkcd.com/1597/
    xdg-open https://xkcd.com/1597/
    start https://xkcd.com/1597/


License
-------
Copyright &copy; 2018 Susam Pal

[![CC BY 4.0 Logo](meta/ccby.svg "CC BY 4.0")][CCBY]
<!-- :: -->
This document is licensed under the
[Creative Commons Attribution 4.0 International License][CCBY].

You are free to share the material in any medium or format and/or adapt
the material for any purpose, even commercially, under the terms of the
Creative Commons Attribution 4.0 International (CC BY 4.0) License.

This document is provided **as-is and as-available,**
**without representations or warranties of any kind,** whether
express, implied, statutory, or other. See the
[CC BY 4.0 Legal Code][CCBYLC] for details.

[CCBY]: http://creativecommons.org/licenses/by/4.0/
[CCBYLC]: https://creativecommons.org/licenses/by/4.0/legalcode


Support
-------
To report bugs, suggest improvements, or ask questions,
[create issues][ISSUES].

To contribute improvements to this document,
[fork this project][REPO] and *[create pull request][PR]!* ;-)

[ISSUES]: https://github.com/susam/gitpr/issues
[REPO]: https://github.com/susam/gitpr
[PR]: #create-pull-request
