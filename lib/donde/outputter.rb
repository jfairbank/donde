module Donde
  module Outputter
    def self.from_value(item, value)
      if ITEM_MAP.include?(item)
        ITEM_MAP[item].new(value)
      elsif item =~ /^@/
        Attr.new(value)
      else
        Element.new(value)
      end
    end

    class Base
      def initialize(value)
        @value = value
      end
    end

    class Attr < Base
      def add_to_buffer(buffer)
        buffer << @value.value.strip
      end
    end

    class ClassName < Base
      def add_to_buffer(buffer)
        buffer.concat(@value.value.strip.split(/\s+/))
      end
    end

    class Element < Base
      def add_to_buffer(buffer)
        tag = "<#{@value.name}"
        unless @value.attribute_nodes.empty?
          tag << " #{@value.attribute_nodes.map { |a| "#{a.name}=#{a.value.inspect}"}.join(' ')}"
        end
        tag << '>'

        buffer << tag
      end
    end

    ITEM_MAP = {
      '@class' => ClassName
    }
  end
end
