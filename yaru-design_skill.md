
name: yaru-design
description: Recreate the visual design language of the Yaru Widgets / YaruTheme desktop application shown in the reference screenshot. Use when designing desktop settings, component galleries, control showcases, or application interfaces that should resemble this Yaru-inspired UI.
---

# Yaru Design Skill

## Purpose

Use this skill to reproduce the light, restrained, desktop-native interface shown in the Yaru Widgets reference screenshot. The interface is a component showcase inside a desktop application: a persistent left navigation rail, a title bar, a compact toolbar, category tabs, a spacious component preview area, and a bottom navigation bar.

Treat the screenshot as the visual reference. The values below are practical approximations inferred from the image, not official Yaru design-token specifications.

## Overall visual character

- Light theme with a white main canvas and pale-gray navigation surfaces.
- Flat, restrained, utility-first styling. Avoid gradients, glossy effects, strong shadows, glassmorphism, and oversized marketing-style typography.
- Thin neutral borders divide structural regions.
- Rounded outer application window and gently rounded selected-navigation backgrounds.
- Dark charcoal text and thin-line icons.
- Orange-red is the primary interaction/accent color.
- Green appears as an example component state, not as the global brand accent.
- Spacious layout with consistent alignment and comfortable click targets.
- Desktop-first composition. Preserve the distinction between app chrome, navigation, and the component demonstration canvas.

## Reference screenshot and proportions

The reference image is approximately 1300 × 1130 px. Its application window begins about 3% from the left and top edges, occupies nearly the full available height and width, and has a black background visible around it.

Approximate layout:
- Outer window: x=39, y=34, width=1235, height=1068 px.
- Left sidebar: about 417 px wide, or 34% of the application width.
- Main panel: remaining 66%.
- Sidebar and main panel are separated by a thin vertical gray divider.
- Main title bar: about 70 px tall.
- Main toolbar: about 66 px tall.
- Category tabs: about 72 px tall.
- Component preview occupies most of the remaining center.
- Bottom navigation: about 95 px tall, separated from the preview by a faint horizontal line.

Use these proportions as a starting point, not as rigid pixel requirements. At smaller viewport sizes, retain the hierarchy and use responsive behavior rather than forcing the exact screenshot dimensions.

## Color palette

Use the following approximate tokens:

| Token | Approximate value | Usage |
|---|---|---|
| `canvas` | `#FFFFFF` | Main content and preview surface |
| `sidebar` | `#F7F7F7` | Left navigation background |
| `surface-subtle` | `#EAEAEA` | Selected sidebar item and selected footer item |
| `surface-muted` | `#E7E7E7` | Disabled/filled examples and pale icon buttons |
| `text-primary` | `#303030` | Main labels and headings |
| `text-secondary` | `#666666` | Secondary labels and navigation icons |
| `text-disabled` | `#A6A6A6` | Disabled labels and icons |
| `border` | `#D6D6D6` | Main dividers and outlined controls |
| `border-subtle` | `#EEEEEE` | Low-emphasis separator lines |
| `accent` | `#E95420` | Active tab underline, selected text/icon, accent action |
| `success-example` | `#078A1D` | Green elevated-button demonstration |
| `soft-accent-bg` | `#F7E8E4` | Pale accent-tinted circular example |
| `window-control-bg` | `#E9E9E9` | Minimize, maximize, and close circles |
| `window-bg` | `#000000` | Screenshot's surrounding desktop/background only |

Do not apply black as the page background. Black is visible only outside the rounded app window in this screenshot. The application itself is light.

## Typography

- Use a clean humanist sans-serif similar to Ubuntu's interface typography. Prefer `Ubuntu` when available, with `Noto Sans`, `Segoe UI`, and generic sans-serif fallbacks.
- Text is regular-weight rather than bold-heavy.
- Main title-bar text is around 20–22 px in the reference.
- Sidebar labels are around 23–25 px.
- Toolbar and tab labels are around 20–22 px.
- Component samples are around 19–21 px.
- Footer labels are around 18–20 px.
- Use medium or semibold weight only for emphasis where needed. Avoid large bold headings.
- Maintain comfortable line-height and consistent baselines.
- Truncate long sidebar labels with an ellipsis instead of wrapping onto multiple lines.

Suggested CSS font stack:

```css
font-family: Ubuntu, "Noto Sans", "Segoe UI", sans-serif;
font-weight: 400;
```

## Application window and chrome

