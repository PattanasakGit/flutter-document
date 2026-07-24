# Flutter Field Guide — Applied Design Direction

The generated UI/UX recommendation is a useful baseline for developer
documentation: content-first layout, persistent navigation, search, full
light/dark support, precise typography, and subtle motion.

The generic grey-and-link-blue palette is intentionally replaced because it
could belong to any documentation site. This guide takes its visual language
from an execution trace and a field notebook:

- `ink`: `#10212B` — primary text and dark navigation
- `paper`: `#F6F3EA` — long-form reading surface
- `emerald`: `#147D64` — completed flow and runnable outcome
- `amber`: `#B66A12` — React-to-Flutter translation
- `coral`: `#B7463C` — production and security warnings
- `sky`: `#2D6F9F` — links and active learning state

Typography remains offline. Display and body text use the Thai-capable system
sans stack; code and execution labels use the system monospace stack.

The signature element is the **execution rail**: each chapter exposes where the
reader is in the path from user action to widget, controller, use case,
repository, datasource, test, and build artifact. The rail is structural, not
decorative, and changes to match the current lesson.

Interaction rules:

- Search is available from every page and with `/`.
- Main navigation stays predictable across pages.
- All controls are at least 44×44 CSS pixels.
- Focus uses a visible 3px ring.
- Theme and progress state are optional enhancements.
- Motion uses opacity/transform for 160–220ms and is removed under
  `prefers-reduced-motion`.
- Diagrams are semantic HTML/CSS, preserve source reading order, and have prose
  descriptions.
