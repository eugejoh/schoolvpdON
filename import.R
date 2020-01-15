library(here)
library(tidyverse)
library(janitor)

# Import Metadata ---------------------------------------------------------
metd <- readr::read_csv(here("data", "metadata.csv"))

my_readxl <- function(x, ...) {
  stopifnot(is.data.frame(x))
  stopifnot(all(c("data_file", "sheet") %in% names(x)))
  
  out <- dplyr::mutate(x, path = here::here("data", data_file)) %>%
    dplyr::select(path, sheet, skip) %>%
    purrr::pmap(~ readxl::read_xlsx(...)) %>%
    purrr::map(janitor::clean_names)
  
  out
  
}

# Import Coverage ---------------------------------------------------------
ic_data <- metd %>%
  filter(name == "imm_coverage") %>% 
  my_readxl()

names(ic_data) <- metd$sheet[metd$name == "imm_coverage"]

# Import School Info ------------------------------------------------------
school_info <- metd %>%
  filter(name == "school_info") %>% 
  my_readxl() %>% 
  pluck(1)

