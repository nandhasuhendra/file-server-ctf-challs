class Libs::Xmls
  def initialize(file)
    @file = file
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
    
    puts eval(tmp)
  end
end
