---
name: FocusLock
colors:
  surface: '#121316'
  surface-dim: '#121316'
  surface-bright: '#38393c'
  surface-container-lowest: '#0d0e11'
  surface-container-low: '#1b1b1f'
  surface-container: '#1f1f23'
  surface-container-high: '#292a2d'
  surface-container-highest: '#343538'
  on-surface: '#e3e2e6'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#e3e2e6'
  inverse-on-surface: '#2f3034'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#45dfa4'
  on-secondary: '#003825'
  secondary-container: '#00bd85'
  on-secondary-container: '#00452e'
  tertiary: '#ffb95f'
  on-tertiary: '#472a00'
  tertiary-container: '#e29100'
  on-tertiary-container: '#523200'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#68fcbf'
  secondary-fixed-dim: '#45dfa4'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#005137'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#121316'
  on-background: '#e3e2e6'
  surface-variant: '#343538'
typography:
  display-hero:
    fontFamily: Inter
    fontSize: 72px
    fontWeight: '600'
    lineHeight: 80px
    letterSpacing: -0.04em
  display-hero-mobile:
    fontFamily: Inter
    fontSize: 56px
    fontWeight: '600'
    lineHeight: 64px
    letterSpacing: -0.03em
  display-timer:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '500'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-timer-mobile:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '500'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: 0em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.01em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.03em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  space-xxs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
  space-2xl: 2rem
  space-3xl: 2.5rem
  space-4xl: 3rem
  margin-mobile: 1rem
  margin-tablet: 1.5rem
  touch-target-min: 3rem
---

## Brand & Style

This design system embodies a calm, hyper-focused, and intentional utility for digital wellbeing on modern Android hardware. The aesthetic fuses Material 3 tonal elevation with a dark, distraction-free atmosphere tailored for deep work sessions, late-night study, and sustained attention.

### Personality & Principles
- **Monastic Clarity:** Eliminate extraneous chrome, decorative illustrations, and visual noise. The interface prioritizes essential data—countdown timers, lock statuses, and core action targets.
- **Glanceable Ergonomics:** Engineered for ambient desk viewing from two to three feet away, utilizing hyper-legible, high-contrast numerals alongside one-handed touch zones optimized for modern thumb-reach envelopes.
- **Disciplined Restraint:** Color is applied strictly for state feedback (focus active, warnings, break periods, destructive confirmations). Default states remain submerged in deep, calming dark-neutral tones.

### Style Archetype
- **Material 3 Minimalist (Dark-First):** Relies on tonal layering, precise structural hierarchy, soft 1px surface borders, and generous breathing room rather than heavy skeuomorphism or harsh contrast jumps.

## Colors

The color system is constructed around a dark-first foundation to reduce eye fatigue and limit OLED display energy consumption during extended desk sessions.

### Functional Palette
- **Base Canvas (`#121316`):** The primary root background for full-screen focus sessions and navigation scafolds.
- **Surface Dim (`#1A1B20`):** Recessed containers, background scrims, and sheet backdrops.
- **Surface Container (`#22242B`):** Default card surfaces, settings containers, and module backgrounds.
- **Surface Container High (`#2C2F38`):** Elevated components, interactive modal dialogs, active bottom sheets, and pressed chip states.
- **Border Subtle (`#353844`):** Crisp 1px structural separation across containers without high-contrast friction.
- **Text Primary (`#F4F5F7`):** High-contrast neutral for active counters, headings, and primary labels.
- **Text Secondary (`#949AA8`):** Muted slate for metadata, session statistics, descriptions, and disabled hints.
- **Focus Emerald (`#10B981`, `#059669`, `#34D399`):** Represents focused states, completed intervals, circular progress tracks, and confirmation actions.
- **Warning Amber (`#F59E0B`):** Strict lock overrides, nearing break completions, and quota notifications.
- **Critical Coral (`#EF4444`):** Emergency quit triggers, strict-mode penalty notices, and app kill confirmations.

## Typography

Typography relies on `Inter` for its crisp neo-grotesque structural rhythm, tall x-height, and neutral precision.

### Typographic Roles
- **Display Hero & Timer:** Rendered with tabular figures (`font-variant-numeric: tabular-nums`) to prevent horizontal jitter during active countdown updates. These styles provide instant recognition during glanceable desk positioning.
- **Headlines:** Clean geometric headers that ground settings groups, analytical recaps, and deep-focus configuration drawers.
- **Body & Captions:** Tuned with balanced line heights to present friction logs, quota summaries, and session descriptions with minimal visual density.
- **Labels & Micro-data:** Uppercase or semi-bold micro-labels are deployed sparingly for badge counts, strict-mode warnings, and pill selectors.

