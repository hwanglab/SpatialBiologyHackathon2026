############################################################
# Spatial Biology Analysis Hackathon 2026
# R Environment Installation Script
#
# Target use:
# - Visium / Visium HD
# - Spatial transcriptomics
# - Seurat-based analysis
#
# R version: >= 4.2 recommended
############################################################

cat("Starting Spatial Hackathon R environment setup...\n")

# -----------------------------
# 1. Basic sanity checks
# -----------------------------
if (getRversion() < "4.2.0") {
  stop("R >= 4.2.0 is required. Please update R before proceeding.")
}

# -----------------------------
# 2. Helper function
# -----------------------------
install_if_missing <- function(pkgs, repos = "https://cloud.r-project.org") {
  missing <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
  if (length(missing) > 0) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing, repos = repos, dependencies = TRUE)
  } else {
    message("All CRAN packages already installed.")
  }
}

# -----------------------------
# 3. CRAN packages
# -----------------------------
cran_packages <- c(
  # Core
  "Seurat",
  "SeuratObject",
  "Matrix",
  "patchwork",
  "ggplot2",
  "cowplot",
  "data.table",
  "dplyr",
  "tidyr",
  "stringr",
  "purrr",

  # Visualization
  "viridis",
  "scales",
  "RColorBrewer",

  # Spatial / statistics
  "spdep",
  "sf",
  "igraph",

  # Utilities
  "future",
  "future.apply",
  "optparse",
  "jsonlite"
)

install_if_missing(cran_packages)

# -----------------------------
# 4. Bioconductor setup
# -----------------------------
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

BiocManager::install(
  c(
    "SingleCellExperiment",
    "SummarizedExperiment",
    "SpatialExperiment",
    "ComplexHeatmap",
    "scater",
    "scran",
    "limma"
  ),
  update = FALSE,
  ask = FALSE
)

# -----------------------------
# 5. GitHub packages (used in hackathon-style workflows)
# -----------------------------
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

github_packages <- c(
  "satijalab/seurat-data",
  "satijalab/seurat-wrappers"
)

for (repo in github_packages) {
  pkg <- basename(repo)
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing GitHub package: ", repo)
    remotes::install_github(repo, dependencies = TRUE, upgrade = "never")
  }
}

# -----------------------------
# 6. Final validation
# -----------------------------
required_for_validation <- c(
  "Seurat",
  "ggplot2",
  "patchwork",
  "SingleCellExperiment",
  "SpatialExperiment"
)

missing_after <- required_for_validation[
  !required_for_validation %in% installed.packages()[, "Package"]
]

if (length(missing_after) > 0) {
  warning(
    "Some required packages failed to install:\n",
    paste(missing_after, collapse = ", "),
    "\nPlease check system dependencies or install manually."
  )
} else {
  cat("\n✅ Spatial Hackathon R environment successfully installed!\n")
}

############################################################
# End of script
############################################################
