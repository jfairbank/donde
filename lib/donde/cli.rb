module Donde
  class Cli < Thor
    desc 'find SELECTOR DIR', 'find files containing HTML SELECTOR in DIR'
    option :filetypes, aliases: '-f', default: '*.*', banner: 'FILETYPES'
    option :engine, aliases: '-e', enum: %w(css xpath), banner: 'SELECTOR_ENGINE', default: 'css'
    def find(selector, directory = '.')
      selector_engine = SelectorEngine.from_string(options[:engine])
      finder = Finder.new(selector_engine, selector)

      filetypes = get_filetypes

      glob = File.join(directory, '**', filetypes)
      files = Dir[glob]

      puts files.size
      files.select! do |file|
        doc = Nokogiri::HTML(File.open(file))
        finder.in_doc?(doc)
      end
      puts files.size
    end

    desc 'list ITEM DIR', 'list ITEM found in HTML files in DIR'
    option :filetypes, aliases: '-f', default: '*.*', banner: 'FILETYPES'
    option :sort, aliases: '-s', type: :boolean
    option :unique, aliases: '-u', type: :boolean
    def list(item, directory= '.')
      files = Dir[File.join(directory, '**', get_filetypes)]

      buffer = []

      files.each do |file|
        doc = Nokogiri::HTML(File.open(file))

        doc.xpath("//#{item}").each do |value|
          Outputter.from_value(item, value).add_to_buffer(buffer)
        end
      end

      buffer.sort! if options[:sort]
      buffer.uniq! if options[:unique]

      puts buffer
    end

    private

    def get_filetypes
      "{#{options[:filetypes].split(',').map do |ext|
        "*#{ext}"
      end.join(',')}}"
    end
  end
end
