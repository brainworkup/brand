#!/usr/bin/env Rscript
# ============================================================================
# render_all_brands.R
# ============================================================================
# Renders a 7 x 5 matrix of Quarto brand previews:
#   7 brand concepts x 5 output formats (html, typst/pdf, pdf, docx, revealjs)
#
# Output files are named: {format}-{concept-name}.{ext}
#   e.g., typst-concept-4-institute.pdf
#         html-concept-1-growing-minds.html
#         pdf-concept-6-academic-authority.pdf
#         docx-concept-3-clinical-modern.docx
#
# Usage:
#   Rscript render_all_brands.R           # render all 28
#   Rscript render_all_brands.R html      # render only html (7 files)
#   Rscript render_all_brands.R typst     # render only typst (7 files)
#   Rscript render_all_brands.R 4         # render only concept 4 (4 files)
#   Rscript render_all_brands.R typst 4   # render one specific combo
# ============================================================================

library(fs)
library(glue)
library(yaml)
library(cli)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

concepts <- c(
  "concept-1-growing-minds",
  "concept-2-lighthouse",
  "concept-3-clinical-modern",
  "concept-4-institute",
  "concept-5-neural-blueprint",
  "concept-6-academic-authority",
  "concept-7-dual-identity"
)

# Human-readable labels for the subtitle
concept_labels <- c(
  "concept-1-growing-minds" = "Concept 1: Growing Minds (Warm & Supportive)",
  "concept-2-lighthouse" = "Concept 2: The Lighthouse (Warm & Supportive)",
  "concept-3-clinical-modern" = "Concept 3: Clinical Modern (Mixed)",
  "concept-4-institute" = "Concept 4: The Institute (Mixed-Academic)",
  "concept-5-neural-blueprint" = "Concept 5: Neural Blueprint (Mixed)",
  "concept-6-academic-authority" = "Concept 6: Academic Authority (Academic)",
  "concept-7-dual-identity" = "Concept 7: Dual Identity (Strategic Hybrid)"
)

# Format definitions: name, quarto format key, file extension, extra YAML options
formats <- list(
  html = list(
    format_key = "html",
    ext = "html",
    opts = list(
      toc = TRUE,
      `toc-depth` = 3L,
      `number-sections` = FALSE,
      `embed-resources` = TRUE,
      `self-contained` = TRUE
    )
  ),
  typst = list(
    format_key = "typst",
    ext = "pdf",
    opts = list(
      toc = TRUE,
      `toc-depth` = 3L,
      `number-sections` = TRUE
    )
  ),
  pdf = list(
    format_key = "pdf",
    ext = "pdf",
    opts = list(
      toc = TRUE,
      `toc-depth` = 3L,
      `number-sections` = TRUE,
      documentclass = "article",
      papersize = "letter"
    )
  ),
  docx = list(
    format_key = "docx",
    ext = "docx",
    opts = list(
      toc = TRUE,
      `toc-depth` = 3L,
      `number-sections` = TRUE
    )
  ),
  revealjs = list(
    format_key = "revealjs",
    ext = "html",
    opts = list(
      toc = TRUE,
      `toc-depth` = 1L,
      `number-sections` = TRUE,
      `slide-number` = TRUE,
      theme = "default",
      transition = "slide",
      `transition-speed` = "default",
      `embed-resources` = TRUE,
      `self-contained` = TRUE,
      `slide-level` = 2L,
      `incremental` = FALSE,
      width = 1050L,
      height = 700L
    )
  )
)

# ---------------------------------------------------------------------------
# Parse CLI args for optional filtering
# ---------------------------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)
filter_format <- NULL
filter_concept <- NULL

for (arg in args) {
  if (arg %in% names(formats)) {
    filter_format <- arg
  } else if (grepl("^[1-7]$", arg)) {
    filter_concept <- as.integer(arg)
  } else if (arg %in% concepts) {
    filter_concept <- which(concepts == arg)
  }
}

# Apply filters
if (!is.null(filter_format)) {
  formats <- formats[filter_format]
}
if (!is.null(filter_concept)) {
  concepts <- concepts[filter_concept]
  concept_labels <- concept_labels[concepts]
}

# ---------------------------------------------------------------------------
# Directories
# ---------------------------------------------------------------------------

# This script should be run from the brainworkup-brands/ directory
script_dir <- if (interactive()) {
  getwd()
} else {
  # When run via Rscript, use the script's own location
  initial_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("--file=", initial_args, value = TRUE)
  if (length(file_arg) > 0) {
    dirname(normalizePath(sub("--file=", "", file_arg)))
  } else {
    getwd()
  }
}

content_file <- file.path(script_dir, "_content.qmd")
output_dir <- file.path(script_dir, "output")
qmd_dir <- file.path(script_dir, "output", "_qmd")

# Create output directories
dir_create(output_dir)
dir_create(qmd_dir)

# Verify content file exists
if (!file_exists(content_file)) {
  cli_abort("Content file not found: {content_file}")
}

content_body <- readLines(content_file, warn = FALSE)

# ---------------------------------------------------------------------------
# Generate QMD files and render
# ---------------------------------------------------------------------------

