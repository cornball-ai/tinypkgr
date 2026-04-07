# tinypkgr 0.2.0

* New `use_version()` bumps the DESCRIPTION Version field and prepends a matching NEWS.md section header. Supports `patch`, `minor`, `major`, and `dev` bumps. (For package skeleton creation, use `pkgKitten::kitten()`.)
* New `use_github_action()` writes a `.github/workflows/ci.yaml` from the r-ci template (Ubuntu + macOS) and adds `^\.github$` to `.Rbuildignore`.

# tinypkgr 0.1.0

* Initial CRAN release.
* Development utilities: `install()`, `load_all()`, `reload()`, `check()`.
* Release utilities: `build()`, `maintainer()`, `check_win_devel()`, `submit_cran()`.
