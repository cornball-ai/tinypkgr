## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Resubmission 0.2.1

Addressing reviewer feedback on 0.2.0:

* Added reference URLs ('Writing R Extensions', CRAN Repository Policy) to the
  Description field, formatted as requested (no space after 'https:', angle
  brackets for auto-linking).
* Rewrote most examples to be executable: each function's example now scaffolds
  a minimal throwaway package under `tempdir()` and exercises the function
  against it, so `R CMD check` runs the code. The remaining `\donttest{}`
  examples (for `install()`, `reload()`, `check()`, `check_win_devel()`,
  `submit_cran()`) are guarded with `if (interactive())` because they mutate
  the user's R library, require network access, or prompt for input; each
  example comment explains why it cannot run in an automated check.
* Removed default paths from writing functions. `use_version()` and
  `use_github_action()` now error if `path` is not supplied, so a no-argument
  call can never write into `getwd()`. `build()`'s `dest_dir` defaults to
  `tempdir()` instead of the working directory.

## Test environments

* local Ubuntu 24.04, R 4.5.3
* GitHub Actions (ubuntu-latest, macos-latest)

## Downstream dependencies

None on CRAN yet.
