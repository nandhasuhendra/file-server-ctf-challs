class Libs::Files
  def initialize
    @path = Dir.pwd + "/app/files/"
    @file = nil
  end
  
  def create(client, file, size)
    filename = @path + 'new_' + file + '.zip'
    t = 0

    File.open(filename, 'wb') do |f|
      while buff = client.gets
        t += buff.length
        f.write(buff)
        break if t == size
      end
    end
    puts "Size => #{size}"
    puts "Temp => #{t}"

    if isDocx(filename)
      puts "[!] [#{Time.now.ctime}]: #{client.addr[2]} is upload file \"#{file}\"."
      set_file(filename)
      return true
      $stdin.flush
    else
      puts "[!] [#{Time.now.ctime}]: \"#{file}\" has been delete"
      delete(filename)
      return false
      $stdin.flush
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
