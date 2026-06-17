# Handoff: LANDOR Design System (Internal Tool)

## Overview
This is the foundational design system for the **Talent Directory** internal tool — the
colour, typography, iconography and core interface components that every screen is built
from. Implementing this system as reusable tokens + components is the first step before
building any feature screens.

## About the Design Files
The file in this bundle (`LANDOR Design System.dc.html`) is a **design reference created
in HTML** — a living spec showing the intended look and behaviour of the system, not
production code to copy directly. Your task is to **recreate these foundations in the
target codebase's existing environment** (React + CSS/Tailwind/CSS-Modules, Vue, etc.)
using its established patterns. If no front-end exists yet, choose the most appropriate
framework and implement the tokens as CSS custom properties (or a theme file) and the
components as reusable primitives.

Recommended structure once recreated:
- `tokens.css` (or `theme.ts`) — colours, type scale, radii, spacing
- `components/` — `Button`, `Tag`, `Avatar`, `AvatarStack`, `Input`, `Select`, `Icon`
- A `<Icon name="…" />` component backed by a single sprite or per-icon SVG set

## Fidelity
**High-fidelity (hifi).** Final colours, typography, spacing and interaction states.
Recreate pixel-accurately using the codebase's libraries. Exact values are below.

---

## Design Tokens

### Colours
| Token | Hex | RGB | Role |
|---|---|---|---|
| Ultramarine | `#0E1ADF` | 14 · 26 · 223 | **Primary** brand / labels / accents (RAL 5002, PMS 072 C) |
| Volt | `#ECFD01` | 236 · 253 · 1 | High-energy **accent**, used sparingly for emphasis (PMS 395 C) |
| Shore | `#DBD1C8` | 219 · 209 · 200 | Warm **neutral** surface |
| Signal Black | `#000000` | 0 · 0 · 0 | Text, outlines (RAL 9004, PMS 419 C) |
| Signal White | `#FFFFFF` | 255 · 255 · 255 | Surfaces (RAL 9003) |

**Interaction blues** (derived from Ultramarine, used by primary buttons & interactive states):
| State | Hex |
|---|---|
| Default | `#0027D7` |
| Hover | `#0E1ADF` |
| Pressed | `#081086` |
| Disabled | `#DCDCDC` |

**Supporting greys / surfaces:**
| Use | Hex |
|---|---|
| Page background | `#ECEAEE` |
| Section header band (lavender) | `#E6E0E9` |
| Field fill (soft grey) | `#E8E6EA` |
| Hairline / card border | `#ECEAEE` / `#E0DEE3` |
| List hover row | `#F4F3F5` |
| Muted text | `#898989` |
| Secondary text | `#606161` |

### Typography
Brand face: **Landor Sans Beta** (custom — licensed font files required). UI/body in the
original system also uses **Aptos**. In this reference both fall back to **Archivo**
(Google Fonts) as a close grotesque. In the real codebase, register the licensed
`Landor Sans` `@font-face` and keep Archivo as the fallback.

Specs read **size / line-height · letter-spacing**:

| Style | Size/LH · Tracking | Weight | Transform |
|---|---|---|---|
| Display Large | 64 / 64 · −0.02em | 800 | uppercase |
| Display Medium | 32 / 35 · 0 | 800 | uppercase |
| Display Small | 24 / 24 · 0 | 800 | uppercase |
| Headline Large | 32 / 32 · 0 | 700 | none |
| Headline Medium | 28 / 31 · 0 | 700 | none |
| Headline Small | 20 / 20 · 0 | 700 | none |
| Body Large | 16 / 20 · +0.1px | 400 | none |
| Body Medium | 14 / 14 · +0.1px | 400 | none |
| Body Small | 12 / 17 · +0.1px | 400 | none |
| Label Large | 14 / 14 · +0.04em | 600 | uppercase |
| Label Small | 12 / 12 · +0.04em | 600 | uppercase |
| Button Large | 20 / 19.7 · +0.02em | 600 | uppercase |
| Button Small | 12 / 11.8 · +0.02em | 600 | uppercase |

Section titles (e.g. "ICONS", "BUTTONS") use **Display, weight 800, uppercase** at ~88px.

