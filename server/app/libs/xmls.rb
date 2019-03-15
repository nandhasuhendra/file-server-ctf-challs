class Libs::Xmls
  def initialize(file)
    @file   = file
    @output = []
  end

  def read
    files = Zip::File.open(@file)

    files.each do |file| 
      if file.file? and file.name == 'word/document.xml'
        content = file.get_input_stream.read
        is_xml = Nokogiri::XML(content)
        
        is_xml.xpath('//w:t').each do |thing|
          set_xml(filter_command(thing.text))
        end
      end
    end
  end

  def set_xml(value)
    @output << value
  end

  def get_xml
    @output
  end

  private
    def filter_command(check)
      if check =~ /`|system|exec|%x|popen|spwan|require|bin|bash|sh|cte|hs|hsab|nib|llik|kill([.])\./
        check.gsub /`|system|exec|%x|popen|spwan|require|bin|bash|sh|cte|hs|hsab|nib|llik|kill([.])\./, "x"
      else
        check
      end
    end
end
