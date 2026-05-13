require_relative "tailwind_theme_picker/version"
require_relative "tailwind_theme_picker/configuration"
require_relative "tailwind_theme_picker/engine" if defined?(Rails)

module TailwindThemePicker

  class << self

    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end

  end

end