- Place the app inside a large rounded rectangle with approximately 16–18 px corner radii.
- Clip child regions to the rounded outer corners.
- The title bar spans the main content area, not the sidebar.
- Center the application title, `YaruTheme`, horizontally within the main panel.
- Put three circular window controls in the top-right corner: minimize, maximize/restore, and close.
- Each window control is a pale-gray circle around 36 px in diameter, with a small dark glyph centered inside.
- Use generous horizontal spacing between the controls.
- Do not give the title bar a heavy shadow. A thin divider beneath the title bar is sufficient.

## Left sidebar

### Structure

The sidebar is a full-height, pale-gray column on the left. It has:
1. A top header reading `Yaru Widgets`, centered horizontally.
2. A subtle divider or bottom edge below the header.
3. A vertically stacked list of component entries.
4. A selected row for `YaruTheme`.
5. A `Settings` entry near the bottom.

### Sizing and spacing

- Width: approximately one-third of the application window.
- Header height: around 68 px.
- Navigation row height: approximately 68–70 px.
- Horizontal item padding: around 44–48 px from the sidebar's left edge.
- Icon-to-label gap: around 20–24 px.
- Keep the row rhythm even and align all icons and labels to consistent columns.
- Allow labels to truncate when the sidebar is too narrow.

### Navigation entries

The screenshot lists these entries in order:
- YaruOptionButton
- YaruPageIndicator
- YaruPopupMenuButton
- YaruProgressIndicator
- YaruRadio
- YaruSearchField
- YaruSection
- YaruSelectableContai… (truncated)
- YaruSwitch
- YaruTabBar
- YaruTheme
- YaruTile
- YaruWindowControl
- Settings

Each entry has a small monochrome icon to its left. Use consistent icon stroke weight, optical size, and vertical alignment. Icons should be approximately 22–25 px and dark gray.

### Selected sidebar item

- Use a rounded light-gray rectangle behind the selected row.
- In the reference, the selected row has approximately 10–12 px corner radii and modest horizontal inset from the sidebar edges.
- Keep the selected text and icon dark charcoal rather than switching to the orange accent.
- The highlight is subtle, not a saturated brand-colored pill.
- The selected row spans nearly the full available sidebar width while retaining equal left and right margins.

### Sidebar colors and borders

- Sidebar background: `#F7F7F7`.
- Header and sidebar are separated from the main panel by a thin `#D6D6D6` vertical border.
- Use a subtle bottom border below the sidebar header.
- Avoid card shadows around individual navigation entries.

## Main panel layout

The right-hand area is a vertical stack of clearly separated horizontal regions:

1. Title bar
2. Toolbar
3. Category tab bar
4. Main component preview
5. Bottom navigation

Use white backgrounds for all of these regions, with thin light-gray dividers. Align content to a shared left and right grid. Avoid nested cards unless the component being demonstrated specifically requires one.

## Toolbar

- Height: approximately 66 px.
- White background.
- Thin bottom border.
- Left side: hamburger/menu icon, then a sun/light-theme icon.
- Right side: plus icon and an orange-red eyedropper/color-tool icon.
- Use around 22–24 px icons with generous clickable areas.
- Keep the left and right groups close to their respective edges with roughly 32–36 px padding.
- Icons are mostly dark gray; the eyedropper is the accent orange-red.
- Do not add text labels to the toolbar icons in this layout.

## Category tabs

The category row sits below the toolbar and spans the width of the main panel.

Visible tabs:
- Buttons
- Fabs
- Toggleables
- Chips
- Progress

Design:
- Height around 72 px.
- White background with a thin gray bottom divider.
- Arrange tabs horizontally with generous spacing.
- Center each tab label within its own region.
- Regular-weight, dark-gray text around 20–22 px.
- The active tab (`Buttons`) has a short orange-red underline at the bottom, around 4–5 px thick, with softly rounded ends.
- The underline is about 75 px wide in the screenshot.
- Inactive tabs have no underline.
- Keep the accent underline aligned with the active tab's content, not stretched across the entire tab.
- If the viewport is too narrow, allow horizontal scrolling rather than wrapping tabs into multiple rows.

## Component preview area

This is the large white central canvas. It is intentionally sparse, with controls arranged in a compact demonstration column near the upper-left and substantial whitespace to the right and below.

- Use a white background.
- Add around 30–32 px of top padding.
- Add around 30 px of horizontal padding.
- Keep demonstrations left-aligned.
- Do not center the examples in the entire panel.
- Use a regular vertical rhythm between sample rows, with roughly 20–30 px between groups.
- Avoid enclosing every sample in a card.
- Show enabled and disabled examples side by side where the reference does so.

