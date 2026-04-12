# Design System: The Nocturnal Curated Experience

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Sommelier."** 

Unlike generic apps that rely on rigid grids and harsh dividers, this system mimics the atmosphere of a high-end lounge: dim lighting, layered textures, and moments of brilliant clarity. We break the "template" look by utilizing **intentional asymmetry**—such as off-center typography and overlapping image containers—to create an editorial feel. The experience should feel less like a utility and more like a leather-bound menu presented in a dimly lit room.

## 2. Color Philosophy
The palette is rooted in the depth of midnight, using a hierarchy of dark tones to create a sense of infinite space.

### The Foundation
*   **Background (`#0f131c`):** The canvas. A rich, deep navy that provides more soul than flat black.
*   **Primary (`#ffb693` / `#ff6b00`):** The "Electric Glow." Use this for high-energy interaction points.
*   **Secondary (`#e9c349`):** The "Vintage Gold." Reserved for premium status, loyalty tiers, and signature cocktails.
*   **Tertiary (`#00daf8`):** The "Neon Pulse." Used sparingly for interactive highlights or live status updates (e.g., "Table Ready").

### The "No-Line" Rule
Traditional 1px borders are strictly prohibited for sectioning. Structural definition must be achieved through **Background Color Shifts**. For example, a card should not have an outline; instead, place a `surface-container-high` card atop a `surface` background. The transition of tone creates the boundary.

### Signature Textures & Gradients
To avoid a "flat" digital feel, main CTAs and Hero sections must utilize a **Linear Polish**: a subtle gradient from `primary` (#ffb693) to `primary-container` (#ff6b00) at a 135-degree angle. This mimics the way light hits a glass of amber liquid.

---

## 3. Typography
We utilize a high-contrast pairing to balance "The Digital Sommelier" editorial look with functional legibility.

*   **Display & Headlines (Epilogue):** An authoritative, wide-set sans-serif. Use `display-lg` for drink names or "Master" branding. The intentional width of Epilogue conveys luxury and "breathing room."
*   **Body & Titles (Manrope):** A modern, geometric sans-serif that maintains high legibility in low-light environments. 
*   **Hierarchy Note:** Use `title-lg` for pricing. Pricing is a key decision factor; it should be clean, prominent, and never obstructed by decorative elements.

---

## 4. Elevation & Depth: The Layering Principle
We move away from Material shadows toward **Tonal Layering** and **Glassmorphism**.

### Stacking Hierarchy
Depth is achieved by nesting surface tokens:
1.  **Base:** `surface` (#0f131c)
2.  **Sectioning:** `surface-container-low` (#181b25)
3.  **Interactive Cards:** `surface-container-high` (#262a34)
4.  **Overlays/Modals:** `surface-bright` (#353943) with a 20px Backdrop Blur.

### Ambient Shadows
Floating elements (like a FAB or a mobile navigation bar) must use "Ambient Shadows":
*   **Shadow Color:** A tinted version of `surface-container-highest` at 40% opacity.
*   **Blur:** 30px–40px to create a soft, natural glow rather than a harsh drop-shadow.

### The "Ghost Border" Fallback
If accessibility requires a container boundary, use the `outline-variant` token at **15% opacity**. This creates a "whisper" of a line that defines the shape without breaking the moody atmosphere.

---

## 5. Components

### Buttons: The Tactile Touch
*   **Primary:** A "Glow" state using the Primary Gradient. Use `xl` (0.75rem) roundedness for a modern, approachable feel.
*   **Secondary (Soft Neomorphism):** Use `surface-container-high` as the base with a subtle top-left highlight (`outline-variant` at 10%) and a bottom-right shadow. It should feel like a physical button integrated into the lounge's upholstery.

### Cards: The Editorial Container
*   **Rule:** Forbid all divider lines.
*   **Styling:** Use `surface-container-low` with a generous `padding: 1.5rem`. Use `xl` corner radius. For premium items, overlay a subtle Glassmorphism layer (20% opacity `surface-bright` + 16px blur) to make the item "float."

### Inputs & Selection
*   **Input Fields:** Use `surface-container-lowest` as the fill. The label should use `label-md` in `on-surface-variant`. On focus, the border doesn't just change color—it glows using a 2px outer shadow of the `tertiary` (#00daf8) color.
*   **Chips:** Used for drink categories (e.g., "Smoky," "Botanical"). Use `none` or `sm` roundedness for a more "Brutalist-Luxury" sharp-edged look.

### Specialist Component: The "Spirit Level" Progress Bar
For loyalty or drink-making status, use a custom progress bar using `secondary` (Gold). The "unfilled" portion should be `surface-container-highest` with a slight inner shadow to look like an empty glass.

---

## 6. Do's and Don'ts

### Do:
*   **Do** use asymmetrical margins (e.g., a headline indented further than the body) to create an editorial, high-end magazine feel.
*   **Do** use `surface-tint` overlays on images to ensure the "Dark Mode Default" vibe is maintained even with bright photography.
*   **Do** prioritize "Negative Space." If a screen feels crowded, remove a container rather than shrinking the text.

### Don't:
*   **Don't** use pure white (#FFFFFF) for text. Always use `on-surface` (#dfe2ef) to reduce eye strain in dark environments.
*   **Don't** use standard Material dividers. If you need to separate content, use a `24px` vertical spacing gap or a tonal shift.
*   **Don't** use high-vibrancy "Error Red." Use the refined `error` token (#ffb4ab) which is desaturated to fit the moody aesthetic.

### Accessibility Note:
While the atmosphere is moody, all interactive text must pass AA contrast ratios against their respective `surface-container` tokens. Use the `on-primary-fixed-variant` for text over accent colors to ensure legibility.