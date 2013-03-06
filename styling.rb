module Stylist
  DEFAULTS = { ie9: true, chrome: true, firefox: true, safari: true }


  def support(options = {})
    options.merge! DEFAULTS
  end

  def style(selector, options = {}, &block)
    style = Style.new(selector, options)
    @substyles << style if defined?(@substyles)
    style.tap { |o| o.instance_eval &block }
  end

  class Style
    attr_accessor :selector, :properties, :substyles

    def initialize(selector, options = {})
      @selector = selector
      @properties = []
      @substyles = []
    end

    module Helpers
      def rgb(red, green, blue)
        RGB.new red, green, blue
      end

      def linear_gradient(position, start_color, end_color)
        LinearGradient.new position, start_color, end_color
      end

      class LinearGradient
        attr_accessor :position, :start_color, :end_color

        def initialize(position, start_color, end_color)
          @position = position
          @start_color = start_color
          @end_color = end_color
        end

        def to_s
          "linear-gradient(#{position},#{start_color},#{end_color})"
        end
      end

      class RGB
        attr_accessor :red, :green, :blue

        def initialize(red, green, blue)
          @red = red
          @green = green
          @blue = blue
        end

        def to_s
          "rgb(#{red},#{green},#{blue})"
        end
      end
    end

    class Property
      include Helpers

      attr_accessor :subproperties

      def self.attributes(*properties)
        properties.each do |property|
          define_method property, ->(value = nil) do
            if value
              instance_variable_set("@#{property}", value)
            else
              instance_variable_get("@#{property}")
            end
          end
        end
      end
    end

    class Background < Property
      attributes :color, :image

      def initialize(properties = {}, &block)
        instance_eval &block if block_given?
        color properties[:color]
        image properties[:image]
      end

      def to_s
        "background:#{color} #{image};"
      end
    end

    class Border < Property
      attributes :radius

      def initialize(properties = {}, &block)
        radius properties[:radius]
      end

      def to_s
        "border-radius:#{radius}px;" if radius
      end
    end

    class Text < Property
      attributes :color, :size, :font

      def initialize(properties = {}, &block)
        color properties[:color]
        size properties[:size]
        font properties[:font]
      end

      def to_s
        [color_to_s, size_to_s, font_to_s].compact
      end

      private

      def color_to_s
        "color:#{color};" if color
      end

      def size_to_s
        "font-size:#{size}px" if size
      end

      def font_to_s
        "font-family:#{font}" if font
      end
    end

    [:background, :border, :text].each do |group|
      klass = Style.const_get(group.capitalize)
      define_method group, ->(subproperties = {}, &block) do
        klass.new(subproperties, &block).tap { |o| properties << o }
      end
    end

    def to_s
      "#{selector}{#{properties.map(&:to_s).join}} #{print_substyles(selector)}}"
    end

    private

    def print_substyles(selector)
      substyles.map { |style| "#{selector} #{style}"}.join
    end
  end
end

include Stylist

style 'nav.bar' do
  dark_color = rgb(25, 25, 25)
  background do
    image linear_gradient(:top, "#333", "#222")
    color dark_color
  end

  border.radius 3.5

  style 'a' do
    text color: "#333", size: 18, font: "Helvetica"
  end
end
