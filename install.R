pkgs <- c("tidyverse","janitor","tidytext","topicmodels","textmineR",
          "tm","SnowballC","wordcloud","knitr","quarto")

install_if_missing <- function(p) if (!requireNamespace(p, quietly = TRUE)) install.packages(p)

invisible(lapply(pkgs, install_if_missing))
