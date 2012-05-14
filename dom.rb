require 'ostruct'

module DOM
  class Element
    BLOCK_NAMES = %w[head title base link meta-equiv style script noscript body
      section nav article aside h1 h2 h3 h4 h5 h6 hgroup header footer address
      p hr pre blockquote ol ul li dl dt dd figure figcaption div iframe embed
      object param video audio source track canvas map area table caption
      colgroup col tbody thead tfoot tr td th form-charset fieldset legend label
      input button select datalist optgroup option textarea keygen output
      progress meter details summary command menu].map(&:to_sym).freeze
    INLINE_NAMES = %w[a em strong
      small s cite q dfn abbr data time code var samp kbd sub sup i b u mark
      ruby rt rp bdi bdo span br wbr ins del img ].map(&:to_sym).freeze

    attr_accessor :name, :attributes, :parent, :children

    def initialize(parent, name, attributes = {})
      raise ArgumentError unless name.is_a? Symbol
      raise ArgumentError unless attributes.is_a? Hash

      @attributes = Attributes.new attributes if attributes.any?
      @name = name
      @children = []
      parent.children << self if parent
    end

    BLOCK_NAMES.each do |name|
      define_method name, ->(attributes = {}, &block) {
        element = DOM::Element.new self, __method__, attributes
        result = element.instance_eval &block
        element.children << result if result.is_a? String
        element
      }
    end

    INLINE_NAMES.each do |name|
      define_method name, ->(attributes = {}, &block) {
        element = DOM::Inline.new self, __method__, attributes
        result = element.instance_eval &block
        element.children << result if result.is_a? String
        element
      }
    end

    def render
      space = " " unless attributes.nil?
      children.map! do |child|
        if child.is_a? Element
          child.render
        else
          child.to_s
        end
      end
      "<#{name}#{space}#{attributes.render if attributes}>#{children.join('')}</#{name}>"
    end
  end

  class Inline < Element
    alias_method :to_s, :render
  end

  class Attributes < OpenStruct
    GLOBAL = %w[accesskey class contenteditable contextmenu dir draggable
      dropzone hidden id itemid itemprop itemref itemscope itemtype lang role
      spellcheck style tabindex title].map(&:to_sym).freeze
    EXTENDABLE_GLOBAL = ['aria-', 'data-'].freeze

    def initialize(table)
      table.keep_if do |key|
        GLOBAL.include?(key) || EXTENDABLE_GLOBAL.any? { |e| key.include? e }
      end
      super table
    end

    def render
      marshal_dump.map { |pair| %[#{pair.first}="#{pair.last}"] }.join ' '
    end
  end
end

def html(attributes = {}, &block)
  element = DOM::Element.new nil, :html, attributes
  element.instance_eval &block
  element
end

document = html class: "Red" do
  body id: "account_1", class: "account", "data-state" => "dead" do
    h1 { "Below Is A Test" }
    p { "The First paragraph is the #{strong {"easiest"}}."}
  end
end

puts document.render
