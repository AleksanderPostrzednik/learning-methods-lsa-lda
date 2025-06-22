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

2.  **Pobierz dane z Kaggle:**
    > **Wymagane:** Konto na [Kaggle](https://kaggle.com) i plik `kaggle.json`.
    ```bash
    bash scripts/setup_kaggle.sh
    ```
    *Skrypt pobierze dane do katalogu `data/`.*

3.  **Zainstaluj pakiety R:**
    ```bash
    Rscript install.R
    ```
    *Instalacja może potrwać 2-3 minuty.*

4.  **Uruchom podgląd slajdów (w terminalu, nie w R):**
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

2.  **Zainstaluj pakiety R:**
    *   Ten skrypt użyje `renv` do zainstalowania wszystkich wymaganych pakietów R.
    ```bash
    Rscript install.R
    ```

3.  **Wyświetl slajdy (w terminalu, nie w R):**
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
├── data/                          # ⇦ Pliki CSV z Kaggle
│   └── student_performance_large_dataset.csv
├── quarto/
│   └── learning_lsa_lda.qmd       # ⇦ Główny plik ze slajdami (reveal.js)
├── renv/                          # ⇦ Biblioteki R (ignorowane przez .gitignore)
├── scripts/
│   ├── setup_kaggle.sh            # ⇦ Pobiera dane i konfiguruje API token
│   └── bake_wordclouds.R          # ⇦ (Opcjonalnie) Generuje chmury słów jako PNG
├── .gitignore
├── install.R                      # ⇦ Instaluje pakiety R i inicjuje renv
├── renv.lock                      # ⇦ Plik blokady wersji pakietów R
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

### 2. Instalacja pakietów R (renv)

Projekt używa `renv` do zarządzania zależnościami w R. Skrypt `install.R` automatyzuje cały proces.

```R
# install.R
# 1. Instalacja renv, jeśli nie istnieje
if (!require("renv")) {
  install.packages("renv")
}

# 2. Inicjalizacja środowiska renv
renv::init(bare = TRUE)

# 3. Lista wymaganych pakietów
pkgs <- c(
  "tidyverse",   # Przetwarzanie danych i ggplot2
  "tidytext",    # Tokenizacja tekstu
  "lsa",         # Latent Semantic Analysis
  "topicmodels", # Modelowanie tematów (LDA)
  "textmineR",   # Obliczanie koherencji i inne narzędzia
  "umap",        # Redukcja wymiarowości (2D)
  "ggwordcloud", # Chmury słów
  "readr",       # Szybki import plików CSV
  "janitor"      # Czyszczenie nazw kolumn
)

# 4. Instalacja pakietów
install.packages(pkgs)

# 5. Zapisanie stanu biblioteki do renv.lock
renv::snapshot()
```
> **Ważne:** Plik `renv.lock` powinien być częścią repozytorium. Katalog `renv/library` jest ignorowany przez `.gitignore`.

---

## 🔬 Logika analizy w pliku `.qmd`

Plik `quarto/learning_lsa_lda.qmd` zawiera całą logikę analizy danych, podzieloną na sekcje (chunki).

| Chunk / Sekcja  | Cel i zawartość                                               |
| :-------------- | :------------------------------------------------------------ |
| `setup`         | Ładowanie bibliotek R, ustawienia globalne `knitr::opts_chunk$set()`. |
| `data-load`     | Wczytanie danych z `data/student_performance_large_dataset.csv` do ramki danych `df`. |
| `clean`         | Czyszczenie tekstu: łączenie kolumn, zmiana na małe litery, tokenizacja, usunięcie stop-words. |
| `lsa`           | Obliczenie TF-IDF, dopasowanie modelu LSA (`k=20`), wizualizacja 2D (UMAP/PCA). |
| `lda`           | Modelowanie LDA (`k=8`), ekstrakcja top 10 słów dla każdego tematu. |
| `sentiment`     | Analiza sentymentu z użyciem słownika NRC, wizualizacja emocji (barplot, chmura słów). |
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
| **NRC Lexicon** | Gotowy słownik mapujący słowa na 8 podstawowych emocji i polaryzację (pozytywna/negatywna). | Obliczono, które emocje dominują w opisach stylów nauki.     |
| **UMAP**    | Algorytm redukcji wymiaru, który dobrze zachowuje lokalne sąsiedztwa punktów. | Użyty jako alternatywa dla PCA do tworzenia czytelniejszych wykresów 2D. |

---

## 🤔 FAQ / Rozwiązywanie problemów

| Problem                           | Prawdopodobna przyczyna                               | Rozwiązanie                                                  |
| :-------------------------------- | :---------------------------------------------------- | :----------------------------------------------------------- |
| `KeyError: 'username'` przy Kaggle | Brak pliku `~/.kaggle/kaggle.json` lub uprawnień.     | Uruchom `bash scripts/setup_kaggle.sh` lub ustaw zmienne `KAGGLE_*`. |
| `language server is not responding` | Wiele wiszących procesów R w tle.                     | W VS Code: `R: Restart Session` i zamknij nieużywane terminale. |
| Błąd renderowania PDF (brak TinyTeX) | Brak zainstalowanej dystrybucji LaTeX.                | Uruchom `quarto install toolchain` w terminalu.              |
| `Error in FitLsaModel`            | Pusta macierz DTM (np. po odfiltrowaniu stop-words). | Sprawdź filtry stop-words lub zmniejsz liczbę wymiarów `k`.   |