### Radii
| Use | Value |
|---|---|
| Pills (buttons, tags) | `1000px` (fully rounded) |
| Cards / section frames | `40px 40px 16px 16px` (large rounded top, small bottom — the signature frame) |
| Colour swatch cards | `20px` |
| Icon tiles | `12–14px` |
| Inputs / dropdowns | `6–8px` |

### Spacing
8px-based. Common values: card padding `56px`; section header band padding `52px 56px`;
field padding `15–16px 18px`; button padding by size (see Buttons).

---

## Components

### Icon
- 24×24 viewBox, **1.5px stroke**, `stroke="currentColor"`, `fill="none"`,
  `stroke-linecap="round"`, `stroke-linejoin="round"` (the `star`/`asterisk` glyphs are filled).
- Ships at **12px (Small)**, **16px (Large)**, **24px (XL)**.
- Set: `chevron`, `arrow`, `back`, `link`, `edit`, `settings`, `grid`, `plus`, `trash`,
  `close`, `info`, `download`, `menu`, `search`, `sort`, `star`.
- Implement as `<Icon name="…" size={16} />`. The exact SVG path data for every icon lives
  in `LANDOR Design System.dc.html` (search the Icons section) — copy paths verbatim.

### Button
Fully-rounded pill, uppercase label, weight 600, optional trailing `arrow` icon.
Three **types** × three **sizes** × four **states**.

**Sizes** (padding · font-size · gap · icon):
| Size | Padding | Font | Gap | Icon |
|---|---|---|---|---|
| Small | `9px 16px` | 12px | 8px | 12px |
| Medium | `12px 20px` | 14px | 9px | 14px |
| Large | `16px 26px` | 16px | 11px | 18px |

**Types:**
- **Primary** — filled `#0027D7`, white text. Hover `#0E1ADF`, Pressed `#081086`,
  Disabled `#DCDCDC`.
- **Secondary** — white fill, `1.5px solid #000` border, black text. Hover inverts to
  black fill / white text.
- **Tertiary** — text only, 2px transparent bottom-border; hover sets text + border to
  Ultramarine `#0E1ADF`.

### Tag — Role pill
- **Filled**: `#2E2E2E` bg, white text, leading filled star/asterisk glyph. Small
  (`7px 14px`, 13px) and Large (`10px 20px`, 18px uppercase 700).
- **Outline/removable**: no fill, black text, leading star glyph, trailing `close` icon
  to remove. Same two sizes.

### Avatar & Avatar Stack
- **Avatar**: circle, sizes 26 / 32 / 36px. Initials fallback when no image; bg pulls from
  the brand palette (`#0E1ADF`, `#DBD1C8`, `#C9B8E0`, `#232323`). Real headshots replace
  initials in production.
- **Stack**: overlapping avatars (`margin-left: -8px to -10px`, `2px solid #fff` ring) with
  a trailing `+N` count. Optional pill-wrapped variant on a translucent white blurred
  background.
- **List row**: avatar (32px) + label, 14–16px gap.

### Input fields
Every field = **blue uppercase Label** (Label Large) + black short-description (Body Large)
+ the control. Required fields append `*`; multi-selects show `(N selected)`.
- **Text area** — white fill, `1px solid #232323`, radius 6px, placeholder `#898989`.
- **Dropdown (filled)** — soft-grey fill `#E8E6EA`, radius 8px, trailing `chevron`.
- **Dropdown (selected)** — white fill, `1px solid #232323`.
- **Searchable select (open)** — grey search header (chevron flips up) joined to a white
  results panel; rows 13px×18px; hovered/active row `#F4F3F5`; category headers bold; a
  pinned "Add this new entry +" action row in Ultramarine.
- **Tag multi-select** — selected values render as removable text tags (label + `close`),
  with a grey "Select another…" field below.

---

## Interactions & Behavior
- **Buttons**: 150ms ease background/colour transitions. Primary cycles Default → Hover →
  Pressed via the interaction blues; Secondary inverts; Tertiary reveals the Ultramarine
  underline + text colour on hover.
- **Dropdowns**: chevron points down when closed, up when open; results panel attaches to
  the search header (shared rounded corners collapse where they meet).
- **Tags**: trailing `close` icon removes the tag.
- **Theme**: the reference exposes two tweakable tokens — `primary` and `accent` — applied
  as CSS custom properties `--ds-primary` / `--ds-accent`. Mirror these as your theme's
  primary/accent variables.

