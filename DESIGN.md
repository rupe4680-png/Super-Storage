---
name: Super Storage
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#bdc8d1'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#87929a'
  outline-variant: '#3e484f'
  surface-tint: '#7bd0ff'
  primary: '#8ed5ff'
  on-primary: '#00354a'
  primary-container: '#38bdf8'
  on-primary-container: '#004965'
  inverse-primary: '#00668a'
  secondary: '#b9c8de'
  on-secondary: '#233143'
  secondary-container: '#39485a'
  on-secondary-container: '#a7b6cc'
  tertiary: '#c2cde5'
  on-tertiary: '#263143'
  tertiary-container: '#a7b2c9'
  on-tertiary-container: '#394458'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c4e7ff'
  primary-fixed-dim: '#7bd0ff'
  on-primary-fixed: '#001e2c'
  on-primary-fixed-variant: '#004c69'
  secondary-fixed: '#d4e4fa'
  secondary-fixed-dim: '#b9c8de'
  on-secondary-fixed: '#0d1c2d'
  on-secondary-fixed-variant: '#39485a'
  tertiary-fixed: '#d8e3fb'
  tertiary-fixed-dim: '#bcc7de'
  on-tertiary-fixed: '#111c2d'
  on-tertiary-fixed-variant: '#3c475a'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  display:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 12px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 40px
---

## Brand & Style
The design system for this high-capacity storage solution is built upon a **Modern Corporate** aesthetic with a heavy emphasis on **Minimalism** and precision. The goal is to evoke a sense of limitless space, technological security, and effortless organization.

The UI utilizes a "Dark First" philosophy, creating a focused environment where content (files and media) stands out against deep, receding backgrounds. High-contrast accents are used sparingly but purposefully to drive action and indicate system status. The overall feel is premium, reliable, and high-performance, catering to users who manage large volumes of critical data.

## Colors
This design system uses a deep charcoal palette to provide a sense of depth and luxury.

- **Primary (#38BDF8):** An electric cyan used for primary actions, active states, and progress indicators. It represents energy and connectivity.
- **Neutral/Background (#0F172A):** The foundation of the UI. This deep slate provides better readability and less eye strain than pure black while maintaining a premium look.
- **Surface/Tertiary (#1E293B):** Used for cards, modals, and secondary containers to create a clear visual hierarchy against the background.
- **Secondary Text (#94A3B8):** A muted grey for metadata, labels, and secondary information to maintain focus on primary content.
- **Borders (#334155):** Subtle, low-contrast outlines used to define structure without adding visual noise.

## Typography
**Inter** is the exclusive typeface for this design system, chosen for its exceptional legibility in digital interfaces and its neutral, systematic character.

- **Scale:** Uses a tight typographic scale to maximize data density while maintaining clarity.
- **Weights:** Bold (700) is reserved for major headings and brand moments. Semi-bold (600) is used for component labels and titles. Regular (400) is the workhorse for all body and metadata.
- **Hierarchy:** Use `body-sm` for file metadata (size, date) and `label-md` in uppercase for section headers (e.g., "RECENT FILES") to create a disciplined, structured appearance.

## Layout & Spacing
The layout follows a **Fluid Grid** model with a base unit of 4px. This ensures all elements align to a consistent mathematical rhythm.

- **Mobile:** A 4-column layout with 20px side margins and 16px gutters.
- **Desktop/Tablet:** A 12-column layout with a max-width of 1440px.
- **Philosophy:** Use generous `lg` (24px) spacing between major sections (e.g., between the Storage Overview and the File List) but tight `sm` (8px) spacing between related items within a list or grid to emphasize their relationship.

## Elevation & Depth
In this dark-themed system, depth is communicated through **Tonal Layers** and **Low-Contrast Outlines** rather than heavy shadows.

- **Level 0 (Base):** The main background (#0F172A).
- **Level 1 (Surface):** Cards and list items (#1E293B). These should have a subtle 1px border (#334155) to define their edges against the dark background.
- **Level 2 (Overlays):** Modals and dropdown menus. These use a slightly lighter slate and a soft, diffused dark shadow (0px 10px 30px rgba(0,0,0,0.5)) to appear lifted.
- **Interaction:** On hover or press, elements should shift tonal value slightly or gain a 1px primary-colored glow to signify interactivity.

## Shapes
The design system employs a **Rounded** language to soften the technical nature of the application and make the interface feel approachable.

- **Primary Containers:** Cards, storage bars, and large buttons use a 16px (`rounded-lg`) radius.
- **Small Elements:** Chips, checkboxes, and small action buttons use a 8px (`rounded-md`) radius.
- **Icons:** Icons should be enclosed in circular or softly rounded square backgrounds when used as category indicators.

## Components
Consistent implementation of components is critical for the premium feel of the system.

- **Storage Progress Bar:** A thick, 12px height track using the `tertiary` color as the background and the `primary` cyan as the fill. Include a subtle glow effect on the primary fill.
- **Buttons:**
    - *Primary:* Solid cyan fill with navy text.
    - *Secondary:* Ghost style with 1px slate border and white text.
- **File Cards:** Use 16px rounding. For grid views, the icon/thumbnail is centered; for list views, the icon is on the left with a two-line text stack (Name / Metadata).
- **Icons:** Line-based, 24px grid, 2px stroke width. Use `primary` cyan for active navigation icons and `secondary` grey for inactive or file-type icons.
- **Input Fields:** Darker than the card surfaces (#0B1120), with a 1px border that turns `primary` on focus.
- **Chips:** Used for file tags (e.g., "Work," "Personal"). Small, low-profile backgrounds with semi-bold text.