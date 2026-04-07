## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new submission.
* `load_all()` uses `attach()` deliberately to expose package symbols on the
  search path for interactive development, mirroring `devtools::load_all()`.
  This is intentional and documented.

## Test environments

* local Ubuntu 24.04, R 4.4.2
* GitHub Actions (ubuntu-latest, macos-latest)

## Downstream dependencies

None (new package).
