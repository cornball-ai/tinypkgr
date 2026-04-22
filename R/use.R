#' Bump Package Version
#'
#' Increments the Version field in DESCRIPTION and prepends a new section
#' header to NEWS.md (if present) so the two never drift apart.
#'
#' @param which Which component to bump: "patch" (0.2.0 -> 0.2.1),
#'   "minor" (0.2.0 -> 0.3.0), "major" (0.2.0 -> 1.0.0), or
#'   "dev" (0.2.0 -> 0.2.0.1, or 0.2.0.1 -> 0.2.0.2).
#' @param path Path to package root directory. Required; no default is
#'   provided because this function edits files in `path`, and CRAN
#'   Repository Policy forbids defaulting write paths to the user's
#'   home filespace (which includes `getwd()`).
#'
#' @return The new version string (invisibly).
#'
#' @export
#'
#' @examples
#' # Scaffold a throwaway package in tempdir() and bump its version.
#' pkg <- file.path(tempdir(), "vxpkg")
#' dir.create(pkg, showWarnings = FALSE)
#' writeLines(c(
#'   "Package: vxpkg",
#'   "Title: Example",
#'   "Version: 0.1.0",
#'   "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
#'   "Description: Example.",
#'   "License: GPL-3"
#' ), file.path(pkg, "DESCRIPTION"))
#'
#' use_version("patch", path = pkg)
#' read.dcf(file.path(pkg, "DESCRIPTION"))[1, "Version"]
#'
#' unlink(pkg, recursive = TRUE)
use_version <- function(which = c("patch", "minor", "major", "dev"),
                        path) {
    if (missing(path)) {
        stop("'path' is required and has no default.", call. = FALSE)
    }
    which <- match.arg(which)
    path <- normalizePath(path, mustWork = TRUE)
    desc_file <- file.path(path, "DESCRIPTION")
    if (!file.exists(desc_file)) {
        stop("No DESCRIPTION file found in ", path, call. = FALSE)
    }

    desc_lines <- readLines(desc_file, warn = FALSE)
    ver_idx <- grep("^Version:", desc_lines)
    if (length(ver_idx) != 1) {
        stop("Could not find Version field in DESCRIPTION", call. = FALSE)
    }
    current <- trimws(sub("^Version:", "", desc_lines[ver_idx]))
    new_version <- bump_version(current, which)
    desc_lines[ver_idx] <- paste0("Version: ", new_version)
    writeLines(desc_lines, desc_file)

    pkg_name <- read.dcf(desc_file)[1, "Package"]
    message("Bumped ", pkg_name, ": ", current, " -> ", new_version)

    # Update NEWS.md only on release-style bumps
    news_file <- file.path(path, "NEWS.md")
    if (file.exists(news_file) && which != "dev") {
        news <- readLines(news_file, warn = FALSE)
        header <- paste0("# ", pkg_name, " ", new_version)
        new_news <- c(header, "", "* ", "", news)
        writeLines(new_news, news_file)
        message("Added NEWS.md header for ", new_version)
    }

    invisible(new_version)
}

#' Add a GitHub Actions CI Workflow
#'
#' Writes `.github/workflows/ci.yaml` using the r-ci template (Ubuntu and
#' macOS, via `eddelbuettel/github-actions/r-ci@master`). Adds `^\.github$`
#' to `.Rbuildignore` if not already present.
#'
#' @param path Path to package root directory. Required; no default is
#'   provided because this function writes files under `path`, and CRAN
#'   Repository Policy forbids defaulting write paths to the user's
#'   home filespace (which includes `getwd()`).
#'
#' @return Path to the created YAML file (invisibly).
#'
#' @export
#'
#' @examples
#' # Scaffold a throwaway package in tempdir() and add the workflow.
#' pkg <- file.path(tempdir(), "ghapkg_example")
#' dir.create(pkg, showWarnings = FALSE)
#' writeLines(c(
#'   "Package: ghapkg",
#'   "Title: Example",
#'   "Version: 0.0.1",
#'   "Authors@R: person('A', 'B', email = 'a@b.com', role = c('aut','cre'))",
#'   "Description: Example.",
#'   "License: GPL-3"
#' ), file.path(pkg, "DESCRIPTION"))
#'
#' yaml <- use_github_action(path = pkg)
#' file.exists(yaml)
#'
#' unlink(pkg, recursive = TRUE)
use_github_action <- function(path) {
    if (missing(path)) {
        stop("'path' is required and has no default.", call. = FALSE)
    }
    path <- normalizePath(path, mustWork = TRUE)
    workflows_dir <- file.path(path, ".github", "workflows")
    dir.create(workflows_dir, recursive = TRUE, showWarnings = FALSE)
    yaml_file <- file.path(workflows_dir, "ci.yaml")
    if (file.exists(yaml_file)) {
        stop("File already exists: ", yaml_file, call. = FALSE)
    }

    yaml_lines <- c(
                    "name: ci",
                    "",
                    "on:",
                    "  push:",
                    "  pull_request:",
                    "",
                    "env:",
                    "  _R_CHECK_FORCE_SUGGESTS_: \"false\"",
                    "",
                    "jobs:",
                    "  ci:",
                    "    strategy:",
                    "      matrix:",
                    "        include:",
                    "          - {os: macos-latest}",
                    "          - {os: ubuntu-latest}",
                    "",
                    "    runs-on: ${{ matrix.os }}",
                    "",
                    "    steps:",
                    "      - uses: actions/checkout@v6",
                    "",
                    "      - name: Setup",
                    "        uses: eddelbuettel/github-actions/r-ci@master",
                    "",
                    "      - name: Dependencies",
                    "        run: ./run.sh install_deps",
                    "",
                    "      - name: Test",
                    "        run: ./run.sh run_tests"
    )
    writeLines(yaml_lines, yaml_file)
    message("Created ", yaml_file)

    # Make sure .github is in .Rbuildignore
    rbi <- file.path(path, ".Rbuildignore")
    rbi_entry <- "^\\.github$"
    if (file.exists(rbi)) {
        lines <- readLines(rbi, warn = FALSE)
        if (!rbi_entry %in% lines) {
            writeLines(c(lines, rbi_entry), rbi)
        }
    } else {
        writeLines(rbi_entry, rbi)
    }

    invisible(yaml_file)
}

# Bump a version string by component.
bump_version <- function(current, which) {
    parts <- strsplit(current, ".", fixed = TRUE)[[1]]
    if (which == "dev") {
        if (length(parts) == 4) {
            parts[4] <- as.character(as.integer(parts[4]) + 1)
        } else if (length(parts) == 3) {
            parts <- c(parts, "1")
        } else {
            stop("Cannot bump dev version from: ", current, call. = FALSE)
        }
    } else {
        if (length(parts) == 4) {
            parts <- parts[1:3]
        }
        if (length(parts) != 3) {
            stop("Cannot parse version: ", current, call. = FALSE)
        }
        nums <- as.integer(parts)
        if (which == "patch") {
            nums[3] <- nums[3] + 1
        } else if (which == "minor") {
            nums[2] <- nums[2] + 1
            nums[3] <- 0
        } else if (which == "major") {
            nums[1] <- nums[1] + 1
            nums[2] <- 0
            nums[3] <- 0
        }
        parts <- as.character(nums)
    }
    paste(parts, collapse = ".")
}

