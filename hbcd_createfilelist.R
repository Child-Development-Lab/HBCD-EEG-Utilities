## hbcd_createfilelist_corrected.R
## Strict EEG filelist generator
## Alicia Vallorani — chaos respected, properly filtered

library(tidyverse)

cat("Starting hbcd_createfilelist\n")

# --------------------------------------------------
# USER SETTINGS
# --------------------------------------------------

deriv_root <- "/Volumes/cdl/Projects/hbcd/BR20.1 made derivatives/br20.1/hbcd/derivatives/made"
raw_root   <- "/Volumes/cdl/Projects/hbcd/BR20.1 rawfiles/br20.1/hbcd/rawdata"

output_csv <- "/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/data_releases/br20.2/data/br20.2_filelist.csv"

set.seed(1234)

n_files <- list(
  rs   = list(V03 = 100, V04 = 100),
  face = list(V03 = 100, V04 = 100),
  mmn  = list(V03 = 100, V04 = 100),
  vep  = list(V0336 = 100, V0369 = 100, V04 = 100)
)

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

deriv_tbl <- tibble(filename = deriv_files) %>%
  mutate(
    filename = basename(filename),   # HARD GUARANTEE: basename only
    subject  = str_extract(filename, "sub-\\d+"),
    session  = str_extract(filename, "ses-V0[34]"),
    task = case_when(
      str_detect(filename, "task-RS")   ~ "rs",
      str_detect(filename, "task-FACE") ~ "face",
      str_detect(filename, "task-MMN")  ~ "mmn",
      str_detect(filename, "task-VEP")  ~ "vep",
      TRUE ~ NA_character_
    )
  ) %>%
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
# SIMPLE SAMPLER
# --------------------------------------------------

sample_simple <- function(task_name, session_name, n) {
  pool <- deriv_tbl %>%
    filter(task == task_name, session == session_name)
  
  if (nrow(pool) == 0) return(character())
  
  sample(basename(pool$filename), min(n, nrow(pool)))
}

# --------------------------------------------------
# VEP V03 SAMPLER (AGE-AWARE + DIAGNOSTICS)
# --------------------------------------------------

sample_vep_v03 <- function(n, age_min, age_max) {
  
  pool <- deriv_tbl %>%
    filter(task == "vep", session == "ses-V03")
  
  cat("\nVEP V03 total files:", nrow(pool), "\n")
  
  if (nrow(pool) == 0) return(character())
  
  ages <- map_dbl(pool$subject, get_age_months, ses = "ses-V03")
  
  valid_age <- !is.na(ages)
  cat("  Files with valid age:", sum(valid_age), "\n")
  
  ages_valid <- ages[valid_age]
  if (length(ages_valid) > 0) {
    cat(
      "  Age summary (months): min =", round(min(ages_valid), 2),
      "max =", round(max(ages_valid), 2),
      "median =", round(median(ages_valid), 2), "\n"
    )
  }
  
  in_range <- ages >= age_min & ages < age_max
  cat("  In range [", age_min, ",", age_max, "): ",
      sum(in_range, na.rm = TRUE), "\n")
  
  valid <- basename(pool$filename[in_range])
  
  if (length(valid) < n) {
    warning("Only ", length(valid),
            " VEP V03 files found in age range ",
            age_min, "-", age_max)
  }
  
  sample(valid, min(n, length(valid)))
}

# --------------------------------------------------
# BUILD FILE LIST
# --------------------------------------------------

cat("Sampling files...\n")
filelist <- list()

filelist$rsV03   <- sample_simple("rs",   "ses-V03", n_files$rs$V03)
filelist$rsV04   <- sample_simple("rs",   "ses-V04", n_files$rs$V04)

filelist$faceV03 <- sample_simple("face", "ses-V03", n_files$face$V03)
filelist$faceV04 <- sample_simple("face", "ses-V04", n_files$face$V04)

filelist$mmnV03  <- sample_simple("mmn",  "ses-V03", n_files$mmn$V03)
filelist$mmnV04  <- sample_simple("mmn",  "ses-V04", n_files$mmn$V04)

filelist$vepV0336 <- sample_vep_v03(n_files$vep$V0336, 3, 5.9)
filelist$vepV0369 <- sample_vep_v03(n_files$vep$V0369, 6, 9)
filelist$vepV04   <- sample_simple("vep", "ses-V04", n_files$vep$V04)

# --------------------------------------------------
# WRITE CSV (FILENAMES ONLY)
# --------------------------------------------------

cat("Writing CSV (filenames only)...\n")

max_len <- max(map_int(filelist, length))

out_tbl <- map_dfc(filelist, function(x) {
  length(x) <- max_len
  x
})

write_csv(out_tbl, output_csv, na = "")

cat("DONE. File written to:\n", output_csv, "\n")
