# TailwindThemePicker

Drop-in theme + light/dark picker for Tailwind-based Rails apps.

## What's in the box

- Floating Stimulus-powered picker UI (palette toggle, 27 color swatches, light/dark switch)
- Two-cookie persistence (`theme`, `mode`) — the server can render `<html class="theme-sky dark">` before any JS runs
- localStorage fallback so cross-tab updates and offline still feel snappy
- 27 ready-to-go `.theme-*` blocks targeting Tailwind's color palette
- Inline FOUC script that's only emitted when cookies aren't yet set

## Install

```ruby
# Gemfile
gem "tailwind_theme_picker", path: "../theme_picker"  # or git: / version once published
```

```bash
bundle install
bin/rails g tailwind_theme_picker:install            # copies themes.css into app/assets/tailwind/tailwind_theme_picker/
bin/rails g tailwind_theme_picker:install --initializer   # also generate config/initializers/tailwind_theme_picker.rb
```

Re-run the generator after upgrading the gem to pick up any new theme rules.

### Configure (optional)

```ruby
# config/initializers/tailwind_theme_picker.rb
TailwindThemePicker.configure do |c|
  c.themes  = %w[red blue green]   # subset or extend the default 27
  c.default = "blue"
end
```

### Wire up the layout

```slim
html lang="en" *theme_picker_html_attrs
  head
    / ...stylesheets, importmap...
    = theme_picker_fouc_script
  body
    = render_theme_picker
    = yield
```

### Import the CSS

```css
/* app/assets/tailwind/application.css */
@import 'tailwindcss';

/* ...your other rules... */

@import './tailwind_theme_picker/themes';
```

The gem's CSS rules are intentionally unlayered so they win over a `:root { --color-primary: ... }` default inside `@layer base`. Keep this import outside any `@layer` block.

Tailwind needs `darkMode: 'class'` in your config. Your app should also define the `--color-primary` custom property and any utilities (`.bg-app`, `.btn-primary`, etc.) that consume it.

### Remove your old controller

If you previously had `app/javascript/controllers/theme_controller.js`, delete it — the gem pins one at the same import name.

## How persistence works

1. Stimulus controller writes both cookies on every change.
2. On the next request, `theme_picker_html_attrs` reads them and paints `<html>` server-side. No FOUC.
3. On the user's *first* visit (no cookies), `theme_picker_fouc_script` emits ~250 bytes of inline JS that paints from localStorage or system preference. After that, cookies take over and the helper returns an empty string.

## Configuration reference

| Setting          | Default                      | Notes |
|------------------|------------------------------|-------|
| `themes`         | 27-color rainbow             | Must match `.theme-*` rules you actually ship. |
| `default`        | `"sky"`                      | Used when cookie is absent or refers to an unknown theme. |
| `theme_cookie`   | `"theme"`                    |       |
| `mode_cookie`    | `"mode"`                     |       |
| `cookie_max_age` | one year                     | Seconds. |

