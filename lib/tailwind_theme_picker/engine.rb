module TailwindThemePicker

  class Engine < ::Rails::Engine

    initializer "tailwind_theme_picker.helpers" do
      ActiveSupport.on_load(:action_view) do
        include TailwindThemePicker::ViewHelper
      end
    end

    # 1. Serve the Stimulus controller as a propshaft asset.
    # 2. Append our importmap.rb so the host doesn't need to pin manually.
    initializer "tailwind_theme_picker.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end
    end

    initializer "tailwind_theme_picker.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app/javascript")
      end
    end

  end

end
