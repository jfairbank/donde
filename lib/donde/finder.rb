module Donde
  class Finder
    def initialize(type, selector)
      @type = type
      @selector = selector
    end

    def search(doc)
      doc.__send__(@type.value, @selector)
    end

    def in_doc?(doc)
      !search(doc).empty?
    end
  end
end
