# install.R
# Robust non-interactive installer for project dependencies

# 1. Default CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# 2. Required packages
pkgs <- c(
  "tidyverse", "janitor", "tidytext",
  "topicmodels", "textmineR", "tm", "SnowballC",
  "wordcloud", "knitr", "quarto",
  "lsa", "umap", "plotly", "ggwordcloud", "dbscan"
)

# 3. Helper to install packages with retries
ensure_pkg <- function(pkg, max_attempts = 3) {
  for (i in seq_len(max_attempts)) {
    if (requireNamespace(pkg, quietly = TRUE)) return(TRUE)
    message(sprintf("[INFO] Installing '%s' (attempt %d/%d)...", pkg, i, max_attempts))
    tryCatch({
      if (.Platform$OS.type == "windows" && pkg %in% loadedNamespaces()) {
        try(unloadNamespace(pkg), silent = TRUE)
      }
      install.packages(pkg, dependencies = TRUE)
    }, error = function(e) {
      message("[WARN] ", e$message)
      lock <- file.path(.libPaths()[1], paste0("00LOCK-", pkg))
      if (dir.exists(lock)) unlink(lock, recursive = TRUE, force = TRUE)
      tryCatch(install.packages(pkg, type = "binary", dependencies = TRUE),
               error = function(e2) message("[WARN] binary install failed: ", e2$message))
    })
    if (requireNamespace(pkg, quietly = TRUE)) return(TRUE)
    Sys.sleep(1)
  }
  FALSE
}

# 4. Install required packages
ok_pkgs <- vapply(pkgs, ensure_pkg, logical(1))

# 5. Pre-download AFINN lexicon (non-interactive)
lex_ok <- tryCatch({
  tidytext::get_sentiments("afinn")
  TRUE
}, error = function(e) {
  message("[WARN] couldn't load AFINN lexicon: ", e$message)
  FALSE
})

# 6. Check all packages load
load_ok <- vapply(pkgs, function(p) {
  tryCatch({
    library(p, character.only = TRUE)
    TRUE
  }, error = function(e) FALSE)
}, logical(1))

success <- all(ok_pkgs) && all(load_ok) && lex_ok

if (success) {
  cat("\033[32m[SUCCESS]\033[39m Packages and lexicons ready.\n")
} else {
  cat("\033[31m[FAIL]\033[39m Some components failed to install or load.\n")
}

invisible(success)
