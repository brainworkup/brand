# Luria Brand System

<!-- TOC-START -->

## 📋 Table of Contents

- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
  - [Using `_brand.yml` in a Quarto Project](#using-_brandyml-in-a-quarto-project)
  - [Local Preview](#local-preview)
- [Directory Guide](#directory-guide)
- [What's Defined in `_brand.yml`](#whats-defined-in-_brandyml)
- [What You'll Still Need

## Usage

### Basic Integration

To use the brainworkup brand system in your Quarto project, copy the `_brand.yml` file to your project root directory:

```bash
# Clone or download this repository
git clone https://github.com/brainworkup/brand.git

# Copy the brand configuration to your project
cp brainworkup/_brand.yml /path/to/your/quarto-project/
```

### Project Setup

1. **Add brand configuration to your `_quarto.yml`:**

   ```yaml
   project:
     type: website
   
   brand: _brand.yml
   
   format:
     html:
       theme: default
   ```

2. **Copy required assets:**

   ```bash
   # Copy logos and images to your project
   cp -r brainworkup/assets/ /path/to/your/project/assets/
   
   # Copy custom CSS (optional)
   cp brainworkup/styles/custom.css /path/to/your/project/styles/
   ```

### Available Brand Elements

#### Typography

Use predefined typography classes in your documents:

```markdown
::: {.brand-heading}
# Main Heading
:::

::: {.brand-subtitle}
Supporting subtitle text
:::
```

#### Color Palette

Reference brand colors in custom CSS or HTML:

```css
/* Primary brand color */
.my-element {
  color: var(--brand-color-primary);
  background-color: var(--brand-color-secondary);
}
```

#### Logos and Assets

Include brand logos in your content:

```markdown
![brainworkup logo](assets/logos/logo.svg){.brand-logo}
```

### Customization

#### Override Specific Elements

Create a custom `_brand-local.yml` to override specific brand settings:

```yaml
# _brand-local.yml
typography:
  base-size: 1.1em
  
color:
  primary: "#your-custom-color"
```

Then reference both files in your `_quarto.yml`:

```yaml
brand: 
  - _brand.yml
  - _brand-local.yml
```

#### Environment-Specific Configurations

Use different brand configurations for different outputs:

```yaml
format:
  html:
    brand: _brand.yml
  pdf:
    brand: _brand-print.yml
```

### Development Workflow

1. **Preview changes locally:**

   ```bash
   quarto preview
   ```

2. **Render with brand system:**

## Installation

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) 1.3 or higher
- Git (for cloning the repository)

### Method 1: Direct Download

1. **Download the brand files**

   ```bash
   curl -L https://github.com/brainworkup/brand/archive/main.zip -o brainworkup-brand.zip
   unzip brainworkup-brand.zip
   ```

2. **Copy brand files to your project**

   ```bash
   cp brainworkup-brand-system-main/_brand.yml /path/to/your-quarto-project/
   cp -r brainworkup-brand-system-main/_brand/ /path/to/your-quarto-project/
   ```

### Method 2: Git Clone

1. **Clone the repository**

   ```bash
   git clone https://github.com/brainworkup/brand-system.git
   cd brand-system
   ```

2. **Copy brand files to your project**

   ```bash
   cp _brand.yml /path/to/your-quarto-project/
   cp -r _brand/ /path/to/your-quarto-project/
   ```

### Method 3: Git Submodule (Recommended for ongoing updates)

1. **Add as a submodule in your Quarto project**

   ```bash
   cd /path/to/your-quarto-project
   git submodule add https://github.com/brainworkup/brand-system.git _brand-system
   ```

2. **Symlink the brand files**

   ```bash
   ln -s _brand-system/_brand.yml _brand.yml
   ln -s _brand-system/_brand/ _brand
   ```

3. **Update submodule when needed**

   ```bash
   git submodule update --remote _brand-system
   ```

### Verification

After installation, verify the brand system is properly configured:

1. Check that `_brand.yml` exists in your project root
2. Confirm the `_brand/` directory contains the necessary assets
3. Run a test render to ensure everything works:

   ```bash
   quarto render --to html
   ```

If successful, your documents should now use the brainworkup brand styling and assets.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### What this means

- ✅ **Commercial use** - You can use this brand system in commercial projects
- ✅ **Modification** - You can modify and adapt the brand assets for your needs
- ✅ **Distribution** - You can distribute copies of the original or modified system
- ✅ **Private use** - You can use this privately without restriction

### Attribution

While not required by the MIT License, attribution is appreciated when using this brand system in your projects.

### Third-Party Assets

Some brand assets may incorporate third-party fonts, icons, or other resources that have their own licensing terms. Please verify the licensing of any third-party components before use in your projects.

   ```bash
   quarto render --brand _brand.yml
   ```

1. **Validate brand compliance:**

   ```bash
   quarto check
   ```

### Troubleshooting

- **Missing assets:** Ensure all referenced files in `_brand.yml` exist in your project
- **Styling conflicts:** Check CSS specificity if custom styles aren't applying
- **Path issues:** Verify relative paths in `_brand.yml` match your project structure
](#what-youll-still-need)

<!-- TOC-END -->

Quarto `_brand.yml` configuration and supporting assets for brainworkup.org.

## Repository Structure

```text
brand/
├── _brand.yml          # Main brand configuration (colors, typography, metadata)
├── _content.qmd        # Content pages using the brand system
├── dashboard.qmd       # Dashboard implementation
├── concepts/           # Brand concept explorations and variations
├── docs/               # Documentation for brand usage

## Configuration

The brainworkup brand system is configured through a central `_brand.yml` file that defines all brand elements for use across Quarto projects. This configuration follows Quarto's brand system specification and provides a single source of truth for all brand assets and styling.

### Core Configuration File

The main configuration is stored in `_brand.yml` at the root of this repository:

```yaml
brand:
  color:
    primary: "#0066CC"
    secondary: "#F5F5F5"
    # Additional color definitions...
  
  typography:
    base:
      family: "Inter, system-ui, sans-serif"
      size: "16px"
    headings:
      family: "Inter, system-ui, sans-serif"
      weight: 600
  
  logo:
    path: "assets/logo/brainworkup-logo.svg"
    alt: "brainworkup logo"
  
  # Additional brand configurations...
```

### Using the Configuration

#### In Your Quarto Project

1. **Copy or reference** the `_brand.yml` file to your project root
2. **Ensure asset paths** are correctly resolved relative to your project
3. **Apply the brand** by adding to your `_quarto.yml`:

```yaml
project:
  type: website

brand: _brand.yml

format:
  html:
    theme: 
      - default
      - brand
```

#### Asset Path Configuration

Update asset paths in `_brand.yml` to match your project structure:

```yaml
# If assets are in a subdirectory
logo:
  path: "brand-assets/logo/brainworkup-logo.svg"

# If using absolute URLs
logo:
  path: "https://cdn.example.com/logo.svg"
```

### Environment-Specific Overrides

Create environment-specific configurations by extending the base brand file:

```yaml
# _brand-dev.yml
extends: _brand.yml

brand:
  color:
    primary: "#FF6B35"  # Development orange
```

### Validation

Verify your configuration with Quarto's built-in validation:

```bash
quarto check brand _brand.yml
```

### Custom CSS Integration

The brand configuration automatically generates CSS custom properties that can be extended:

```css
/* In your custom.css */
:root {
  --brand-accent: #00A86B;  /* Custom accent color */
}

.custom-component {
  color: var(--brand-color-primary);
  font-family: var(--brand-typography-base-family);
}
```

├── examples/           # Example implementations
├── scripts/            # Utility scripts for brand management
├── templates/          # Quarto templates using the brand
├── AGENTS.md           # AI agent guidance for this repo
├── CLAUDE.md           # Claude-specific context and guidelines
└── README.md           # This file

```

## Quick Start

### Using `_brand.yml` in a Quarto Project

Copy the brand configuration to your project root:

```bash
cp _brand.yml ~/sites/brainworkup/_brand.yml
```

Then reference it in your `_quarto.yml`:

```yaml
brand: _brand.yml
```

### Local Preview

```bash
quarto preview _content.qmd
quarto preview dashboard.qmd
```

## Directory Guide

| Directory | Purpose |
|-----------|---------|
| `concepts/` | Brand concept explorations and variations |
| `docs/` | Usage documentation and guidelines |
| `examples/` | Working examples of brand implementation |
| `scripts/` | Automation and utility scripts |
| `templates/` | Reusable Quarto templates |

## What's Defined in `_brand.yml`

- **Colors** — Primary, secondary, and semantic color palette
- **Typography** — Font families, sizes, and weights
- **Metadata** — Default page settings and project info

## What You'll Still Need

1. **Logo files** — Place in your project's assets directory
2. **Custom CSS/SCSS** — For layout beyond brand.yml controls
3. **`_quarto.yml`** — Project-level configuration
4. **Favicons** — Generated to match the brand colors
