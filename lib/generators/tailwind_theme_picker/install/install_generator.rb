require "rails/generators/base"

module TailwindThemePicker

  module Generators

    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../..", __dir__)

      desc "Copies tailwind_theme_picker themes.css into app/assets/tailwind/tailwind_theme_picker/ and prints layout wiring instructions."

      class_option :initializer, type: :boolean, default: false,
                                  desc: "Also create config/initializers/tailwind_theme_picker.rb"

      def copy_themes_stylesheet
        copy_file "assets/stylesheets/tailwind_theme_picker/themes.css",
                  "app/assets/tailwind/tailwind_theme_picker/themes.css"
      end

      def create_initializer
        return unless options[:initializer]
        create_file "config/initializers/tailwind_theme_picker.rb", <<~RUBY
          TailwindThemePicker.configure do |c|
            # c.themes  = %w[red blue green]   # subset / extend default 27
            # c.default = "sky"
            # c.theme_cookie   = "theme"
            # c.mode_cookie    = "mode"
            # c.cookie_max_age = 60 * 60 * 24 * 365
          end
        RUBY
      end

      def show_post_install
        say "\nTailwindThemePicker installed.", :green
        say ""
        say "Next steps:"
        say "  1. Add to your Tailwind input CSS (e.g. app/assets/tailwind/application.css):"
        say "       @import './tailwind_theme_picker/themes';", :cyan
        say "  2. Wire up your layout <html> tag and body:"
        say "       html lang=\"en\" *theme_picker_html_attrs", :cyan
        say "       = theme_picker_fouc_script   # in <head>"
        say "       = render_theme_picker        # in <body>"
        say ""
        say "After upgrading the gem, re-run this generator to pick up any new themes."
      end

    end

  end

end
