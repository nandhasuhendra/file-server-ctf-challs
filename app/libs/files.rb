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

    if isDocx(filename)
      puts "[!] [#{Time.now.ctime}]: #{client.addr[2]} is upload file \"#{filename}\"."
      client.send 'Upload Succes !', 0
      set_file(filename)

      return true
    else
      puts "[!] [#{Time.now.ctime}]: \"#{filename}\" has been delete"
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
    def isDocx(file)
      file = File.read(file,10)
      file.include? "PK\x03\x04\n\x00\x00\x00\x00\x00" or "PK\x4B\x03\x04\x14\x00\x06\x00"
    end

    def delete(file)
      File.delete(file)
    end
end
