module Donde
  module SelectorEngines
    def self.from_string(type)
      const_get(type.capitalize).new
    end

    class Css
      def default_selector
        '*'
      end

      def value
        :css
      end
    end

    class Xpath
      def default_selector
        '//*'
      end

      def value
        :xpath
      end
    end
  end
end
