# tinypkgr

Minimal R package development utilities - base R + curl.

## What it does

tinypkgr provides lightweight wrappers around R CMD INSTALL, R CMD check, and CRAN submission utilities.

## Installation

```r
remotes::install_github("cornball-ai/tinypkgr")
```

## Usage

### Create a package

```r
tinypkgr::create_package("mypkg",
                         author = "First Last",
                         email = "you@example.com",
                         orcid = "0000-0000-0000-0000")
```

### Development

```r
library(tinypkgr)

# Source all R files for interactive development
load_all()

# Install package
install()

# Reinstall and reload
reload()

# Run R CMD check
check()
```

### CRAN Release

```r
# Build tarball
build()

# Test on Windows
check_win_devel()

# Submit to CRAN
submit_cran()
```

## Functions

| Function | Purpose |
|----------|---------|
| `create_package()` | Scaffold a new tinyverse-flavored package |
| `use_version()` | Bump DESCRIPTION version + NEWS.md header |
| `install()` | R CMD INSTALL wrapper |
| `load_all()` | Source R/ files for dev |
| `reload()` | Reinstall and reload |
| `check()` | R CMD check wrapper |
| `build()` | R CMD build wrapper |
| `maintainer()` | Extract maintainer from DESCRIPTION |
| `check_win_devel()` | Upload to win-builder |
| `submit_cran()` | Submit to CRAN |

## Philosophy

Follows [tinyverse](https://www.tinyverse.org) principles. Only dependency is `curl` (for CRAN/win-builder uploads).

## License

GPL-3
