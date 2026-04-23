# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this directory is

`brand/` is the **BRAND** subsystem of Luria Voice (see `../CLAUDE.md` for the three-subsystem overview). It is a Posit `_brand.yml` repository: a single source of truth for colors, typography, logos, and metadata that themes Quarto documents, Shiny apps, and Typst PDFs across the rest of the Luria pipeline.

The active brand is `brand/_brand.yml` — currently **Concept 7: Dual Identity** (navy/gold authority + teal/coral warm, paired with Merriweather headings and Atkinson Hyperlegible body). Seven alternatives live under `concepts/concept-*/`. Switching the active brand is a **file copy**:

```bash
cp concepts/concept-4-institute/_brand.yml _brand.yml
```

Quarto ≥1.4 and Shiny ≥1.9 auto-discover `_brand.yml` at the project root — nothing else needs editing.

## Common commands

```bash
# Render the 7 x 5 preview matrix (35 files: 7 concepts x html/typst/pdf/docx/revealjs)
Rscript scripts/render_all_brands.R

# Filter: one format across all concepts, or one concept across all formats,
# or one specific combo
Rscript scripts/render_all_brands.R html
Rscript scripts/render_all_brands.R 4
Rscript scripts/render_all_brands.R typst 4

# Before rendering docx variants, regenerate the branded reference.docx per concept
python3 scripts/generate_docx_refs.py                     # all 7
python3 scripts/generate_docx_refs.py concept-4-institute # one

# Quick single-file preview against the active brand
quarto preview dashboard.qmd
```

Output lands in `output/`, with intermediate QMDs in `output/_qmd/`. Neither is checked in.

## Architecture notes (the non-obvious stuff)

**The render script is the load-bearing piece.** `scripts/render_all_brands.R` programmatically builds a YAML front matter + appends `_content.qmd` body for every (concept × format) cell, then shells out to `quarto render`. A few constraints baked in that will bite if changed naively:

- `brand:` must be a **top-level** document key, not nested under `format:`. Quarto's Typst, PDF, and other non-HTML formats only pick up brand when it's top-level.
- Brand paths are written **relative to the generated QMD** (`../../<concept>/_brand.yml`), because Quarto resolves brand paths from the QMD, not CWD.
- The script post-processes YAML output to rewrite `yes`/`no` → `true`/`false`. R's `yaml` package emits YAML 1.1 booleans; Quarto requires YAML 1.2.
- `--output-dir` is unreliable with nested QMD paths, so the script renders in place next to the QMD and then `file_move`s the artifact into `output/`.

**docx is a special case.** Quarto does **not** support `brand:` for docx output. The workaround: `scripts/generate_docx_refs.py` reads each concept's `_brand.yml` and writes a `reference.docx` into that concept's directory (using `python-docx`), encoding the palette and typography as Word styles. The render script then injects `reference-doc:` pointing at that file for docx targets. If you edit a concept's `_brand.yml`, you must regenerate its `reference.docx` before rendering docx.

**Concept 7 carries two color sets.** Unlike concepts 1–6, `concept-7-dual-identity/_brand.yml` exposes both the warm (teal/coral) and authority (navy/gold) palettes simultaneously. The `defaults.bootstrap.defaults` block re-exports `$brand-teal`, `$brand-coral`, `$brand-navy`, `$brand-gold` as Sass variables so downstream pages can flip audience context via a CSS class (`.pediatric`, `.forensic`) rather than swapping brand files.

**`templates/` vs `examples/`.** `templates/` holds the format-specific Quarto stubs (`html.qmd`, `docx.qmd`, `typst.qmd`, `revealjs.qmd`, `example.qmd`, and `_colors.scss`) used when you want a single-format preview. `examples/` is older scaffolding from the upstream `brand.yml` sample repo — snapshots of concepts, duplicated scripts (`render.sh`, `render_all_brands.R`, `brand.R`, `app.R`, etc.), and a `brand-repo/` sample. Treat `examples/` as reference material; the canonical working copies live in `scripts/`, `templates/`, and `concepts/`.

**Logos are not in concept folders.** The root `_brand.yml` references `logos/logo.png`, `logos/favicon.png`, etc. Concept folders contain only `_brand.yml` (and a generated `reference.docx` for docx support). Logo assets are expected alongside the active brand file, not per-concept.

**`_content.qmd` is the shared preview body.** Every rendered combo reuses the same content — this is intentional so that visual differences between concepts are purely brand-driven, not content-driven. Edit `_content.qmd` once to change what all 35 preview files display.

## Editing concept brands

When changing a concept's `_brand.yml`:

1. Edit `concepts/<concept>/_brand.yml`.
2. If the concept will be rendered to docx, regenerate its reference: `python3 scripts/generate_docx_refs.py <concept>`.
3. If this concept is the active brand, copy it back up: `cp concepts/<concept>/_brand.yml _brand.yml`.
4. Re-render: `Rscript scripts/render_all_brands.R <concept>`.

## Scope

Per `AGENTS.md`, this directory's guidance is narrow: only what's specific to brand-file authoring, concept switching, and the preview matrix. Anything about Quarto extensions, report templates, or the SOUL/STYLE pipelines belongs in `../CLAUDE.md` or the respective subdirectories.
