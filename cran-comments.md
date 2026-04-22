## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Resubmission 0.2.1

Addressing reviewer feedback on 0.2.0:

* Added references to the Description field: Wickham and Bryan (2023,
  ISBN:9781098134945) as the canonical R package development text, plus URLs
  for 'Writing R Extensions' and the 'CRAN' Repository Policy. All formatted
  as requested (no space after 'https:' or 'ISBN:', angle brackets for
  auto-linking).
* Rewrote most examples to be executable: each function's example now scaffolds
  a minimal throwaway package under `tempdir()` and exercises the function
  against it, so `R CMD check` runs the code. The remaining `\donttest{}`
  examples (for `install()`, `reload()`, `check()`, `check_win_devel()`,
  `submit_cran()`) are guarded with `if (interactive())` because they mutate
  the user's R library, require network access, or prompt for input; each
  example comment explains why it cannot run in an automated check.
* Aligned every write path with CRAN Repository Policy on the user's home
  filespace:
  - `use_version()` and `use_github_action()` now error if `path` is not
    supplied (no default), so a no-argument call can never write into
    `getwd()`. They edit files under `path` and so cannot sensibly default
    to `tempdir()`.
  - `build()`'s `dest_dir` now defaults to
    `tools::R_user_dir("tinypkgr", "cache")` (e.g. `~/.cache/R/tinypkgr/` on
    Linux), which is CRAN's recommended location for persistent per-package
    artifacts and is never inside the user's working directory.

## Test environments

* local Ubuntu 24.04, R 4.5.3
* GitHub Actions (ubuntu-latest, macos-latest)

## Downstream dependencies

None on CRAN yet.
