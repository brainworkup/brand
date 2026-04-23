from brand_yml import Brand

brand = Brand.from_yaml_str(
    # Typically, this file is stored in `_brand.yml`
    # and read with `Brand.from_yaml()`.
    """
    meta:
      name: Posit Software, PBC
      link: https://posit.co
    color:
      palette:
        blue: "#447099"
        green: "#72994E"
        teal: "#419599"
        orange: "#EE6331"
        purple: "#9A4665"
        gray: "#707073"
      primary: blue
      secondary: gray
      success: green
      info: teal
      warning: orange
      danger: purple
    typography:
      base:
        family: Open Sans
        weight: 300
    """
)
