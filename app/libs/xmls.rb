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
        $stdin.flush

      end
    end
    
    if filter_command(tmp)
      set_docx("LOL")
      #set_docx(eval(tmp))
    else
      set_docx("[!] [#{Time.now.ctime}]: Try Harder")
    end
  end

  def set_docx(tmp)
    @docx = tmp
  end

  def get_docx
    @docx
  end

  private
    def filter_command(check)
      if check =~ /`|system|exec|%x|popen|spwan/
        return false
      else
        return true
      end
    end
end
