Changelog
=========

0.4.0 (2018-07-15)
------------------
### Changed
- Use `git pull` to keep the fork's main development branch updated with
  changes in the upstream instead of `git fetch` and `git merge`.


0.3.0 (2018-07-07)
------------------
### Added
- Rebase options to get rid of merge commit while merging without commit.
- Caveats of various rebase options.
- Amending last commit with `git commit --amend`.
- Alias `git co` for `git checkout` command.
- Alias `git cob` for `git checkout -b` command.
- Alias `git ca` for `git commit --amend` command.
- Staging partial changes with `git add -p`.

### Changed
- Discuss editing previous comments in general with `git rebase -i`
  command rather than squashing commits in particular.
- Include `git pull` command to update the main development branch while
  merging pull requests in local clone of upstream repository.
- Discuss `git push -f` command in a separate section.


0.2.0 (2018-03-23)
------------------
### Added
- Explain that downloads are for stable version only.
- Provide a list of all placeholders used in the document.
- Aliases `git br` and `git brr` for `git branch` commands.

### Changed
- Use shorter alias names for `git log` aliases.
- Simpler `git rebase` commands.
- Simpler description of some steps.


0.1.0 (2018-02-17)
------------------
### Added
- README.md with the following top-level sections:
  - Introduction
  - Quick Reference
  - Create Pull Request
  - Merge Pull Request
  - Nifty Commands
  - License
  - Support
- Generate PDF and TXT output files from README.md.
