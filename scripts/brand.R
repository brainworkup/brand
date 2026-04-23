library(brand.yml)

brand <- read_brand_yml(
  system.file("examples", "brand-posit.yml", package = "brand.yml")
)

brand$color |> str()

read_brand_yml()

# For this example: copy a brand.yml to a temporary directory
tmp_dir <- tempfile()
dir.create(tmp_dir)
file.copy(
  system.file("examples/brand-posit.yml", package = "brand.yml"),
  file.path(tmp_dir, "_brand.yml")
)

brand <- read_brand_yml(tmp_dir)
