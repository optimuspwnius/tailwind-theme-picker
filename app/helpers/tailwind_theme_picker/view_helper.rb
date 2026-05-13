module TailwindThemePicker

  module ViewHelper

    # Emoji defaults so the gem has no icon-library dependency. Override by
    # passing :icons to render_tailwind_theme_picker.
    DEFAULT_ICONS = {
      palette: "🎨",
      times:   "❌",
      sun:     "☀️",
      moon:    "🌙"
    }.freeze

    # Returns HTML attributes for the <html> tag based on the request's cookies.
    # Use like: html lang="en" *tailwind_theme_picker_html_attrs
    def tailwind_theme_picker_html_attrs
      config = TailwindThemePicker.configuration
      theme  = cookies[config.theme_cookie].presence
      theme  = config.default unless config.themes.include?(theme)
      mode   = cookies[config.mode_cookie] == "dark" ? "dark" : nil

      classes = ["theme-#{theme}", mode].compact.join(" ")
      { class: classes }
    end

    # Whether the current request already has theme cookies set. Useful for
    # skipping the FOUC fallback script.
    def tailwind_theme_picker_cookies_present?
      config = TailwindThemePicker.configuration
      cookies[config.theme_cookie].present? && cookies[config.mode_cookie].present?
    end

    # Inline <script> that paints theme + mode classes from cookies/localStorage
    # before the rest of the page renders. Only needed on the first visit (when
    # the cookies aren't yet set server-side) — pass force: true to always emit.
    def tailwind_theme_picker_fouc_script(force: false)
      return "".html_safe if !force && tailwind_theme_picker_cookies_present?

      config = TailwindThemePicker.configuration
      nonce  = (respond_to?(:content_security_policy_nonce) ? content_security_policy_nonce : nil)

      js = <<~JS
        (function(){try{
          var d=document.documentElement;
          var rc=function(n){var m=document.cookie.match(new RegExp('(?:^|; )'+n+'=([^;]*)'));return m?decodeURIComponent(m[1]):null};
          var tn=rc('#{config.theme_cookie}')||localStorage.getItem('theme')||'#{config.default}';
          d.classList.add('theme-'+tn);
          var m=rc('#{config.mode_cookie}')||localStorage.getItem('mode');
          if(m==='dark'||(!m&&window.matchMedia('(prefers-color-scheme: dark)').matches)){d.classList.add('dark');}else{d.classList.remove('dark');}
        }catch(e){}})();
      JS

      content_tag(:script, js.html_safe, nonce: nonce)
    end

    def render_tailwind_theme_picker(themes: nil, default: nil, icons: {})
      config = TailwindThemePicker.configuration
      render(
        partial: "tailwind_theme_picker/picker",
        locals: {
          themes:        (themes  || config.themes).map(&:to_s),
          default:       (default || config.default).to_s,
          theme_cookie:  config.theme_cookie,
          mode_cookie:   config.mode_cookie,
          cookie_max_age: config.cookie_max_age,
          icons:         DEFAULT_ICONS.merge(icons)
        }
      )
    end

  end

end
