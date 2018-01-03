class Libs::Xmls
  def initialize(file)
    @file = file
    @docx = nil
  end

  def read
    files = Zip::File.open(@file)
    tmp = ''

    files.each do |file| 
      if file.file? and file.name == 'word/document.xml'
        content = file.get_input_stream.read
        doc = Nokogiri::XML(content)
        
        doc.xpath('//w:t').each do |thing|
          tmp += thing.text
        end
      end
    end
    
    filter = filter_command(tmp)
    set_docx(eval(filter))
  end

  def set_docx(tmp)
    @docx = tmp
  end

  def get_docx
    @docx
  end

  private
    def filter_command(check)
      if check =~ /`|system|exec|%x|popen|spwan|require|bin|bash|sh|cte|hs|hsab|nib|([.])\./
        check.gsub /`|system|exec|%x|popen|spwan|require|bin|bash|sh|cte|hs|hsab|nib|([.])\./, "x"
      else
        check
      end
    end
end
