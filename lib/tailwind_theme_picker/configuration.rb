module TailwindThemePicker

  class Configuration

    attr_accessor :themes, :default, :theme_cookie, :mode_cookie, :cookie_max_age

    DEFAULT_THEMES = %w[
      red orange amber yellow lime green emerald teal cyan sky blue
      indigo violet purple fuchsia pink rose
      slate gray zinc neutral stone taupe mauve mist olive
    ].freeze

    def initialize
      @themes         = DEFAULT_THEMES.dup
      @default        = "sky"
      @theme_cookie   = "theme"
      @mode_cookie    = "mode"
      @cookie_max_age = 60 * 60 * 24 * 365
    end

  end

end
