# tinypkgr 0.2.1

* Addressed CRAN resubmission feedback:
  - Added references to the Description field: Wickham and Bryan (2023, ISBN:9781098134945), plus URLs for 'Writing R Extensions' and the 'CRAN' Repository Policy.
  - Rewrote most `\dontrun{}` examples to be executable against a throwaway package in `tempdir()`, so they exercise the functions during `R CMD check`. Examples that genuinely cannot run under check (`install()`, `reload()`, `check()`, `check_win_devel()`, `submit_cran()`) now use `\donttest{}` + `if (interactive())` and explain why.
  - Aligned every write path with CRAN Repository Policy on the user's home filespace:
    * `use_version()` and `use_github_action()` now require an explicit `path` (no default), because they edit files under `path` and CRAN forbids defaulting write paths into the home filespace.
    * `build()` now defaults `dest_dir` to `tools::R_user_dir("tinypkgr", "cache")` (e.g. `~/.cache/R/tinypkgr/` on Linux), CRAN's recommended location for persistent per-package artifacts.
* Internal: `R CMD` invocations now use `file.path(R.home("bin"), "R")` instead of bare `R` on `PATH`, per 'Writing R Extensions' 1.6.

# tinypkgr 0.2.0

* New `use_version()` bumps the DESCRIPTION Version field and prepends a matching NEWS.md section header. Supports `patch`, `minor`, `major`, and `dev` bumps. (For package skeleton creation, use `pkgKitten::kitten()`.)
* New `use_github_action()` writes a `.github/workflows/ci.yaml` from the r-ci template (Ubuntu + macOS) and adds `^\.github$` to `.Rbuildignore`.

# tinypkgr 0.1.0

* Initial CRAN release.
* Development utilities: `install()`, `load_all()`, `reload()`, `check()`.
* Release utilities: `build()`, `maintainer()`, `check_win_devel()`, `submit_cran()`.
