cd ~/path/to/brand/brainworkup-brands

# Render all 28 (7 concepts × 4 formats)
Rscript render_all_brands.R

# Render only HTML variants (7 files)
Rscript render_all_brands.R html

# Render only concept 4 across all formats (4 files)
Rscript render_all_brands.R 4

# Render one specific combo
Rscript render_all_brands.R typst 4
