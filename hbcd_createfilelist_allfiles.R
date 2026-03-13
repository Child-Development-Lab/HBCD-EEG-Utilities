## hbcd_createfilelist_corrected.R
## Strict EEG filelist generator
## Alicia Vallorani — chaos respected, properly filtered

library(tidyverse)

cat("Starting hbcd_createfilelist\n")

# --------------------------------------------------
# USER SETTINGS
# --------------------------------------------------

deriv_root <- "/Volumes/rosalind/Projects/hbcd/EEG/Main_Study/CBRAIN_Outputs/V06"

output_csv <- "/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/data_releases/v06_windows/data"


# --------------------------------------------------
# INDEX DERIVATIVE FILES
# --------------------------------------------------

cat("Indexing derivative files...\n")

deriv_files <- list.files(
  deriv_root,
  pattern = "\\.set$",
  recursive = TRUE,
  full.names = FALSE
)

deriv_tbl <- tibble(filename = deriv_files) |>
  mutate(
    filename = basename(filename),   # HARD GUARANTEE: basename only
    subject  = str_extract(filename, "sub-\\d+"),
    session  = str_extract(filename, "ses-V0[6]"),
    task = case_when(
      str_detect(filename, "task-RS")   ~ "rs",
      str_detect(filename, "task-FACE") ~ "face",
      str_detect(filename, "task-MMN")  ~ "mmn",
      str_detect(filename, "task-VEP")  ~ "vep",
      TRUE ~ NA_character_
    )
  ) |>
  filter(!is.na(task), !is.na(session))

cat("Indexed", nrow(deriv_tbl), "files\n")

# --------------------------------------------------
# AGE LOOKUP (USED ONLY FOR VEP V03)
# --------------------------------------------------

get_age_months <- function(sub, ses) {
  tsv <- file.path(raw_root, sub, ses, paste0(sub, "_", ses, "_scans.tsv"))
  if (!file.exists(tsv)) return(NA_real_)
  
  dat <- tryCatch(
    read_tsv(tsv, col_types = cols(), progress = FALSE),
    error = function(e) NULL
  )
  if (is.null(dat) || !"age" %in% names(dat) || !"filename" %in% names(dat)) {
    return(NA_real_)
  }
  
  acq_rows <- dat %>% filter(str_detect(filename, "acq-eeg"))
  if (nrow(acq_rows) == 0) return(NA_real_)
  
  acq_rows$age[1] * 12
}

# --------------------------------------------------
# BUILD FILE LIST (ALL FILES)
# --------------------------------------------------

cat("Building full file list (no sampling)...\n")

file_tbl <- deriv_tbl |>
  mutate(col = paste0(task, str_remove(session, "ses-"))) |>
  select(col, filename)

# make columns like rsV06, faceV06, etc.
file_tbl <- file_tbl |>
  group_by(col) |>
  mutate(row = row_number()) |>
  ungroup() |>
  pivot_wider(names_from = col, values_from = filename) |>
  select(-row)

# --------------------------------------------------
# WRITE CSV (FILENAMES ONLY)
# --------------------------------------------------

cat("Writing CSV...\n")

outfile <- file.path(output_csv, "hbcd_filelist.csv")

write_csv(file_tbl, outfile, na = "")

cat("DONE. File written to:\n", output_csv, "\n")
