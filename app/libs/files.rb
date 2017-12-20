class Libs::Files
  def initialize
    @path = Dir.pwd + "/app/files/"
    @file = nil
  end
  
  def create(client, file)
    filename = @path + 'new_' + file + '.zip'

    File.open(filename, 'wb') do |f|
      while buff = client.gets
        f.write(buff)
      end
    end

    if isDocx(filename)
      set_file(filename)
      puts "[!] [#{Time.now.ctime}]: #{client.addr[2]} is upload file \"#{file}\"."
      return true
    else
      puts "[!] [#{Time.now.ctime}]: \"#{file}\" has been delete"
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
      File.read(file, 10).include? "PK\x03\x04\n\x00\x00\x00\x00\x00"
    end

    def delete(file)
      File.delete(file)
    end
end