## Assets
- **Icons**: inline SVG, drawn to spec (no external files). Path data is in the HTML.
- **Avatars**: initials placeholders only — supply real headshots in production.
- **Fonts**: Landor Sans Beta is a **licensed custom font not included here**. Obtain the
  files, register `@font-face`, keep Archivo (Google Fonts) as fallback.

## Files
- `tokens.css` — copy-paste CSS custom properties for every token above (colours, type
  scale, radii, spacing, motion) plus a few optional utility classes. Import once at app
  root: `@import "./tokens.css";`
- `LANDOR Design System.dc.html` — the full living spec (Colours, Type, Icons, Buttons,
  Inputs, Tags). Open it in a browser to see every component and state; it is the source
  of truth for exact SVG paths and inline values.

---

## Implemented Components (codebase additions)

The following components have been built and shipped in `components.css`. They extend the
original handoff spec and are the production-ready equivalents of the conceptual descriptions
above.

---

### `.btn-primary` — DS Primary Button (Medium)

Filled Ultramarine pill. Use for the primary call-to-action on any toolbar or form.

```css
/* Medium (default) — padding 12px 20px, 14px font */
.btn-primary { … }
.btn-primary:hover   { background: var(--ds-interactive-hover);    }
.btn-primary:active  { background: var(--ds-interactive-pressed);  }
.btn-primary:disabled{ background: var(--ds-interactive-disabled); cursor: not-allowed; }
```

| Variant | Padding | Font | Token |
|---|---|---|---|
| Medium (default) | `12px 20px` | 14px | `--ds-interactive-default` (`#0027D7`) |
| Hover | — | — | `--ds-interactive-hover` (`#0E1ADF`) |
| Pressed | — | — | `--ds-interactive-pressed` (`#081086`) |
| Disabled | — | — | `--ds-interactive-disabled` (`#DCDCDC`) |

Usage:
```html
<button class="btn-primary">Add new project</button>
```

---

### `.btn-secondary` — DS Secondary Button (Medium)

White pill with 1.5px black border. Inverts to black/white on hover. Use for secondary
actions alongside a primary button.

```css
.btn-secondary { border: 1.5px solid #000; background: #fff; color: #000; … }
.btn-secondary:hover  { background: #000; color: #fff; }
.btn-secondary:active { background: #232323; color: #fff; }
```

Usage:
```html
<button class="btn-secondary">Most recent</button>
```

---

### Toolbar pattern

Toolbars appear at the top of list/grid views. The count is left-aligned; action buttons
are always pinned to the right using `justify-content: space-between`.

```html
<div class="proj-toolbar">
  <span class="proj-count">436 projects</span>
  <div class="proj-toolbar-actions">
    <button class="btn-secondary">Most recent …</button>
    <button class="btn-primary">Add new project …</button>
  </div>
</div>
```

Key CSS rules (defined inline per view; candidates for promotion to `components.css`):
```css
.proj-toolbar         { display:flex; align-items:center; justify-content:space-between; gap:12px; }
.proj-toolbar-actions { display:flex; align-items:center; gap:12px; flex-shrink:0; }
```

---

### `.project-card` — Project Card

Image-backed card with a frosted people-pill in the top-right corner and a gradient
info panel at the bottom. Lives inside a 2-column responsive grid.

**Structure:**
```html
<div class="project-card" style="height:480px;">
  <div class="project-card-bg project-card-bg-cover">
    <img src="…" alt="Project cover" />
  </div>
  <div class="project-card-top">
    <!-- optional year label or tag pill top-left -->
    <div class="people-tag">
      <div class="people-avatars">
        <img src="avatar.jpg" />
      </div>
      <span class="people-count">3 people</span>
    </div>
  </div>
  <div class="project-info">
    <div class="project-title-block">
      <div class="project-title">Project Name</div>
      <div class="project-meta">
        <span>INDUSTRY</span><span class="dot-white"></span><span>2024</span>
      </div>
    </div>
    <div class="project-details">
      <div class="project-detail-row">
        <span class="label">MARKET</span>
        <span class="value">Global</span>
      </div>
      <div class="project-detail-row">
        <span class="label">SKILLSET</span>
        <span class="value">Brand Strategy, Design</span>
      </div>
    </div>
  </div>
</div>
```

**Sub-elements:**