total <- length(concepts) * length(formats)
cli_h1("Brainworkup Brand Matrix Render")
cli_alert_info(
  "Rendering {total} files: {length(concepts)} concepts x {length(formats)} formats"
)
cli_text("")

results <- data.frame(
  concept = character(),
  format = character(),
  output = character(),
  status = character(),
  stringsAsFactors = FALSE
)

count <- 0
for (concept in concepts) {
  for (fmt_name in names(formats)) {
    count <- count + 1
    fmt <- formats[[fmt_name]]

    # Output file name: e.g., typst-concept-4-institute.pdf
    out_filename <- glue("{fmt_name}-{concept}.{fmt$ext}")
    out_path <- file.path(output_dir, out_filename)

    # QMD file name
    qmd_filename <- glue("{fmt_name}-{concept}.qmd")
    qmd_path <- file.path(qmd_dir, qmd_filename)

    # Brand file path (relative from qmd_dir to concept dir)
    # Quarto resolves brand paths relative to the QMD file, not CWD
    brand_rel <- file.path("..", "..", concept, "_brand.yml")

    cli_h2("[{count}/{total}] {concept} -> {fmt_name}")

    # Build YAML front matter
    yaml_list <- list(
      title = "Brainworkup Brand Preview",
      subtitle = concept_labels[[concept]],
      author = "Joey Trampush, PhD",
      date = "today"
    )

    # Brand must be a top-level document key (not nested under format)
    # so that typst, pdf, and other non-HTML formats pick it up
    yaml_list[["brand"]] <- brand_rel

    # Format block (without brand)
    format_block <- list()
    format_opts_final <- fmt$opts

    # For docx: Quarto doesn't support brand for docx, so inject reference-doc
    # (generated by generate_docx_refs.py) to carry fonts/colors into Word output
    if (fmt$format_key == "docx") {
      ref_docx <- file.path("..", "..", concept, "reference.docx")
      format_opts_final[["reference-doc"]] <- ref_docx
    }

    format_block[[fmt$format_key]] <- format_opts_final
    yaml_list[["format"]] <- format_block

    # Write the QMD
    # yaml::as.yaml() emits YAML 1.1 booleans (yes/no); Quarto requires 1.2 (true/false)
    yaml_header <- yaml::as.yaml(yaml_list, indent.mapping.sequence = TRUE)
    yaml_header <- gsub("\\byes\\b", "true", yaml_header)
    yaml_header <- gsub("\\bno\\b", "false", yaml_header)
    qmd_lines <- c("---", yaml_header, "---", "", content_body)
    writeLines(qmd_lines, qmd_path)

    cli_alert("Generated: {qmd_filename}")

    # Render with quarto
    # Render in place (next to the QMD), then move to output/.
    # --output-dir is unreliable with nested QMD paths, so we avoid it.
    rendered_in_qmd_dir <- file.path(qmd_dir, out_filename)
    render_cmd <- glue(
      'cd "{qmd_dir}" && quarto render "{qmd_filename}" --output "{out_filename}"'
    )

    cli_alert("Rendering: {out_filename}")
    exit_code <- system(render_cmd, intern = FALSE)

    # Quarto may place the file next to the QMD; move it to output/
    if (exit_code == 0 && file_exists(rendered_in_qmd_dir)) {
      file_move(rendered_in_qmd_dir, out_path)
    }

    if (exit_code == 0 && file_exists(out_path)) {
      cli_alert_success("{out_filename}")
      results <- rbind(
        results,
        data.frame(
          concept = concept,
          format = fmt_name,
          output = out_filename,
          status = "success",
          stringsAsFactors = FALSE
        )
      )
    } else {
      cli_alert_danger("FAILED: {out_filename}")
      results <- rbind(
        results,
        data.frame(
          concept = concept,
          format = fmt_name,
          output = out_filename,
          status = "FAILED",
          stringsAsFactors = FALSE
        )
      )
    }
  }
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

cli_h1("Render Summary")

n_success <- sum(results$status == "success")
n_failed <- sum(results$status == "FAILED")

cli_alert_success("Succeeded: {n_success}/{total}")
if (n_failed > 0) {
  cli_alert_danger("Failed: {n_failed}/{total}")
  cli_h2("Failed renders:")
  failed <- results[results$status == "FAILED", ]
  for (i in seq_len(nrow(failed))) {
    cli_alert_danger("  {failed$output[i]}")
  }
}

cli_h2("Output directory: {output_dir}")

# Print a nice matrix view
cli_text("")
cli_h2("Results Matrix")

# Pivot to matrix form
mat <- matrix(
  "",
  nrow = length(unique(results$concept)),
  ncol = length(unique(results$format))
)
rownames(mat) <- unique(results$concept)
colnames(mat) <- unique(results$format)
for (i in seq_len(nrow(results))) {
  mat[results$concept[i], results$format[i]] <-
    ifelse(results$status[i] == "success", "\u2713", "\u2717")
}
print(mat, quote = FALSE)

cli_text("")
cli_alert_info("Done! Output files are in: {output_dir}")
