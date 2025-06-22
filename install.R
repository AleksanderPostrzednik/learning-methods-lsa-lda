# Set a default CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("tidyverse","janitor","tidytext","textdata","topicmodels","textmineR",
          "tm","SnowballC","wordcloud","knitr","quarto")

install_if_missing <- function(p) if (!requireNamespace(p, quietly = TRUE)) install.packages(p)

invisible(lapply(pkgs, install_if_missing))

# Pre-download lexicons to avoid interactive prompts during rendering
print("[INFO] Downloading sentiment lexicons...")
tryCatch({
  tidytext::get_sentiments("afinn")
  tidytext::get_sentiments("nrc")
  print("[INFO] Lexicons downloaded successfully.")
}, error = function(e) {
  print("[WARN] Could not download lexicons automatically. You may be prompted to download them when running the Quarto document.")
})