## Layout & Spacing

The layout embraces an ergonomic, bottom-weighted hierarchy suited for one-handed thumb interaction on mobile devices, translating cleanly to anchored split panels on larger foldable screens and tablets.

### Layout Mechanics
- **Grid Architecture:** 4-column fluid layout on mobile viewports (< 600dp) with a fixed 16px lateral margin and 12px gutters. Expands to an 8-column layout on tablets and unfolded foldables with centered 480dp max-width focus viewports.
- **Vertical Hierarchy:** The primary timer or focus circle occupies the visual upper half, while controls, app selector pills, and session triggers live inside the lower 45% screen boundary for effortless thumb access.
- **Touch Targets:** All interactive components (switches, buttons, navigation items) maintain an unambiguous 48px minimum touch envelope (`touch-target-min`).

## Elevation & Depth

This design system avoids heavy drop shadows, relying primarily on Material 3 tonal surface layering, subtle borders, and soft directional ambient glows.

### Tonal Hierarchy
- **Level 0 (Base Canvas):** `#121316` — Full-bleed screen canvas.
- **Level 1 (Card & Module Layer):** `#22242B` with a continuous `1px solid #353844` border. No drop shadow.
- **Level 2 (Active Floating Controls & Floating Sheets):** `#2C2F38` paired with an ambient shadow: `0 8px 24px -4px rgba(0, 0, 0, 0.45)` and a subtle highlight border: `1px solid rgba(255, 255, 255, 0.08)`.
- **Level 3 (Focused State Accentuation):** When active, primary focus indicators and running timers project a soft emerald ambient aura: `0 0 32px rgba(16, 185, 129, 0.15)`.

## Shapes

Shapes leverage a balanced Material 3 geometry that transitions smoothly from generous card corners to full pills.

### Geometry Specifications
- **Standard Surfaces (`rounded-2xl` / 16px):** Main configuration blocks, stats summaries, and app listing rows.
- **Floating Controls & Action Buttons (Pill / 9999px):** All primary CTA triggers ("Start Focus", "Pause Session", "Break Now"), chip tags, and bottom nav indicators.
- **Inner Elements (`rounded-lg` / 8px):** Checkbox boxes, progress fill capsules, and secondary numerical steppers.

## Components

### Buttons
- **Primary Focus Button:** Fully pill-shaped (`border-radius: 9999px`), 56px height. Filled with Focus Emerald (`#10B981`) text in `#121316` (heavy weight). On pressed state: scales down to `0.98` with `#059669`.
- **Secondary / Ghost Button:** Fully pill-shaped, 48px or 56px height. Background `#22242B`, border `1px solid #353844`, text `#F4F5F7`.
- **Destructive Pill:** Pill-shaped, semi-transparent coral tint (`rgba(239, 68, 68, 0.15)`), text `#EF4444`, border `1px solid rgba(239, 68, 68, 0.3)`.

### Chips & App Tags
- **Filter & Preset Chips:** 36px height, pill-shaped. Unselected: background `#22242B`, text `#949AA8`, border `1px solid #353844`. Selected: background `rgba(16, 185, 129, 0.16)`, border `1px solid #10B981`, text `#34D399`.

### App-Blocking List Row
- **Container:** Height 64px, background transparent or nested `#22242B`, padding `0 16px`, corner radius `16px`.
- **Left Slot:** App icon placeholder (40px squircle, radius 10px) with fallback monogram.
- **Center:** App title (`body-lg`, `#F4F5F7`) stacked over lock condition / usage budget (`body-sm`, `#949AA8`).
- **Right Slot:** Material 3 switch toggle or padlock status icon.

### Switches & Checkboxes
- **Material 3 Switch:** 52px width, 32px height track. Inactive track: `#2C2F38` with `#949AA8` thumb (16px). Active track: `#10B981` with `#121316` thumb (24px). Smooth physical sliding translation.
- **Checkboxes:** 20px rounded rectangle (corner radius 4px). Inactive: `#353844` border. Active: `#10B981` fill with crisp white check mark.

### Bottom Navigation Bar
- **Bar Structure:** Height 80px, background `#1A1B20`, border-top `1px solid #353844`.
- **Item Treatment:** Centered icon with an animated pill indicator behind the selected state (`rgba(16, 185, 129, 0.18)`), accompanied by `label-sm` text in `#34D399`. Inactive items display in `#949AA8`.

### Circular Timer Display
- **Radial Indicator:** 280px diameter circle on mobile. Background track: 8px stroke in `#22242B`. Foreground progress track: 8px stroke with rounded caps in `#10B981`. Center holds the `display-hero-mobile` remaining time and active mode chip ("Strict Lock", "Deep Study").