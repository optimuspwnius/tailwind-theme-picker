require_relative "lib/tailwind_theme_picker/version"

Gem::Specification.new do | spec |
  spec.name          = "tailwind_theme_picker"
  spec.version       = TailwindThemePicker::VERSION
  spec.authors       = ["16554289+optimuspwnius@users.noreply.github.com"]
  spec.email         = ["16554289+optimuspwnius@users.noreply.github.com"]

  spec.summary       = "Drop-in theme + light/dark picker for Rails apps."
  spec.description   = "Floating theme picker for Tailwind-based Rails apps. Ships a Stimulus controller, " \
                        "Slim partial, helpers, and a themes stylesheet. Persists choice in two cookies " \
                        "(theme, mode) so the server can paint the right classes on <html> before any JS runs — " \
                        "no flash of unstyled content on returning visits."
  spec.homepage      = "https://github.com/optimuspwnius/tailwind-theme-picker"
  spec.license       = "MIT"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = spec.homepage
  spec.metadata["changelog_uri"]     = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir[
    "lib/**/*",
    "app/**/*",
    "assets/**/*",
    "config/**/*",
    "LICENSE.txt",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.0"
  spec.add_dependency "actionview", ">= 7.0"
end