| Class | Role |
|---|---|
| `.project-card-bg` | Absolutely-positioned image container |
| `.project-card-bg-cover` | Modifier — `object-fit: cover`, fills full card |
| `.project-card-top` | Top zone: people-pill + optional label, `z-index: 1` |
| `.people-tag` | Frosted pill (`--ds-frosted` + `backdrop-filter: blur(2px)`) |
| `.people-avatars` | Overlapping avatars stack, `−4px` margin between |
| `.people-count` | 12px label beside avatars |
| `.project-info` | Bottom info panel with gradient background |
| `.project-title` | 28px / 31px white title |
| `.project-meta` | 14px uppercase meta row with `.dot-white` separators |
| `.project-detail-row` | Key/value row: `.label` (uppercase) + `.value` (right-aligned) |

---

### `.client-card` — Client Card

Full-bleed image card with a gradient info panel at the bottom. Used in a 3-column
responsive grid (`client-grid`).

**Structure:**
```html
<div class="client-card">
  <img src="client-cover.jpg" alt="Client name" />
  <div class="client-card-info">
    <div class="client-card-name">Nike</div>
    <div class="client-card-meta">
      <span>13 projects</span>
      <span class="dot"></span>
      <span>FASHION</span>
      <span class="dot"></span>
      <span>Since 2024</span>
    </div>
  </div>
</div>
```

**Sub-elements:**

| Class | Role |
|---|---|
| `.client-card` | Card root — `position: relative`, `height: 336px`, `border-radius: var(--ds-radius-card)` |
| `.client-card > img` | Absolutely-positioned cover image, `inset: 0`, `object-fit: cover` |
| `.client-card-info` | Gradient info panel — `rgba(0,0,0,0) → rgba(0,0,0,0.92)`, `padding: 24px` |
| `.client-card-name` | 28px / 31px white client name |
| `.client-card-meta` | 14px uppercase meta row with `.dot` separators |

Hover state: card lifts `translateY(-2px)` with deeper shadow.

---

### `.client-grid` — Client Grid Layout

3-column responsive grid for client cards.

```css
.client-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
@media (max-width: 1100px) { .client-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 700px)  { .client-grid { grid-template-columns: 1fr; } .client-card { height: 260px; } }
```

Usage:
```html
<div class="client-grid">
  <div class="client-card">…</div>
  <div class="client-card">…</div>
  <!-- … -->
</div>
```

---

### `.dot` / `.dot-white` — Inline Dot Separator

Small 4×4px circular separators used in meta rows inside cards.

```css
.dot       { width:4px; height:4px; border-radius:50%; background:currentColor; flex-shrink:0; }
.dot-white { width:4px; height:4px; border-radius:50%; background:#fff; flex-shrink:0; }
```

Use `.dot` on white backgrounds (inherits text colour) and `.dot-white` on dark/image
backgrounds.

---

## Architecture Notes

### SPA View Switching

`index.html` is a single-page application. All views (`#viewHome`, `#viewTalents`,
`#viewProjects`, `#viewClients`) share the same shell and are toggled with the
`showView(name)` helper:

```js
function showView(name) {
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  document.getElementById('view' + name[0].toUpperCase() + name.slice(1))
          .classList.add('active');
  // update nav-item active state & slide indicator
}
```

Views use `.view { display: none; }` / `.view.active { display: block; }` (or flex/grid
as appropriate for the view).

### Supabase Integration

Live data is fetched from Supabase REST on page load. Pattern:

```js
const SB_URL = 'https://<project>.supabase.co';
const SB_KEY = '<anon-publishable-key>';

async function loadData() {
  const res = await fetch(`${SB_URL}/rest/v1/talents?select=*,studios(name)&order=full_name.asc`, {
    headers: { apikey: SB_KEY, Authorization: `Bearer ${SB_KEY}` }
  });
  const data = await res.json();
  // render data into DOM
}
```

RLS policy required: `CREATE POLICY "Public can read talents" ON talents FOR SELECT USING (true);`
The `anon` role needs `USAGE` on the schema and `SELECT` on the table granted before the
policy applies. Do **not** create a policy that queries the same table from within its own
USING clause — this causes infinite recursion (`42P17`).

### CSS Import Order

Always import in this order at the top of every page:

```html
<link rel="stylesheet" href="tokens.css" />
<link rel="stylesheet" href="components.css" />
<!-- page-specific inline styles or a page.css last -->
```
