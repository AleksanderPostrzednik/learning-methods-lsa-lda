# Helper functions for text analysis

calc_sentiment <- function(opinions) {
  opinions |>
    tidytext::unnest_tokens(word, text) |>
    inner_join(get_sentiments("afinn"), by = "word") |>
    dplyr::summarise(sentiment = sum(value), .by = id)
}
