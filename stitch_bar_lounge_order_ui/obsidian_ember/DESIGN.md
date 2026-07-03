---
name: Obsidian & Ember
colors:
  surface: '#10141a'
  surface-dim: '#10141a'
  surface-bright: '#353940'
  surface-container-lowest: '#0a0e14'
  surface-container-low: '#181c22'
  surface-container: '#1c2026'
  surface-container-high: '#262a31'
  surface-container-highest: '#31353c'
  on-surface: '#dfe2eb'
  on-surface-variant: '#e2bfb0'
  inverse-surface: '#dfe2eb'
  inverse-on-surface: '#2d3137'
  outline: '#a98a7d'
  outline-variant: '#5a4136'
  surface-tint: '#ffb693'
  primary: '#ffb693'
  on-primary: '#561f00'
  primary-container: '#ff6b00'
  on-primary-container: '#572000'
  inverse-primary: '#a04100'
  secondary: '#c2c7d0'
  on-secondary: '#2c3138'
  secondary-container: '#42474f'
  on-secondary-container: '#b1b5bf'
  tertiary: '#ecbda2'
  on-tertiary: '#462917'
  tertiary-container: '#ba9078'
  on-tertiary-container: '#472a18'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdbcc'
  primary-fixed-dim: '#ffb693'
  on-primary-fixed: '#351000'
  on-primary-fixed-variant: '#7a3000'
  secondary-fixed: '#dee2ec'
  secondary-fixed-dim: '#c2c7d0'
  on-secondary-fixed: '#171c23'
  on-secondary-fixed-variant: '#42474f'
  tertiary-fixed: '#ffdbc8'
  tertiary-fixed-dim: '#ecbda2'
  on-tertiary-fixed: '#2e1505'
  on-tertiary-fixed-variant: '#603f2b'
  background: '#10141a'
  on-background: '#dfe2eb'
  surface-variant: '#31353c'
typography:
  display-lg:
    fontFamily: Epilogue
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Epilogue
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-md:
    fontFamily: Epilogue
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-sm:
    fontFamily: Epilogue
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.05em
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.1em
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.08em
  headline-lg-mobile:
    fontFamily: Epilogue
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-margin: 20px
  gutter: 16px
  section-padding: 32px
  card-padding: 20px
---

## Brand & Style
The design system embodies the "Digital Sommelier" persona: a sophisticated, precise, and luxurious companion for high-end nightlife and hospitality. The aesthetic targets an elite audience that values exclusivity and seamless technological integration.

The visual style is a fusion of **Glassmorphism** and **Ultra-Premium Dark Mode**. It utilizes deep, charcoal-navy backgrounds to create an "Obsidian" depth, contrasted by "Ember" orange accents that evoke warmth and energy. The interface prioritizes tactile surfaces with high-radius corners, subtle border glows, and translucent layers that create a multi-dimensional environment reminiscent of a dimly lit, high-end lounge.

## Colors
The palette is anchored in deep, atmospheric tones to maintain a premium "nighttime" feel while ensuring high-impact visibility for interactive elements.

- **Primary (Ember):** #FF6B00. Used for call-to-action buttons, active states, and critical highlights. It represents heat, energy, and the "pour."
- **Secondary (Obsidian Surface):** #1A1F26. Used for cards, containers, and secondary buttons. It provides a softer contrast against the background.
- **Tertiary (Champagne Gold):** #E2B49A. A muted, sophisticated metal tone used for small accents, descriptive icons, and secondary headings to soften the orange.
- **Neutral (Deep Space):** #0D1117. The primary background color, providing a solid foundation for glassmorphic layers.
- **Glass/Stroke:** Semi-transparent white (10-15% opacity) for subtle border glows and surface dividers.

## Typography
The typographic system balances the bold, editorial presence of **Epilogue** for headlines with the technical precision and legibility of **Manrope** for body and UI elements.

- **Headlines:** Epilogue is used for branding, page titles, and section headers. High-level headers (H1, H2) often utilize uppercase styling and tight tracking to command attention.
- **Body & Controls:** Manrope provides a clean, modern readability for menu descriptions, account details, and labels.
- **Labels:** Use Manrope with increased letter-spacing and uppercase styling for a "curated" look, particularly for metadata like table numbers or status indicators.

## Layout & Spacing
The layout follows a **fluid-to-fixed model** optimized for mobile-first interactions. It relies on a consistent 8px spatial grid to ensure mathematical harmony between elements.

- **Margins:** A standard 20px margin is applied to the left and right of the screen to keep content centered and premium.
- **Gaps:** Use 16px (2x base) for vertical spacing between standard list items and 24px-32px for spacing between distinct functional sections.
- **Safe Areas:** Bottom navigation is anchored with a fixed height and an internal backdrop blur, ensuring the content reflows behind it gracefully.
- **Density:** High-density lists (like the drink menu) use horizontal card layouts to maximize vertical scanability while maintaining large touch targets for buttons.

## Elevation & Depth
Depth is created through "Obsidian Stacking" rather than traditional drop shadows.

- **Base Layer:** The deepest background (#0D1117).
- **Surface Layer:** Secondary containers (#1A1F26) with a subtle 1px border at 10% white opacity.
- **Glassmorphic Layer:** Overlays (Modals, Bottom Nav) use a semi-transparent surface with a 16px to 32px backdrop-blur and a light top-edge highlight to simulate light catching the edge of a glass pane.
- **Accent Glow:** Primary interactive elements (active buttons, QR scanner frame) utilize an external glow (Shadow) with the primary color (#FF6B00) at 20-30% opacity to suggest radiant heat.

## Shapes
The shape language is defined by a "High-Roundness" philosophy (ROUND_FOUR in local terms), creating a soft, approachable feel within a dark, industrial environment.

- **Cards & Primary Containers:** 1rem (16px) corner radius.
- **Buttons & Input Fields:** 0.75rem (12px) to 1rem (16px) radius, maintaining consistency with cards.
- **Chips & Tags:** Fully pill-shaped (rounded-full) for category selectors and filter chips.
- **Media:** Thumbnails within lists should share the 12px corner radius of their parent containers for a nested, harmonious look.

## Components
Consistent application of styles across the following core elements:

- **Buttons:**
    - *Primary:* Ember gradient or solid fill with white/dark text. High-radius.
    - *Secondary:* Ghost style with subtle 1px border and Manrope Medium text.
- **Cards:** High-radius (#1A1F26) background. Interactive cards should have a subtle brightness increase on hover/tap.
- **Bottom Navigation:** A persistent, glassmorphic bar with four icons: **Lounge** (Drinks), **Scanner** (QR), **Orders** (Bill), and **Account**. Active icons use the Ember color and a subtle bottom-glow.
- **QR Scanner:** A signature component. Central square frame with high-contrast Ember corner brackets and a blurred peripheral mask.
- **Input Fields:** Deep Obsidian fill, Manrope text, with the Ember accent color appearing on the border or cursor during the focus state.
- **Chips:** Selected chips use the Ember orange with high-contrast text; unselected chips use the secondary surface color.