### Sample controls shown

The screenshot demonstrates multiple button and icon-button states:

1. Text-only button labels: one active orange-red `Text` label and one disabled gray `Text` label.
2. Icon-only notification/bell examples, enabled in dark gray and disabled in light gray.
3. Outlined buttons, one normal and one disabled.
4. Filled buttons, one normal gray-filled sample and one disabled sample.
5. Elevated buttons, including a green example and a disabled gray example.
6. Elevated icon-plus-text buttons, again with enabled and disabled states.
7. Circular icon buttons with orange-red, gray, outlined white, and pale-accent backgrounds.
8. Disabled controls use lighter text and icon colors and low-contrast gray surfaces.

These are component samples rather than a production form. Preserve their varied states and repeatable alignment.

## Button styles

### Text button
- No visible border or filled background.
- Text uses the accent orange-red when active.
- Disabled text uses `#B0B0B0`.
- Comfortable horizontal padding.

### Outlined button
- White background.
- Thin light-gray border, around 1.5 px.
- Border radius around 9–11 px.
- Text dark gray when active and pale gray when disabled.
- Approximate height: 53 px.
- Horizontal padding around 22–24 px.

### Filled button
- Pale-gray fill in the example, no visible border.
- Rounded corners around 10 px.
- Dark-gray text when active.
- Disabled state uses a similar or slightly paler fill with muted text.
- Approximate height: 54 px.

### Elevated button
- Rounded rectangle with no prominent border.
- The screenshot uses green for one enabled example and pale gray for a disabled example.
- White text on the green button; muted gray text on the disabled button.
- Do not interpret the green example as the application's main accent. The primary interface accent remains orange-red.

### Icon-plus-text button
- Same shape language as the elevated button.
- Icon and label align horizontally with a consistent gap.
- Active example uses white icon and text over green.
- Disabled example uses gray icon and text over pale gray.

### Circular icon buttons
- Circular shapes, approximately 50 px diameter.
- Samples include orange-red fill with dark icon, light-gray fill with muted icon, white fill with a thin border, and pale peach fill.
- Keep the icon centered.
- Use disabled gray states to demonstrate reduced emphasis.
- Preserve the compact circle size and the space between paired examples.

### Disabled-state rules
- Use muted gray text and icons.
- Reduce contrast without making disabled elements disappear.
- Disabled controls should remain legible.
- Do not rely only on color if building a real accessible UI. Add the appropriate disabled semantics.

## Bottom navigation / footer menu

The bottom menu is fixed to the bottom of the main panel, not the entire app window. It is separated from the preview by a thin, very pale gray top border.

Visible destinations:
- Fonts
- Controls
- TextFields
- Palette
- Containers

### Layout

- Approximately 95 px tall.
- White background.
- Five evenly distributed navigation items across the main panel width.
- Each item stacks an icon above its label, centered horizontally.
- Keep the icon and label vertically aligned within each item's area.
- Use compact, regular-weight labels around 18–20 px.
- Use monochrome line icons around 23–25 px.
- Footer labels are dark gray.
- Avoid strong separators between individual footer items.

### Selected footer item

`Controls` is selected:
- Place a pale-gray rounded capsule or pill behind the icon area.
- The selection background is approximately 95 px wide and 47 px tall.
- The icon sits centered inside the selected surface.
- Keep the label beneath the capsule, outside it.
- The selected state is subtle and neutral gray, not orange.
- Other footer icons sit directly on the white background.

### Badge

The `Fonts` item has a small green count badge reading `123`, positioned above and slightly overlapping the icon area. The badge is a compact green rounded capsule with white text. Treat it as a notification/count badge, not a universal requirement for every navigation item.

## Iconography

- Use a consistent monochrome outline icon family.
- Keep icons optically balanced, simple, and recognizable at small sizes.
- Use dark gray for enabled icons and light gray for disabled icons.
- Use the accent orange-red only for a small number of emphasized tools or active control examples.
- Avoid mixing filled, outlined, colorful, and emoji-style icons arbitrarily.
- When an exact Yaru icon is unavailable, choose the closest simple line icon and keep its stroke weight consistent.

## Borders, radii, and shadows

- Structural borders are thin and neutral, usually around 1 px.
- Main horizontal dividers use `#D6D6D6` or a softer gray.
- Subtle internal dividers use `#EEEEEE`.
- Outer application corners: approximately 16–18 px.
- Selected sidebar row: approximately 10–12 px.
- Buttons: approximately 9–11 px.
- Circular controls: fully round.
- Shadows are absent or extremely subtle. Prefer borders and background contrast to create hierarchy.

