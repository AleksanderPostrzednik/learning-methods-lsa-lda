# 📚 Learning Methods – LSA & LDA (Quarto + R)

Analiza metod nauki studentów w korelacji z GPA oraz eksploracja tematów i emocji w opisach stylów nauki przy użyciu Latent Semantic Analysis (LSA) i Latent Dirichlet Allocation (LDA).

---

## 🎯 Cel projektu

Głównym celem jest zbadanie, która metoda nauki (np. fiszki, mapy myśli, `spaced repetition`) wykazuje najsilniejszą korelację z wyższym GPA studentów. Dodatkowo, projekt analizuje, jakie tematy i emocje dominują w tekstowych opisach poszczególnych stylów nauki.

---

## 🚀 Szybki start (TL;DR)

1.  **Klonuj repozytorium i przejdź do katalogu:**
    ```bash
    git clone https://github.com/USER/learning-methods-lsa-lda.git
    cd learning-methods-lsa-lda
    ```

2.  **Pobierz dane z Kaggle (dane liczbowe):**
    > **Wymagane:** Konto na [Kaggle](https://kaggle.com) i plik `kaggle.json`.
    ```bash
    bash scripts/setup_kaggle.sh
    ```
    *Skrypt pobierze dane do katalogu `data/`.*

3.  **Pobierz angielski zbiór tweetów (1.6 mln wpisów):**
    ```bash
    bash scripts/setup_feedback.sh
    ```
    *Zostanie utworzony plik `data/sentiment140.csv`.*

4.  **Zainstaluj pakiety R:**
    ```bash
    Rscript install.R
    ```
    *Instalacja może potrwać 2-3 minuty.*

5.  **Uruchom podgląd slajdów (w terminalu, nie w R):**
    ```bash
    quarto preview quarto/learning_lsa_lda.qmd
    ```

---

## ✅ Uruchomienie projektu

Aby uruchomić projekt, wykonaj poniższe kroki w terminalu, będąc w głównym katalogu repozytorium:

1.  **Pobierz dane z Kaggle:**
    *   Najpierw upewnij się, że posiadasz plik `kaggle.json` pobrany ze swojego konta Kaggle. Szczegóły znajdziesz w sekcji "Pobieranie danych z Kaggle".
    ```bash
    bash scripts/setup_kaggle.sh
    ```
2.  **Pobierz angielski zbiór tweetów:**
    ```bash
    bash scripts/setup_feedback.sh
    ```

3.  **Zainstaluj pakiety R:**
    *   Skrypt zainstaluje brakujące pakiety R i pobierze słowniki sentymentu.
    ```bash
    Rscript install.R
    ```

4.  **Wyświetl slajdy (w terminalu, nie w R):**
    *   Ta komenda uruchomi lokalny serwer i otworzy podgląd slajdów w Twojej domyślnej przeglądarce.
    *   **Ważne:** Uruchom tę komendę w terminalu systemowym (np. PowerShell, CMD, Bash), a **nie** wewnątrz konsoli R.
    ```bash
    quarto preview quarto/learning_lsa_lda.qmd
    ```

---

## 🛠️ Wymagania

| Narzędzie      | Wersja minimalna | Polecenie do weryfikacji        |
| :------------- | :--------------- | :------------------------------ |
| R              | `4.2`            | `R --version`                   |
| Quarto CLI     | `1.4`            | `quarto check`                  |
| VS Code        | `1.90`           | `code --version`                |
| Git            | –                | `git --version`                 |
| Python (opcj.) | `3.9`            | `python --version`              |
| Kaggle CLI     | –                | `kaggle -h`                     |

> **Uwaga:** Quarto CLI jest niezbędne do renderowania plików `.qmd` do formatów HTML/PDF. Rozszerzenie VS Code służy jedynie jako edytor i do podglądu na żywo.

---

## 📁 Struktura repozytorium

```
learning-methods-lsa-lda/
├── data/
│   ├── student_performance_large_dataset.csv  # ⇦ Dane z Kaggle
│   └── sentiment140.csv                      # ⇦ 1.6 mln angielskich tweetów
├── quarto/
│   └── learning_lsa_lda.qmd       # ⇦ Główny plik ze slajdami (reveal.js)
├── scripts/
│   ├── setup_kaggle.sh            # ⇦ Pobiera dane i konfiguruje API token
│   ├── setup_feedback.sh          # ⇦ Pobiera angielski zbiór tweetów
│   └── bake_wordclouds.R          # ⇦ (Opcjonalnie) Generuje chmury słów jako PNG
├── .gitignore
├── install.R                      # ⇦ Skrypt do instalacji pakietów R
└── README.md                      # ⇦ Ten plik
```

---

## ⚙️ Instalacja i konfiguracja

### 1. Pobieranie danych z Kaggle

Aby pobrać dane, potrzebujesz konta na [Kaggle](https://kaggle.com).

1.  Zaloguj się na swoje konto Kaggle.
2.  Przejdź do `Account` → `Create New API Token`, aby pobrać plik `kaggle.json`.
3.  Uruchom skrypt konfiguracyjny:
    ```bash
    bash scripts/setup_kaggle.sh
    ```

**Co robi skrypt `setup_kaggle.sh`?**
*   Kopiuje `kaggle.json` do `~/.kaggle/` i ustawia odpowiednie uprawnienia (`chmod 600`).
*   Pobiera zbiór danych `adilshamim8/student-performance-and-learning-style` do katalogu `data/`.
*   Rozpakowuje archiwum, tworząc plik `student_performance_large_dataset.csv`.

> **Alternatywa (ręczna):** Ustaw zmienne środowiskowe `KAGGLE_USERNAME` i `KAGGLE_KEY`, a następnie wykonaj komendy `kaggle datasets download ...` i `unzip ...` ręcznie.

### 2. Pobieranie tweetów do analizy

Skrypt pobiera korpus **Sentiment140** zawierający 1.6&nbsp;miliona angielskich tweetów z etykietami sentymentu.

```bash
bash scripts/setup_feedback.sh
```

Powstanie plik `sentiment140.csv` w katalogu `data/`.

### 3. Instalacja pakietów R

Skrypt `install.R` instaluje potrzebne pakiety z CRAN i wstępnie pobiera słowniki sentymentu.

```R
# install.R
options(repos = c(CRAN = "https://cloud.r-project.org"))
options(textdata.download = TRUE)

pkgs <- c(
  "tidyverse", "janitor", "tidytext", "textdata",
  "topicmodels", "textmineR", "tm", "SnowballC",
  "wordcloud", "knitr", "quarto"
)

install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p)
  }
}

invisible(lapply(pkgs, install_if_missing))

# Pobranie słownika AFINN (używany w przykładzie sentymentu)
tidytext::get_sentiments("afinn")
```

---

## 🔬 Logika analizy w pliku `.qmd`

Plik `quarto/learning_lsa_lda.qmd` zawiera całą logikę analizy danych, podzieloną na sekcje (chunki).

| Chunk / Sekcja  | Cel i zawartość                                               |
| :-------------- | :------------------------------------------------------------ |
| `setup`         | Ładowanie bibliotek R, ustawienia globalne `knitr::opts_chunk$set()`. |
| `data-load`     | Wczytanie danych z `../data/student_performance_large_dataset.csv` lub `sentiment140.csv` i przygotowanie danych. |
| `clean`         | Tworzenie kolumny tekstowej do analizy (z braku danych opisowych), czyszczenie tekstu: zmiana na małe litery, tokenizacja, usunięcie stop-words. |
| `lsa`           | Obliczenie TF-IDF, dopasowanie modelu LSA (`k=20`), wizualizacja 2D (UMAP/PCA). |
| `lda`           | Modelowanie LDA (`k=8`), ekstrakcja top 10 słów dla każdego tematu. |
| `sentiment`     | Analiza sentymentu z użyciem słownika AFINN, prosta wizualizacja wyniku. |
| `gpa-boxplot`   | Wizualizacja zależności GPA od stylu nauki (boxplot).         |
| `conclusions`   | Podsumowanie (3-5 głównych wniosków) i omówienie ograniczeń modelu. |

**Renderowanie pliku do HTML:**
```bash
quarto render quarto/learning_lsa_lda.qmd --to revealjs
```

---

## 📖 Szybka teoria (dla niewtajemniczonych)

| Termin      | Opis "po ludzku"                                              | Zastosowanie w projekcie                                      |
| :---------- | :------------------------------------------------------------ | :------------------------------------------------------------ |
| **TF-IDF**  | Miara ważności słowa: rośnie, gdy słowo jest rzadkie w całym zbiorze tekstów. | Służy jako macierz wejściowa dla modelu LSA.                  |
| **LSA**     | Metoda matematyczna redukująca tysiące słów do kilkunastu "ukrytych wymiarów znaczeń". | Umożliwia wizualizację studentów w 2D i pokolorowanie ich według metody nauki. |
| **LDA**     | Algorytm, który "odgaduje" tematy, na jakie można podzielić zbiór tekstów. | Zidentyfikowano 8 głównych tematów wraz z listą najważniejszych słów. |
| **AFINN Lexicon** | Prosty słownik ocenianych słów od -5 do 5. | Używany do obliczenia podstawowego wyniku sentymentu. |
| **UMAP**    | Algorytm redukcji wymiaru, który dobrze zachowuje lokalne sąsiedztwa punktów. | Użyty jako alternatywa dla PCA do tworzenia czytelniejszych wykresów 2D. |

---

## 🤔 FAQ / Rozwiązywanie problemów

| Problem                           | Prawdopodobna przyczyna                               | Rozwiązanie                                                  |
| :-------------------------------- | :---------------------------------------------------- | :----------------------------------------------------------- |
| `KeyError: 'username'` przy Kaggle | Brak pliku `~/.kaggle/kaggle.json` lub uprawnień.     | Uruchom `bash scripts/setup_kaggle.sh` lub ustaw zmienne `KAGGLE_*`. |
| `language server is not responding` | Wiele wiszących procesów R w tle.                     | W VS Code: `R: Restart Session` i zamknij nieużywane terminale. |
| Błąd renderowania PDF (brak TinyTeX) | Brak zainstalowanej dystrybucji LaTeX.                | Uruchom `quarto install toolchain` w terminalu.              |
| `Error in FitLsaModel`            | Pusta macierz DTM (np. po odfiltrowaniu stop-words). | Sprawdź filtry stop-words lub zmniejsz liczbę wymiarów `k`.   |
