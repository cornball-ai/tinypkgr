## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Resubmission

Version 0.1.0 was previously rejected because `Suggests: tinyrox` referred to a
package not yet on CRAN. `tinyrox` is now on CRAN, and all Suggests packages
(`tinyrox`, `tinytest`) resolve against mainstream repositories.

## Test environments

* local Ubuntu 24.04, R 4.5.3
* GitHub Actions (ubuntu-latest, macos-latest)

## Downstream dependencies

None (new package).