## Spacing system

Use a simple spacing scale:
- 4 px: icon-label micro-spacing adjustments.
- 8 px: tight control internals.
- 12 px: small gaps and corner spacing.
- 16 px: standard compact spacing.
- 24 px: component group spacing.
- 32 px: main content padding.
- 44–48 px: sidebar left inset for navigation content.

Keep spacing consistent across the interface. The screenshot feels orderly because regions align to clear grids and rows repeat the same spacing.

## Responsive behavior

The screenshot is a desktop UI. For responsive adaptations:
- Keep the left navigation persistent on wide screens.
- On narrower windows, allow the sidebar to collapse to an icon rail or become a drawer.
- Keep the title bar and toolbar compact.
- Let the tab strip scroll horizontally.
- Allow component examples to wrap only when needed, while keeping enabled/disabled pairs together when possible.
- The bottom navigation may remain five columns on medium widths; at narrow widths, reduce labels or convert to a compact navigation pattern.
- Preserve the white canvas, neutral borders, restrained typography, and orange-red accent at every size.

## Accessibility and interaction

- Use real buttons and navigation semantics, not clickable generic containers alone.
- Provide accessible names for icon-only controls.
- Make selected states distinguishable beyond color alone, where appropriate.
- Ensure visible keyboard focus rings.
- Keep sufficient contrast for active text and icons.
- Disabled controls should use actual disabled state semantics.
- Support keyboard navigation for tabs and bottom navigation.
- Do not make the small screenshot-inspired hit areas smaller than comfortable interaction targets in a real application.

## Implementation starter tokens

```css
:root {
  --yaru-canvas: #ffffff;
  --yaru-sidebar: #f7f7f7;
  --yaru-surface-subtle: #eaeaea;
  --yaru-surface-muted: #e7e7e7;
  --yaru-text-primary: #303030;
  --yaru-text-secondary: #666666;
  --yaru-text-disabled: #a6a6a6;
  --yaru-border: #d6d6d6;
  --yaru-border-subtle: #eeeeee;
  --yaru-accent: #e95420;
  --yaru-success-example: #078a1d;
  --yaru-soft-accent-bg: #f7e8e4;
  --yaru-window-control-bg: #e9e9e9;

  --yaru-radius-window: 17px;
  --yaru-radius-nav-item: 11px;
  --yaru-radius-control: 10px;
  --yaru-sidebar-width: 34%;
  --yaru-titlebar-height: 70px;
  --yaru-toolbar-height: 66px;
  --yaru-tabs-height: 72px;
  --yaru-footer-height: 95px;

  --yaru-font-family: Ubuntu, "Noto Sans", "Segoe UI", sans-serif;
}
```

## Do

- Keep the interface light, flat, calm, and carefully aligned.
- Use a pale-gray sidebar and white main panel.
- Use thin dividers between structural regions.
- Make the selected sidebar row neutral gray.
- Use orange-red for the active tab underline and a few highlighted actions.
- Show enabled and disabled component examples side by side.
- Keep the content examples left-aligned and leave generous whitespace.
- Keep the footer menu attached to the bottom of the main panel.
- Use consistent icon sizing and restrained typography.

## Avoid

- Dark mode as the default for this reference.
- Black page backgrounds inside the application.
- Gradients, glassmorphism, neon colors, glossy buttons, and strong drop shadows.
- Large bold marketing headings.
- Dense cards around every control.
- Random spacing or inconsistent icon sizes.
- Using green as the main application accent.
- Turning the sidebar selection or footer selection into a saturated orange pill.
- Wrapping the category tabs into multiple rows on desktop.
- Centering the component preview across the entire content panel.

## Prompt template for applying this skill

"Design this screen using the Yaru Design Skill. Use a light desktop-native component-gallery layout with a pale-gray left sidebar, white main canvas, thin neutral dividers, regular Ubuntu-like typography, dark-gray line icons, and a restrained orange-red accent. Reproduce the hierarchy of title bar, compact toolbar, horizontal category tabs, spacious left-aligned component preview, and bottom navigation. Keep the selected sidebar row and selected footer item neutral gray, use orange-red for the active tab underline, and show enabled/disabled component states with muted gray styling. Avoid gradients, heavy shadows, dark surfaces, and oversized bold headings. Follow the spacing, proportions, colors, and component details in this skill."