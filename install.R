# install.R
# ----------
# Instalacja i wstępna konfiguracja pakietów potrzebnych do projektu
# (lokalne, offline; bez interaktywnego pobierania podczas renderu Quarto)

# 1. Stałe ustawienia --------------------------------------------------------
options(repos = c(CRAN = "https://cloud.r-project.org"))      # domyślne mirror CRAN
options(textdata.download = TRUE)                             # zezwól textdata na pobieranie

# 2. Lista wymaganych pakietów ----------------------------------------------
pkgs <- c(
  "tidyverse", "janitor", "tidytext", "textdata",
  "topicmodels", "textmineR", "tm", "SnowballC",
  "wordcloud", "knitr", "quarto",
  "lsa", "umap", "plotly", "ggwordcloud"
)

# 3. Funkcja pomocnicza – instaluj, jeśli brakuje ----------------------------
install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) {
    message(sprintf("[INFO] Installing package '%s' ...", p))
    install.packages(p)
  }
}

# 4. Instalacja wymaganych pakietów ------------------------------------------
invisible(lapply(pkgs, install_if_missing))
message("[INFO] Wszystkie pakiety bazowe są zainstalowane lub już były obecne.")

# --------------------------------------------------
# 5. Pobranie i cache słowników sentimentu ---------
# --------------------------------------------------

library(textdata)   # jawne wczytanie, żeby było wiadomo skąd funkcje

message("[INFO] Pobieranie słownika AFINN...")
tryCatch({
  textdata::download_lexicon("afinn")          # ⇦ bez menu, bez argumentów
  message("[INFO] AFINN OK.")
}, error = function(e) {
  message("[WARN] AFINN: ", e$message)
})

message("[INFO] Pobieranie słownika NRC...")
tryCatch({
  textdata::download_lexicon("nrc")            # ⇦ analogicznie dla NRC
  message("[INFO] NRC OK.")
}, error = function(e) {
  message("[WARN] NRC: ", e$message,
          "\n       Możesz pobrać ręcznie w sesji interaktywnej: ",
          'tidytext::get_sentiments("nrc")')
})

# 6. Pre-download dodatkowych leksykonów sentimentu --------------------------
message("[INFO] Pobieranie pozostałych leksykonów sentymentu (tidytext)...")
tryCatch({
  tidytext::get_sentiments("afinn")
  tidytext::get_sentiments("nrc")
  message("[INFO] Lexikony AFINN i NRC pobrane pomyślnie.")
}, error = function(e) {
  message("[WARN] Nie udało się pobrać lexikonów automatycznie: ", e$message,
          "\n       Zostaną pobrane przy pierwszym użyciu w dokumencie.")
})

message("[INFO] install.R zakończony sukcesem.")
