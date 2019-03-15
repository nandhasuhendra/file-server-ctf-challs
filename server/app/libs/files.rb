class Libs::Files
  def initialize
    @path = Dir.pwd + "/app/files/"
    @file = nil
  end
  
  def create(client, filename, size)
    filename = @path + 'new_' + filename + '.zip'
    t = 0

    File.open(filename, 'wb') do |f|
      loop do
        buff  = client.recv(1024)
        t    += buff.length
        f.write(buff)
        break if t == size.to_i
      end
    end

    if isFile(filename)
      puts "[!] [#{Time.now.ctime}], %-7.7s --: %s upload file %s." % ['SUCCESS', client.addr[2], filename]
      client.send 'Upload Succes !', 0
      set_file(filename)

      return true
    else
      puts "[!] [#{Time.now.ctime}], %-7.7s --: %s trying to upload file %s." % ['WARNING', client.addr[2], filename]
      client.send 'Upload Succes !', 0
      delete(filename)

      return false
    end
  end

  def set_file(file)
    @file = file
  end

  def get_file
    @file
  end

  private
    def isFile(filename)
      file = File.read(filename,10)

      return false if file.blank?

      file.include? "PK\x03\x04\n\x00\x00\x00\x00\x00" or "PK\x4B\x03\x04\x14\x00\x06\x00"
    end

    def delete(file)
      File.delete(file)
    end
end
